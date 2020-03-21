package com.chenenru.gmall.service;

import com.chenenru.gmall.bean.OmsCartItem;
import com.chenenru.gmall.bean.OmsOrder;
import com.chenenru.gmall.bean.OmsOrderItem;

import java.util.List;

public interface OrderService {

    String checkTradeCode(String memberId, String tradeCode);

    String getTradeCode(String memberId);

    void saveOrder(OmsOrder omsOrder);

    OmsOrder getOrderByOutTradeNo(String outTradeNo);

    void updateOrder(OmsOrder omsOrder);

    List<OmsOrder> getOrdersByuId(String uId);

    List<OmsOrderItem> getOrderItemsByOid(String oId);

    OmsOrder getorderByorderSn(String orderSn);

    List<OmsOrder> getOrdersByuIdAndStus(String uId, String status);

    void updateOrderStusAndCStus(OmsOrder omsOrder);

    void flushOrderCache(String memberId,String orderSn);

    void deleteOrder(OmsOrder order);

    List<OmsOrder> getOrdersByOrdType(String orderType);

    List<OmsOrder> getOrdersByStatus();

    List<OmsOrder> getOrdersByStatus(String status,Integer ordertype);
}

