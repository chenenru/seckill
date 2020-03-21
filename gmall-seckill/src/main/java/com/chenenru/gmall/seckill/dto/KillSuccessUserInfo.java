package com.chenenru.gmall.seckill.dto;

import com.chenenru.gmall.seckill.bean.ItemKillSuccess;
import lombok.Data;
import lombok.ToString;

import java.io.Serializable;

@Data
@ToString
public class KillSuccessUserInfo extends ItemKillSuccess implements Serializable{

    private String userName;

    private String phone;

    private String email;

    private String itemName;

    @Override
    public String toString() {
        return super.toString()+"\nKillSuccessUserInfo{" +
                "userName='" + userName + '\'' +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", itemName='" + itemName + '\'' +
                '}';
    }
}