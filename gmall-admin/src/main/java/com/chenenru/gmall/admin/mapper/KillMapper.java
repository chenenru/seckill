package com.chenenru.gmall.admin.mapper;

import com.chenenru.gmall.bean.ItemKill;
import org.apache.ibatis.annotations.Param;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;

public interface KillMapper extends Mapper<ItemKill> {
    List<ItemKill> selectAllKill();

    ItemKill selectKillKilById(@Param("id") Integer id);

    int updateKillKill(@Param("killId") Integer killId);



    //优化
    ItemKill selectKillByIdV2(@Param("id") Integer id);

    int updateKillKillV2(@Param("killId") Integer killId);
}
