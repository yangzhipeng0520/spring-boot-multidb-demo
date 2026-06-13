# Spring Boot Multi-DB Demo

一个面向 Java 后端开发者的多数据库适配 Demo，首版覆盖：

- MySQL 8
- PostgreSQL 16
- 达梦 DM8
- Spring Boot 3
- MyBatis-Plus

项目目标不是做后台脚手架，而是演示企业项目中常见的数据库适配问题：连接配置、分页方言、主键策略、关键字、时间字段、CLOB/JSON 替代方案和基础 CRUD。

## 环境要求

- JDK 17+
- Maven 3.8+
- Docker Desktop，可选
- 达梦 DM8，本地或客户环境，可选

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

## 验证接口

```bash
curl http://localhost:8080/api/users
curl http://localhost:8080/api/users/search?keyword=admin
curl http://localhost:8080/api/orders
curl http://localhost:8080/api/configs/feature.multidb.enabled
```

## 项目约束

- 主键使用 MyBatis-Plus `ASSIGN_ID`，避免跨库自增差异。
- 表名和字段名统一小写下划线。
- 不使用 MySQL 反引号。
- 不使用 `user`、`order` 等关键字作为表名。
- JSON 类配置首版用文本/CLOB 存储，由 Java 侧处理。
- 分页方言按 profile 显式配置。

## 目录说明

```text
src/main/java/com/example/multidb
  config      多数据库 MyBatis-Plus 配置
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
  dm          达梦初始化脚本
```

