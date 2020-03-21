package com.chenenru.gmall.seckill.service;

import com.alibaba.dubbo.config.annotation.Reference;
import com.chenenru.gmall.bean.*;
import com.chenenru.gmall.seckill.bean.ItemKill;
import com.chenenru.gmall.seckill.bean.ItemKillSuccess;
import com.chenenru.gmall.seckill.dto.KillSuccessUserInfo;
import com.chenenru.gmall.service.OrderService;
import com.chenenru.gmall.service.SkuService;
import com.chenenru.gmall.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @Author chenenru
 * @ClassName KillToOrderAndToPayService
 * @Description
 * @Date 2020/3/11 1:06
 * @Version 1.0
 **/
@Service
public class KillToOrderAndToPayService {
    @Reference
    UserService userService;
    @Reference
    SkuService skuService;
    @Reference
    OrderService orderService;
    @Reference
    ItemKillService itemKillService;
    @Reference
    ItemKillSuccessService itemKillSuccessService;
    //秒杀订单同时插入到order表
    public void insertToOrder(String memberId,String itemId,String orderNo){
        System.out.println("insertToOrder-memberId:"+memberId+" itemId :"+itemId+" orderNo:"+orderNo);

        //总结：
        //收件人地址
        // 收件人地址列表
        List<UmsMemberReceiveAddress> umsMemberReceiveAddresses = userService.getReceiveAddressByMemberId(memberId);
        UmsMember umsMember = new UmsMember();
        umsMember.setId(memberId);
        umsMember=userService.getOauthUser(umsMember);
        //商品skuid--商品列表
        //订单对象
        OmsOrder omsOrder = new OmsOrder();
        omsOrder.setAutoConfirmDay(7);
        omsOrder.setCreateTime(new Date());
        omsOrder.setDiscountAmount(null);
        //omsOrder.setFreightAmount(); 运费，支付后，在生成物流信息时
        omsOrder.setMemberId(memberId);
        omsOrder.setMemberUsername(umsMember.getUsername());
        omsOrder.setNote("快点发货");
        omsOrder.setDeleteStatus(0);
        //String outTradeNo = "gmall";
        //outTradeNo = outTradeNo + System.currentTimeMillis();// 将毫秒时间戳拼接到外部订单号
        //SimpleDateFormat sdf = new SimpleDateFormat("YYYYMMDDHHmmss");
        //outTradeNo = outTradeNo + sdf.format(new Date());// 将时间字符串拼接到外部订单号
        omsOrder.setOrderSn(orderNo);//外部订单号
        //omsOrder.setOrderType(0);

        //订单的地址--->这里容易出bug
        if (umsMemberReceiveAddresses!=null&&!("").equals(umsMemberReceiveAddresses)&&umsMemberReceiveAddresses.size()>0){
            UmsMemberReceiveAddress umsMemberReceiveAddress = umsMemberReceiveAddresses.get(0);
            System.out.println("umsMemberReceiveAddress:"+umsMemberReceiveAddress);
            omsOrder.setReceiverCity(umsMemberReceiveAddress.getCity());
            omsOrder.setReceiverDetailAddress(umsMemberReceiveAddress.getDetailAddress());
            if (umsMemberReceiveAddress.getName()==null){
                omsOrder.setReceiverName(umsMember.getNickname());
            } else {
                omsOrder.setReceiverName(umsMemberReceiveAddress.getName());
            }
            if (umsMemberReceiveAddress.getPhoneNumber()==null){
                omsOrder.setReceiverPhone("135");
            } else {
                omsOrder.setReceiverPhone(umsMemberReceiveAddress.getPhoneNumber());
            }
            omsOrder.setReceiverPostCode(umsMemberReceiveAddress.getPostCode());
            omsOrder.setReceiverProvince(umsMemberReceiveAddress.getProvince());
            omsOrder.setReceiverRegion(umsMemberReceiveAddress.getRegion());
        }
        // 当前日期加一天，一天后配送
        Calendar c = Calendar.getInstance();
        c.add(Calendar.DATE,1);
        Date time = c.getTime();
        omsOrder.setReceiveTime(time);
        omsOrder.setSourceType(0);
        omsOrder.setStatus("0");
        omsOrder.setOrderType(1);
        omsOrder.setPayType(0);
        omsOrder.setAutoConfirmDay(7);
        //要购买的商品列表
        PmsSkuInfo skuInfo = skuService.getSkuById(itemId, "");
        // 获得订单详情列表
        List<OmsOrderItem> omsOrderItems=new ArrayList<>();
        OmsOrderItem omsOrderItem = new OmsOrderItem();

        // 验库存,远程调用库存系统
        omsOrderItem.setProductPic(String.valueOf(skuInfo.getSkuDefaultImg()));
        omsOrderItem.setProductName(skuInfo.getSkuName());
        omsOrderItem.setOrderSn(orderNo);// 外部订单号，用来和其他系统进行交互，防止重复
        omsOrderItem.setProductCategoryId(skuInfo.getCatalog3Id());
        omsOrderItem.setProductPrice(skuInfo.getPrice());
        omsOrderItem.setRealAmount(skuInfo.getPrice());
        omsOrderItem.setProductQuantity(BigDecimal.valueOf(1));
        omsOrderItem.setProductSkuCode(String.valueOf(UUID.randomUUID()));
        omsOrderItem.setProductSkuId(skuInfo.getId());
        omsOrderItem.setProductId(skuInfo.getProductId());
        omsOrderItem.setProductSn("仓库对应的商品编号");// 在仓库中的skuId
        omsOrderItems.add(omsOrderItem);
        omsOrder.setOmsOrderItems(omsOrderItems);
        omsOrder.setTotalAmount(skuInfo.getPrice());
        omsOrder.setPayAmount(skuInfo.getPrice());

        // 将订单和订单详情写入数据库
        orderService.saveOrder(omsOrder);
        // 删除购物车的对应商品
    }

