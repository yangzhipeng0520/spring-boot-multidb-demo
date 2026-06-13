CREATE TABLE sys_user (
    id BIGINT NOT NULL,
    user_name VARCHAR(64) NOT NULL,
    display_name VARCHAR(128),
    email VARCHAR(128),
    status INTEGER NOT NULL DEFAULT 1,
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE UNIQUE INDEX uk_sys_user_user_name ON sys_user(user_name);

CREATE TABLE biz_order (
    id BIGINT NOT NULL,
    order_no VARCHAR(64) NOT NULL,
    user_id BIGINT NOT NULL,
    amount NUMERIC(18, 2) NOT NULL,
    order_status INTEGER NOT NULL DEFAULT 0,
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE UNIQUE INDEX uk_biz_order_order_no ON biz_order(order_no);
CREATE INDEX idx_biz_order_user_id ON biz_order(user_id);

CREATE TABLE operation_log (
    id BIGINT NOT NULL,
    biz_type VARCHAR(64) NOT NULL,
    biz_id BIGINT,
    operator_id BIGINT,
    operation VARCHAR(128) NOT NULL,
    detail TEXT,
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE INDEX idx_operation_log_biz ON operation_log(biz_type, biz_id);

CREATE TABLE app_config (
    id BIGINT NOT NULL,
    config_key VARCHAR(128) NOT NULL,
    config_value TEXT,
    remark VARCHAR(256),
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE UNIQUE INDEX uk_app_config_key ON app_config(config_key);

