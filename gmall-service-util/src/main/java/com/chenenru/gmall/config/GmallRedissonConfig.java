package com.chenenru.gmall.config;

import org.redisson.Redisson;
import org.redisson.api.RedissonClient;
import org.redisson.config.Config;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @Author chenenru
 * @ClassName GmallRedissonConfig
 * @Description
 * @Date 2020/2/21 23:47
 * @Version 1.0
 **/
@Configuration
public class GmallRedissonConfig {

    @Value("${spring.redis.host:0}")
    private String host;

    @Value("${spring.redis.port:6379}")
    private String port;

    @Bean
    public RedissonClient redissonClient() {
        Config config = new Config();
        config.useSingleServer().setAddress("redis://" + host + ":" + port);
        RedissonClient redisson = Redisson.create(config);
        return redisson;
    }
}

