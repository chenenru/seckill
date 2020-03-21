package com.chenenru.gmall.seckill.service;

import com.chenenru.gmall.seckill.bean.ItemKillSuccess;
import com.chenenru.gmall.seckill.dto.KillSuccessUserInfo;
import com.chenenru.gmall.seckill.dto.MailDto;
import com.chenenru.gmall.seckill.mapper.ItemKillSuccessMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;

/**
 * @Author chenenru
 * @ClassName RabbitReceiverService
 * @Description RabbitMQ接受消息服务
 * @Date 2020/1/31 0:29
 * @Version 1.0
 **/
@Service
public class RabbitReceiverService {

    public static final Logger log = LoggerFactory.getLogger(RabbitReceiverService.class);

    @Autowired
    private MailService mailService;

    @Autowired
    private Environment env;

    @Autowired
    private ItemKillSuccessService itemKillSuccessService;

    /**
     * 秒杀异步邮件通知-接受消息
     */
    @RabbitListener(queues = {"${mq.kill.item.success.email.queue}"},containerFactory = "singleListenerContainer")
    public void consumeEmailMsg(KillSuccessUserInfo info){
        try {
            log.info("秒杀异步邮件通知-接受消息:{}", info);
            //TODO:真正的发生邮件
            //MailDto dto =new MailDto(env.getProperty("mail.kill.item.success.subject"),"这是测试内容",new String[] {info.getEmail()});
            //mailService.sendSimpleEMail(dto);
            final String content=String.format(env.getProperty("mail.kill.item.success.content"),info.getItemName(),info.getCode());
            MailDto dto =new MailDto(env.getProperty("mail.kill.item.success.subject"),content,new String[] {info.getEmail()});
            mailService.sendHTMMail(dto);
            System.out.println("秒杀异步邮件通知-接受消息-真正的发生邮件...");
        }catch (Exception e){
            log.error("秒杀异步邮件通知-接受消息-发送异常：",e.fillInStackTrace());
        }
    }

    /**
     * 用户秒杀成功后超时未支付-监听者
     */
    @RabbitListener(queues = {"${mq.kill.item.success.kill.dead.real.queue}"},containerFactory = "singleListenerContainer")
    public void consumeExpireOrder(KillSuccessUserInfo info){
        try {
            log.info("用户秒杀成功后超时未支付-监听者-接受消息:{}", info);
            if (info!=null){
                System.out.println("用户秒杀成功后超时未支付-查询相关订单");
                ItemKillSuccess entity=itemKillSuccessService.selectByPrimaryKey(info.getCode());
                if (entity!=null&&entity.getStatus()==0){
                    System.out.println("用户秒杀成功后超时未支付-使其失效");
                    itemKillSuccessService.expireOrder(info.getCode());
                }
            }
        }catch (Exception e){
            log.error("用户秒杀成功后超时未支付-监听者-发送异常：",e.fillInStackTrace());
        }
    }
}
