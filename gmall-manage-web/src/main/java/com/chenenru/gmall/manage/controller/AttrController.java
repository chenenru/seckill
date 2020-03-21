package com.chenenru.gmall.manage.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.chenenru.gmall.bean.PmsBaseAttrInfo;
import com.chenenru.gmall.bean.PmsBaseAttrValue;
import com.chenenru.gmall.bean.PmsBaseSaleAttr;
import com.chenenru.gmall.service.AttrService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @Author chenenru
 * @ClassName AttrController
 * @Description
 * @Date 2020/2/18 11:13
 * @Version 1.0
 **/
@Controller
@CrossOrigin
public class AttrController {

    @Reference
    AttrService attrService;


    //baseSaleAttrList
    @RequestMapping("baseSaleAttrList")
    @ResponseBody
    public List<PmsBaseSaleAttr> baseSaleAttrList() {
        List<PmsBaseSaleAttr> pmsBaseSaleAttrs = attrService.baseSaleAttrList();
        return pmsBaseSaleAttrs;
    }

    //saveAttrInfo
    @RequestMapping("saveAttrInfo")
    @ResponseBody
    public String saveAttrInfo(@RequestBody PmsBaseAttrInfo pmsBaseAttrInfo) {

        String status = attrService.saveAttrInfo(pmsBaseAttrInfo);
        return status;
    }

    //attrInfoList?catalog3Id=61
    @RequestMapping("attrInfoList")
    @ResponseBody
    public List<PmsBaseAttrInfo> attrInfoList(String Catalog3Id) {
        List<PmsBaseAttrInfo> pmsBaseAttrInfoList = attrService.attrInfoList(Catalog3Id);
        return pmsBaseAttrInfoList;
    }

    //getAttrValueList?attrId=43
    @RequestMapping("getAttrValueList")
    @ResponseBody
    public List<PmsBaseAttrValue> getAttrValueList(String attrId) {
        List<PmsBaseAttrValue> pmsBaseAttrValueList = attrService.getAttrValueList(attrId);
        return pmsBaseAttrValueList;
    }


}
