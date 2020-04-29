package com.chenenru.gmall.passport.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.alibaba.fastjson.JSON;
import com.chenenru.gmall.HttpclientUtil;
import com.chenenru.gmall.bean.UmsMember;
import com.chenenru.gmall.bean.UmsMemberReceiveAddress;
import com.chenenru.gmall.service.UserService;
import com.chenenru.gmall.util.JwtUtil;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.crypto.hash.Md5Hash;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.persistence.Transient;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * @Author chenenru
 * @ClassName PassportController
 * @Description
 * @Date 2020/2/25 0:00
 * @Version 1.0
 **/
@Controller
public class PassportController {


    @Reference
    UserService userService;

    @Autowired
    private Environment env;


    @RequestMapping("vlogin")
    public String vlogin(String code, HttpServletRequest request) {

        // 授权码换取access_token
        // 换取access_token
        // client_secret=f043fe09dcab7e9b90cdd7491e282a8f
        // client_id=2173054083
        String s3 = "https://api.weibo.com/oauth2/access_token?";
        Map<String, String> paramMap = new HashMap<>();
        paramMap.put("client_id", "2173054083");
        paramMap.put("client_secret", "f043fe09dcab7e9b90cdd7491e282a8f");
        paramMap.put("grant_type", "authorization_code");
        paramMap.put("redirect_uri", "http://passport.gmall.com:8085/vlogin");
        paramMap.put("code", code);// 授权有效期内可以使用，没新生成一次授权码，说明用户对第三方数据进行重启授权，之前的access_token和授权码全部过期
        String access_token_json = HttpclientUtil.doPost(s3, paramMap);

        Map<String, Object> access_map = JSON.parseObject(access_token_json, Map.class);

        // access_token换取用户信息
        String uid = (String) access_map.get("uid");
        String access_token = (String) access_map.get("access_token");
        String show_user_url = "https://api.weibo.com/2/users/show.json?access_token=" + access_token + "&uid=" + uid;
        String user_json = HttpclientUtil.doGet(show_user_url);
        Map<String, Object> user_map = JSON.parseObject(user_json, Map.class);

        // 将用户信息保存数据库，用户类型设置为微博用户
        UmsMember umsMember = new UmsMember();
        umsMember.setSourceType("2");
        umsMember.setAccessCode(code);
        umsMember.setAccessToken(access_token);
        umsMember.setSourceUid((String) user_map.get("idstr"));
        umsMember.setCity((String) user_map.get("location"));
        umsMember.setNickname((String) user_map.get("screen_name"));
        umsMember.setEmail(String.valueOf(access_map.get("email")));
        String g = "0";
        String gender = (String) user_map.get("gender");
        if (gender.equals("m")) {
            g = "1";
        }
        umsMember.setGender(g);

        UmsMember umsCheck = new UmsMember();
        umsCheck.setSourceUid(umsMember.getSourceUid());
        UmsMember umsMemberCheck = userService.checkOauthUser(umsCheck);// 检查该用户(社交用户)以前是否登陆过系统

        if (umsMemberCheck == null) {
            umsMember = userService.addOauthUser(umsMember);
        } else {
            umsMember = umsMemberCheck;
        }

        // 生成jwt的token，并且重定向到首页，携带该token
        String token = null;
        String memberId = umsMember.getId();// rpc的主键返回策略失效
        String nickname = umsMember.getNickname();
        Map<String, Object> userMap = new HashMap<>();
        userMap.put("memberId", memberId);// 是保存数据库后主键返回策略生成的id
        userMap.put("nickname", nickname);


        String ip = request.getHeader("x-forwarded-for");// 通过nginx转发的客户端ip
        if (StringUtils.isBlank(ip)) {
            ip = request.getRemoteAddr();// 从request中获取ip
            if (StringUtils.isBlank(ip)) {
                ip = "127.0.0.1";
            }
        }

        // 按照设计的算法对参数进行加密后，生成token
        token = JwtUtil.encode("2019gmall0105", userMap, ip);

        // 将token存入redis一份
        userService.addUserToken(token, memberId);


        return "redirect:http://search.gmall.com:8083/index?token=" + token;
    }


    @RequestMapping("verify")
    @ResponseBody
    public String verify(String token, String currentIp, HttpServletRequest request) {

        System.out.println("拦截器传过来的ip:"+currentIp);
        System.out.println("拦截器传过来的token:"+token);
        // 通过jwt校验token真假
        Map<String, String> map = new HashMap<>();

        Map<String, Object> decode = JwtUtil.decode(token, "2019gmall0105", currentIp);

        if (decode != null) {
            map.put("status", "success");
            map.put("memberId", (String) decode.get("memberId"));
            map.put("nickname", (String) decode.get("nickname"));
        } else {
            map.put("status", "fail");
        }

        System.out.println("校验后的结果:"+map.get("status"));

        return JSON.toJSONString(map);
    }


