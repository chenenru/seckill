package com.chenenru.gmall.seckill.service;

import com.chenenru.gmall.seckill.dto.MailDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.stereotype.Service;

import javax.mail.internet.MimeMessage;

/**
 * @Author chenenru
 * @ClassName MailService
 * @Description
 * @Date 2020/1/31 12:07
 * @Version 1.0
 **/
@Service
@EnableAsync
public class MailService {

    private static final Logger log= LoggerFactory.getLogger(MailService.class);

    @Autowired
    private JavaMailSender mailSender;
    @Autowired
    private Environment env;

    /**
     * 发送简单文本文
     */
    @Async
    public void sendSimpleEMail(final MailDto mailDto){
        try{
            log.info("发送简单文本文件-发送成功！");
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(env.getProperty("mail.send.from"));
            message.setTo(mailDto.getTos());
            message.setSubject(mailDto.getSubject());
            message.setText(mailDto.getContent());
            mailSender.send(message);
        }catch (Exception e){
            log.error("发送简单文本文件-发生异常：",e.fillInStackTrace());
        }
    }

    /**
     * 发送带有链接的邮件
     * @param dto
     */
    @Async
    public void sendHTMMail(final MailDto dto){
        try {
            log.info("发送带有链接的邮件-发送成功！");
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper messageHelper = new MimeMessageHelper(message,true,"utf-8");
            messageHelper.setFrom(env.getProperty("mail.send.from"));
            messageHelper.setTo(dto.getTos());
            messageHelper.setSubject(dto.getSubject());
            messageHelper.setText(dto.getContent(),true);
            System.out.println("MailService-发送成功");
            mailSender.send(message);
        }catch (Exception e){
            log.error("发送带有链接的邮件-发生异常：",e.fillInStackTrace());
        }
    }
}
