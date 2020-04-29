package com.chenenru.gmall.user.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.chenenru.gmall.annotations.LoginRequired;
import com.chenenru.gmall.bean.UmsMember;
import com.chenenru.gmall.bean.UmsMemberReceiveAddress;
import com.chenenru.gmall.service.UserService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * @Author chenenru
 * @ClassName UserController
 * @Description
 * @Date 2020/2/16 13:12
 * @Version 1.0
 **/
@Controller
@CrossOrigin
public class UserController {
    @Reference
    UserService userService;


    @RequestMapping("index")
    @ResponseBody
    public String index() {
        return "hello usercontroller";
    }

    @RequestMapping("getAllUser")
    @ResponseBody
    public List<UmsMember> getAllUser() {
        List<UmsMember> umsMembers = userService.getAllUser();
        return umsMembers;
    }

    @RequestMapping("getReceiveAddressByMemberId")
    @ResponseBody
    public List<UmsMemberReceiveAddress> getReceiveAddressByMemberId(String memberId) {
        List<UmsMemberReceiveAddress> umsMemberReceiveAddresses = userService.getReceiveAddressByMemberId(memberId);
        return umsMemberReceiveAddresses;
    }

    @RequestMapping("addAddress")
    @ResponseBody
    @LoginRequired(loginSuccess = true)
    public String addAddress(UmsMemberReceiveAddress umsMemberReceiveAddress){

        /*private String id;
        private String memberId;
        private String  name;
        private String  phoneNumber;
        private int defaultStatus;
        private String postCode;
        private String province;
        private String city;
        private String region;
        private String detailAddress;*/
        umsMemberReceiveAddress.setCity(umsMemberReceiveAddress.getCity()+"市");
        //umsMemberReceiveAddress.setRegion(umsMemberReceiveAddress.getRegion()+"区");
        umsMemberReceiveAddress.setDefaultStatus(0);
        umsMemberReceiveAddress.setRegion(umsMemberReceiveAddress.getArea()+"区");
        userService.saveUmsMemberReceiveAddress(umsMemberReceiveAddress);

        //System.out.println(umsMemberReceiveAddress.toString()+"????");
        return "success";
    }

    //管理地址 0增加地址 1删除地址 2修改地址 3默认查询所有地址
    @RequestMapping("manageAddress")
    @LoginRequired(loginSuccess = true)
    public String manageAddress(String operation, UmsMemberReceiveAddress umsMemberReceiveAddress, ModelMap modelMap, HttpServletRequest request){
        String uId = (String) request.getAttribute("memberId");
        //uId="42";//先写死
        if ("0".equals(operation)&& StringUtils.isNotBlank(operation)){
            userService.saveUmsMemberReceiveAddress(umsMemberReceiveAddress);
        }
        if ("1".equals(operation)&&StringUtils.isNotBlank(operation)){
            userService.deleateUmsMemberReceiveAddress(umsMemberReceiveAddress);
        }
        if ("2".equals(operation)&&StringUtils.isNotBlank(operation)){
            userService.updateReceiveAddress(umsMemberReceiveAddress);
        }
        List<UmsMemberReceiveAddress> addresses = userService.getReceiveAddressByMemberId(uId);
        modelMap.put("addresses", addresses);
        modelMap.put("memberId",uId);
        return "address";
    }

    @RequestMapping("userInfo")
    @LoginRequired(loginSuccess = true)
    public String getUserByUserId(HttpServletRequest request,ModelMap modelMap){
        String uId = (String) request.getAttribute("memberId");
        if (uId==null){
            uId="46";
        }
        UmsMember umsMember= userService.getUserByuId(uId);
        List<UmsMemberReceiveAddress> address = userService.getReceiveAddressByMemberId(uId);
        modelMap.put("user", umsMember);
        modelMap.put("address", address.get(0));
        return "self_info";
    }


}
