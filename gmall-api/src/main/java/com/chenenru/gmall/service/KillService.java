package com.chenenru.gmall.service;

import com.chenenru.gmall.bean.ItemKill;

import java.util.List;

public interface KillService {
    List<ItemKill> getKillItems() throws Exception;
    ItemKill getKillDetail(Integer id) throws Exception;
    List<ItemKill> getKills(String list, String ip) throws Exception;
    ItemKill getDetailKill(Integer id) throws Exception;

    String saveKill(ItemKill kill);

    String updateKill(ItemKill kill);
}
