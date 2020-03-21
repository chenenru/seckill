package com.chenenru.gmall.seckill.service.impl;

import com.alibaba.dubbo.config.annotation.Service;
import com.chenenru.gmall.seckill.bean.ItemKillSuccess;
import com.chenenru.gmall.seckill.dto.KillSuccessUserInfo;
import com.chenenru.gmall.seckill.mapper.ItemKillSuccessMapper;
import com.chenenru.gmall.seckill.service.ItemKillSuccessService;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

/**
 * @Author chenenru
 * @ClassName ItemKillSuccessServiceImpl
 * @Description
 * @Date 2020/3/5 14:47
 * @Version 1.0
 **/
@Service
public class ItemKillSuccessServiceImpl implements ItemKillSuccessService {

    @Autowired
    ItemKillSuccessMapper itemKillSuccessMapper;

    @Override
    public KillSuccessUserInfo selectByCode(String code) {
        KillSuccessUserInfo killSuccessUserInfo = itemKillSuccessMapper.selectKillSuccessUserInfoByCode(code);
        return killSuccessUserInfo;
    }
    @Override
    public KillSuccessUserInfo selectAllstatusByCode(String code) {
        KillSuccessUserInfo killSuccessUserInfo = itemKillSuccessMapper.selectKillSuccessUserInfoAllStatusByCode(code);
        return killSuccessUserInfo;
    }
    @Override
    public ItemKillSuccess selectToStatusByCode(String code) {
        ItemKillSuccess itemKillSuccess = itemKillSuccessMapper.selectItemKillSuccessToStatusByCode(code);
        return itemKillSuccess;
    }

    @Override
    public ItemKillSuccess selectByPrimaryKey(String code) {
        ItemKillSuccess itemKillSuccess =new ItemKillSuccess();
        itemKillSuccess.setCode(code);
        List<ItemKillSuccess> itemKillSuccesses = itemKillSuccessMapper.select(itemKillSuccess);
        return itemKillSuccesses!=null?itemKillSuccesses.get(0):null;
    }

    @Override
    public void expireOrder(String code) {
        itemKillSuccessMapper.expireOrder(code);

    }

    @Override
    public List<ItemKillSuccess> selectExpireOrders() {
        List<ItemKillSuccess> itemKillSuccesses = itemKillSuccessMapper.selectExpireOrders();
        return itemKillSuccesses;
    }

    @Override
    public List<ItemKillSuccess> selectShipExpireOrders() {
        List<ItemKillSuccess> itemKillSuccesses = itemKillSuccessMapper.selectShipExpireOrders();
        return itemKillSuccesses;
    }

    @Override
    public boolean updateItemKillStatus(ItemKillSuccess itemKillSuccess, Byte i) {
        itemKillSuccess.setStatus(i);
        int update = itemKillSuccessMapper.updateByPrimaryKey(itemKillSuccess);
        if (update>0){
            return true;
        }else {
            return false;
        }
    }
}
