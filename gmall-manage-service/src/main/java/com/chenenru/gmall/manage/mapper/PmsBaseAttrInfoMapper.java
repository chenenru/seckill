package com.chenenru.gmall.manage.mapper;

import com.chenenru.gmall.bean.PmsBaseAttrInfo;
import org.apache.ibatis.annotations.Param;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;

/**
 * @Author chenenru
 * @ClassName PmsBaseAttrInfoMapper
 * @Description
 * @Date 2020/2/18 11:24
 * @Version 1.0
 **/
public interface PmsBaseAttrInfoMapper extends Mapper<PmsBaseAttrInfo> {
    List<PmsBaseAttrInfo> selectAttrValueListByValueId(@Param("valueIdStr") String valueIdStr);
}
