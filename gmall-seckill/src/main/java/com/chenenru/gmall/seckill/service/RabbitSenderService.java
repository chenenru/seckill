package com.chenenru.gmall.seckill.service;

import com.chenenru.gmall.seckill.dto.KillSuccessUserInfo;
import com.chenenru.gmall.seckill.mapper.ItemKillSuccessMapper;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.AmqpException;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.core.MessageDeliveryMode;
import org.springframework.amqp.core.MessagePostProcessor;
import org.springframework.amqp.core.MessageProperties;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.support.converter.AbstractJavaTypeMapper;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;

/**
 * @Author chenenru
 * @ClassName RabbitSenderService
 * @Description RabbitMQ发生消息服务
 * @Date 2020/1/31 0:27
 * @Version 1.0
 **/
@Service
public class RabbitSenderService {
    public static final Logger log= LoggerFactory.getLogger(RabbitSenderService.class);

    @Autowired
    private RabbitTemplate rabbitTemplate;

    @Autowired
    private Environment env;

    @Autowired
    private ItemKillSuccessService itemKillSuccessService;
    /**
     * 秒杀成功异步发送邮件通知消息
     */
    public void sendKillSuccessEmailMsg(String orderNo){
        log.info("秒杀成功异步发送邮件通知消息-准备发送消息：{}",orderNo);

        try {

            if (StringUtils.isNotBlank(orderNo)){
                KillSuccessUserInfo info = itemKillSuccessService.selectByCode(orderNo);
                System.out.println("秒杀成功异步发送邮件通知消息-查询有效用户的订单号为"+orderNo+"秒杀订单为："+info);
                if (info!=null){
                    System.out.println("秒杀成功异步发送邮件通知消息-rabbitTemplate创建开始");
                    //TODO:rabbitmq发送消息的逻辑
                    rabbitTemplate.setMessageConverter(new Jackson2JsonMessageConverter());
                    rabbitTemplate.setExchange(env.getProperty("mq.kill.item.success.email.exchange"));
                    rabbitTemplate.setRoutingKey(env.getProperty("mq.kill.item.success.email.routing.key"));
                    System.out.println("秒杀成功异步发送邮件通知消息-rabbitTemplate创建结束");
                    //TODO:将info充当消息发送队列
                    rabbitTemplate.convertAndSend(info,new MessagePostProcessor(){
                        @Override
                        public Message postProcessMessage(Message message) throws AmqpException {
                            System.out.println("秒杀成功异步发送邮件通知消息-好像开始发送邮件了。。。");
                            MessageProperties messageProperties=message.getMessageProperties();
                            messageProperties.setDeliveryMode(MessageDeliveryMode.PERSISTENT);
                            messageProperties.setHeader(AbstractJavaTypeMapper.DEFAULT_CONTENT_CLASSID_FIELD_NAME,KillSuccessUserInfo.class);
                            System.out.println("秒杀成功异步发送邮件通知消息-你丫的，发了没");
                            return message;
                        }
                    });
                }
                System.out.println("秒杀成功异步发送邮件通知消息-查询有效用户的订单号为"+orderNo+"秒杀订单为空。。。。。");
            }

        }catch (Exception e){
            log.error("秒杀成功异步发送邮件通知消息-发生异常，消息为：{}",orderNo,e.fillInStackTrace());
        }

    }

    /**
     * 秒杀成功后生成抢购订单-发送信息入死队列，等待一定时间失效超时未支付的订单
     * @param orderCode
     */
    public void sendKillSuccessOrderExpireMsg(final String orderCode){
        log.info("等待一定时间失效超时未支付的订单:{}",orderCode);
        try {
            if (StringUtils.isNotBlank(orderCode)){
                KillSuccessUserInfo info = itemKillSuccessService.selectByCode(orderCode);
                System.out.println("等待一定时间失效超时未支付的订单-查询有效用户的订单号为"+orderCode+"秒杀订单为："+info);
                if (info!=null){
                    System.out.println("等待一定时间失效超时未支付的订单-rabbitTemplate创建开始");
                    rabbitTemplate.setMessageConverter(new Jackson2JsonMessageConverter());
                    rabbitTemplate.setExchange(env.getProperty("mq.kill.item.success.kill.dead.prod.exchange"));
                    rabbitTemplate.setRoutingKey(env.getProperty("mq.kill.item.success.kill.dead.prod.routing.key"));
                    System.out.println("等待一定时间失效超时未支付的订单-rabbitTemplate创建结束");
                    rabbitTemplate.convertAndSend(info,new MessagePostProcessor(){

                        @Override
                        public Message postProcessMessage(Message message) throws AmqpException {
                            System.out.println("等待一定时间失效超时未支付的订单-好像开始失效订单。。。");
                            MessageProperties mp=message.getMessageProperties();
                            mp.setDeliveryMode(MessageDeliveryMode.PERSISTENT);
                            mp.setHeader(AbstractJavaTypeMapper.DEFAULT_CONTENT_CLASSID_FIELD_NAME,KillSuccessUserInfo.class);

                            //TODO:动态设置TTL(为了方便，暂且设置为10s-->半小时
                            mp.setExpiration(env.getProperty("mq.kill.item.success.kill.expire"));
                            System.out.println("等待一定时间失效超时未支付的订单-设置失效时间。。。");
                            return message;
                        }
                    });
                }
                System.out.println("查询有效用户的订单号为"+orderCode+"秒杀订单为空。。。");
            }
        }catch (Exception e){
            log.error("秒杀成功后生成抢购订单-发送信息入死队列，等待一定时间失效超时未支付的订单-发生异常，消息为：",orderCode,e.fillInStackTrace());
        }
    }
}
