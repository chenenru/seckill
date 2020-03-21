package com.chenenru.gmall.seckill.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @Author chenenru
 * @ClassName BaseController
 * @Description
 * @Date 2020/3/5 11:10
 * @Version 1.0
 **/
@Controller
@RequestMapping("/base")
public class BaseController {
    @RequestMapping(value = "/error",method = RequestMethod.GET)
    public String error(){
        return "err";
    }

    @RequestMapping("success")
    public String success(){
        return "success";
    }
}
