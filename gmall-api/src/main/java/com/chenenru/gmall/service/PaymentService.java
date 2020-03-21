package com.chenenru.gmall.service;

import com.chenenru.gmall.bean.PaymentInfo;

import java.util.Map;

public interface PaymentService {
    void savePaymentInfo(PaymentInfo paymentInfo);

    void updatePayment(PaymentInfo paymentInfo);

    void sendDelayPaymentResultCheckQueue(String outTradeNo,int count);

    Map<String,Object> checkAlipayPayment(String out_trade_no);


    PaymentInfo selectPaymentInfoByoutTradeNo(String outTradeNo);
}

