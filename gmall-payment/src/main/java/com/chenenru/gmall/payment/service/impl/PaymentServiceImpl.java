package com.chenenru.gmall.payment.service.impl;

import com.alibaba.dubbo.config.annotation.Service;
import com.alibaba.fastjson.JSON;
import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.request.AlipayTradeQueryRequest;
import com.alipay.api.response.AlipayTradeQueryResponse;
import com.chenenru.gmall.bean.PaymentInfo;
import com.chenenru.gmall.mq.ActiveMQUtil;
import com.chenenru.gmall.payment.config.WeChatConfig;
import com.chenenru.gmall.payment.mapper.PaymentInfoMapper;
import com.chenenru.gmall.payment.utils.CommonUtils;
import com.chenenru.gmall.payment.utils.HttpUtils;
import com.chenenru.gmall.payment.utils.WXPayUtil;
import com.chenenru.gmall.service.PaymentService;
import org.apache.activemq.ScheduledMessage;
import org.apache.activemq.command.ActiveMQMapMessage;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import tk.mybatis.mapper.entity.Example;

import javax.jms.*;
import javax.jms.Queue;
import java.util.*;

/**
 * @Author chenenru
 * @ClassName PaymentServiceImpl
 * @Description
 * @Date 2020/2/26 14:13
 * @Version 1.0
 **/
@Service
public class PaymentServiceImpl implements PaymentService {

    @Autowired
    PaymentInfoMapper paymentInfoMapper;

    @Autowired
    ActiveMQUtil activeMQUtil;

    @Autowired
    AlipayClient alipayClient;

    @Autowired
    private WeChatConfig weChatConfig;

    @Override
    public void savePaymentInfo(PaymentInfo paymentInfo) {
        paymentInfoMapper.insertSelective(paymentInfo);
    }


    @Override
    public void updatePayment(PaymentInfo paymentInfo) {

        // 幂等性检查
        PaymentInfo paymentInfoParam = new PaymentInfo();
        paymentInfoParam.setOrderSn(paymentInfo.getOrderSn());
        System.out.println("paymentserviceimpl的updatePayment前的paymentInfo："+paymentInfo);
        PaymentInfo paymentInfoResult =paymentInfoMapper.selectOne(paymentInfoParam);
        System.out.println("paymentserviceimpl的updatePayment的selectOne后的paymentInfo："+paymentInfo);

        if(StringUtils.isNotBlank(paymentInfoResult.getPaymentStatus())&&("已支付").equals(paymentInfoResult.getPaymentStatus())){
            return;
        }else{

            //String orderSn = paymentInfo.getOrderSn();

            //Example e = new Example(PaymentInfo.class);
            //e.createCriteria().andEqualTo("orderSn",orderSn);

            Connection connection = null;
            Session session = null;
            try {
                connection = activeMQUtil.getConnectionFactory().createConnection();
                session = connection.createSession(true, Session.SESSION_TRANSACTED);
            } catch (Exception e1) {
                e1.printStackTrace();
            }

            try{
                paymentInfoMapper.updateByPrimaryKey(paymentInfo);
                System.out.println("paymentserviceimpl的updatePayment的updateByPrimaryKey后的paymentInfo："+paymentInfo);
                // 支付成功后，引起的系统服务-》订单服务的更新-》库存服务-》物流服务
                // 调用mq发送支付成功的消息
                Queue payhment_success_queue = session.createQueue("PAYHMENT_SUCCESS_QUEUE");
                MessageProducer producer = session.createProducer(payhment_success_queue);

                //TextMessage textMessage=new ActiveMQTextMessage();//字符串文本

                MapMessage mapMessage = new ActiveMQMapMessage();// hash结构

                mapMessage.setString("out_trade_no",paymentInfo.getOrderSn());

                producer.send(mapMessage);

                session.commit();
            }catch (Exception ex){
                // 消息回滚
                try {
                    session.rollback();
                } catch (JMSException e1) {
                    e1.printStackTrace();
                }
            }finally {
                try {
                    connection.close();
                } catch (JMSException e1) {
                    e1.printStackTrace();
                }
            }
        }

    }

    @Override
    public void sendDelayPaymentResultCheckQueue(String outTradeNo,int count) {

        Connection connection = null;
        Session session = null;
        try {
            connection = activeMQUtil.getConnectionFactory().createConnection();
            session = connection.createSession(true, Session.SESSION_TRANSACTED);
        } catch (Exception e1) {
            e1.printStackTrace();
        }

        try{
            Queue payhment_success_queue = session.createQueue("PAYMENT_CHECK_QUEUE");
            MessageProducer producer = session.createProducer(payhment_success_queue);

            //TextMessage textMessage=new ActiveMQTextMessage();//字符串文本

            MapMessage mapMessage = new ActiveMQMapMessage();// hash结构

            mapMessage.setString("out_trade_no",outTradeNo);
            mapMessage.setInt("count",count);

            // 为消息加入延迟时间
            mapMessage.setLongProperty(ScheduledMessage.AMQ_SCHEDULED_DELAY,1000*60);

            producer.send(mapMessage);

            session.commit();
        }catch (Exception ex){
            // 消息回滚
            try {
                session.rollback();
            } catch (JMSException e1) {
                e1.printStackTrace();
            }
        }finally {
            try {
                connection.close();
            } catch (JMSException e1) {
                e1.printStackTrace();
            }
        }
    }

