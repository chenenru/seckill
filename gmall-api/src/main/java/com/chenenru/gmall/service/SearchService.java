package com.chenenru.gmall.service;

import com.chenenru.gmall.bean.PmsSearchParam;
import com.chenenru.gmall.bean.PmsSearchSkuInfo;

import java.util.List;

public interface SearchService {
    List<PmsSearchSkuInfo> list(PmsSearchParam pmsSearchParam);
}
