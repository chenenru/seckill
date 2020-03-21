package com.chenenru.gmall;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;
import tk.mybatis.spring.annotation.MapperScan;

@SpringBootApplication
@MapperScan(basePackages ="com.chenenru.gmall.seckill.mapper")
@EnableScheduling
public class GmallSeckillApplication {

    public static void main(String[] args) {
        SpringApplication.run(GmallSeckillApplication.class, args);
    }

}
