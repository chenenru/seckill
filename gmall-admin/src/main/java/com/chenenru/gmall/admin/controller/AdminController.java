package com.chenenru.gmall.admin.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.chenenru.gmall.bean.*;
import com.chenenru.gmall.service.*;
import io.searchbox.client.JestClient;
import io.searchbox.core.Index;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @Author chenenru
 * @ClassName AdminController
 * @Description
 * @Date 2020/3/28 2:11
 * @Version 1.0
 **/
@Controller
public class AdminController {
    private static final Logger log = LoggerFactory.getLogger(AdminController.class);

    @Reference
    OrderService orderService;

    @Reference
    UserService userService;

    @Reference
    SkuService skuService;

    @Reference
    SpuService spuService;

    @Reference
    CatalogService catalogService;

    @Reference
    KillService killService;

    @Autowired
    JestClient jestClient;


    @RequestMapping("index")
    public String index(){
        return "index";
    }

    @RequestMapping("login")
    public String login(){
        return "login";
    }

    //"href": "html/often/form-complex2",
    @RequestMapping("html/order-add")
    public String orderadd(String orderSn,ModelMap modelMap){
        OmsOrder omsOrder = orderService.getorderByorderSn(orderSn);
        if (!("").equals(omsOrder)&&null!=omsOrder){
            List<OmsOrderItem> items = orderService.getOrderItemsByOid(omsOrder.getId());
            omsOrder.setOmsOrderItems(items);
        }
        modelMap.put("order",omsOrder);
        return "html/order-add";
    }

    @RequestMapping("html/order-update")
    @ResponseBody
    public String updateorder(OmsOrder omsOrder){
        omsOrder.setModifyTime(new Date());
        orderService.updateorder(omsOrder);
        return "success";
    }

    @RequestMapping("html/order-del")
    @ResponseBody
    public String orderdel(String orderSn,String operation,ModelMap modelMap){//1 删除 2发货
        OmsOrder omsOrder=new OmsOrder();
        omsOrder.setOrderSn(orderSn);
        omsOrder=orderService.getorderByorderSn(orderSn);
        if ("1".equals(operation)){
            omsOrder.setDeleteStatus(1);
        }else if ("2".equals(operation)){
            omsOrder.setStatus(String.valueOf(2));
            omsOrder.setDeliveryTime(new Date());
        }
        orderService.updateOrderStusAndCStus(omsOrder);
       /* List<OmsOrder> omsOrders= orderService.getAllOrders();
        if (!("").equals(omsOrders)&&null!=omsOrders){
            for (OmsOrder order: omsOrders) {
                List<OmsOrderItem> items = orderService.getOrderItemsByOid(order.getId());
                order.setOmsOrderItems(items);
            }
        }
        modelMap.put("orders", omsOrders);
        return "html/order-list";*/
       return "success";
    }

    //"href": "html/often/article",
    @RequestMapping("html/order-list")
    public String orderlist(String orderType,String payType,String status,String orderSn,ModelMap modelMap){
        List<OmsOrder> omsOrders=new ArrayList<>();
        if (StringUtils.isBlank(orderType)&&StringUtils.isBlank(payType)&&StringUtils.isBlank(status)&&StringUtils.isBlank(orderSn)){
            omsOrders= orderService.getAllOrders();
        }else {
            OmsOrder omsOrder=new OmsOrder();
           if (!"".equals(orderType)){
               omsOrder.setOrderType(Integer.valueOf(orderType));
           }
           if (!"".equals(payType)){
               omsOrder.setPayType(Integer.valueOf(payType));
           }
            if (!"".equals(status)){
                omsOrder.setStatus(status);
            }
            if (!"".equals(orderSn)){
                omsOrder.setOrderSn(orderSn);
            }
            omsOrders=orderService.getOrdersByFilter(omsOrder);
        }
        if (!("").equals(omsOrders)&&null!=omsOrders){
            for (OmsOrder order: omsOrders) {
                List<OmsOrderItem> items = orderService.getOrderItemsByOid(order.getId());
                order.setOmsOrderItems(items);
            }
        }
        modelMap.put("orders", omsOrders);
        return "html/order-list";
    }

