package com.chenenru.gmall.seckill.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.chenenru.gmall.annotations.LoginRequired;
import com.chenenru.gmall.bean.OmsCartItem;
import com.chenenru.gmall.bean.OmsOrder;
import com.chenenru.gmall.bean.OmsOrderItem;
import com.chenenru.gmall.bean.UmsMemberReceiveAddress;
import com.chenenru.gmall.seckill.bean.ItemKillSuccess;
import com.chenenru.gmall.seckill.dto.KillDto;
import com.chenenru.gmall.seckill.dto.KillSuccessUserInfo;
import com.chenenru.gmall.seckill.enums.StatusCode;
import com.chenenru.gmall.seckill.response.BaseResponse;
import com.chenenru.gmall.seckill.service.ItemKillService;
import com.chenenru.gmall.seckill.service.ItemKillSuccessService;
import com.chenenru.gmall.seckill.service.KillService;
import com.chenenru.gmall.seckill.service.KillToOrderAndToPayService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 * @Author chenenru
 * @ClassName KillController
 * @Description 秒杀controller
 * @Date 2020/1/30 16:55
 * @Version 1.0
 **/
@Controller
public class KillController {
    private static final Logger log = LoggerFactory.getLogger(KillController.class);

    private static final String prefix = "/kill";

    @Reference
    KillService killService;

    @Reference
    ItemKillSuccessService itemKillSuccessService;

    @Autowired
    KillToOrderAndToPayService killToOrderAndToPayService;


    /**
     * 商品秒杀核心业务逻辑
     * @param dto
     * @param
     * @return
     */
    @RequestMapping(value = prefix+"/execute")
    @LoginRequired(loginSuccess = true)
    public String execute(KillDto dto,ModelMap modelMap){

        //System.out.println(dto.toString()+"*********");
        /*if (result.hasErrors()||dto.getKillId()<=0){
            return new BaseResponse(StatusCode.InvalidParams);
        }*/
        /*Object uId = session.getAttribute("uid");
        if (uId==null){
            return new BaseResponse(StatusCode.UserNotLogin);
        }
        Integer userId = (Integer)uId;*/

        BaseResponse response =new BaseResponse(StatusCode.Success);

        try{
            Boolean res = killService.killItemV4(dto.getKillId(),dto.getUserId());
            if (!res){
                response= new BaseResponse(StatusCode.Fail.getCode(),"哈哈~商品已抢购完毕或者不在抢购时间段哦!");
            }
        }catch (Exception e){
            response=new BaseResponse(StatusCode.Fail.getCode(),e.getMessage());
        }
        /*System.out.println(response.getMsg()+"////");
        System.out.println(response.getCode()+"////");
        System.out.println(response.getData()+"/////");*/
        modelMap.put("msg",response.getMsg());
        if (StringUtils.equals(response.getMsg(), "成功")){
            return "executeSuccess";
        }else {
            return "executeFail";
        }
    }


    /**
     * 商品秒杀核心业务逻辑---用于压力测试
     * @param dto
     * @param result
     * @param session
     * @return
     */
    @RequestMapping(value = prefix+"/execute/lock",method = RequestMethod.POST,consumes = MediaType.APPLICATION_JSON_UTF8_VALUE)
    @ResponseBody
    public BaseResponse executeLock(@RequestBody @Validated KillDto dto, BindingResult result, HttpSession session){

        if (result.hasErrors()||dto.getKillId()<=0){
            return new BaseResponse(StatusCode.InvalidParams);
        }
        //Object uId = session.getAttribute("userid");
        //Integer userId = (Integer)uId;

        BaseResponse response =new BaseResponse(StatusCode.Success);

        try{
            //不加分布式锁的前提
            /*Boolean res = killService.killItemV2(dto.getKillId(),dto.getUserId());
            if (!res){
                return new BaseResponse(StatusCode.Fail.getCode(),"不加分布式锁-哈哈~商品已抢购完毕或者不在抢购时间段哦!");
            }*/
            //基于Redis的分布式锁
            /*Boolean res = killService.killItemV3(dto.getKillId(), dto.getUserId());
            if (!res){
                return new BaseResponse(StatusCode.Fail.getCode(),"加redis分布式锁-哈哈~商品已抢购完毕或者不在抢购时间段哦!");
            }*/
            //基于Redisson的分布式锁
            Boolean res = killService.killItemV4(dto.getKillId(), dto.getUserId());
            if (!res){
                return new BaseResponse(StatusCode.Fail.getCode(),"加redisson分布式锁-哈哈~商品已抢购完毕或者不在抢购时间段哦!");
            }
            //基于zookeeper的分布式锁进行控制
            /*Boolean res = killService.killItemV5(dto.getKillId(), dto.getUserId());
            if (!res){
                return new BaseResponse(StatusCode.Fail.getCode(),"加zookeeper分布式锁-哈哈~商品已抢购完毕或者不在抢购时间段哦!");
            }*/
        }catch (Exception e){
            response=new BaseResponse(StatusCode.Fail.getCode(),e.getMessage());
        }
        return response;
    }

    //抢购成功跳转页面
    @RequestMapping(value = prefix+"/execute/success",method = RequestMethod.GET)
    public String executeSuccess(){
        return "executeSuccess";
    }
    //抢购失败跳转的页面
    @RequestMapping(value = prefix+"/execute/fail",method = RequestMethod.GET)
    public String execuuteFail(){
        return "executeFail";
    }

    /**
     * 查看订单详情
     * @param orderNo
     * @param modelMap
     * @return
     */
    //http://localhost:8092/kill/kill/record/detail/420670768410800128
    @RequestMapping(value = "/record/{orderNo}",method = RequestMethod.GET)
    @LoginRequired(loginSuccess = true)
    public String KillOrderDetail(@PathVariable String orderNo, ModelMap modelMap,HttpServletRequest request) throws Exception{
        String memberId = (String) request.getAttribute("memberId");
        //memberId= String.valueOf(28);
        if (StringUtils.isBlank(orderNo)){
            return "redirect:/base/error";
        }
        KillSuccessUserInfo info = itemKillSuccessService.selectAllstatusByCode(orderNo);

        ItemKillSuccess itemKillSuccess = itemKillSuccessService.selectToStatusByCode(orderNo);
        if (itemKillSuccess==null){
            return "redirect:/base/error";
        }
        boolean b = killToOrderAndToPayService.checkItemKillAndOrder(itemKillSuccess);
        if (b){
            System.out.println("同步order和itemkill支付状态成功");
        }else {
            System.out.println("同步order和itemkill支付状态失败");
        }
        modelMap.put("memberId",memberId);
        //modelMap.put("orderNo", orderNo);
        modelMap.put("info", info);
        return "killRecord";
    }
    //秒杀支付


}
