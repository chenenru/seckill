package com.chenenru.gmall.seckill.service.impl;

import com.alibaba.dubbo.config.annotation.Service;
import com.alibaba.fastjson.JSON;
import com.chenenru.gmall.bean.PmsSkuImage;
import com.chenenru.gmall.bean.PmsSkuInfo;
import com.chenenru.gmall.seckill.bean.ItemKill;
import com.chenenru.gmall.seckill.mapper.ItemKillMapper;
import com.chenenru.gmall.seckill.service.ItemKillService;
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
 * @ClassName ItemServiceImpl
 * @Description
 * @Date 2020/1/30 12:41
 * @Version 1.0
 **/
@Service
public class ItemKillServiceImpl implements ItemKillService {

    private static final Logger log = LoggerFactory.getLogger(ItemKillServiceImpl.class);
    @Autowired
    private ItemKillMapper itemKillMapper;

    @Autowired
    RedisUtil redisUtil;
    /**
     * 待秒杀商品列表
     * @return
     * @throws Exception
     */
    @Override
    public List<ItemKill> getKillItems() throws Exception {

        return itemKillMapper.selectAllItemKil();
    }

    /**
     * 获取秒杀详情
     * @param id
     * @return
     * @throws Exception
     */
    @Override
    public ItemKill getKillDetail(Integer id) throws Exception {
        //ItemKill itemKill = itemKillMapper.selectItemKilById(id);
        ItemKill itemKill=itemKillMapper.selectByIdV2(id);

        if (itemKill==null){
            throw new Exception("获取秒杀详情-待秒杀商品记录不存在");
        }
        return itemKill;
    }

    @Override
    public List<ItemKill> getItemKills(String userId,String ip) throws Exception{
        System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "进入的商品详情的请求");
        List<ItemKill> itemKills = new ArrayList<>();
        // 链接缓存
        Jedis jedis = redisUtil.getJedis();
        // 查询缓存
        String killsKey = "killsId:" + userId + ":info";
        String killsJson = jedis.get(killsKey);

        if (StringUtils.isNotBlank(killsJson)) {//if(skuJson!=null&&!skuJson.equals(""))
            System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "从缓存中获取商品详情");

            //itemKills = JSON.parseObject(killsJson, ItemKill.class);
            itemKills=JSON.parseArray(killsJson,ItemKill.class);
        } else {
            // 如果缓存中没有，查询mysql
            System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "发现缓存中没有，申请缓存的分布式锁：" + "killsId:" + userId + ":lock");

            // 设置分布式锁
            String token = UUID.randomUUID().toString();
            String OK = jedis.set("killsId:" + userId + ":lock", token, "nx", "px", 10 * 1000);// 拿到锁的线程有10秒的过期时间
            if (StringUtils.isNotBlank(OK) && OK.equals("OK")) {
                // 设置成功，有权在10秒的过期时间内访问数据库
                System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "有权在10秒的过期时间内访问数据库：" + "killsId:" + userId + ":lock");

                try {
                    itemKills = getKillItems();
                } catch (Exception e) {
                    e.printStackTrace();
                }

                if (itemKills != null) {
                    // mysql查询结果存入redis
                    jedis.set("killsId:" + userId + ":info", JSON.toJSONString(itemKills));
                } else {
                    // 数据库中不存在该sku
                    // 为了防止缓存穿透将，null或者空字符串值设置给redis
                    jedis.setex("killsId:" + userId + ":info", 60 * 3, JSON.toJSONString(""));
                }

                // 在访问mysql后，将mysql的分布锁释放
                System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "使用完毕，将锁归还：" + "killsId:" + userId + ":lock");
                String lockToken = jedis.get("killsId:" + userId + ":info");
                if (StringUtils.isNotBlank(lockToken) && lockToken.equals(token)) {
                    //jedis.eval("lua");可与用lua脚本，在查询到key的同时删除该key，防止高并发下的意外的发生
                    jedis.del("killsId:" + userId + ":info");// 用token确认删除的是自己的sku的锁
                }
            } else {
                // 设置失败，自旋（该线程在睡眠几秒后，重新尝试访问本方法）
                System.out.println("ip为" + ip + "的同学:" + Thread.currentThread().getName() + "没有拿到锁，开始自旋");

                return getItemKills(userId, ip);
            }
        }
        jedis.close();
        return itemKills;
    }
}
