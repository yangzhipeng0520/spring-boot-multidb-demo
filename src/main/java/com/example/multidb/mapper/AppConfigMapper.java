package com.example.multidb.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.multidb.entity.AppConfig;

public interface AppConfigMapper extends BaseMapper<AppConfig> {
    AppConfig selectByConfigKey(String configKey);
}

