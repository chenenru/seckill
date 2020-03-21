package com.chenenru.gmall.seckill.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.SchedulingConfigurer;
import org.springframework.scheduling.config.ScheduledTaskRegistrar;

import java.util.concurrent.Executors;

/**
 * @Author chenenru
 * @ClassName SchedulerConfig
 * @Description 定时任务多线程处理的通用化配置
 * @Date 2020/1/31 16:37
 * @Version 1.0
 **/
@Configuration
public class SchedulerConfig implements SchedulingConfigurer {

    @Override
    public void configureTasks(ScheduledTaskRegistrar scheduledTaskRegistrar) {
        scheduledTaskRegistrar.setScheduler(Executors.newScheduledThreadPool(10));
    }
}
