package com.example.multidb.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.multidb.entity.AppConfig;
import com.example.multidb.entity.BizOrder;
import com.example.multidb.entity.SysUser;
import com.example.multidb.mapper.AppConfigMapper;
import com.example.multidb.mapper.BizOrderMapper;
import com.example.multidb.mapper.SysUserMapper;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class DemoQueryService {

    private final SysUserMapper sysUserMapper;
    private final BizOrderMapper bizOrderMapper;
    private final AppConfigMapper appConfigMapper;

    public DemoQueryService(SysUserMapper sysUserMapper, BizOrderMapper bizOrderMapper, AppConfigMapper appConfigMapper) {
        this.sysUserMapper = sysUserMapper;
        this.bizOrderMapper = bizOrderMapper;
        this.appConfigMapper = appConfigMapper;
    }

    public List<SysUser> listActiveUsers() {
        return sysUserMapper.selectActiveUsers();
    }

    public List<SysUser> searchUsers(String keyword) {
        return sysUserMapper.searchByKeyword(keyword);
    }

    public IPage<BizOrder> pageOrders(long current, long size) {
        return bizOrderMapper.selectPage(Page.of(current, size), null);
    }

    public AppConfig getConfig(String key) {
        return appConfigMapper.selectByConfigKey(key);
    }
}