    //"href": "html/chart/chart5",
    @RequestMapping("html/member-list")
    public String memberlist(String username,ModelMap modelMap){
        List<UmsMember> allUser =new ArrayList<>();
        if (StringUtils.isBlank(username)||"".equals(username)){
            allUser = userService.getAllUser();
        }else {
            UmsMember umsMember=new UmsMember();
            umsMember.setUsername(username);
            umsMember=userService.getOauthUser(umsMember);
            allUser.add(umsMember);
        }
        modelMap.put("users", allUser);
        //modelMap.put("size", allUser.size());
        return "html/member-list";
    }

    //"href": "html/chart/chart2",
    @RequestMapping("html/member-del")
    @ResponseBody
    public String memberdel(String userId,String status,ModelMap modelMap){
        UmsMember umsMember = userService.getUserByuId(userId);
        umsMember.setStatus(Integer.valueOf(status));
        userService.updateUser(umsMember);
        //List<UmsMember> allUser = userService.getAllUser();
        //modelMap.put("users", allUser);
        //return "html/member-list";
        return "success";
    }


    //"href": "html/chart/chart4",
    @RequestMapping("html/member-edit")
    public String memberedit(String userId,ModelMap modelMap){
        UmsMember umsMember = userService.getUserByuId(userId);
        modelMap.put("user", umsMember);
        return "html/member-edit";
    }

    @RequestMapping("html/product-add")
    @ResponseBody
    public String productadd() throws IOException {
        // 查询mysql数据
        List<PmsSkuInfo> pmsSkuInfoList = new ArrayList<>();

        pmsSkuInfoList = skuService.getAllSku("1261");

        // 转化为es的数据结构
        List<PmsSearchSkuInfo> pmsSearchSkuInfos = new ArrayList<>();

        for (PmsSkuInfo pmsSkuInfo : pmsSkuInfoList) {
            PmsSearchSkuInfo pmsSearchSkuInfo = new PmsSearchSkuInfo();

            BeanUtils.copyProperties(pmsSkuInfo, pmsSearchSkuInfo);

            pmsSearchSkuInfo.setId(Long.parseLong(pmsSkuInfo.getId()));

            pmsSearchSkuInfos.add(pmsSearchSkuInfo);

        }

        // 导入es
        for (PmsSearchSkuInfo pmsSearchSkuInfo : pmsSearchSkuInfos) {
            Index put = new Index.Builder(pmsSearchSkuInfo).index("gmall0105").type("PmsSkuInfo").id(pmsSearchSkuInfo.getId() + "").build();
            jestClient.execute(put);
        }
        System.out.println("成功");
        return "success";
    }

    @RequestMapping("html/product-update")
    @ResponseBody
    public String productupdate(PmsSkuInfo pmsSkuInfo,ModelMap modelMap){
        String success=skuService.updateSkuInfo(pmsSkuInfo);
        return success;
    }

    @RequestMapping("html/product-edit")
    public String adminedit(String skuId,ModelMap modelMap){
        PmsSkuInfo skuInfo = skuService.getSkuById(skuId, "127.0.0.1");
       /* List<PmsSkuSaleAttrValue> skuSaleAttrValues= skuService.getSkuSaleAttrValueListBySkuId(skuId);
        skuInfo.setSkuSaleAttrValueList(skuSaleAttrValues);*/
        modelMap.put("sku", skuInfo);
        return "html/product-edit";
    }

