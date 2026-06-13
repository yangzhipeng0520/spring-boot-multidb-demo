# Spring Boot 适配达梦数据库：从 JDBC 到 MyBatis-Plus 分页

很多 Java 项目最开始使用 MySQL，后续因为政企项目、客户环境或国产化要求，需要适配达梦 DM8。真实改造时，问题通常不只是换一个 JDBC URL，而是涉及驱动、分页方言、主键策略、关键字、大小写、时间字段和 SQL 函数差异。

本文用一个最小 Spring Boot Demo 说明：如何把 Spring Boot 3 + MyBatis-Plus 项目接入达梦数据库，并给出几个工程上更稳的处理建议。

## 1. 依赖配置

达梦 JDBC 驱动可以通过 Maven 引入。为了不影响 MySQL/PostgreSQL 用户，建议把达梦依赖放到单独 profile 中。

```xml
<profiles>
    <profile>
        <id>dm</id>
        <dependencies>
            <dependency>
                <groupId>com.dameng</groupId>
                <artifactId>DmJdbcDriver18</artifactId>
                <version>${dm.jdbc.version}</version>
                <scope>runtime</scope>
            </dependency>
        </dependencies>
    </profile>
</profiles>
```

这样普通构建不强制加载达梦驱动，需要达梦环境时再执行：

```bash
mvn package -Pdm
```

## 2. 数据源配置

达梦常见 JDBC 配置如下：

```yaml
spring:
  datasource:
    driver-class-name: dm.jdbc.driver.DmDriver
    url: jdbc:dm://localhost:5236
    username: MULTIDB_DEMO
    password: MULTIDB_DEMO_123
```

生产环境不要直接使用示例账号。建议创建独立业务用户和 schema，避免把业务表放在系统账号下。

## 3. MyBatis-Plus 分页方言

达梦适配里一个高频问题是分页。不要让框架自动猜测数据库类型，建议按 profile 显式配置：

```java
@Configuration
@Profile("dm")
public class DmMybatisPlusConfig {

    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        PaginationInnerInterceptor pagination = new PaginationInnerInterceptor(DbType.DM);
        pagination.setMaxLimit(1000L);
        interceptor.addInnerInterceptor(pagination);
        return interceptor;
    }
}
```

如果项目同时支持 MySQL、PostgreSQL、达梦，建议分别提供：

```text
MysqlMybatisPlusConfig
PostgresMybatisPlusConfig
DmMybatisPlusConfig
```

这样线上环境出现问题时，排查范围更小。

## 4. 主键策略

跨数据库项目不建议首版就依赖数据库自增。MySQL、PostgreSQL、达梦的自增和序列机制都有差异，迁移时容易在插入逻辑、批量写入和测试数据上出现问题。

更稳的方式是统一使用框架生成 ID：

```java
@TableId(type = IdType.ASSIGN_ID)
private Long id;
```

对应建表时只定义普通 `BIGINT` 主键：

```sql
CREATE TABLE sys_user (
    id BIGINT NOT NULL,
    user_name VARCHAR(64) NOT NULL,
    PRIMARY KEY (id)
);
```

## 5. 命名和关键字

MySQL 项目里经常出现反引号和关键字表名：

```sql
select `id`, `name` from `user`;
```

这种写法迁移到达梦时会增加兼容成本。更推荐从一开始就规避：

```sql
select id, user_name from sys_user;
```

建议规则：

- 表名小写下划线。
- 字段名小写下划线。
- 不使用数据库关键字。
- 不在 Mapper XML 中写 MySQL 反引号。

## 6. JSON 字段处理

如果原 MySQL 项目大量使用 JSON 字段，不建议直接假设达梦可以完全等价替代。

更稳的两种方案：

- JSON 原文存为 CLOB，Java 侧序列化、反序列化和校验。
- 高频查询字段拆成普通列，JSON/CLOB 只存扩展信息。

示例：

```sql
CREATE TABLE app_config (
    id BIGINT NOT NULL,
    config_key VARCHAR(128) NOT NULL,
    config_value CLOB,
    PRIMARY KEY (id)
);
```

## 7. 启动验证

达梦 profile 构建：

```bash
mvn clean package -Pdm -DskipTests
```

达梦 profile 启动：

```bash
mvn spring-boot:run -Pdm -Dspring-boot.run.profiles=dm
```

基础接口：

```bash
curl http://localhost:8080/api/users
curl http://localhost:8080/api/orders
```

## 8. 常见坑

| 问题 | 常见原因 | 建议 |
|---|---|---|
| 驱动类找不到 | 未启用 `dm` profile | 使用 `-Pdm` 构建 |
| 分页 SQL 异常 | 未配置 `DbType.DM` | 显式配置分页方言 |
| 表不存在 | schema 或大小写问题 | 统一 schema 和命名规范 |
| SQL 语法错误 | MySQL 反引号或函数 | 改写为跨库 SQL |
| JSON 查询异常 | 照搬 MySQL JSON 函数 | CLOB 存储或字段拆列 |

## 9. 示例项目

完整示例代码：

```text
https://github.com/yangzhipeng0520/spring-boot-multidb-demo
```

这个仓库包含 MySQL、PostgreSQL、达梦 DM8 三套 profile，适合用来做多数据库适配的最小验证。

## 10. 后续扩展

如果要继续做成更完整的企业适配包，可以补充：

- MySQL 到达梦的 20 个 SQL 差异案例。
- 达梦常见报错排查手册。
- 批量插入、分页排序、时间字段专题。
- 人大金仓、OceanBase 扩展章节。

