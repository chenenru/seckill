package com.chenenru.gmall.service;

import com.chenenru.gmall.bean.PmsBaseAttrInfo;
import com.chenenru.gmall.bean.PmsBaseAttrValue;
import com.chenenru.gmall.bean.PmsBaseSaleAttr;

import java.util.HashSet;
import java.util.List;

/**
 * @Author chenenru
 * @ClassName AttrService
 * @Description
 * @Date 2020/2/18 11:20
 * @Version 1.0
 **/
public interface AttrService {
    List<PmsBaseAttrInfo> attrInfoList(String catalog3Id);

    String saveAttrInfo(PmsBaseAttrInfo pmsBaseAttrInfo);

    List<PmsBaseAttrValue> getAttrValueList(String attrId);

    List<PmsBaseSaleAttr> baseSaleAttrList();

    List<PmsBaseAttrInfo> getAttrValueListByValueId(HashSet<String> valueIdSet);
}
