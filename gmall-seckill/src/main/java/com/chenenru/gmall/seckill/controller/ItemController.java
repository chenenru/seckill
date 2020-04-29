package com.chenenru.gmall.seckill.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.alibaba.fastjson.JSON;
import com.chenenru.gmall.annotations.LoginRequired;
import com.chenenru.gmall.bean.PmsProductSaleAttr;
import com.chenenru.gmall.bean.PmsSkuInfo;
import com.chenenru.gmall.bean.PmsSkuSaleAttrValue;
import com.chenenru.gmall.seckill.bean.ItemKill;
import com.chenenru.gmall.seckill.service.ItemKillService;
import com.chenenru.gmall.service.SkuService;
import com.chenenru.gmall.service.SpuService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author chenenru
 * @ClassName ItemController
 * @Description
 * @Date 2020/1/30 12:32
 * @Version 1.0
 **/
@CrossOrigin
@Controller
public class ItemController {
    private static final Logger log = LoggerFactory.getLogger(ItemController.class);

    private static final String prefix = "item";

    @Reference
    SkuService skuService;
    @Reference
    SpuService spuService;

    @Reference
    ItemKillService itemKillService;

    /**
     * 获取商品列表
     */
    @RequestMapping(value = {prefix+"/",prefix+"/index",prefix+"/list",prefix+"/index.html"},method = RequestMethod.GET)
    @LoginRequired(loginSuccess = false)
    public String list(ModelMap modelMap, HttpServletRequest request){
        try{
            String memberId = (String) request.getAttribute("memberId");
            String nickname = (String) request.getAttribute("nickname");
            //获取秒杀商品列表
            List<ItemKill> list = itemKillService.getKillItems();
            for (ItemKill itemKill:list){
                System.out.println(itemKill.toString());
            }
            modelMap.put("memberId", memberId);
            modelMap.put("list", list);
            log.info("获取秒杀商品列表-数据{}",list);
        }catch (Exception e){
            log.error("获取待秒杀商品列表异常：",e.fillInStackTrace());
            return "redirect:/base/error";
        }
        return "sec_kill";
    }

    /**
     * 获取待秒杀商品的详情
     * @return
     */
    @RequestMapping(value = prefix+"/detail/{id}")
    @LoginRequired(loginSuccess = true)
    public String detail(@PathVariable("id") Integer id, ModelMap modelMap,HttpServletRequest request){
        String memberId = (String) request.getAttribute("memberId");
        String nickname = (String) request.getAttribute("nickname");
        modelMap.put("memberId", memberId);
        if (id==null||id<0){
            return "redirect:/base/error";
        }
        try {
            ItemKill detail = itemKillService.getDetailKill(id);
            modelMap.put("detail", detail);

            String remoteAddr = request.getRemoteAddr();

            // request.getHeader("");// nginx负载均衡
            //sku对象
            PmsSkuInfo pmsSkuInfo = skuService.getSkuById(detail.getItemId(), remoteAddr);
            modelMap.put("skuInfo", pmsSkuInfo);

            List<PmsSkuInfo> pmsSkuInfos = skuService.getSkuSaleAttrValueListBySpu(pmsSkuInfo.getProductId());
            for (PmsSkuInfo skuInfo : pmsSkuInfos) {
                if (skuInfo.getId().equals(pmsSkuInfo.getId())){
                    List<PmsSkuSaleAttrValue> pmsProductSaleAttrs = skuInfo.getSkuSaleAttrValueList();
                    //将sku的销售属性放到页面
                    modelMap.put("spuSaleAttrListCheckBySku", pmsProductSaleAttrs);
                    System.out.println(pmsProductSaleAttrs.get(0).getSaleAttrName());
                    System.out.println(pmsProductSaleAttrs.get(0).getSaleAttrValueName());
                }
            }

        }catch (Exception e){
            log.error("获取待秒杀商品的详情-发生异常：id={}",id,e.fillInStackTrace());
            return "redirect:/base/error";
        }
        return "seckill-item";
    }


}