    //统一itemkill和order的支付状态
    public boolean checkItemKillAndOrder(ItemKillSuccess itemKillSuccess) throws Exception{
        //KillSuccessUserInfo killSuccessUserInfo = itemKillSuccessService.selectByCode(orderNo);
        OmsOrder omsOrder = orderService.getorderByorderSn(itemKillSuccess.getCode());
        boolean success =false;
        if (omsOrder!=null){
             if (itemKillSuccess.getStatus()!=Byte.valueOf(omsOrder.getStatus())){
                 success = itemKillSuccessService.updateItemKillStatus(itemKillSuccess, Byte.valueOf(omsOrder.getStatus()));
                 return success;
             }
        }
        return false;
    }
    /*private void insertToOrder(){
        String memberId = (String) request.getAttribute("memberId");
        System.out.println("秒杀支付的用户id:"+memberId);
        String nickname = (String) request.getAttribute("nickname");

        // 收件人地址列表
        List<UmsMemberReceiveAddress> umsMemberReceiveAddresses = userService.getReceiveAddressByMemberId(memberId);


        if (success.equals("success")) {
            List<OmsOrderItem> omsOrderItems = new ArrayList<>();
            // 订单对象
            OmsOrder omsOrder = new OmsOrder();
            omsOrder.setAutoConfirmDay(7);
            omsOrder.setCreateTime(new Date());
            omsOrder.setDiscountAmount(null);
            //omsOrder.setFreightAmount(); 运费，支付后，在生成物流信息时
            omsOrder.setMemberId(memberId);
            omsOrder.setMemberUsername(nickname);
            omsOrder.setNote("快点发货");
            String outTradeNo = "gmall";
            outTradeNo = outTradeNo + System.currentTimeMillis();// 将毫秒时间戳拼接到外部订单号
            SimpleDateFormat sdf = new SimpleDateFormat("YYYYMMDDHHmmss");
            outTradeNo = outTradeNo + sdf.format(new Date());// 将时间字符串拼接到外部订单号

            omsOrder.setOrderSn(outTradeNo);//外部订单号
            omsOrder.setPayAmount(totalAmount);
            omsOrder.setOrderType(1);

            //订单的地址
            UmsMemberReceiveAddress umsMemberReceiveAddress = userService.getReceiveAddressById(receiveAddressId);
            omsOrder.setReceiverCity(umsMemberReceiveAddress.getCity());
            omsOrder.setReceiverDetailAddress(umsMemberReceiveAddress.getDetailAddress());
            omsOrder.setReceiverName(umsMemberReceiveAddress.getName());
            omsOrder.setReceiverPhone(umsMemberReceiveAddress.getPhoneNumber());
            omsOrder.setReceiverPostCode(umsMemberReceiveAddress.getPostCode());
            omsOrder.setReceiverProvince(umsMemberReceiveAddress.getProvince());
            omsOrder.setReceiverRegion(umsMemberReceiveAddress.getRegion());
            // 当前日期加一天，一天后配送
            Calendar c = Calendar.getInstance();
            c.add(Calendar.DATE,1);
            Date time = c.getTime();
            omsOrder.setReceiveTime(time);
            omsOrder.setSourceType(0);
            omsOrder.setStatus("0");
            omsOrder.setOrderType(0);
            omsOrder.setTotalAmount(totalAmount);

            //要购买的商品列表
            // 根据用户id获得要购买的商品列表(购物车)，和总价格
            List<OmsCartItem> omsCartItems = cartService.cartList(memberId);

            for (OmsCartItem omsCartItem : omsCartItems) {
                if (omsCartItem.getIsChecked().equals("1")) {
                    // 获得订单详情列表
                    OmsOrderItem omsOrderItem = new OmsOrderItem();
                    // 检价
                    boolean b = skuService.checkPrice(omsCartItem.getProductSkuId(),omsCartItem.getPrice());
                    if (b == false) {
                        ModelAndView mv = new ModelAndView("tradeFail");
                        return mv;
                    }
                    // 验库存,远程调用库存系统
                    omsOrderItem.setProductPic(omsCartItem.getProductPic());
                    omsOrderItem.setProductName(omsCartItem.getProductName());

                    omsOrderItem.setOrderSn(outTradeNo);// 外部订单号，用来和其他系统进行交互，防止重复
                    omsOrderItem.setProductCategoryId(omsCartItem.getProductCategoryId());
                    omsOrderItem.setProductPrice(omsCartItem.getPrice());
                    omsOrderItem.setRealAmount(omsCartItem.getTotalPrice());
                    omsOrderItem.setProductQuantity(omsCartItem.getQuantity());
                    omsOrderItem.setProductSkuCode(String.valueOf(UUID.randomUUID()));
                    omsOrderItem.setProductSkuId(omsCartItem.getProductSkuId());
                    omsOrderItem.setProductId(omsCartItem.getProductId());
                    omsOrderItem.setProductSn("仓库对应的商品编号");// 在仓库中的skuId

                    omsOrderItems.add(omsOrderItem);
                }
            }
            omsOrder.setOmsOrderItems(omsOrderItems);

            // 将订单和订单详情写入数据库
            orderService.saveOrder(omsOrder);
            // 删除购物车的对应商品
    }*/
}
