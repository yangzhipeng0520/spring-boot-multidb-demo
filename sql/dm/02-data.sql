INSERT INTO sys_user (id, user_name, display_name, email, status, create_time)
VALUES (10001, 'admin', 'System Admin', 'admin@example.com', 1, CURRENT_TIMESTAMP);

INSERT INTO sys_user (id, user_name, display_name, email, status, create_time)
VALUES (10002, 'demo_user', 'Demo User', 'demo@example.com', 1, CURRENT_TIMESTAMP);

INSERT INTO biz_order (id, order_no, user_id, amount, order_status, create_time)
VALUES (20001, 'ORD202606130001', 10001, 199.00, 1, CURRENT_TIMESTAMP);

INSERT INTO biz_order (id, order_no, user_id, amount, order_status, create_time)
VALUES (20002, 'ORD202606130002', 10002, 49.90, 0, CURRENT_TIMESTAMP);

INSERT INTO operation_log (id, biz_type, biz_id, operator_id, operation, detail, create_time)
VALUES (30001, 'ORDER', 20001, 10001, 'CREATE_ORDER', '{"source":"dm-demo"}', CURRENT_TIMESTAMP);

INSERT INTO app_config (id, config_key, config_value, remark, create_time)
VALUES (40001, 'feature.multidb.enabled', '{"enabled":true}', 'multi database switch', CURRENT_TIMESTAMP);

