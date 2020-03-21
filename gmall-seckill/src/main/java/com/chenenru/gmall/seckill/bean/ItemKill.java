package com.chenenru.gmall.seckill.bean;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import lombok.ToString;

import javax.persistence.Transient;
import java.io.Serializable;
import java.util.Date;

@Data
@ToString
public class ItemKill implements Serializable {
    private Integer id;

    private String itemId;

    private Integer total;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
    private Date startTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
    private Date endTime;

    private Byte isActive;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
    private Date createTime;

    private String itemName;

    //采用服务器时间控制是否可以进行抢购
    private Integer canKill;

    @Transient
    Double price;
    @Transient
    String skuDesc;
    @Transient
    String skuDefaultImg;
}