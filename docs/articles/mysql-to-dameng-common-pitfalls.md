# MySQL 迁移达梦 DM8：Java 项目最容易踩的 15 个坑

MySQL 迁移达梦 DM8 时，很多问题不会出现在项目启动阶段，而是在接口查询、分页、批量写入、上线验收时才暴露。对 Java 后端来说，真正需要关注的是应用层、SQL 层和 ORM 层的兼容风险。

下面整理 15 个高频坑点，适合在迁移前做自查。

## 1. 以为只改 JDBC URL 就够了

JDBC URL 只是连接层。真实迁移还会涉及：

- SQL 方言。
- MyBatis XML。
- 分页插件。
- 主键策略。
- 关键字和大小写。
- 时间字段。
- JSON 字段。

建议至少准备一套最小 Demo，把核心 SQL 在达梦上跑一遍。

## 2. 没有显式配置 MyBatis-Plus 方言

如果使用 MyBatis-Plus 分页，建议显式配置达梦方言：

```java
new PaginationInnerInterceptor(DbType.DM)
```

不要依赖自动识别。多环境部署时，自动识别失败会增加排查成本。

## 3. 使用 MySQL 反引号

MySQL 中常见：

```sql
select `id`, `name` from `user`;
```

迁移时建议直接改成跨库命名：

```sql
select id, user_name from sys_user;
```

## 4. 使用关键字作为表名

`user`、`order`、`group`、`type` 都容易造成兼容问题。新项目应尽量使用业务前缀：

```text
sys_user
biz_order
operation_log
app_config
```

## 5. 表名字段名大小写不统一

跨数据库项目最好统一：

- 小写表名。
- 小写字段名。
- 下划线命名。
- Java 侧用驼峰映射。

同时开启：

```yaml
mybatis-plus:
  configuration:
    map-underscore-to-camel-case: true
```

## 6. 直接照搬自增主键

MySQL 自增迁移到达梦时需要处理 identity 或序列差异。为了让 Demo 更稳，建议使用框架生成 ID：

```java
@TableId(type = IdType.ASSIGN_ID)
private Long id;
```

## 7. JSON 字段直接照搬

MySQL JSON 函数不能简单照搬到达梦。更稳的企业方案：

- JSON 原文存 CLOB。
- Java 侧序列化和校验。
- 高频查询字段拆成普通列。

## 8. 时间字段默认值没有验证

常见字段：

```text
create_time
update_time
```

迁移时要单独验证：

- 默认当前时间。
- Java `LocalDateTime` 映射。
- 时区。
- 查询条件边界。

## 9. 批量插入 SQL 没单独测试

MyBatis 的批量插入经常藏在 XML 中。迁移时要专门验证：

- 单批次大小。
- 参数绑定。
- 事务回滚。
- 失败后错误信息。

## 10. 分页加排序没有覆盖

分页本身能跑，不代表分页 + 排序 + 条件查询都能跑。建议至少覆盖：

- 单表分页。
- 带条件分页。
- 按时间排序。
- 按别名排序。

## 11. 字符串函数差异

字符串拼接、截取、大小写转换等函数要单独检查。不要在 Mapper XML 中散落太多数据库专属函数。

## 12. 唯一约束和空值行为没有验证

唯一索引、空值、重复数据导入，这些问题经常在测试数据少时被忽略。迁移验证必须覆盖。

## 13. schema 和账号混用

生产环境不要用系统账号放业务表。建议：

- 创建业务用户。
- 创建业务 schema。
- 初始化脚本和连接账号保持一致。

## 14. 只测启动，不测业务接口

应用能启动只代表连接成功。至少要测：

- 列表查询。
- 分页查询。
- 模糊搜索。
- 新增。
- 批量写入。
- 配置读取。

## 15. 没有上线前检查清单

上线前至少确认：

- 达梦版本。
- JDBC 驱动版本。
- 连接池参数。
- schema。
- 初始化脚本。
- 回滚方案。
- SQL 日志开关。

## 示例项目

我整理了一个最小可运行 Demo：

```text
https://github.com/yangzhipeng0520/spring-boot-multidb-demo
```

它包含 MySQL、PostgreSQL、达梦 DM8 三套 profile，适合做迁移前的基础验证。

