package com.example.multidb.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.example.multidb.entity.AppConfig;
import com.example.multidb.entity.BizOrder;
import com.example.multidb.entity.SysUser;
import com.example.multidb.service.DemoQueryService;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class DemoController {

    private final DemoQueryService demoQueryService;

    public DemoController(DemoQueryService demoQueryService) {
        this.demoQueryService = demoQueryService;
    }

    @GetMapping("/users")
    public List<SysUser> users() {
        return demoQueryService.listActiveUsers();
    }

    @GetMapping("/users/search")
    public List<SysUser> searchUsers(@RequestParam String keyword) {
        return demoQueryService.searchUsers(keyword);
    }

    @GetMapping("/orders")
    public IPage<BizOrder> orders(@RequestParam(defaultValue = "1") long current,
                                  @RequestParam(defaultValue = "10") long size) {
        return demoQueryService.pageOrders(current, size);
    }

    @GetMapping("/configs/{key}")
    public AppConfig config(@PathVariable String key) {
        return demoQueryService.getConfig(key);
    }
}

