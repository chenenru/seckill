package com.chenenru.gmall.seckill.service.impl;

import com.alibaba.dubbo.config.annotation.Service;
import com.chenenru.gmall.bean.OmsCartItem;
import com.chenenru.gmall.bean.OmsOrder;
import com.chenenru.gmall.bean.OmsOrderItem;
import com.chenenru.gmall.bean.UmsMemberReceiveAddress;
import com.chenenru.gmall.seckill.bean.ItemKill;
import com.chenenru.gmall.seckill.bean.ItemKillSuccess;
import com.chenenru.gmall.seckill.enums.SysConstant;
import com.chenenru.gmall.seckill.mapper.ItemKillMapper;
import com.chenenru.gmall.seckill.mapper.ItemKillSuccessMapper;
import com.chenenru.gmall.seckill.service.KillService;
import com.chenenru.gmall.seckill.service.KillToOrderAndToPayService;
import com.chenenru.gmall.seckill.service.RabbitSenderService;
import com.chenenru.gmall.seckill.utils.RandomUtil;
import com.chenenru.gmall.seckill.utils.SnowFlake;
import org.joda.time.DateTime;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.web.servlet.ModelAndView;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.TimeUnit;


/**
 * @Author chenenru
 * @ClassName KillServiceImpl
 * @Description
 * @Date 2020/1/30 16:57
 * @Version 1.0
 **/
@Service
public class KillServiceImpl implements KillService {

    private static final Logger log = LoggerFactory.getLogger(KillServiceImpl.class);

    private SnowFlake snowFlake = new SnowFlake(2, 3);

    private static final String pathPrefix = "/kill/zkLock/";

    @Autowired
    private ItemKillSuccessMapper itemKillSuccessMapper;
    @Autowired
    private ItemKillMapper itemKillMapper;
    @Autowired
    private RabbitSenderService rabbitSenderService;
    @Autowired
    private StringRedisTemplate stringRedisTemplate;
    @Autowired
    private RedissonClient redissonClient;
    /*@Autowired
    private CuratorFramework curatorFramework;*/
    @Autowired
    KillToOrderAndToPayService killToOrderAndToPayService;

    /**
     * 商品秒杀核心业务逻辑的处理
     *
     * @param killId
     * @param userId
     * @return
     * @throws Exception
     */
    /*@Override
    public Boolean killItem(Integer killId, Integer userId) throws Exception {
        Boolean result = false;

        //TODO:判断当前用户是否已经抢购过当前商品
        if (itemKillSuccessMapper.countByKillUserId(killId, userId) <= 0) {
            //TODO:查询待秒杀商品详情
            ItemKill itemKill = itemKillMapper.selectById(killId);

            //TODO:判断是否可以被秒杀cankill=1?
            if (itemKill != null && 1 == itemKill.getCanKill()) {
                //TODO:扣减库存-减一
                int res = itemKillMapper.updateKillItem(killId);

                //TODO:扣减是否成功？是-生成秒杀成功的订单，同时通知用户秒杀成功的消息
                if (res > 0) {
                    commonRecordKillSuccessInfo(itemKill, userId);
                    result = true;
                }
            }
        } else {
            throw new Exception("您已经抢购过该商品了！");
        }
        return result;
    }*/

