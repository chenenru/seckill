package com.chenenru.gmall.interceptors;

import com.alibaba.fastjson.JSON;
import com.chenenru.gmall.HttpclientUtil;
import com.chenenru.gmall.annotations.LoginRequired;
import com.chenenru.gmall.util.CookieUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * @Author chenenru
 * @ClassName AuthInterceptor
 * @Description
 * @Date 2020/2/25 2:14
 * @Version 1.0
 **/
@Component
public class AuthInterceptor extends HandlerInterceptorAdapter {
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 拦截代码
        // 判断被拦截的请求的访问的方法的注解(是否时需要拦截的)
        HandlerMethod hm = (HandlerMethod) handler;
        LoginRequired methodAnnotation = hm.getMethodAnnotation(LoginRequired.class);

        StringBuffer url = request.getRequestURL();
        System.out.println("AuthInterceptor：拦截"+url);

        // 是否拦截
        if (methodAnnotation == null) {
            return true;
        }

        String token = "";

        String oldToken = CookieUtil.getCookieValue(request, "oldToken", true);
        if (StringUtils.isNotBlank(oldToken)) {
            token = oldToken;
        }

        String newToken = request.getParameter("token");
        if (StringUtils.isNotBlank(newToken)) {
            token = newToken;
        }

        // 是否必须登录
        boolean loginSuccess = methodAnnotation.loginSuccess();// 获得该请求是否必登录成功

        // 调用认证中心进行验证
        String success = "fail";
        Map<String, String> successMap = new HashMap<>();
        if (StringUtils.isNotBlank(token)) {
            String ip = request.getHeader("x-forwarded-for");// 通过nginx转发的客户端ip
            if (StringUtils.isBlank(ip)) {
                ip = request.getRemoteAddr();// 从request中获取ip
                if (StringUtils.isBlank(ip)) {
                    ip = "127.0.0.1";
                }
            }
            ip = "127.0.0.1";
            System.out.println("拦截器-ip:"+ip);
            System.out.println("拦截器到认证的token:"+token);
            String successJson = HttpclientUtil.doGet("http://passport.gmall.com:8096/verify?token=" + token + "&currentIp=" + ip);

            successMap = JSON.parseObject(successJson, Map.class);

            success = successMap.get("status");

        }

        if (loginSuccess) {
            // 必须登录成功才能使用
            if (!success.equals("success")) {
                //重定向会passport登录
                StringBuffer requestURL = request.getRequestURL();
                response.sendRedirect("http://passport.gmall.com:8096/index?ReturnUrl=" + requestURL);
                return false;
            }

            // 需要将token携带的用户信息写入
            request.setAttribute("memberId", successMap.get("memberId"));
            request.setAttribute("nickname", successMap.get("nickname"));
            //request.setAttribute("username", successMap.get("username"));
            /*HttpSession session = request.getSession();
            session.setAttribute("memberId",successMap.get("memberId"));
            session.setAttribute("nickname",successMap.get("nickname"));
            System.out.println("需要将token携带的用户信息写入---->"+session.getAttribute("memberId"));*/
            //验证通过，覆盖cookie中的token
            if (StringUtils.isNotBlank(token)) {
                CookieUtil.setCookie(request, response, "oldToken", token, 60 * 60 * 2, true);
            }

        } else {
            // 没有登录也能用，但是必须验证
            if (success.equals("success")) {
                // 需要将token携带的用户信息写入
                request.setAttribute("memberId", successMap.get("memberId"));
                request.setAttribute("nickname", successMap.get("nickname"));

                /*HttpSession session = request.getSession();
                session.setAttribute("memberId",successMap.get("memberId"));
                session.setAttribute("nickname",successMap.get("nickname"));
                System.out.println("没有登录也能用，但是必须验证session---->"+session.getAttribute("memberId"));*/
                //验证通过，覆盖cookie中的token
                if (StringUtils.isNotBlank(token)) {
                    CookieUtil.setCookie(request, response, "oldToken", token, 60 * 60 * 2, true);
                }

            }
        }


        return true;
    }
}
