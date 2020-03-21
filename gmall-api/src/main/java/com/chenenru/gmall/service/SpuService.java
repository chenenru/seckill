package com.chenenru.gmall.service;

import com.chenenru.gmall.bean.PmsProductImage;
import com.chenenru.gmall.bean.PmsProductInfo;
import com.chenenru.gmall.bean.PmsProductSaleAttr;

import java.util.List;

public interface SpuService {
    List<PmsProductInfo> spuList(String catalog3Id);

    List<PmsProductImage> spuImageList(String spuId);

    List<PmsProductSaleAttr> spuSaleAttrList(String spuId);

    void saveSpuInfo(PmsProductInfo pmsProductInfo);

    List<PmsProductSaleAttr> spuSaleAttrListCheckBySku(String productId, String skuId);
}
