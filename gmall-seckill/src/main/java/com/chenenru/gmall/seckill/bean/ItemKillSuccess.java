package com.chenenru.gmall.seckill.bean;

import lombok.Data;
import lombok.ToString;

import javax.persistence.Id;
import javax.persistence.Transient;
import java.io.Serializable;
import java.util.Date;

@Data
@ToString
public class ItemKillSuccess implements Serializable {
    @Id
    private String code;

    private String itemId;

    private Integer killId;

    private String userId;

    private Byte status;

    private Date createTime;

    @Transient
    private Integer diffTime;
}