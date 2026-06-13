CREATE TABLE sys_user (
    id BIGINT NOT NULL,
    user_name VARCHAR(64) NOT NULL,
    display_name VARCHAR(128),
    email VARCHAR(128),
    status INT NOT NULL DEFAULT 1,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_sys_user_user_name (user_name)
);

CREATE TABLE biz_order (
    id BIGINT NOT NULL,
    order_no VARCHAR(64) NOT NULL,
    user_id BIGINT NOT NULL,
    amount DECIMAL(18, 2) NOT NULL,
    order_status INT NOT NULL DEFAULT 0,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_biz_order_order_no (order_no),
    KEY idx_biz_order_user_id (user_id)
);

CREATE TABLE operation_log (
    id BIGINT NOT NULL,
    biz_type VARCHAR(64) NOT NULL,
    biz_id BIGINT,
    operator_id BIGINT,
    operation VARCHAR(128) NOT NULL,
    detail TEXT,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_operation_log_biz (biz_type, biz_id)
);

CREATE TABLE app_config (
    id BIGINT NOT NULL,
    config_key VARCHAR(128) NOT NULL,
    config_value TEXT,
    remark VARCHAR(256),
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_app_config_key (config_key)
);

