package com.example.multidb.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.multidb.entity.SysUser;
import java.util.List;

public interface SysUserMapper extends BaseMapper<SysUser> {
    List<SysUser> selectActiveUsers();
    List<SysUser> searchByKeyword(String keyword);
}

