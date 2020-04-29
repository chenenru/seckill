package com.chenenru.gmall.order.service.impl;

import com.alibaba.dubbo.config.annotation.Service;
import com.alibaba.fastjson.JSON;
import com.chenenru.gmall.bean.OmsCartItem;
import com.chenenru.gmall.bean.OmsOrder;
import com.chenenru.gmall.bean.OmsOrderItem;
import com.chenenru.gmall.mq.ActiveMQUtil;
import com.chenenru.gmall.order.mapper.OmsOrderItemMapper;
import com.chenenru.gmall.order.mapper.OmsOrderMapper;
import com.chenenru.gmall.service.OrderService;
import com.chenenru.gmall.util.RedisUtil;
import org.apache.activemq.command.ActiveMQTextMessage;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import redis.clients.jedis.Jedis;
import tk.mybatis.mapper.entity.Example;

import javax.jms.*;
import javax.jms.Queue;
import java.util.*;

/**
 * @Author chenenru
 * @ClassName OrderServiceImpl
 * @Description
 * @Date 2020/2/25 22:07
 * @Version 1.0
 **/
@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    RedisUtil redisUtil;

    @Autowired
    OmsOrderMapper omsOrderMapper;

    @Autowired
    OmsOrderItemMapper omsOrderItemMapper;

    @Autowired
    ActiveMQUtil activeMQUtil;

    @Override
    public String checkTradeCode(String memberId, String tradeCode) {
        Jedis jedis = null ;

        try {
            jedis = redisUtil.getJedis();
            String tradeKey = "user:" + memberId + ":tradeCode";


            //String tradeCodeFromCache = jedis.get(tradeKey);// 使用lua脚本在发现key的同时将key删除，防止并发订单攻击
            //对比防重删令牌
            String script = "if redis.call('get', KEYS[1]) == ARGV[1] then return redis.call('del', KEYS[1]) else return 0 end";
            Long eval = (Long) jedis.eval(script, Collections.singletonList(tradeKey), Collections.singletonList(tradeCode));

            if (eval!=null&&eval!=0) {
                jedis.del(tradeKey);
                return "success";
            } else {
                return "fail";
            }
        }finally {
            jedis.close();
        }

    }

    @Override
    public String getTradeCode(String memberId) {

        Jedis jedis = redisUtil.getJedis();

        String tradeKey = "user:"+memberId+":tradeCode";

        String tradeCode = UUID.randomUUID().toString();

        jedis.setex(tradeKey,60*15,tradeCode);

        jedis.close();

        return tradeCode;
    }

    @Override
    public void saveOrder(OmsOrder omsOrder) {

        // 保存订单表
        omsOrderMapper.insertSelective(omsOrder);
        String orderId = omsOrder.getId();
        // 保存订单详情
        List<OmsOrderItem> omsOrderItems = omsOrder.getOmsOrderItems();
        for (OmsOrderItem omsOrderItem : omsOrderItems) {
            omsOrderItem.setOrderId(orderId);
            omsOrderItemMapper.insertSelective(omsOrderItem);
            // 删除购物车数据
            // cartService.delCart();
        }
    }

    @Override
    public OmsOrder getOrderByOutTradeNo(String outTradeNo) {

        OmsOrder omsOrder = new OmsOrder();
        omsOrder.setOrderSn(outTradeNo);
        OmsOrder omsOrder1 = omsOrderMapper.selectOne(omsOrder);

        return omsOrder1;
    }

    @Override
    public void updateOrder(OmsOrder omsOrder) {
        Example e = new Example(OmsOrder.class);
        e.createCriteria().andEqualTo("orderSn",omsOrder.getOrderSn());


        OmsOrder omsOrderUpdate = new OmsOrder();

        omsOrderUpdate.setStatus("1");
        omsOrderUpdate.setPaymentTime(new Date());
        omsOrderUpdate.setPayType(1);

        // 发送一个订单已支付的队列，提供给库存消费
        Connection connection = null;
        Session session = null;
        try{
            connection = activeMQUtil.getConnectionFactory().createConnection();
            session = connection.createSession(true,Session.SESSION_TRANSACTED);
            Queue payhment_success_queue = session.createQueue("ORDER_PAY_QUEUE");
            MessageProducer producer = session.createProducer(payhment_success_queue);
            TextMessage textMessage=new ActiveMQTextMessage();//字符串文本
            //MapMessage mapMessage = new ActiveMQMapMessage();// hash结构

            // 查询订单的对象，转化成json字符串，存入ORDER_PAY_QUEUE的消息队列
            OmsOrder omsOrderParam = new OmsOrder();
            omsOrderParam.setOrderSn(omsOrder.getOrderSn());
            OmsOrder omsOrderResponse = omsOrderMapper.selectOne(omsOrderParam);

            OmsOrderItem omsOrderItemParam = new OmsOrderItem();
            omsOrderItemParam.setOrderSn(omsOrderParam.getOrderSn());
            List<OmsOrderItem> select = omsOrderItemMapper.select(omsOrderItemParam);
            omsOrderResponse.setOmsOrderItems(select);
            textMessage.setText(JSON.toJSONString(omsOrderResponse));

            omsOrderMapper.updateByExampleSelective(omsOrderUpdate,e);
            producer.send(textMessage);
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
    public List<OmsOrder> getOrdersByuId(String uId) {
        List<OmsOrder> omsOrderFromDb = orderFromDb(uId);
        return omsOrderFromDb;
    }
    /*public List<OmsCartItem> cartList(String userId) {
        Jedis jedis = null;
        List<OmsCartItem> omsCartItems = new ArrayList<>();
        try {
            jedis = redisUtil.getJedis();

            List<String> hvals = jedis.hvals("user:" + userId + ":cart");

            for (String hval : hvals) {
                OmsCartItem omsCartItem = JSON.parseObject(hval, OmsCartItem.class);
                omsCartItems.add(omsCartItem);
            }

        } catch (Exception e) {
            // 处理异常，记录系统日志
            e.printStackTrace();
            //String message = e.getMessage();
            //logService.addErrLog(message);
            return null;
        } finally {
            jedis.close();
        }

        return omsCartItems;
    }*/

    /*@Override
    public List<OmsOrder> getOrdersByuId(String uId) {
        Jedis jedis = null;
        List<OmsOrder> omsOrderFromCache = new ArrayList<>();
        try {
            jedis = redisUtil.getJedis();

            if (jedis != null) {
                Map<String, String> omsOrders = jedis.hgetAll("order:" + uId + ":info");
                System.out.println("redis取订单："+omsOrders);
                if (omsOrders.size()>0) {
                    // 根据用户去订单
                    //List<OmsOrder> omsOrderFromCache = JSON.parseArray(omsOrders, OmsOrder.class);
                    //return omsOrderFromCache;
                for (String hval : omsOrders.values()) {
                    OmsOrder omsOrder = JSON.parseObject(hval, OmsOrder.class);
                    omsOrderFromCache.add(omsOrder);
                    System.out.println("成功没："+omsOrder);
                    return omsOrderFromCache;
                }
                }
            }
            // 链接redis失败，开启数据库
            List<OmsOrder> omsOrderFromDb = orderFromDb(uId);
            if (omsOrderFromDb != null) {
                //放入redis缓存
                for (OmsOrder omsOrder :omsOrderFromDb){
                    jedis.hset("order:" + uId + ":info", omsOrder.getOrderSn(),JSON.toJSONString(omsOrder));
                }
                //jedis.setex("order:" + uId + ":info", 60 * 60 * 24, JSON.toJSONString(omsOrderFromDb));
            }
            System.out.println("数据库取订单："+omsOrderFromDb);
            return omsOrderFromDb;
        } catch (Exception e) {
            // 处理异常，记录系统日志
            e.printStackTrace();
            //String message = e.getMessage();
            //logService.addErrLog(message);
            return null;
        }finally {
            jedis.close();
        }
    }*/

    @Override
    public List<OmsOrderItem> getOrderItemsByOid(String oId) {
        OmsOrderItem omsOrderItem = new OmsOrderItem();
        omsOrderItem.setOrderId(oId);
        List<OmsOrderItem> omsOrderItems = omsOrderItemMapper.select(omsOrderItem);
        return omsOrderItems;
    }

    @Override
    public OmsOrder getorderByorderSn(String orderSn) {
        OmsOrder omsOrder = new OmsOrder();
        omsOrder.setOrderSn(orderSn);
        OmsOrder omsOrder1 = omsOrderMapper.selectOne(omsOrder);
        return omsOrder1;
    }

    @Override
    public List<OmsOrder> getOrdersByuIdAndStus(String uId, String status) {
        OmsOrder omsOrder =new OmsOrder();
        omsOrder.setMemberId(uId);
        if (status!=null){
            omsOrder.setStatus(status);
        }
        List<OmsOrder> omsOrders = omsOrderMapper.select(omsOrder);
        if (omsOrders != null&&omsOrders.size()>0) {
            return omsOrders;
        }

        return null;
    }

    @Override
    public void updateOrderStusAndCStus(OmsOrder omsOrder) {
//        Example e = new Example(OmsOrder.class);
//        e.createCriteria().andEqualTo("status",omsOrder.getStatus()).andEqualTo("confirmStatus",omsOrder.getConfirmStatus());
        omsOrderMapper.updateByPrimaryKeySelective(omsOrder);
        //System.out.println("更新后数据库的order:"+omsOrder);
        // 缓存同步
        //flushOrderCache(omsOrder.getMemberId(),omsOrder.getOrderSn());
        //System.out.println("更新后redis的order:"+omsOrder);
    }

    @Override
    public void flushOrderCache(String memberId,String orderSn) {
        OmsOrder omsOrder = new OmsOrder();
        omsOrder.setMemberId(memberId);
        omsOrder.setOrderSn(orderSn);
        List<OmsOrder> omsOrders = omsOrderMapper.select(omsOrder);

        // 同步到redis缓存中
        Jedis jedis = redisUtil.getJedis();

        Map<String, String> map = new HashMap<>();
        for (OmsOrder order : omsOrders) {
            map.put(order.getOrderSn(), JSON.toJSONString(order));
        }

        jedis.hdel("order:" + memberId + ":info",orderSn);
        jedis.hmset("order:" + memberId + ":info", map);


        jedis.close();

    }

    @Override
    public void deleteOrder(OmsOrder omsOrder) {
        omsOrder.setDeleteStatus(1);
        omsOrder.setModifyTime(new Date());
        omsOrderMapper.updateByPrimaryKey(omsOrder);
    }

    @Override
    public List<OmsOrder> getOrdersByOrdType(String orderType) {
        OmsOrder omsOrder =new OmsOrder();
        omsOrder.setOrderType(Integer.valueOf(orderType));
        List<OmsOrder> omsOrders = omsOrderMapper.select(omsOrder);
        return omsOrders;
    }

    @Override
    public List<OmsOrder> getOrdersByStatus() {
        OmsOrder omsOrder =new OmsOrder();
        omsOrder.setStatus(String.valueOf(1));
        List<OmsOrder> orders = omsOrderMapper.select(omsOrder);
        return orders;
    }

    @Override
    public List<OmsOrder> getOrdersByStatus(String status,Integer orderType) {
        OmsOrder omsOrder =new OmsOrder();
        omsOrder.setStatus(status);
        if ("2".equals(status)){
            omsOrder.setConfirmStatus(1);
        }
        if (orderType!=null){
            omsOrder.setOrderType(orderType);
        }
        List<OmsOrder> orders = omsOrderMapper.select(omsOrder);
        return orders;
    }

    @Override
    public List<OmsOrder> getAllOrders() {
        List<OmsOrder> omsOrders = omsOrderMapper.selectAll();
        return omsOrders;
    }

    @Override
    public List<OmsOrder> getOrdersByFilter(OmsOrder omsOrder) {
        List<OmsOrder> omsOrders = omsOrderMapper.select(omsOrder);
        return omsOrders;
    }

    @Override
    public void updateorder(OmsOrder omsOrder) {
        omsOrderMapper.updateByPrimaryKeySelective(omsOrder);
    }

    private List<OmsOrder> orderFromDb(String uId) {

        OmsOrder omsOrder =new OmsOrder();
        omsOrder.setMemberId(uId);

        List<OmsOrder> omsOrders = omsOrderMapper.select(omsOrder);

        if (omsOrders != null&&omsOrders.size()>0) {
            return omsOrders;
        }

        return null;

    }

    /*

    @Override
    public void checkCart(OmsCartItem omsCartItem) {

        Example e = new Example(OmsCartItem.class);

        e.createCriteria().andEqualTo("memberId", omsCartItem.getMemberId()).andEqualTo("productSkuId", omsCartItem.getProductSkuId());

        omsCartItemMapper.updateByExampleSelective(omsCartItem, e);

        // 缓存同步
        flushCartCache(omsCartItem.getMemberId());

    }

    @Override
    public void flushCartCache(String memberId) {

        OmsCartItem omsCartItem = new OmsCartItem();
        omsCartItem.setMemberId(memberId);
        List<OmsCartItem> omsCartItems = omsCartItemMapper.select(omsCartItem);

        // 同步到redis缓存中
        Jedis jedis = redisUtil.getJedis();

        Map<String, String> map = new HashMap<>();
        for (OmsCartItem cartItem : omsCartItems) {
            cartItem.setTotalPrice(cartItem.getPrice().multiply(cartItem.getQuantity()));
            map.put(cartItem.getProductSkuId(), JSON.toJSONString(cartItem));
        }

        jedis.del("user:" + memberId + ":cart");
        jedis.hmset("user:" + memberId + ":cart", map);


        jedis.close();
    }*/

}



