package com.chenenru.gmall.service;


import com.chenenru.gmall.bean.UmsMember;
import com.chenenru.gmall.bean.UmsMemberReceiveAddress;

import java.util.List;

public interface UserService {

    List<UmsMember> getAllUser();

    List<UmsMemberReceiveAddress> getReceiveAddressByMemberId(String memberId);

    UmsMember login(UmsMember umsMember);

    void addUserToken(String token, String memberId);

    UmsMember addOauthUser(UmsMember umsMember);

    UmsMember checkOauthUser(UmsMember umsCheck);

    UmsMember getOauthUser(UmsMember umsMemberCheck);

    UmsMemberReceiveAddress getReceiveAddressById(String receiveAddressId);

    void saveUmsMemberReceiveAddress(UmsMemberReceiveAddress umsMemberReceiveAddress);

    void deleateUmsMemberReceiveAddress(UmsMemberReceiveAddress umsMemberReceiveAddress);

    void updateReceiveAddress(UmsMemberReceiveAddress umsMemberReceiveAddress);

    UmsMember getUserByuId(String userId);

    void updateUser(UmsMember umsMember);
}
