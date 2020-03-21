package com.chenenru.gmall.seckill.service;

import com.alibaba.dubbo.config.annotation.Reference;
import com.chenenru.gmall.bean.OmsOrder;
import com.chenenru.gmall.seckill.bean.ItemKillSuccess;
import com.chenenru.gmall.seckill.mapper.ItemKillSuccessMapper;
import com.chenenru.gmall.service.OrderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

/**
 * @Author chenenru
 * @ClassName SchedulerService
 * @Description
 * @Date 2020/1/31 15:29
 * @Version 1.0
 **/
@Service
public class SchedulerService {
    private static final Logger log= LoggerFactory.getLogger(SchedulerService.class);

    @Autowired
    private ItemKillSuccessService itemKillSuccessService;

    @Reference
    OrderService orderService;

    @Autowired
    private Environment env;

    /**
     * 时获取status==0的订单并是否超过TTL，然后进行失效
     */
    @Scheduled(cron = "0/30 * * * * ? ")
    public void schedulerExpireOrder(){
        try {
            log.info("v1的定时任务----时获取status==0的订单并是否超过TTL，然后进行失效");
            List<OmsOrder> orders = orderService.getOrdersByStatus(String.valueOf(0),0);
            if (orders!=null&&!orders.isEmpty()){
                orders.stream().forEach(i -> {
                    long nd = 1000*24*60*60;//一天的毫秒数
                    long nh = 1000 * 60 * 60;
                    // 获得两个时间的毫秒时间差异
                    long diff =new Date().getTime() - i.getCreateTime().getTime();
                    long hour = diff%nd/nh;//计算差多少小时
                    System.out.println("距离创建订单多少小时："+hour);
                    if (i!=null&&hour>24){
                        i.setStatus(String.valueOf(5));
                        orderService.updateOrderStusAndCStus(i);
                        System.out.println("24小时未支付失效order成功");
                    }
                });
            }
            List<ItemKillSuccess> list=itemKillSuccessService.selectExpireOrders();
            if (list!=null&&!list.isEmpty()){
                list.stream().forEach(i -> {
                    if (i!=null&&i.getDiffTime()>env.getProperty("scheduler.expire.orders.time",Integer.class)){
                        itemKillSuccessService.expireOrder(i.getCode());
                        System.out.println("秒杀订单30分钟未支付失效itemkill成功");
                    }
                });
            }

             orders = orderService.getOrdersByStatus(String.valueOf(0),1);
            if (orders!=null&&!orders.isEmpty()){
                orders.stream().forEach(i -> {
                    long nd = 1000*24*60*60;//一天的毫秒数
                    long nh = 1000 * 60 * 60;
                    long nm = 1000 * 60;
                    // 获得两个时间的毫秒时间差异
                    long diff =new Date().getTime() - i.getCreateTime().getTime();
                    // 计算差多少分钟
                    long min = diff % nd % nh / nm;
                    System.out.println("距离秒杀创建订单多少分钟："+min);
                    if (i!=null&&min>30){
                        i.setStatus(String.valueOf(5));
                        orderService.updateOrderStusAndCStus(i);
                        System.out.println("秒杀订单30分钟未支付失效秒杀order成功");
                    }
                });
            }
            //订单已发货并且收货状态为1
            orders = orderService.getOrdersByStatus(String.valueOf(2),null);
            if (orders!=null&&!orders.isEmpty()){
                orders.stream().forEach(i -> {
                    long nd = 1000*24*60*60;//一天的毫秒数
                    // 获得两个时间的毫秒时间差异
                    long diff =new Date().getTime() - i.getCreateTime().getTime();
                    // 计算差多少天
                    long day = diff / nd;
                    System.out.println("距离订单创建订单多少天："+day);
                    if (i!=null&&day>7){
                        i.setStatus(String.valueOf(3));
                        orderService.updateOrderStusAndCStus(i);
                        System.out.println("订单自动完成order成功");
                    }
                });
            }

            /*for (ItemKillSuccess entity:list){
                log.info("当前记录：{}", entity);
            }*/
        }catch (Exception e){
            log.error("定时获取status==0的订单并是否超过TTL，然后进行失效-发生异常：",e.fillInStackTrace());
        }
    }

    //每天凌晨1点执行发货一次：0 0 1 * * ? 朝九晚五工作时间内每半小时 0 0/30 9-17 * * ?
    @Scheduled(cron = "0 0/30 9-17 * * ?")
    public void schedulerShipOrder(){
        try {
            log.info("v2的定时任务----朝九晚五工作时间内每半小时发货一次");
            List<OmsOrder> orders = orderService.getOrdersByStatus();
            List<ItemKillSuccess> list=itemKillSuccessService.selectShipExpireOrders();
            if (orders!=null&&!orders.isEmpty()){
                orders.stream().forEach(i -> {
                    if (i!=null){
                        //itemKillSuccessService.expireOrder(i.getCode());
                        i.setStatus(String.valueOf(2));
                        i.setDeliveryTime(new Date());
                        orderService.updateOrderStusAndCStus(i);
                        //itemKillSuccessService.updateItemKillStatus(, );
                        System.out.println("发货成功");
                    }
                });
            }

            if (list!=null&&!list.isEmpty()){
                list.stream().forEach(i -> {
                    if (i!=null&&i.getStatus()==1){
                        itemKillSuccessService.updateItemKillStatus(i, (byte) 2);
                        System.out.println("同步itemkill和order表的发货状态");
                    }
                });
            }

            /*for (ItemKillSuccess entity:list){
                log.info("当前记录：{}", entity);
            }*/
        }catch (Exception e){
            log.error("定时发货status==0的订单并是否超过TTL，然后进行失效-发生异常：",e.fillInStackTrace());
        }
    }
        /*@Scheduled(cron = "0/11 * * * * ?")
        public void schedulerExpireOrdersV2(){
            log.info("v2的定时任务----");
        }

        @Scheduled(cron = "0/10 * * * * ?")
        public void schedulerExpireOrdersV3(){
            log.info("v3的定时任务----");
        }*/

}