    @RequestMapping("html/product-list")
    public String adminlist(String skuName,ModelMap modelMap){
        List<PmsBaseCatalog1> catalog1 = catalogService.getCatalog1();
        List<PmsBaseCatalog2> catalog2 = catalogService.getCatalog2("11");
        List<PmsBaseCatalog3> catalog3 = catalogService.getCatalog3("61");
        List<PmsProductInfo> pmsProductInfos = spuService.spuList("1261");
        List<PmsSkuInfo> allSku = new ArrayList<>();
        for(PmsProductInfo pmsProductInfo: pmsProductInfos){
            List<PmsSkuInfo> pmsSkuInfos = skuService.getSkuSaleAttrValueListBySpu(pmsProductInfo.getId());
            for (PmsSkuInfo pmsSkuInfo:pmsSkuInfos){
                if (!"".equals(skuName)&&StringUtils.isNotBlank(skuName)){
                    if (pmsSkuInfo.getSkuName().equals(skuName)||pmsSkuInfo.getSkuName()==skuName){
                        allSku.add(pmsSkuInfo);
                    }
                }else {
                    allSku.add(pmsSkuInfo);
                }
            }
        }
        modelMap.put("catalog1", catalog1);
        modelMap.put("catalog2",catalog2);
        modelMap.put("catalog3",catalog3);
        modelMap.put("allSku",allSku);
        modelMap.put("size",allSku.size());
        return "html/product-list";
    }

    @RequestMapping("html/kill-list")
    public String adminrole(ItemKill kill,ModelMap modelMap){
        try{
            //获取秒杀商品列表
            /*List<ItemKill> kills=new ArrayList<>();
            List<ItemKill> list = killService.getKillItems();
            if ((!"".equals(kill.getStartTime())&&kill.getStartTime()!=null)|| (!"".equals(kill.getEndTime())&&kill.getEndTime()!=null)|| (StringUtils.isNotBlank(kill.getItemName())&&!"".equals(kill.getItemName()))){
                for (ItemKill itemKill:list){
                    if (itemKill.getStartTime().after(kill.getStartTime())|| itemKill.getEndTime().before(kill.getEndTime())|| itemKill.getItemName().equals(kill.getItemName())){
                        System.out.println("????");
                        kills.add(itemKill);
                    }
                }
                modelMap.put("list", kills);
            }else {
                modelMap.put("list", list);
            }*/
            List<ItemKill> kills=new ArrayList<>();
            List<ItemKill> list = killService.getKillItems();
            if (StringUtils.isNotBlank(kill.getItemName())&&!"".equals(kill.getItemName())){
                for (ItemKill itemKill:list){
                    if (itemKill.getItemName().equals(kill.getItemName())){
                        //System.out.println("????");
                        kills.add(itemKill);
                    }
                }
                modelMap.put("list", kills);
            }else {
                modelMap.put("list", list);
            }
            log.info("获取秒杀商品列表-数据{}",list);
        }catch (Exception e){
            log.error("获取待秒杀商品列表异常：",e.fillInStackTrace());
            return "redirect:/base/error";
        }
        return "html/kill-list";
    }


    @RequestMapping("html/kill-add")
    @ResponseBody
    public String roleadd(Integer id){
        ItemKill kill =new ItemKill();
        kill.setItemId(String.valueOf(id));
        kill.setStartTime(new Date());
        kill.setEndTime(new Date());
        kill.setIsActive((byte) 1);
        kill.setTotal(0);
        kill.setCreateTime(new Date());
        String success = killService.saveKill(kill);
        return success;
    }

    //"href": "html/often/link",
    @RequestMapping("html/kill-edit")
    public String roleedit(Integer id, ModelMap modelMap, HttpServletRequest request){
        if (id==null||id<0){
            return "redirect:/base/error";
        }
        try {
            ItemKill detail = killService.getDetailKill(id);
            modelMap.put("detail", detail);

            String remoteAddr = request.getRemoteAddr();
            // request.getHeader("");// nginx负载均衡
            //sku对象
            PmsSkuInfo pmsSkuInfo = skuService.getSkuById(detail.getItemId(), remoteAddr);
            modelMap.put("skuInfo", pmsSkuInfo);
        }catch (Exception e){
            log.error("获取待秒杀商品的详情-发生异常：id={}",id,e.fillInStackTrace());
            return "redirect:/base/error";
        }
        return "html/kill-edit";
    }
    @RequestMapping("html/kill-update")
    @ResponseBody
    public String roleupdate(ItemKill kill){
        String success = killService.updateKill(kill);
        return success;
    }

    //"href": "html/system/shield",
    @RequestMapping("html/welcome")
    public String welcome(){
        return "html/welcome";
    }
}
