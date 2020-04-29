package com.chenenru.gmall.admin.service.impl;

import com.alibaba.dubbo.config.annotation.Service;
import com.alibaba.fastjson.JSON;
import com.chenenru.gmall.admin.mapper.KillMapper;
import com.chenenru.gmall.bean.ItemKill;
import com.chenenru.gmall.bean.PmsSkuInfo;
import com.chenenru.gmall.service.KillService;
import com.chenenru.gmall.util.RedisUtil;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import redis.clients.jedis.Jedis;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * @Author chenenru
 * @ClassName KillServiceImpl
 * @Description
 * @Date 2020/4/8 20:43
 * @Version 1.0
 **/
@Service
public class KillServiceImpl implements KillService {

    private static final Logger log = LoggerFactory.getLogger(KillServiceImpl.class);

    @Autowired
    KillMapper killMapper;

    @Autowired
    RedisUtil redisUtil;

    @Override
    public List<ItemKill> getKillItems() throws Exception {
        List<ItemKill> kills = killMapper.selectAllKill();
        return kills;
    }

    @Override
    public ItemKill getKillDetail(Integer id) throws Exception {
        ItemKill kill=killMapper.selectKillKilById(id);

        if (kill==null){
            throw new Exception("获取秒杀详情-待秒杀商品记录不存在");
        }
        return kill;
    }

    @Override
    public List<ItemKill> getKills(String list, String ip) throws Exception {
        System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "进入的商品详情的请求");
        List<ItemKill> itemKills = new ArrayList<>();
        // 链接缓存
        Jedis jedis = redisUtil.getJedis();
        // 查询缓存
        String killsKey = "kills:" + list + ":info";
        String killsJson = jedis.get(killsKey);

        if (StringUtils.isNotBlank(killsJson)) {//if(skuJson!=null&&!skuJson.equals(""))
            System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "从缓存中获取商品详情");

            //itemKills = JSON.parseObject(killsJson, ItemKill.class);
            itemKills=JSON.parseArray(killsJson, ItemKill.class);
        } else {
            // 如果缓存中没有，查询mysql
            System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "发现缓存中没有，申请缓存的分布式锁：" + "kills:" + list + ":lock");

            // 设置分布式锁
            String token = UUID.randomUUID().toString();
            String OK = jedis.set("kills:" + list + ":lock", token, "nx", "px", 10 * 1000);// 拿到锁的线程有10秒的过期时间
            if (StringUtils.isNotBlank(OK) && OK.equals("OK")) {
                // 设置成功，有权在10秒的过期时间内访问数据库
                System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "有权在10秒的过期时间内访问数据库：" + "kills:" + list + ":lock");

                try {
                    itemKills = getKillItems();
                } catch (Exception e) {
                    e.printStackTrace();
                }

                if (itemKills != null) {
                    // mysql查询结果存入redis
                    jedis.set("kills:" + list + ":info", JSON.toJSONString(itemKills));
                } else {
                    // 数据库中不存在该sku
                    // 为了防止缓存穿透将，null或者空字符串值设置给redis
                    jedis.setex("kills:" + list + ":info", 60 * 3, JSON.toJSONString(""));
                }

                // 在访问mysql后，将mysql的分布锁释放
                System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "使用完毕，将锁归还：" + "kills:" + list + ":lock");
                String lockToken = jedis.get("kills:" + list + ":info");
                if (StringUtils.isNotBlank(lockToken) && lockToken.equals(token)) {
                    //jedis.eval("lua");可与用lua脚本，在查询到key的同时删除该key，防止高并发下的意外的发生
                    jedis.del("kills:" + list + ":info");// 用token确认删除的是自己的sku的锁
                }
            } else {
                // 设置失败，自旋（该线程在睡眠几秒后，重新尝试访问本方法）
                System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "没有拿到锁，开始自旋");

                return getKills(list, ip);
            }
        }
        jedis.close();
        return itemKills;
    }

    @Override
    public ItemKill getDetailKill(Integer id) throws Exception {
        String ip="127.0.0.1";

        System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "进入的商品详情的请求");
        ItemKill itemKill = new ItemKill();
        // 链接缓存
        Jedis jedis = redisUtil.getJedis();
        // 查询缓存
        String killKey = "kill:" + id + ":info";
        String killJson = jedis.get(killKey);

        if (StringUtils.isNotBlank(killJson)) {//if(skuJson!=null&&!skuJson.equals(""))
            System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "从缓存中获取商品详情");

            itemKill = JSON.parseObject(killJson, ItemKill.class);
        } else {
            // 如果缓存中没有，查询mysql
            System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "发现缓存中没有，申请缓存的分布式锁：" + "kill:" + id + ":lock");

            // 设置分布式锁
            String token = UUID.randomUUID().toString();
            String OK = jedis.set("kill:" + id + ":lock", token, "nx", "px", 10 * 1000);// 拿到锁的线程有10秒的过期时间
            if (StringUtils.isNotBlank(OK) && OK.equals("OK")) {
                // 设置成功，有权在10秒的过期时间内访问数据库
                System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "有权在10秒的过期时间内访问数据库：" + "kill:" + id + ":lock");

                itemKill = getKillDetail(id);

                if (itemKill != null) {
                    // mysql查询结果存入redis
                    jedis.set("kill:" + id + ":info", JSON.toJSONString(itemKill));
                } else {
                    // 数据库中不存在该sku
                    // 为了防止缓存穿透将，null或者空字符串值设置给redis
                    jedis.setex("kill:" + id + ":info", 60 * 3, JSON.toJSONString(""));
                }

                // 在访问mysql后，将mysql的分布锁释放
                System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "使用完毕，将锁归还：" + "kill:" + id + ":lock");
                String lockToken = jedis.get("kill:" + id + ":lock");
                if (StringUtils.isNotBlank(lockToken) && lockToken.equals(token)) {
                    //jedis.eval("lua");可与用lua脚本，在查询到key的同时删除该key，防止高并发下的意外的发生
                    jedis.del("kill:" + id + ":lock");// 用token确认删除的是自己的sku的锁
                }
            } else {
                // 设置失败，自旋（该线程在睡眠几秒后，重新尝试访问本方法）
                System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "没有拿到锁，开始自旋");

                return getDetailKill(id);
            }
        }
        jedis.close();
        return itemKill;
    }

    @Override
    public String saveKill(ItemKill kill) {
        int insert = killMapper.insert(kill);
        if (insert>0){
            return "success";
        }else {
            return "fail";
        }
    }

    @Override
    public String updateKill(ItemKill kill) {
        int i = killMapper.updateByPrimaryKeySelective(kill);
        if (i>0){
            flushKillCache(kill.getId());
            return "success";
        }else {
            return "fail";
        }
    }
    public void flushKillCache(Integer killId) {
        ItemKill itemKill=new ItemKill();
        /*itemKill.setId(killId);
        itemKill = killMapper.selectOne(itemKill);*/
        try {
            itemKill=getKillDetail(killId);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 同步到redis缓存中
        Jedis jedis = redisUtil.getJedis();
        //jedis.hdel("order:" + skuId + ":info",pmsSkuInfo);
        // jedis.hmset("order:" + skuId + ":info", map);
        jedis.del("kill:" + killId + ":info");
        jedis.set("kill:" + killId + ":info", JSON.toJSONString(itemKill));
        jedis.close();

    }
}
