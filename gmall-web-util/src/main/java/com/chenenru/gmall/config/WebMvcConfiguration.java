package com.chenenru.gmall.config;

import com.chenenru.gmall.interceptors.AuthInterceptor;
import com.chenenru.gmall.interceptors.CorsInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;


/**
 * @Author chenenru
 * @ClassName WebMvcConfiguration
 * @Description
 * @Date 2020/2/25 2:12
 * @Version 1.0
 **/
@Configuration
public class WebMvcConfiguration extends WebMvcConfigurerAdapter {
    @Autowired
    AuthInterceptor authInterceptor;

    @Autowired
    private CorsInterceptor corsInterceptor;

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("POST", "GET", "PUT", "OPTIONS", "DELETE")
                .maxAge(3600)
                .allowCredentials(true);
    }
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 跨域拦截器需放在最上面
        registry.addInterceptor(corsInterceptor).addPathPatterns("/**");
        registry.addInterceptor(authInterceptor).addPathPatterns("/**").excludePathPatterns("/error");
        super.addInterceptors(registry);
    }
}