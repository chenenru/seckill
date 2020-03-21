package com.chenenru.gmall.manage.service.impl;

import com.alibaba.dubbo.config.annotation.Service;
import com.chenenru.gmall.bean.PmsProductImage;
import com.chenenru.gmall.bean.PmsProductInfo;
import com.chenenru.gmall.bean.PmsProductSaleAttr;
import com.chenenru.gmall.bean.PmsProductSaleAttrValue;
import com.chenenru.gmall.manage.mapper.PmsProductImageMapper;
import com.chenenru.gmall.manage.mapper.PmsProductInfoMapper;
import com.chenenru.gmall.manage.mapper.PmsProductSaleAttrMapper;
import com.chenenru.gmall.manage.mapper.PmsProductSaleAttrValueMaper;
import com.chenenru.gmall.service.SpuService;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

/**
 * @Author chenenru
 * @ClassName SpuServiceImpl
 * @Description
 * @Date 2020/2/18 14:56
 * @Version 1.0
 **/
@Service
public class SpuServiceImpl implements SpuService {

    @Autowired
    PmsProductInfoMapper pmsProductInfoMapper;

    @Autowired
    PmsProductImageMapper pmsProductImageMapper;
    @Autowired
    PmsProductSaleAttrMapper pmsProductSaleAttrMapper;
    @Autowired
    PmsProductSaleAttrValueMaper pmsProductSaleAttrValueMaper;

    @Override
    public List<PmsProductInfo> spuList(String catalog3Id) {
        PmsProductInfo pmsProductInfo = new PmsProductInfo();
        pmsProductInfo.setCatalog3Id(catalog3Id);
        List<PmsProductInfo> pmsProductInfos = pmsProductInfoMapper.select(pmsProductInfo);
        return pmsProductInfos;
    }

    @Override
    public void saveSpuInfo(PmsProductInfo pmsProductInfo) {

        //保存商品信息
        pmsProductInfoMapper.insertSelective(pmsProductInfo);

        //生成商品主键
        String productId = pmsProductInfo.getId();

        //保存商品图片信息
        List<PmsProductImage> spuImageList = pmsProductInfo.getSpuImageList();
        for (PmsProductImage pmsProductImage : spuImageList) {
            pmsProductImage.setProductId(productId);
            pmsProductImageMapper.insertSelective(pmsProductImage);
        }

        //保存销售信息
        List<PmsProductSaleAttr> spuSaleAttrList = pmsProductInfo.getSpuSaleAttrList();
        for (PmsProductSaleAttr pmsProductSaleAttr : spuSaleAttrList) {
            pmsProductSaleAttr.setProductId(productId);
            pmsProductSaleAttrMapper.insertSelective(pmsProductSaleAttr);

            //保存销售值信息
            List<PmsProductSaleAttrValue> spuSaleAttrValueList = pmsProductSaleAttr.getSpuSaleAttrValueList();//spuSaleAttrValueList
            for (PmsProductSaleAttrValue pmsProductSaleAttrValue : spuSaleAttrValueList) {
                pmsProductSaleAttrValue.setProductId(productId);
                pmsProductSaleAttrValueMaper.insertSelective(pmsProductSaleAttrValue);
            }
        }

    }

    @Override
    public List<PmsProductSaleAttr> spuSaleAttrListCheckBySku(String productId, String skuId) {

        /*PmsProductSaleAttr pmsProductSaleAttr = new PmsProductSaleAttr();
        pmsProductSaleAttr.setProductId(productId);
        List<PmsProductSaleAttr> pmsProductSaleAttrs = pmsProductSaleAttrMapper.select(pmsProductSaleAttr);
        for (PmsProductSaleAttr productSaleAttr:pmsProductSaleAttrs){
            String saleAttrId = productSaleAttr.getSaleAttrId();

            PmsProductSaleAttrValue pmsProductSaleAttrValue = new PmsProductSaleAttrValue();
            pmsProductSaleAttrValue.setSaleAttrId(saleAttrId);
            pmsProductSaleAttrValue.setProductId(productId);
            List<PmsProductSaleAttrValue> pmsProductSaleAttrValues = pmsProductSaleAttrValueMaper.select(pmsProductSaleAttrValue);

            pmsProductSaleAttr.setSpuSaleAttrValueList(pmsProductSaleAttrValues);

        }*/

        List<PmsProductSaleAttr> pmsProductSaleAttrs = pmsProductSaleAttrMapper.selectSpuSaleAttrListCheckBySku(productId, skuId);

        return pmsProductSaleAttrs;
    }

    @Override
    public List<PmsProductSaleAttr> spuSaleAttrList(String spuId) {
        PmsProductSaleAttr pmsProductSaleAttr = new PmsProductSaleAttr();
        pmsProductSaleAttr.setProductId(spuId);
        List<PmsProductSaleAttr> pmsProductSaleAttrs = pmsProductSaleAttrMapper.select(pmsProductSaleAttr);

        for (PmsProductSaleAttr productSaleAttr : pmsProductSaleAttrs) {
            PmsProductSaleAttrValue pmsProductSaleAttrValue = new PmsProductSaleAttrValue();
            pmsProductSaleAttrValue.setProductId(spuId);
            pmsProductSaleAttrValue.setSaleAttrId(productSaleAttr.getSaleAttrId());//销售属性id的是系统的字典表中的id，不是销售属性表的主键
            List<PmsProductSaleAttrValue> pmsProductSaleAttrValues = pmsProductSaleAttrValueMaper.select(pmsProductSaleAttrValue);
            productSaleAttr.setSpuSaleAttrValueList(pmsProductSaleAttrValues);
        }

        return pmsProductSaleAttrs;
    }

    @Override
    public List<PmsProductImage> spuImageList(String spuId) {

        PmsProductImage pmsProductImage = new PmsProductImage();
        pmsProductImage.setProductId(spuId);
        List<PmsProductImage> pmsProductImages = pmsProductImageMapper.select(pmsProductImage);

        return pmsProductImages;

    }

}
