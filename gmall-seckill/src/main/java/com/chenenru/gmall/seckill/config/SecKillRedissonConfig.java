package com.chenenru.gmall.seckill.config;

import org.redisson.Redisson;
import org.redisson.api.RedissonClient;
import org.redisson.config.Config;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;

/**
 * @Author chenenru
 * @ClassName RedissonConfig
 * @Description
 * @Date 2020/2/1 1:20
 * @Version 1.0
 **/
@Configuration
public class SecKillRedissonConfig {
    @Autowired
    private Environment env;

    @Bean
    public RedissonClient redissonClient(){
        Config config = new Config();
        //config.setTransportMode(TransportMode.EPOLL);
        config.useSingleServer()
                .setAddress(env.getProperty("redis.config.host"))
                .setPassword(env.getProperty("spring.redis.password"));
                //可以用"rediss://"来启用SSL连接
                //.addNodeAddress("redis://127.0.0.1:7181");
        RedissonClient client = Redisson.create(config);
        return client;
    }
}
