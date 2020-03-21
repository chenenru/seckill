package com.chenenru.gmall.manage.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.chenenru.gmall.bean.PmsSkuInfo;
import com.chenenru.gmall.service.SkuService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @Author chenenru
 * @ClassName SkuController
 * @Description
 * @Date 2020/2/19 21:58
 * @Version 1.0
 **/
@Controller
@CrossOrigin
public class SkuController {

    @Reference
    SkuService skuService;

    ///saveSkuInfo
    @RequestMapping("saveSkuInfo")
    @ResponseBody
    public String saveSkuInfo(@RequestBody PmsSkuInfo pmsSkuInfo) {

        //前端只给spuId赋值，没有给productId赋值(PmsSkuInfo实体有spuId和productId字段，对应的表pms_sku_info只存productId)，
        //将spuId封装给productId
        pmsSkuInfo.setProductId(pmsSkuInfo.getSpuId());
        //处理默认图片
        String skuDefaultImg = pmsSkuInfo.getSkuDefaultImg();
        if (StringUtils.isBlank(skuDefaultImg)) {
            pmsSkuInfo.setSkuDefaultImg(pmsSkuInfo.getSkuImageList().get(0).getImgUrl());
        }
        skuService.saveSkuInfo(pmsSkuInfo);
        return "success";
    }
}
