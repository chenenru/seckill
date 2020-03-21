package com.chenenru.gmall.seckill.service;

import com.chenenru.gmall.seckill.bean.ItemKill;

import java.util.List;

public interface ItemKillService {
    List<ItemKill> getKillItems() throws Exception;
    ItemKill getKillDetail(Integer id) throws Exception;
    List<ItemKill> getItemKills(String userId, String ip) throws Exception;
}