    @Override
    public Map<String, Object> checkAlipayPayment(String out_trade_no) {

        Map<String,Object> resultMap = new HashMap<>();

        AlipayTradeQueryRequest request = new AlipayTradeQueryRequest();
        Map<String,Object> requestMap = new HashMap<>();
        requestMap.put("out_trade_no",out_trade_no);
        request.setBizContent(JSON.toJSONString(requestMap));
        AlipayTradeQueryResponse response = null;
        try {
            response = alipayClient.execute(request);
        } catch (AlipayApiException e) {
            e.printStackTrace();
        }
        if(response.isSuccess()){
            System.out.println("有可能交易已创建，调用成功");
            resultMap.put("out_trade_no",response.getOutTradeNo());
            resultMap.put("trade_no",response.getTradeNo());
            resultMap.put("trade_status",response.getTradeStatus());
            resultMap.put("call_back_content",response.getMsg());
        } else {
            System.out.println("有可能交易未创建，调用失败");

        }

        return resultMap;
    }

    @Override
    public PaymentInfo selectPaymentInfoByoutTradeNo(String outTradeNo) {
        PaymentInfo paymentInfo=new PaymentInfo();
        paymentInfo.setOrderSn(outTradeNo);
        PaymentInfo selectOne = paymentInfoMapper.selectOne(paymentInfo);
        return selectOne;
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public String saveWxPaymentInfo(PaymentInfo paymentInfo) throws Exception{
        //1、查找商品信息（这里商品指的是视频课程）
        //Video video =  videoMapper.findById(videoOrderDto.getVideoId());

        //2、查找用户信息
        //User user = userMapper.findByid(videoOrderDto.getUserId());

        //3、生成订单，插入数据库
        /*VideoOrder videoOrder = new VideoOrder();
        videoOrder.setTotalFee(video.getPrice());
        videoOrder.setVideoImg(video.getCoverImg());
        videoOrder.setVideoTitle(video.getTitle());
        videoOrder.setCreateTime(new Date());
        videoOrder.setVideoId(video.getId());
        videoOrder.setState(0);
        videoOrder.setUserId(user.getId());
        videoOrder.setHeadImg(user.getHeadImg());
        videoOrder.setNickname(user.getName());
        videoOrder.setDel(0);
        videoOrder.setIp(videoOrderDto.getIp());
        videoOrder.setOutTradeNo(CommonUtils.generateUUID());*/

        //videoOrderMapper.insert(videoOrder);

        //说明不是从数据库读取的，是新数据
        if ("".equals(paymentInfo.getId())||null==paymentInfo.getId()){
            paymentInfoMapper.insertSelective(paymentInfo);
        }
        //否则不用插入
        //4、获取codeurl
        String codeUrl = unifiedOrder(paymentInfo);

        return codeUrl;
    }

    /**
     * 统一下单方法
     * @return
     */
    private String unifiedOrder(PaymentInfo paymentInfo) throws Exception {


        //4.1、生成签名 按照开发文档需要按字典排序，所以用SortedMap
        SortedMap<String,String> params = new TreeMap<>();
        params.put("appid",weChatConfig.getAppId());         //公众账号ID
        params.put("mch_id", weChatConfig.getMchId());       //商户号
        params.put("nonce_str", paymentInfo.getOrderSn()); //随机字符串
        params.put("body",paymentInfo.getSubject());       // 商品描述
        params.put("out_trade_no",paymentInfo.getOrderSn());//商户订单号,商户系统内部订单号，要求32个字符内，只能是数字、大小写字母_-|* 且在同一个商户号下唯一
        params.put("total_fee", String.valueOf(paymentInfo.getTotalAmount()));//标价金额	分
        params.put("spbill_create_ip","120.25.1.43");
        params.put("notify_url",weChatConfig.getPayCallbackUrl());  //通知地址
        params.put("trade_type","NATIVE"); //交易类型 JSAPI 公众号支付 NATIVE 扫码支付 APP APP支付

        //4.2、sign签名 具体规则:https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=4_3
        String sign = WXPayUtil.createSign(params, weChatConfig.getKey());
        params.put("sign",sign);

        //4.3、map转xml （ WXPayUtil工具类）
        String payXml = WXPayUtil.mapToXml(params);
        System.out.println("payXml:"+payXml);

        //4.4、回调微信的统一下单接口(HttpUtil工具类）
        String orderStr = HttpUtils.doPost(WeChatConfig.getUnifiedOrderUrl(),payXml,4000);
        System.out.println("orderStr:"+orderStr);
        if(null == orderStr) {
            return null;
        }
        //4.5、xml转map （WXPayUtil工具类）
        Map<String, String> unifiedOrderMap =  WXPayUtil.xmlToMap(orderStr);
        System.out.println("unifiedOrderMap:"+unifiedOrderMap.toString());

        //4.6、获取最终code_url
        if(unifiedOrderMap != null) {
            System.out.println("unifiedOrderMap.get(code_url):"+unifiedOrderMap.get("code_url"));
            return unifiedOrderMap.get("code_url");
        }

        return null;
    }
}

