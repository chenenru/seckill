package com.chenenru.gmall.seckill.mapper;

import com.chenenru.gmall.seckill.bean.ItemKillSuccess;
import com.chenenru.gmall.seckill.dto.KillSuccessUserInfo;
import org.apache.ibatis.annotations.Param;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;

public interface ItemKillSuccessMapper extends Mapper<ItemKillSuccess> {
    //int deleteByPrimaryKey(String code);

    //int insert(ItemKillSuccess record);

    //int insertSelective(ItemKillSuccess record);

    //ItemKillSuccess selectBySuccessCode(String code);//有问题

    //int updateByPrimaryKeySelective(ItemKillSuccess record);

    //int updateByPrimaryKey(ItemKillSuccess record);

    int countByKillUserId(@Param("killId") Integer killId, @Param("userId") String userId);

    KillSuccessUserInfo selectKillSuccessUserInfoByCode(@Param("code") String code);

    //新增
    KillSuccessUserInfo selectKillSuccessUserInfoAllStatusByCode(@Param("code") String code);
    //新增
    ItemKillSuccess selectItemKillSuccessToStatusByCode(@Param("code") String code);

    int expireOrder(@Param("code") String code);

    List<ItemKillSuccess> selectExpireOrders();

    List<ItemKillSuccess> selectShipExpireOrders();
}