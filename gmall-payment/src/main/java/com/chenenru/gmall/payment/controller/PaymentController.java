package com.chenenru.gmall.payment.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.alibaba.fastjson.JSON;
import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.request.AlipayTradePagePayRequest;
import com.chenenru.gmall.annotations.LoginRequired;
import com.chenenru.gmall.bean.OmsOrder;
import com.chenenru.gmall.bean.PaymentInfo;
import com.chenenru.gmall.payment.config.AlipayConfig;
import com.chenenru.gmall.service.OrderService;
import com.chenenru.gmall.service.PaymentService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * @Author chenenru
 * @ClassName PaymentController
 * @Description
 * @Date 2020/2/26 11:16
 * @Version 1.0
 **/
@Controller
public class PaymentController {

    @Autowired
    AlipayClient alipayClient;

    @Autowired
    PaymentService paymentService;

    @Reference
    OrderService orderService;

    @RequestMapping("alipay/callback/return")
    @LoginRequired(loginSuccess = true)
    public String aliPayCallBackReturn(HttpServletRequest request, ModelMap modelMap){

        // 回调请求中获取支付宝参数
        String sign = request.getParameter("sign");
        String trade_no = request.getParameter("trade_no");
        String out_trade_no = request.getParameter("out_trade_no");
        String trade_status = request.getParameter("trade_status");
        String total_amount = request.getParameter("total_amount");
        String subject = request.getParameter("subject");
        String call_back_content = request.getQueryString();


        // 通过支付宝的paramsMap进行签名验证，2.0版本的接口将paramsMap参数去掉了，导致同步请求没法验签
        if(StringUtils.isNotBlank(sign)){
            // 验签成功
            // 更新用户的支付状态

            PaymentInfo paymentInfo = new PaymentInfo();
            paymentInfo= paymentService.selectPaymentInfoByoutTradeNo(out_trade_no);
            paymentInfo.setOrderSn(out_trade_no);
            paymentInfo.setPaymentStatus("已支付");
            paymentInfo.setAlipayTradeNo(trade_no);// 支付宝的交易凭证号
            paymentInfo.setCallbackContent(call_back_content);//回调请求字符串
            paymentInfo.setCallbackTime(new Date());

            System.out.println("paycontroller的aliPayCallBackReturn前的paymentInfo："+paymentInfo);

            paymentService.updatePayment(paymentInfo);
            System.out.println("paycontroller的aliPayCallBackReturn后的paymentInfo："+paymentInfo);
            OmsOrder omsOrder = orderService.getOrderByOutTradeNo(out_trade_no);
            omsOrder.setPaymentTime(new Date());
            omsOrder.setPayType(1);
            orderService.updateOrder(omsOrder);
            System.out.println("更新订单支付状态成功");

        }

        //return new ModelAndView("redirect:/orderList");
        return "redirect:http://order.gmall.com:8097/orderList";
    }



    @RequestMapping("alipay/submit")
    @LoginRequired(loginSuccess = true)
    @ResponseBody
    public String alipay(String outTradeNo, BigDecimal totalAmount, HttpServletRequest request, ModelMap modelMap){

        // 获得一个支付宝请求的客户端(它并不是一个链接，而是一个封装好的http的表单请求)
        String form = null;
        AlipayTradePagePayRequest alipayRequest = new AlipayTradePagePayRequest();//创建API对应的request

        // 回调函数
        alipayRequest.setReturnUrl(AlipayConfig.return_payment_url);
        alipayRequest.setNotifyUrl(AlipayConfig.notify_payment_url);

        Map<String,Object> map = new HashMap<>();
        map.put("out_trade_no",outTradeNo);
        map.put("product_code","FAST_INSTANT_TRADE_PAY");
        map.put("total_amount",0.01);
        map.put("subject","闪购秒杀牌子鞋的购物网站的新鞋");

        String param = JSON.toJSONString(map);

        alipayRequest.setBizContent(param);

        try {
            form = alipayClient.pageExecute(alipayRequest).getBody(); //调用SDK生成表单
            System.out.println(form);
        } catch (AlipayApiException e) {
            e.printStackTrace();
        }

        // 生成并且保存用户的支付信息
        PaymentInfo paymentInfo = paymentService.selectPaymentInfoByoutTradeNo(outTradeNo);
        //原来没有记录才要创建一条
        if (paymentInfo==null){
            OmsOrder omsOrder = orderService.getOrderByOutTradeNo(outTradeNo);
            PaymentInfo paymentInfo1 = new PaymentInfo();
            paymentInfo1.setCreateTime(new Date());
            paymentInfo1.setOrderId(omsOrder.getId());
            paymentInfo1.setOrderSn(outTradeNo);
            paymentInfo1.setPaymentStatus("未付款");
            paymentInfo1.setSubject("秒杀牌子鞋商城商品一件");
            paymentInfo1.setTotalAmount(totalAmount);
            paymentService.savePaymentInfo(paymentInfo1);
        }
        //如果是待支付状态呢的呢？需要重新创建一条数据吗？是不是傻
        /*OmsOrder omsOrder = orderService.getOrderByOutTradeNo(outTradeNo);
        PaymentInfo paymentInfo = new PaymentInfo();
        paymentInfo.setCreateTime(new Date());
        paymentInfo.setOrderId(omsOrder.getId());
        paymentInfo.setOrderSn(outTradeNo);
        paymentInfo.setPaymentStatus("未付款");
        paymentInfo.setSubject("秒杀牌子鞋商城商品一件");
        paymentInfo.setTotalAmount(totalAmount);
        paymentService.savePaymentInfo(paymentInfo);*/

        // 向消息中间件发送一个检查支付状态(支付服务消费)的延迟消息队列
        paymentService.sendDelayPaymentResultCheckQueue(outTradeNo,5);

        // 提交请求到支付宝
        return form;
    }

    @RequestMapping("index")
    @LoginRequired(loginSuccess = true)
    public String index(String outTradeNo, BigDecimal totalAmount, HttpServletRequest request, ModelMap modelMap){
        String memberId = (String)request.getAttribute("memberId");
        String nickname = (String)request.getAttribute("nickname");

        modelMap.put("nickname",nickname);
        modelMap.put("outTradeNo",outTradeNo);
        modelMap.put("totalAmount",totalAmount);

        return "index";
    }


    /*@RequestMapping("mx/submit")
    @LoginRequired(loginSuccess = true)
    public String mx(String outTradeNo, BigDecimal totalAmount, HttpServletRequest request, ModelMap modelMap){


        return null;
    }*/
}
