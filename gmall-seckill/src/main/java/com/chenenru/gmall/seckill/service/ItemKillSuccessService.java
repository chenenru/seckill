package com.chenenru.gmall.seckill.service;

import com.chenenru.gmall.seckill.bean.ItemKillSuccess;
import com.chenenru.gmall.seckill.dto.KillSuccessUserInfo;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ItemKillSuccessService {
    KillSuccessUserInfo selectByCode(@Param("code") String code);
    //新增
    KillSuccessUserInfo selectAllstatusByCode(@Param("code") String code);
    //新增
    ItemKillSuccess selectToStatusByCode(@Param("code") String code);

    ItemKillSuccess selectByPrimaryKey(String code);

    void expireOrder(String code);

    List<ItemKillSuccess> selectExpireOrders();

    List<ItemKillSuccess> selectShipExpireOrders();

    boolean updateItemKillStatus(ItemKillSuccess itemKillSuccess, Byte i);
}
