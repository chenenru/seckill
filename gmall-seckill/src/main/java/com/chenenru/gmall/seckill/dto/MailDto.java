package com.chenenru.gmall.seckill.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

/**
 * @Author chenenru
 * @ClassName MailDto
 * @Description
 * @Date 2020/1/31 12:12
 * @Version 1.0
 **/
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class MailDto {
    //邮件主题
    private String subject;
    //邮件内容
    private String content;
    //接收人
    private String[] tos;
}
