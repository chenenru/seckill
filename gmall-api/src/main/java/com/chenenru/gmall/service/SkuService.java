package com.chenenru.gmall.service;

import com.chenenru.gmall.bean.PmsProductSaleAttr;
import com.chenenru.gmall.bean.PmsSkuInfo;
import com.chenenru.gmall.bean.PmsSkuSaleAttrValue;

import java.math.BigDecimal;
import java.util.List;

public interface SkuService {
    void saveSkuInfo(PmsSkuInfo pmsSkuInfo);

    PmsSkuInfo getSkuById(String skuId, String ip);

    List<PmsSkuInfo> getSkuSaleAttrValueListBySpu(String productId);

    List<PmsSkuInfo> getAllSku(String catalog3Id);

    boolean checkPrice(String productSkuId, BigDecimal productPrice);

    List<PmsSkuSaleAttrValue> getSkuSaleAttrValueListBySkuId(String skuId);

    String updateSkuInfo(PmsSkuInfo pmsSkuInfo);
}