    @RequestMapping("login")
    @ResponseBody
    public String login(UmsMember umsMember, HttpServletRequest request) {

        String token = "";

        String newPsd=new Md5Hash(umsMember.getPassword(),env.getProperty("shiro.encrypt.password.salt")).toString();
        umsMember.setPassword(newPsd);
        // 调用用户服务验证用户名和密码
        UmsMember umsMemberLogin = userService.login(umsMember);

        if (umsMemberLogin != null) {
            // 登录成功

            // 用jwt制作token
            String memberId = umsMemberLogin.getId();
            String nickname = umsMemberLogin.getNickname();
            Map<String, Object> userMap = new HashMap<>();
            userMap.put("memberId", memberId);
            userMap.put("nickname", nickname);


            String ip = request.getHeader("x-forwarded-for");// 通过nginx转发的客户端ip
            System.out.println("passport-ip1:"+ip);
            if (StringUtils.isBlank(ip)) {
                ip = request.getRemoteAddr();// 从request中获取ip
                if (StringUtils.isBlank(ip)) {
                    ip = "127.0.0.1";
                }
            }

            ip = "127.0.0.1";
            System.out.println("passport-ip2:"+ip);
            // 按照设计的算法对参数进行加密后，生成token
            token = JwtUtil.encode("2019gmall0105", userMap, ip);
            System.out.println("加密后的token:"+token);

            // 将token存入redis一份
            userService.addUserToken(token, memberId);

        } else {
            // 登录失败
            token = "fail";
        }

        return token;
    }

    @RequestMapping("toregister")
    public String toRegist() {
        return "register";
    }

    @RequestMapping("register")
    @ResponseBody
    public String regist(UmsMember umsMember, HttpServletRequest request) {

        //System.out.println(umsMember.toString());

        // 将用户信息保存数据库
        /*id
        * 选项 **后台填充  ***必填

        username ***
        password ***
        phone ***
        email ***

        nickname *
        gender *
        birthday *
        city *

        member_level_id 4**
        status 1**
        create_time **
        source_type 1**
        icon



        job
        personalized_signature

        integration
        growth
        luckey_count
        history_integration
        access_token
        access_code
        source_uid
        */
        // 表示用户名+密码唯一
        String newPsd=new Md5Hash(umsMember.getPassword(),env.getProperty("shiro.encrypt.password.salt")).toString();
        umsMember.setPassword(newPsd);
        UmsMember umsMemberLogin=new UmsMember();
        umsMemberLogin.setUsername(umsMember.getUsername());
        umsMemberLogin.setPassword(umsMember.getPassword());
        // 调用用户服务验证用户名和密码
        umsMemberLogin = userService.getOauthUser(umsMemberLogin);

        if (umsMemberLogin == null) {

            umsMember.setSourceType("1");
            umsMember.setStatus(1);//这里打错了4，但是数据库为空
            umsMember.setMemberLevelId(String.valueOf(4));
            umsMember.setCreateTime(new Date());
            String g = "2";
            String gender = umsMember.getGender();
            if (StringUtils.isNotBlank(gender)&&gender.equals("m")) {
                g = "1";
            }
            umsMember.setGender(g);
            umsMember.setBirthday(new Date());
            umsMember.setPersonalizedSignature("快来设置自己的个性签名吧");
            umsMember.setJob("顾客是上帝");
            umsMember.setIcon("../img/icon.png");
            //umsMember.setCity("中国");

            String province=umsMember.getProvince().substring(0, umsMember.getProvince().length() - 1);
            String city=umsMember.getCity();
            String area=umsMember.getArea();
            String detailAddress=umsMember.getDetailAddress();
            String postCode=umsMember.getPostCode();

            umsMember = userService.addOauthUser(umsMember);

            UmsMemberReceiveAddress umsMemberReceiveAddress =new UmsMemberReceiveAddress();
            umsMemberReceiveAddress.setMemberId(umsMember.getId());
            umsMemberReceiveAddress.setDefaultStatus(1);
            umsMemberReceiveAddress.setName(umsMember.getUsername());
            umsMemberReceiveAddress.setPhoneNumber(umsMember.getPhone());
            umsMemberReceiveAddress.setProvince(province);
            umsMemberReceiveAddress.setCity(city);
            umsMemberReceiveAddress.setRegion(area);
            umsMemberReceiveAddress.setDetailAddress(detailAddress);
            umsMemberReceiveAddress.setPostCode(postCode);
            userService.saveUmsMemberReceiveAddress(umsMemberReceiveAddress);
            if (umsMember==null){
                return "fail";
            }
        }else{
            return "fail";
        }

        return "success";
    }

    @RequestMapping("index")
    public String index(String ReturnUrl, ModelMap map) {

        map.put("ReturnUrl", ReturnUrl);
        return "index";
    }
}



