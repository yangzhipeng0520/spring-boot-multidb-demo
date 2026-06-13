# Spring Boot Multi-DB Demo

Spring Boot 多数据库适配示例项目，面向 Java 后端开发者，演示 MySQL、PostgreSQL、达梦 DM8 在企业项目中的常见适配方式。

这个项目不是后台管理脚手架，而是一个专注于数据库迁移和国产数据库适配的最小可运行 Demo。

## 适用场景

- Java 项目需要从 MySQL 迁移到 PostgreSQL。
- 客户环境要求适配达梦 DM8。
- 需要验证 MyBatis-Plus 在不同数据库下的分页方言。
- 团队想建立一套多数据库开发规范。
- 外包或政企项目中需要快速识别数据库兼容风险。

## 技术栈

| 类型 | 技术 |
|---|---|
| JDK | Java 17+ |
| 框架 | Spring Boot 3.3.x |
| ORM | MyBatis-Plus 3.5.x |
| 数据库 | MySQL 8 / PostgreSQL 16 / 达梦 DM8 |
| 构建 | Maven |
| 本地环境 | Docker Compose |

## 项目结构

```text
src/main/java/com/example/multidb
  config      MyBatis-Plus 多数据库分页配置
  controller  示例接口
  entity      示例实体
  mapper      Mapper 接口
  service     示例服务

src/main/resources
  application-mysql.yml
  application-postgres.yml
  application-dm.yml
  mapper/*.xml

sql
  mysql       MySQL 初始化脚本
  postgres    PostgreSQL 初始化脚本
  dm          达梦 DM8 初始化脚本

checklists
  dameng-checklist.md

docs
  monetization.md
```

## 核心设计

- 主键统一使用 MyBatis-Plus `ASSIGN_ID`，避免跨数据库自增差异。
- 表名和字段名统一小写下划线。
- 不使用 MySQL 反引号。
- 不使用 `user`、`order` 等关键字作为表名。
- JSON 类配置先用文本/CLOB 存储，由 Java 侧序列化和校验。
- 分页方言按 profile 显式配置，不依赖自动识别。

## 启动 MySQL / PostgreSQL

```bash
docker compose up -d mysql postgres
```

## 使用 MySQL 启动

```bash
mvn spring-boot:run -Dspring-boot.run.profiles=mysql
```

## 使用 PostgreSQL 启动

```bash
mvn spring-boot:run -Dspring-boot.run.profiles=postgres
```

## 使用达梦 DM8 启动

达梦默认连接：

```text
jdbc:dm://localhost:5236
MULTIDB_DEMO / MULTIDB_DEMO_123
```

启动命令：

```bash
mvn spring-boot:run -Pdm -Dspring-boot.run.profiles=dm
```

达梦适配检查清单见：

[checklists/dameng-checklist.md](checklists/dameng-checklist.md)

## 验证接口

```bash
curl http://localhost:8080/api/users
curl "http://localhost:8080/api/users/search?keyword=admin"
curl http://localhost:8080/api/orders
curl http://localhost:8080/api/configs/feature.multidb.enabled
```

## 免费版包含

- MySQL / PostgreSQL / 达梦 DM8 基础连接配置。
- MyBatis-Plus 多数据库分页配置。
- 用户、订单、日志、配置四类样例表。
- 基础 CRUD 和查询接口。
- 三套初始化 SQL。
- 达梦适配检查清单。

## 后续可扩展的付费版内容

这个公开仓库适合作为免费版入口。后续可以把更完整的迁移资料整理为付费版：

- 20-30 个 MySQL 到达梦迁移差异案例。
- 达梦常见报错排查手册。
- JSON/CLOB 字段处理专题。
- 批量插入、时间字段、分页排序专题。
- MyBatis XML 改造案例。
- 上线前验证清单。
- 人大金仓 / OceanBase 扩展章节。

变现路径草案见：

[docs/monetization.md](docs/monetization.md)

## 推荐文章

- [Spring Boot 适配达梦数据库：从 JDBC 到 MyBatis-Plus 分页](docs/articles/spring-boot-dameng-mybatis-plus.md)

## License

当前仓库用于学习、评估和技术验证。商业授权和付费版内容可在后续版本中单独定义。

