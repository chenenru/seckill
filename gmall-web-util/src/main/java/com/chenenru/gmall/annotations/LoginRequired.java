package com.chenenru.gmall.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @Author chenenru
 * @ClassName LoginRequired
 * @Description
 * @Date 2020/2/25 2:16
 * @Version 1.0
 **/
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface LoginRequired {

    boolean loginSuccess() default true;

}