    /**
     * 通用的方法-记录用户秒杀成功后生成的订单-并进行异步邮件消息的通知
     *
     * @param kill
     * @param userId
     * @throws Exception
     */
    private void commonRecordKillSuccessInfo(ItemKill kill, String userId) throws Exception {
        //TODO:记录抢购成功后生成的秒杀订单记录

        ItemKillSuccess entity = new ItemKillSuccess();
        //String orderNo=String.valueOf()
        //entity.setCode(RandomUtil.generateOrderCode());
        String orderNo = String.valueOf(snowFlake.nextId());
        entity.setCode(orderNo);
        entity.setItemId(kill.getItemId());
        entity.setKillId(kill.getId());
        entity.setUserId(userId);
        entity.setStatus(SysConstant.OrderStatus.SuccessNotPayed.getCode().byteValue());
        entity.setCreateTime(DateTime.now().toDate());
        //TODO:学以致用，举一反三 --> 仿照单例模式的双重检验锁写法
        if (itemKillSuccessMapper.countByKillUserId(kill.getId(), userId) <= 0) {
            int res = itemKillSuccessMapper.insertSelective(entity);
            killToOrderAndToPayService.insertToOrder(userId,kill.getItemId(),orderNo);
            if (res >= 0) {
                //TODO:进行异步邮件消息的通知=rabbitMQ+mail
                rabbitSenderService.sendKillSuccessEmailMsg(orderNo);
                //TODO:入死信队列，用于”失效“超时指定的TTL时间仍然未支付的订单
                rabbitSenderService.sendKillSuccessOrderExpireMsg(orderNo);
                //同时插入到order表
                //支付后再插入order表
                //killToOrderAndToPayService.insertToOrder(userId,kill.getItemId(),orderNo);
            }

        }
    }

    /**
     * 商品秒杀核心业务逻辑的处理--mysql的优化
     *
     * @param killId
     * @param userId
     * @return
     * @throws Exception
     */
    /*@Override
    public Boolean killItemV2(Integer killId, Integer userId) throws Exception {
        Boolean result = false;

        //TODO:判断当前用户是否已经抢购过当前商品 需要优化为原子性
        if (itemKillSuccessMapper.countByKillUserId(killId, userId) <= 0) {
            //TODO: 优化A：查询待秒杀商品详情
            ItemKill itemKill = itemKillMapper.selectByIdV2(killId);

            //TODO:优化C：判断是否可以被秒杀cankill=1?
            if (itemKill != null && 1 == itemKill.getCanKill() && itemKill.getTotal() > 0) {
                //TODO:优化B：扣减库存-减一
                int res = itemKillMapper.updateKillItemV2(killId);

                //TODO:扣减是否成功？是-生成秒杀成功的订单，同时通知用户秒杀成功的消息
                if (res > 0) {
                    commonRecordKillSuccessInfo(itemKill, userId);
                    result = true;
                }
            }
        } else {
            throw new Exception("您已经抢购过该商品了！");
        }
        return result;
    }*/

    /**
     * 商品秒杀核心业务逻辑的处理--redis分布式锁
     *
     * @param killId
     * @param userId
     * @return
     * @throws Exception
     */
    /*@Override
    public Boolean killItemV3(Integer killId, Integer userId) throws Exception {
        Boolean result = false;

        //TODO:判断当前用户是否已经抢购过当前商品 需要优化为原子性
        if (itemKillSuccessMapper.countByKillUserId(killId, userId) <= 0) {

            //TODO:借助Redis的原子操作实现分布式锁-对共享操作-资源进行控制
            ValueOperations valueOperations = stringRedisTemplate.opsForValue();
            final String key = new StringBuffer().append(killId).append(userId).append("-RedisLock").toString();
            final String value = RandomUtil.generateOrderCode();
            Boolean cacheRes = valueOperations.setIfAbsent(key, value);//luna脚本提供“分布式锁”，就可以写在一起
            //TODO:redis部署节点宕机了
            if (cacheRes) {
                stringRedisTemplate.expire(key, 30, TimeUnit.SECONDS);
                try {
                    //TODO: 优化A：查询待秒杀商品详情
                    ItemKill itemKill = itemKillMapper.selectByIdV2(killId);

                    //TODO:优化C：判断是否可以被秒杀cankill=1?
                    if (itemKill != null && 1 == itemKill.getCanKill() && itemKill.getTotal() > 0) {

                        //TODO:优化B：扣减库存-减一
                        int res = itemKillMapper.updateKillItemV2(killId);

                        //TODO:扣减是否成功？是-生成秒杀成功的订单，同时通知用户秒杀成功的消息
                        if (res > 0) {
                            commonRecordKillSuccessInfo(itemKill, userId);
                            result = true;
                        }
                    }
                } catch (Exception e) {
                    throw new Exception("还没到抢购时间、已经过了抢购时间或已被抢购完毕");
                } finally {
                    if (value.equals(valueOperations.get(key).toString())) {
                        stringRedisTemplate.delete(key);
                    }
                }
            }

        } else {
            throw new Exception("redis-您已经抢购过该商品了！");
        }
        return result;
    }*/

