package com.chenenru.gmall.order.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.chenenru.gmall.annotations.LoginRequired;
import com.chenenru.gmall.bean.*;
import com.chenenru.gmall.service.CartService;
import com.chenenru.gmall.service.OrderService;
import com.chenenru.gmall.service.SkuService;
import com.chenenru.gmall.service.UserService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @Author chenenru
 * @ClassName OrderController
 * @Description
 * @Date 2020/2/25 17:00
 * @Version 1.0
 **/

@Controller
public class OrderController {

    @Reference
    CartService cartService;

    @Reference
    UserService userService;

    @Reference
    OrderService orderService;

    @Reference
    SkuService skuService;


    @RequestMapping("submitOrder")
    @LoginRequired(loginSuccess = true)
    public ModelAndView submitOrder(String receiveAddressId, BigDecimal totalAmount, String tradeCode, HttpServletRequest request, HttpServletResponse response, HttpSession session, ModelMap modelMap) {


        String memberId = (String) request.getAttribute("memberId");
        String nickname = (String) request.getAttribute("nickname");

        // 检查交易码
        String success = orderService.checkTradeCode(memberId, tradeCode);

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
            //omsOrder.setOrderType(1);

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
            omsOrder.setPayType(0);
            omsOrder.setAutoConfirmDay(7);

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


            // 重定向到支付系统
            ModelAndView mv = new ModelAndView("redirect:http://payment.gmall.com:8098/index");
            mv.addObject("outTradeNo",outTradeNo);
            mv.addObject("totalAmount",totalAmount);
            return mv;
        } else {
            ModelAndView mv = new ModelAndView("tradeFail");
            return mv;
        }

    }


    @RequestMapping("toTrade")
    @LoginRequired(loginSuccess = true)
    public String toTrade(HttpServletRequest request, HttpServletResponse response, HttpSession session, ModelMap modelMap) {

        String memberId = (String) request.getAttribute("memberId");
        String nickname = (String) request.getAttribute("nickname");

        // 收件人地址列表
        List<UmsMemberReceiveAddress> umsMemberReceiveAddresses = userService.getReceiveAddressByMemberId(memberId);

        // 将购物车集合转化为页面计算清单集合
        List<OmsCartItem> omsCartItems = cartService.cartList(memberId);

        List<OmsOrderItem> omsOrderItems = new ArrayList<>();

        for (OmsCartItem omsCartItem : omsCartItems) {
            // 每循环一个购物车对象，就封装一个商品的详情到OmsOrderItem
            if (omsCartItem.getIsChecked().equals("1")) {
                OmsOrderItem omsOrderItem = new OmsOrderItem();
                omsOrderItem.setProductName(omsCartItem.getProductName());
                omsOrderItem.setProductPic(omsCartItem.getProductPic());
                omsOrderItems.add(omsOrderItem);
            }
        }

        modelMap.put("omsOrderItems", omsOrderItems);
        modelMap.put("userAddressList", umsMemberReceiveAddresses);
        modelMap.put("defaultUserAddressId", umsMemberReceiveAddresses.get(0).getId());
        modelMap.put("totalAmount", getTotalAmount(omsCartItems));

        // 生成交易码，为了在提交订单时做交易码的校验
        String tradeCode = orderService.getTradeCode(memberId);
        modelMap.put("tradeCode", tradeCode);
        modelMap.put("memberId", memberId);
        return "trade";
    }

    //商品信息立即下单
    @RequestMapping("toTradeNotCart")
    @LoginRequired(loginSuccess = true)
    public String toTradeNotCart(String skuId,HttpServletRequest request, HttpServletResponse response, HttpSession session, ModelMap modelMap) {

        String memberId = (String) request.getAttribute("memberId");
        String nickname = (String) request.getAttribute("nickname");

        // 收件人地址列表
        List<UmsMemberReceiveAddress> umsMemberReceiveAddresses = userService.getReceiveAddressByMemberId(memberId);

        // 将购物车集合转化为页面计算清单集合
        /*List<OmsCartItem> omsCartItems = cartService.cartList(memberId);

        List<OmsOrderItem> omsOrderItems = new ArrayList<>();

        for (OmsCartItem omsCartItem : omsCartItems) {
            // 每循环一个购物车对象，就封装一个商品的详情到OmsOrderItem
            if (omsCartItem.getIsChecked().equals("1")) {
                OmsOrderItem omsOrderItem = new OmsOrderItem();
                omsOrderItem.setProductName(omsCartItem.getProductName());
                omsOrderItem.setProductPic(omsCartItem.getProductPic());
                omsOrderItems.add(omsOrderItem);
            }
        }*/

        //立即下单，查询商品信息
        PmsSkuInfo pmsSkuInfo = skuService.getSkuById(skuId, "");
        modelMap.put("pmsSkuInfo", pmsSkuInfo);
        modelMap.put("userAddressList", umsMemberReceiveAddresses);
        modelMap.put("defaultUserAddressId", umsMemberReceiveAddresses.get(0).getId());
        modelMap.put("totalAmount", pmsSkuInfo.getPrice());

        // 生成交易码，为了在提交订单时做交易码的校验
        String tradeCode = orderService.getTradeCode(memberId);
        modelMap.put("tradeCode", tradeCode);
        modelMap.put("memberId", memberId);
        return "trade";
    }


    private BigDecimal getTotalAmount(List<OmsCartItem> omsCartItems) {
        BigDecimal totalAmount = new BigDecimal("0");

        for (OmsCartItem omsCartItem : omsCartItems) {
            BigDecimal totalPrice = omsCartItem.getTotalPrice();

            if (omsCartItem.getIsChecked().equals("1")) {
                totalAmount = totalAmount.add(totalPrice);
            }
        }

        return totalAmount;
    }

    @RequestMapping("orderList")
    @LoginRequired(loginSuccess = true)
    public String orderList(String status,ModelMap modelMap, HttpServletRequest request){
        String uId = (String) request.getAttribute("memberId");
        System.out.println("orderList-uId:"+uId);
        System.out.println("orderList-status:"+status);
        List<OmsOrder> omsOrders =new ArrayList<>();
        if (status!=null){
            omsOrders=orderService.getOrdersByuIdAndStus(uId,status);
        }
        else {
            omsOrders = orderService.getOrdersByuId(uId);
        }
        if (!("").equals(omsOrders)&&null!=omsOrders){
            for (OmsOrder order: omsOrders) {
                List<OmsOrderItem> items = orderService.getOrderItemsByOid(order.getId());
                order.setOmsOrderItems(items);
            }
        }
        System.out.println("orderList-uId:"+uId+" status:"+status);
        modelMap.put("orderList", omsOrders);
        return "list";
    }
    //确认收货或者取消订单
    @RequestMapping("orderstus")
    public String orderStus(String status,String confirmStatus,String orderSn){
        System.out.println("orderStus-status:"+status+" confirmStatus:"+confirmStatus+" orderSn:"+orderSn);
        OmsOrder omsOrder=orderService.getorderByorderSn(orderSn);
        if (status!=null){
            omsOrder.setStatus(status);
        }
        if (confirmStatus!=null){
            int cstus= Integer.parseInt(confirmStatus);
            omsOrder.setConfirmStatus(cstus);
            omsOrder.setReceiveTime(new Date());
        }
        orderService.updateOrderStusAndCStus(omsOrder);
        System.out.println("更新的order："+omsOrder);
        return "redirect:/orderList";
    }

    //订单详情
    @RequestMapping("orderDetial")
    public String orderItemByOid(String orderSn,ModelMap modelMap){
        System.out.println("orderItemByOid-orderSn:"+orderSn);
        OmsOrder omsOrder = orderService.getorderByorderSn(orderSn);
        List<OmsOrderItem> items = orderService.getOrderItemsByOid(omsOrder.getId());
        omsOrder.setOmsOrderItems(items);
        modelMap.put("order",omsOrder);
        return "detail";
    }

    //去支付
    @RequestMapping("topay")
    public String topay(String orderSn,ModelMap modelMap){
        System.out.println("topay-orderSn:"+orderSn);
        OmsOrder omsOrder=orderService.getorderByorderSn(orderSn);
        List<OmsOrderItem> items = orderService.getOrderItemsByOid(omsOrder.getId());
        omsOrder.setOmsOrderItems(items);
        modelMap.put("order",omsOrder);
        return "topay";
    }
    //删除订单
    @RequestMapping("delorder")
    public String delOrder(String orderSn){
        System.out.println("delOrder-orderSn"+orderSn);
        OmsOrder omsOrder=orderService.getorderByorderSn(orderSn);
        orderService.deleteOrder(omsOrder);
        return "redirect:/orderList";
    }

    //查询秒杀订单
    @RequestMapping("selordertype")
    public String selordertype(String orderType,ModelMap modelMap){
        System.out.println("selordertype-orderType:"+orderType);
        List<OmsOrder> omsOrders = orderService.getOrdersByOrdType(orderType);
        modelMap.put("orderList", omsOrders);
        return "list";
    }

    //同时插入到order表
    /*@RequestMapping("insertkillToOrder")
    public String insertkillToOrder(String orderNo,String memberId,String itemId){
        System.out.println("insertToOrder-memberId:"+memberId+" itemId :"+itemId+" orderNo不知道为什么为空:"+orderNo);
        OmsOrder order =new OmsOrder();
        if (StringUtils.isNotBlank(orderNo)){
            order = orderService.getorderByorderSn(orderNo);

        if (order==null) {
            //总结：
            //收件人地址
            // 收件人地址列表
            List<UmsMemberReceiveAddress> umsMemberReceiveAddresses = userService.getReceiveAddressByMemberId(memberId);
            UmsMember umsMember = new UmsMember();
            umsMember.setId(memberId);
            umsMember = userService.getOauthUser(umsMember);
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
            //String outTradeNo = "gmall";
            //outTradeNo = outTradeNo + System.currentTimeMillis();// 将毫秒时间戳拼接到外部订单号
            //SimpleDateFormat sdf = new SimpleDateFormat("YYYYMMDDHHmmss");
            //outTradeNo = outTradeNo + sdf.format(new Date());// 将时间字符串拼接到外部订单号

            omsOrder.setOrderSn(orderNo);//外部订单号
            omsOrder.setOrderType(1);

            //订单的地址
            if (umsMemberReceiveAddresses != null && !("").equals(umsMemberReceiveAddresses) && umsMemberReceiveAddresses.size() > 0) {
                UmsMemberReceiveAddress umsMemberReceiveAddress = umsMemberReceiveAddresses.get(0);
                if (umsMemberReceiveAddress == null) {
                    umsMemberReceiveAddress = userService.getReceiveAddressById(String.valueOf(0));
                }
                System.out.println("umsMemberReceiveAddress:" + umsMemberReceiveAddress);
                omsOrder.setReceiverCity(umsMemberReceiveAddress.getCity());
                omsOrder.setReceiverDetailAddress(umsMemberReceiveAddress.getDetailAddress());
                omsOrder.setReceiverName(umsMemberReceiveAddress.getName());
                omsOrder.setReceiverPhone(umsMemberReceiveAddress.getPhoneNumber());
                omsOrder.setReceiverPostCode(umsMemberReceiveAddress.getPostCode());
                omsOrder.setReceiverProvince(umsMemberReceiveAddress.getProvince());
                omsOrder.setReceiverRegion(umsMemberReceiveAddress.getRegion());
            }
            // 当前日期加一天，一天后配送
            Calendar c = Calendar.getInstance();
            c.add(Calendar.DATE, 1);
            Date time = c.getTime();
            omsOrder.setReceiveTime(time);
            omsOrder.setSourceType(0);
            omsOrder.setStatus("0");
            omsOrder.setOrderType(1);

            //要购买的商品列表
            PmsSkuInfo skuInfo = skuService.getSkuById(itemId, "");
            // 获得订单详情列表
            List<OmsOrderItem> omsOrderItems = new ArrayList<>();
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
            //omsOrder.setOrderType(1);

            // 将订单和订单详情写入数据库
            orderService.saveOrder(omsOrder);
            // 删除购物车的对应商品
        }
        return "redirect:http://localhost:8097/topay?orderSn="+orderNo;
        }
        return "redirect:http://localhost:8099/base/error";
    }*/
    @RequestMapping("list2")
    public String toList2(){
        return "list2";
    }
}
