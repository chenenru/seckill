package com.chenenru.gmall.manage.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.chenenru.gmall.bean.PmsProductImage;
import com.chenenru.gmall.bean.PmsProductInfo;
import com.chenenru.gmall.bean.PmsProductSaleAttr;
import com.chenenru.gmall.manage.util.PmsUpLoadUtil;
import com.chenenru.gmall.service.SpuService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * @Author chenenru
 * @ClassName SpuController
 * @Description
 * @Date 2020/2/18 14:50
 * @Version 1.0
 **/
@Controller
@CrossOrigin
public class SpuController {
    @Reference
    SpuService spuService;

    //spuImageList?spuId=67
    @RequestMapping("spuImageList")
    @ResponseBody
    public List<PmsProductImage> spuImageList(String spuId) {
        List<PmsProductImage> pmsProductImages = spuService.spuImageList(spuId);
        return pmsProductImages;
    }

    //spuSaleAttrList?spuId=67
    @RequestMapping("spuSaleAttrList")
    @ResponseBody
    public List<PmsProductSaleAttr> spuSaleAttrList(String spuId) {
        List<PmsProductSaleAttr> pmsProductSaleAttr = spuService.spuSaleAttrList(spuId);
        return pmsProductSaleAttr;
    }


    //fileUpload
    @RequestMapping("fileUpload")
    @ResponseBody
    public String fileUpload(@RequestParam("file") MultipartFile multipartFile) {

        //将图片或者音视频上传到分布式的文件存储系统
        //将图片的存储路径返回给页面
        String imgUrl = PmsUpLoadUtil.uploadImage(multipartFile);//"http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5Mt6-AQKlOAC-ojGdpZlE229.png";
        System.out.println(imgUrl);
        return imgUrl;
    }

    //saveSpuInfo
    @RequestMapping("saveSpuInfo")
    @ResponseBody
    public String saveSpuInfo(@RequestBody PmsProductInfo pmsProductInfo) {
        spuService.saveSpuInfo(pmsProductInfo);
        return "success";
    }

    //spuList?catalog3Id=61
    @RequestMapping("spuList")
    @ResponseBody
    public List<PmsProductInfo> spuList(String catalog3Id) {
        List<PmsProductInfo> pmsProductInfos = spuService.spuList(catalog3Id);
        return pmsProductInfos;
    }

}