    /**
     * 商品秒杀核心业务逻辑的处理--redisson的分布式锁
     *
     * @param killId
     * @param userId
     * @return
     * @throws Exception
     */
    @Override
    public Boolean killItemV4(Integer killId, String userId) throws Exception {
        Boolean result = false;

        final String lockKey = new StringBuffer().append(killId).append(userId).append("-RedissonLock").toString();
        //TODO:Redission锁
        RLock lock = redissonClient.getLock(lockKey);
        try {
            //lock.lock(10,TimeUnit.SECONDS);
            //TODO:设置拿锁的时间
            boolean cachRes = lock.tryLock(30, 10, TimeUnit.SECONDS);
            if (cachRes) {
                //TODO:判断当前用户是否已经抢购过当前商品 需要优化为原子性
                if (itemKillSuccessMapper.countByKillUserId(killId, userId) <= 0) {
                    //TODO: 优化A：查询待秒杀商品详情
                    ItemKill itemKill = itemKillMapper.selectByIdV2(killId);

                    //TODO:优化C：判断是否可以被秒杀cankill=1?
                    if (itemKill != null && 1 == itemKill.getCanKill() && itemKill.getTotal() > 0) {
                        //TODO:优化B：扣减库存-减一
                        int res = itemKillMapper.updateKillItemV2(killId);

                        //TODO:扣减是否成功？是-生成秒杀成功的订单，同时通知用户秒杀成功的消息
                        if (res > 0) {
                            commonRecordKillSuccessInfo(itemKill, userId);
                            result = true;
                        }
                    }
                } else {
                    throw new Exception("redisson-您已经抢购过该商品了！");
                }
            }
        } finally {
            lock.unlock();
//            lock.forceUnlock();
        }


        return result;
    }


    /**
     * 商品秒杀核心业务逻辑的处理--基于zookeeper的分布式锁
     *
     * @param killId
     * @param userId
     * @return
     * @throws Exception
     */
    /*@Override
    public Boolean killItemV5(Integer killId, Integer userId) throws Exception {
        Boolean result = false;

        InterProcessMutex mutex = new InterProcessMutex(curatorFramework, pathPrefix + killId + userId + "_lock");

        try {
            if (mutex.acquire(10L, TimeUnit.SECONDS)) {
                //TODO:判断当前用户是否已经抢购过当前商品 需要优化为原子性
                if (itemKillSuccessMapper.countByKillUserId(killId, userId) <= 0) {
                    //TODO: 优化A：查询待秒杀商品详情
                    ItemKill itemKill = itemKillMapper.selectByIdV2(killId);

                    //TODO:优化C：判断是否可以被秒杀cankill=1?
                    if (itemKill != null && 1 == itemKill.getCanKill() && itemKill.getTotal() > 0) {
                        //TODO:优化B：扣减库存-减一
                        int res = itemKillMapper.updateKillItemV2(killId);

                        //TODO:扣减是否成功？是-生成秒杀成功的订单，同时通知用户秒杀成功的消息
                        if (res > 0) {
                            commonRecordKillSuccessInfo(itemKill, userId);
                            result = true;
                        }
                    }
                } else {
                    throw new Exception("zookeeper-您已经抢购过该商品了！");
                }
            }
        } catch (Exception e) {
            throw new Exception("还没到抢购日期、已经过了抢购时间或者已抢购完毕");
        } finally {
            if (mutex != null) {
                mutex.release();
            }
        }
        return result;
    }*/
}
