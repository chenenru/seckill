package com.chenenru.gmall.seckill.dto;

import lombok.Data;
import lombok.ToString;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * @Author chenenru
 * @ClassName KillDto
 * @Description
 * @Date 2020/1/30 18:14
 * @Version 1.0
 **/
@Data
@ToString
public class KillDto implements Serializable {
    //@NotNull
    private Integer killId;
    private String userId;
}
