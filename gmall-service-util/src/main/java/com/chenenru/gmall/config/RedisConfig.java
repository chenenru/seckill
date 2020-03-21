package com.chenenru.gmall.config;

import com.chenenru.gmall.util.RedisUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @Author chenenru
 * @ClassName RedisConfig
 * @Description
 * @Date 2020/2/21 15:58
 * @Version 1.0
 **/
@Configuration
public class RedisConfig {
    //读取配置文件中的redis的ip地址
    @Value("${spring.redis.host:disabled}")
    private String host = "127.0.0.1";
    @Value("${spring.redis.port:0}")
    private int port = 6179;
    @Value("${spring.redis.database:0}")
    private int database;

    @Bean
    public RedisUtil getRedisUtil() {
        if (host.equals("disabled")) {
            return null;
        }
        RedisUtil redisUtil = new RedisUtil();
        redisUtil.initPool(host, port, database);
        return redisUtil;
    }
}
