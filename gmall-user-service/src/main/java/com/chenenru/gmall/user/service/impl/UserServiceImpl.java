package com.chenenru.gmall.user.service.impl;

import com.alibaba.dubbo.config.annotation.Reference;
import com.alibaba.dubbo.config.annotation.Service;
import com.alibaba.fastjson.JSON;
import com.chenenru.gmall.bean.UmsMember;
import com.chenenru.gmall.bean.UmsMemberReceiveAddress;
import com.chenenru.gmall.user.mapper.UmsMemberReceiveAddressMapper;
import com.chenenru.gmall.user.mapper.UserMapper;
import com.chenenru.gmall.service.UserService;
import com.chenenru.gmall.util.RedisUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import redis.clients.jedis.Jedis;

import java.util.List;

/**
 * @Author chenenru
 * @ClassName UserServiceImpl
 * @Description
 * @Date 2020/2/16 13:15
 * @Version 1.0
 **/
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    UserMapper userMapper;

    @Autowired
    UmsMemberReceiveAddressMapper umsMemberReceiveAddressMapper;

    @Autowired
    RedisUtil redisUtil;

    @Override
    public List<UmsMember> getAllUser() {

        List<UmsMember> umsMembers = userMapper.selectAll();//userMapper.selectAllUser();

        return umsMembers;
    }

    @Override
    public List<UmsMemberReceiveAddress> getReceiveAddressByMemberId(String memberId) {

        // 封装的参数对象
        UmsMemberReceiveAddress umsMemberReceiveAddress = new UmsMemberReceiveAddress();
        umsMemberReceiveAddress.setMemberId(memberId);
        List<UmsMemberReceiveAddress> umsMemberReceiveAddresses = umsMemberReceiveAddressMapper.select(umsMemberReceiveAddress);


//       Example example = new Example(UmsMemberReceiveAddress.class);
//       example.createCriteria().andEqualTo("memberId",memberId);
//       List<UmsMemberReceiveAddress> umsMemberReceiveAddresses = umsMemberReceiveAddressMapper.selectByExample(example);

        return umsMemberReceiveAddresses;
    }


    @Override
    public UmsMember login(UmsMember umsMember) {
        Jedis jedis = null;
        try {
            jedis = redisUtil.getJedis();

            if (jedis != null) {
                String umsMemberStr = jedis.get("user:" + umsMember.getPassword() + umsMember.getUsername() + ":info");
                System.out.println("redis取用户："+umsMemberStr);
                if (StringUtils.isNotBlank(umsMemberStr)) {
                    // 密码正确
                    UmsMember umsMemberFromCache = JSON.parseObject(umsMemberStr, UmsMember.class);
                    return umsMemberFromCache;
                }
            }
            // 链接redis失败，开启数据库
            UmsMember umsMemberFromDb = loginFromDb(umsMember);
            if (umsMemberFromDb != null) {
                jedis.setex("user:" + umsMember.getPassword() + umsMember.getUsername() + ":info", 60 * 60 * 24, JSON.toJSONString(umsMemberFromDb));
            }
            System.out.println("数据库取用户："+umsMemberFromDb);
            return umsMemberFromDb;
        } finally {
            jedis.close();
        }
    }

    @Override
    public void addUserToken(String token, String memberId) {
        Jedis jedis = redisUtil.getJedis();

        jedis.setex("user:" + memberId + ":token", 60 * 60 * 2, token);

        jedis.close();
    }

    @Override
    public UmsMember addOauthUser(UmsMember umsMember) {
        userMapper.insertSelective(umsMember);

        return umsMember;
    }

    @Override
    public UmsMember checkOauthUser(UmsMember umsCheck) {
        UmsMember umsMember = userMapper.selectOne(umsCheck);
        return umsMember;
    }

    @Override
    public UmsMember getOauthUser(UmsMember umsMemberCheck) {

        UmsMember umsMember = userMapper.selectOne(umsMemberCheck);
        return umsMember;
    }

    @Override
    public UmsMemberReceiveAddress getReceiveAddressById(String receiveAddressId) {
        UmsMemberReceiveAddress umsMemberReceiveAddress = new UmsMemberReceiveAddress();
        umsMemberReceiveAddress.setId(receiveAddressId);
        UmsMemberReceiveAddress umsMemberReceiveAddress1 = umsMemberReceiveAddressMapper.selectOne(umsMemberReceiveAddress);
        return umsMemberReceiveAddress1;
    }

    @Override
    public void saveUmsMemberReceiveAddress(UmsMemberReceiveAddress umsMemberReceiveAddress) {
        umsMemberReceiveAddressMapper.insert(umsMemberReceiveAddress);
    }

    @Override
    public void deleateUmsMemberReceiveAddress(UmsMemberReceiveAddress umsMemberReceiveAddress) {
        umsMemberReceiveAddressMapper.delete(umsMemberReceiveAddress);
    }

    @Override
    public void updateReceiveAddress(UmsMemberReceiveAddress umsMemberReceiveAddress) {
        umsMemberReceiveAddressMapper.updateByPrimaryKey(umsMemberReceiveAddress);
    }

    @Override
    public UmsMember getUserByuId(String userId) {
        UmsMember umsMember=new UmsMember();
        umsMember.setId(userId);
        UmsMember member = userMapper.selectOne(umsMember);
        return member;
    }

    @Override
    public void updateUser(UmsMember umsMember) {
        userMapper.updateByPrimaryKeySelective(umsMember);
    }

    private UmsMember loginFromDb(UmsMember umsMember) {

        List<UmsMember> umsMembers = userMapper.select(umsMember);

        if (umsMembers != null&&umsMembers.size()>0) {
            return umsMembers.get(0);
        }

        return null;

    }
}
