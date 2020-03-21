package com.chenenru.gmall.seckill.mapper;

import com.chenenru.gmall.seckill.bean.ItemKill;
import org.apache.ibatis.annotations.Param;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;

public interface ItemKillMapper extends Mapper<ItemKill> {
    List<ItemKill> selectAllItemKil();

    ItemKill selectItemKilById(@Param("id") Integer id);

    int updateKillItem(@Param("killId") Integer killId);



    //优化
    ItemKill selectByIdV2(@Param("id") Integer id);

    int updateKillItemV2(@Param("killId") Integer killId);
}