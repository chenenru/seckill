package com.chenenru.gmall.item.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.alibaba.fastjson.JSON;
import com.chenenru.gmall.bean.PmsProductSaleAttr;
import com.chenenru.gmall.bean.PmsSkuInfo;
import com.chenenru.gmall.bean.PmsSkuSaleAttrValue;
import com.chenenru.gmall.service.SkuService;
import com.chenenru.gmall.service.SpuService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author chenenru
 * @ClassName ItemController
 * @Description
 * @Date 2020/2/20 12:12
 * @Version 1.0
 **/
@Controller
@CrossOrigin
public class ItemController {

    @Reference
    SkuService skuService;
    @Reference
    SpuService spuService;

    @RequestMapping("{skuId}.html")
    public String item(@PathVariable String skuId, ModelMap modelMap, HttpServletRequest request) {

        String remoteAddr = request.getRemoteAddr();

        // request.getHeader("");// nginx负载均衡
        //sku对象
        PmsSkuInfo pmsSkuInfo = skuService.getSkuById(skuId, remoteAddr);
        modelMap.put("skuInfo", pmsSkuInfo);
        //销售属性列表
        List<PmsProductSaleAttr> pmsProductSaleAttrs = spuService.spuSaleAttrListCheckBySku(pmsSkuInfo.getProductId(), pmsSkuInfo.getId());
        modelMap.put("spuSaleAttrListCheckBySku", pmsProductSaleAttrs);

        //查询当前的sku的spu的其他sku的集合的hash表
        Map<String, String> skuSaleAttrHash = new HashMap<>();
        List<PmsSkuInfo> pmsSkuInfos = skuService.getSkuSaleAttrValueListBySpu(pmsSkuInfo.getProductId());
        for (PmsSkuInfo skuInfo : pmsSkuInfos) {
            String k = "";
            String v = skuInfo.getId();
            List<PmsSkuSaleAttrValue> skuSaleAttrValueList = skuInfo.getSkuSaleAttrValueList();
            for (PmsSkuSaleAttrValue pmsSkuSaleAttrValue : skuSaleAttrValueList) {
                k += pmsSkuSaleAttrValue.getSaleAttrValueId() + "|";
            }
            skuSaleAttrHash.put(k, v);
        }

        //将sku的销售属性hash表放到页面
        String skuSaleAttrHashJsonStr = JSON.toJSONString(skuSaleAttrHash);
        modelMap.put("skuSaleAttrHashJsonStr", skuSaleAttrHashJsonStr);

        return "item";
    }

    @RequestMapping("index")
    public String index(ModelMap modelMap) {
        List<String> strr = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            strr.add("循环数据" + i);
        }
        modelMap.put("check", "1");
        modelMap.put("strr", strr);
        modelMap.put("hello", "hello thymeleaf!");
        return "index";
    }
}
