package com.chenenru.gmall.service;

import com.chenenru.gmall.bean.PmsBaseCatalog1;
import com.chenenru.gmall.bean.PmsBaseCatalog2;
import com.chenenru.gmall.bean.PmsBaseCatalog3;

import java.util.List;

/**
 * @Author chenenru
 * @ClassName CatalogService
 * @Description
 * @Date 2020/2/18 0:52
 * @Version 1.0
 **/
public interface CatalogService {
    List<PmsBaseCatalog1> getCatalog1();

    List<PmsBaseCatalog2> getCatalog2(String catalog1Id);

    List<PmsBaseCatalog3> getCatalog3(String catalog2Id);
}
