package com.chenenru.gmall.order.mq;

import com.chenenru.gmall.bean.OmsOrder;
import com.chenenru.gmall.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.annotation.JmsListener;
import org.springframework.stereotype.Component;

import javax.jms.JMSException;
import javax.jms.MapMessage;

/**
 * @Author chenenru
 * @ClassName OrderServiceMqListener
 * @Description
 * @Date 2020/2/26 19:15
 * @Version 1.0
 **/
@Component
public class OrderServiceMqListener {

    @Autowired
    OrderService orderService;

    @JmsListener(destination = "PAYHMENT_SUCCESS_QUEUE",containerFactory = "jmsQueueListener")
    public void consumePaymentResult(MapMessage mapMessage) throws JMSException {

        String out_trade_no = mapMessage.getString("out_trade_no");

        // 更新订单状态业务
        System.out.println(out_trade_no);

        OmsOrder omsOrder = new OmsOrder();
        omsOrder.setOrderSn(out_trade_no);

        orderService.updateOrder(omsOrder);

        System.out.println("更新订单状态业务:------11111111111111");


    }
}
