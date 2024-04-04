CREATE EXTENSION pg_trgm;

CREATE TABLE public.alert
(
    alert_id    int8    NOT NULL,
    description varchar NULL,
    "name"      varchar NULL,
    CONSTRAINT alerts_pk PRIMARY KEY (alert_id)
);

CREATE TABLE public.alert_vis
(
    alert_vis_id int8    NOT NULL,
    description  varchar NULL,
    "name"       varchar NULL,
    CONSTRAINT alert_vis_pk PRIMARY KEY (alert_vis_id)
);

CREATE TABLE public.applied_cash
(
    applied_cash_id           int8    NOT NULL,
    "name"                    varchar NULL,
    actual_daily_collections  int8    NULL,
    goal_for_today_collection int8    NULL,
    CONSTRAINT applied_cash_pk PRIMARY KEY (applied_cash_id)
);


CREATE TABLE public.cash_deposite_unapplied
(
    cash_deposite_unapplied_id int8    NOT NULL,
    "date"                     varchar NULL,
    percents                   float4  NULL,
    work_day                   int4    NULL,
    CONSTRAINT cash_deposite_unapplied_pk PRIMARY KEY (cash_deposite_unapplied_id)
);


CREATE TABLE public.commercial_payer
(
    commercial_payer_id int8    NOT NULL,
    "name"              varchar NULL,
    percentage          int4    NULL,
    sort_order          int4    NOT NULL,
    CONSTRAINT commercial_payers_pk PRIMARY KEY (commercial_payer_id)
);


CREATE TABLE public.commercial_payment (
    commercial_payment_id int8 NOT NULL,
    amount int8 NULL,
    payment varchar NULL,
    sort_order int4 NOT NULL,
    trend int4 NULL,
    goal float8 NULL,
    variance_goal float8 NULL,
    total_amount float8 NULL,
    total_goal float8 NULL,
    variance_amount float4 NULL,
    variance float4 NULL,
    CONSTRAINT commercial_payment_pk PRIMARY KEY (commercial_payment_id)
);


CREATE TABLE public.cost_to_collect_efficiency
(
    cost_to_collect_efficiency_id int8    NOT NULL,
    company                       varchar NULL,
    payment_type                  varchar NULL,
    amount                        int8    NULL,
    volume                        float4  NULL,
    sort_order                    int4    NOT NULL,
    sort_order_company            int4    NOT NULL,
    trend                         int4    NULL,
    CONSTRAINT cost_to_collect_efficiency_pk PRIMARY KEY (cost_to_collect_efficiency_id)
);


CREATE TABLE public.daily_collection
(
    daily_collection_id int8 NOT NULL,
    achieved            int8 NULL,
    goal                int8 NULL,
    CONSTRAINT newtable_pk PRIMARY KEY (daily_collection_id)
);


CREATE TABLE public.mtd_collection_goal
(
    mtd_collection_goal_id int8    NOT NULL,
    unit                   varchar NULL,
    actual                 int8    NULL,
    goal                   int8    NULL,
    total_goal             int8    NULL,
    sort_order             int4    NOT NULL,
    CONSTRAINT mtd_collection_goal_pk PRIMARY KEY (mtd_collection_goal_id)
);

CREATE TABLE public.ytd_collection_progress
(
    ytd_collection_progress_id int8    NOT NULL,
    "month"                    varchar NULL,
    actual                     int8    NULL,
    goal                       int8    NULL,
    month_number               int4    NULL
);

CREATE TABLE public.payments_by_transaction (
    payment_by_transaction_id int8 NOT NULL,
    payment varchar NOT NULL,
    value float4 NULL
);


--alert
INSERT INTO public.alert
    (id, description, "name")
values (1, 'Alert 1', 'Alert 1 - MTD collections BCBS at 62% '),
       (2, 'Alert 2', 'Alert 2 - DAdjust intra-month forecast');


--alert_vis
INSERT INTO public.alert_vis
    (id, description, "name")
values (1, 'Alert 1', 'Alert 1 - 20% increase in collections for Lockbox 3 signals abnormal behavior.'),
       (2, 'Alert 2', 'Alert 2 - significant increase in unapplied cash deposits.');


--applied_cash
INSERT INTO public.applied_cash
    (id, "name", actual_daily_collections, goal_for_today_collection)
values (1, 'Hospital 1', 1146000, 1110000),
       (2, 'Hospital 2', 780000, 858408.74),
       (3, 'Hospital 3', 894000, 888000);


--cash_deposite_unapplied
INSERT INTO public.cash_deposite_unapplied
    (id, "date", percents, work_day)
values (1, 'Monday, May 1, 2023', 2.5, 1),
       (2, 'Tuesday, May 2, 2023', 2, 2),
       (3, 'Wednesday, May 3, 2023', 3.1, 3),
       (4, 'Thursday, May 4, 2023', 2.8, 4),
       (5, 'Friday, May 5, 2023', 3, 5),
       (6, 'Monday, May 8, 2023', 3.2, 6),
       (7, 'Tuesday, May 9, 2023', 4.92, 7);


--commercial_payers
INSERT INTO public.commercial_payers
    (id, "name", percentage, sort_order)
values (1, 'BCBS', 38, 1),
       (2, 'UnitedHealth', 24, 2),
       (3, 'Aetna', 10, 3),
       (4, 'Cigna', 6, 4),
       (5, 'Humana', 7, 5),
       (6, 'Other', 15, 6);


--commercial_payment
INSERT INTO public.commercial_payment
(commercial_payment_id, amount, payment, sort_order, trend, goal, variance_goal, total_amount, total_goal, variance_amount, variance)
VALUES (1, 203280, 'Lockbox 1', 0, 1, 206393.94, 7.0, 2874960.0, 285640874, 7.0, -2.0),
       (2, 435600, 'Lockbox 2', 1, 1, 45227273, 16.0, 2874960.0, 285640874, 15.0, -4.0),
       (3, 609840, 'Lockbox 3', 2, 2, 510000.0, 18.0, 2874960.0, 285640874, 21.0, 20.0),
       (4, 726000, 'Electronic payments Bank 1', 3, 1, 75341684, 26.0, 2874960.0, 285640874, 25.0, -4.0),
       (5, 842160, 'Electronic payments Bank 2', 4, 1, 87135623, 31.0, 2874960.0, 285640874, 29.0, -3.0),
       (6, 58080, 'Credit cards', 5, 0, 62969.0, 2.0, 2874960.0, 285640874, 2.0, -8.0);



--cost_to_collect_efficiency
INSERT INTO public.cost_to_collect_efficiency
(cost_to_collect_efficiency_id, company, payment_type, amount, volume, sort_order, sort_order_company, trend)
VALUES (1, 'BCBS', 'Lockbox 1', 1550400, 3.0, 1, 1, 1),
       (2, 'UnitedHealth', 'Lockbox 1', 1224000, 3.7, 1, 2, 1),
       (3, 'Aetna', 'Lockbox 1', 1530000, 4.0, 1, 3, 1),
       (4, 'Cigna', 'Lockbox 1', 367200, 4.3, 1, 4, 1),
       (5, 'Humana', 'Lockbox 1', 1285200, 5.2, 1, 5, 1),
       (6, 'Other', 'Lockbox 1', 2983500, 5.5, 1, 6, 1),
       (7, 'BCBS', 'Lockbox 2', 1356600, 3.0, 2, 1, 1),
       (8, 'UnitedHealth', 'Lockbox 2', 856800, 3.7, 2, 2, 1),
       (9, 'Aetna', 'Lockbox 2', 510000, 4.0, 2, 3, 1),
       (10, 'Cigna', 'Lockbox 2', 275400, 4.3, 2, 4, 1),
       (11, 'Humana', 'Lockbox 2', 1178100, 5.2, 2, 5, 1),
       (12, 'Other', 'Lockbox 2', 1530000, 5.5, 2, 6, 1),
       (13, 'BCBS', 'Lockbox 3', 969000, 3.0, 3, 1, 2),
       (14, 'UnitedHealth', 'Lockbox 3', 1101600, 3.7, 3, 2, 2),
       (15, 'Aetna', 'Lockbox 3', 255000, 4.0, 3, 3, 2),
       (16, 'Cigna', 'Lockbox 3', 61200, 4.3, 3, 4, 2),
       (17, 'Humana', 'Lockbox 3', 714000, 5.2, 3, 5, 2),
       (18, 'Other', 'Lockbox 3', 459000, 5.5, 3, 6, 2),
       (19, 'BCBS', 'Electronic payments Bank 1', 11628000, 3.0, 4, 1, 1),
       (20, 'UnitedHealth', 'Electronic payments Bank 1', 5508000, 3.7, 4, 2, 1),
       (21, 'Aetna', 'Electronic payments Bank 1', 1275000, 4.0, 4, 3, 1),
       (22, 'Cigna', 'Electronic payments Bank 1', 979200, 4.3, 4, 4, 1),
       (23, 'Humana', 'Electronic payments Bank 1', 214200, 5.2, 4, 5, 1),
       (24, 'Other', 'Electronic payments Bank 1', 2065500, 5.5, 4, 6, 1),
       (25, 'BCBS', 'Electronic payments Bank 2', 3876000, 3.0, 5, 1, 1),
       (26, 'UnitedHealth', 'Electronic payments Bank 2', 3549600, 3.7, 5, 2, 1),
       (27, 'Aetna', 'Electronic payments Bank 2', 1530000, 4.0, 5, 3, 1),
       (28, 'Cigna', 'Electronic payments Bank 2', 1377000, 4.3, 5, 4, 1),
       (29, 'Humana', 'Electronic payments Bank 2', 178500, 5.2, 5, 5, 1),
       (30, 'Other', 'Electronic payments Bank 2', 382500, 5.5, 5, 6, 1),
       (31, 'Other', 'Credit cards', 153000, 5.5, 6, 6, 0);


--daily_collection
INSERT INTO public.daily_collection
    (id, achieved, goal)
VALUES (1, 2856409, 2874960);


--mtd_collection_goal
INSERT INTO public.mtd_collection_goal
    (id, unit, actual, goal, total_goal, sort_order)
values (1, 'BCBS', 12000000, 19487117, 22800000, 1),
       (2, 'UnitedHealth', 15000000, 12019021, 14400000, 2),
       (3, 'Aetna', 5100000, 5192926, 6000000, 3),
       (4, 'Cigna', 3060000, 3319755, 3600000, 4),
       (5, 'Humana', 3570000, 3545048, 4200000, 5),
       (6, 'Other', 7650000, 7201388, 9000000, 6);


--ytd_collection_progress
INSERT INTO public.ytd_collection_progress
    (id, "month", actual, goal, month_number)
VALUES (1, 'Jan', 1000000, 1000000, 1),
       (2, 'Feb', 800000, 850000, 2),
       (3, 'Mar', 950000, 900000, 3),
       (4, 'Apr', 900000, 950000, 4),
       (5, 'May', 880000, 1000000, 5),
       (6, 'Jun', 980000, 1050000, 6),
       (7, 'Jul', 1020000, 1100000, 7),
       (8, 'Aug', 930000, 900000, 8),
       (9, 'Sep', 970000, 950000, 9),
       (10, 'Oct', 999000, 1000000, 10),
       (11, 'Nov', 1010000, 1050000, 11);

INSERT INTO public.payments_by_transaction (payment_by_transaction_id, payment, value)
VALUES
    (1, 'Lockbox 3', 724.50),
    (2, 'Lockbox 3', 1349.60),
    (3, 'Lockbox 3', 1593.70),
    (4, 'Lockbox 3', 1654.80),
    (5, 'Lockbox 3', 812.90),
    (6, 'Lockbox 3', 1987.00),
    (7, 'Lockbox 3', 1203.10),
    (8, 'Lockbox 3', 1754.20),
    (9, 'Lockbox 3', 2398.30),
    (10, 'Lockbox 3', 1655.40),
    (11, 'Lockbox 3', 1186.50),
    (12, 'Lockbox 3', 927.60),
    (13, 'Lockbox 3', 1481.70),
    (14, 'Lockbox 3', 1968.80),
    (15, 'Lockbox 3', 1034.90),
    (16, 'Lockbox 3', 1720.00),
    (17, 'Lockbox 3', 1425.10),
    (18, 'Lockbox 3', 1859.20),
    (19, 'Lockbox 3', 2159.30),
    (20, 'Lockbox 3', 1942.40),
    (21, 'Lockbox 3', 1700.50),
    (22, 'Lockbox 3', 1912.60),
    (23, 'Lockbox 3', 2375.70),
    (24, 'Lockbox 3', 1218.80),
    (25, 'Lockbox 3', 1377.90),
    (26, 'Lockbox 3', 1639.00),
    (27, 'Lockbox 3', 1085.10),
    (28, 'Lockbox 3', 1273.20),
    (29, 'Lockbox 3', 1595.30),
    (30, 'Lockbox 3', 1847.40),
    (31, 'Lockbox 3', 2036.50),
    (32, 'Lockbox 3', 2268.60),
    (33, 'Lockbox 3', 1990.70),
    (34, 'Lockbox 3', 1445.80),
    (35, 'Lockbox 3', 1717.90),
    (36, 'Lockbox 3', 2142.00),
    (37, 'Lockbox 3', 2311.10),
    (38, 'Lockbox 3', 1798.20),
    (39, 'Lockbox 3', 1225.30),
    (40, 'Lockbox 3', 2360.40),
    (41, 'Lockbox 3', 1832.50),
    (42, 'Lockbox 3', 1971.60),
    (43, 'Lockbox 3', 2058.70),
    (44, 'Lockbox 3', 1529.80),
    (45, 'Lockbox 3', 1486.90),
    (46, 'Lockbox 3', 2288.00),
    (47, 'Lockbox 3', 1735.10),
    (48, 'Lockbox 3', 2159.20),
    (49, 'Lockbox 3', 1784.30),
    (50, 'Lockbox 3', 1943.40),
    (51, 'Lockbox 3', 1612.50),
    (52, 'Lockbox 3', 1359.60),
    (53, 'Lockbox 3', 2024.70),
    (54, 'Lockbox 3', 1172.80),
    (55, 'Lockbox 3', 2253.90),
    (56, 'Lockbox 3', 1335.00),
    (57, 'Lockbox 3', 2067.10),
    (58, 'Lockbox 3', 1901.20),
    (59, 'Lockbox 3', 1783.30),
    (60, 'Lockbox 3', 1459.40),
    (61, 'Lockbox 3', 2221.50),
    (62, 'Lockbox 3', 1247.60),
    (63, 'Lockbox 3', 2389.70),
    (64, 'Lockbox 3', 1532.80),
    (65, 'Lockbox 3', 1165.90),
    (66, 'Lockbox 3', 1298.00),
    (67, 'Lockbox 3', 1624.10),
    (68, 'Lockbox 3', 1414.20),
    (69, 'Lockbox 3', 2071.30),
    (70, 'Lockbox 3', 2196.40),
    (71, 'Lockbox 3', 1985.50),
    (72, 'Lockbox 3', 2076.60),
    (73, 'Lockbox 3', 1673.70),
    (74, 'Lockbox 3', 1384.80),
    (75, 'Lockbox 3', 1713.90),
    (76, 'Lockbox 3', 1595.00),
    (77, 'Lockbox 3', 1827.10),
    (78, 'Lockbox 3', 2009.20),
    (79, 'Lockbox 3', 1781.30),
    (80, 'Lockbox 3', 1953.40),
    (81, 'Lockbox 3', 1299.50),
    (82, 'Lockbox 3', 2350.60),
    (83, 'Lockbox 3', 1908.70),
    (84, 'Lockbox 3', 2212.80),
    (85, 'Lockbox 3', 1564.90),
    (86, 'Lockbox 3', 2126.00),
    (87, 'Lockbox 3', 1260.10),
    (88, 'Lockbox 3', 1692.20),
    (89, 'Lockbox 3', 1672.20),
    (90, 'Lockbox 3', 2090.30),
    (91, 'Lockbox 3', 5904.40),
    (92, 'Lockbox 3', 5823.30),
    (93, 'Lockbox 3', 5649.20),
    (94, 'Lockbox 3', 5583.10),
    (95, 'Lockbox 3', 5501.00),
    (96, 'Lockbox 3', 5620.90),
    (97, 'Lockbox 3', 5711.80),
    (98, 'Lockbox 3', 5455.70),
    (99, 'Lockbox 3', 5517.60),
    (100, 'Lockbox 3', 5396.50),
    (101, 'Lockbox 3', 5486.40),
    (102, 'Lockbox 3', 5384.30),
    (103, 'Lockbox 3', 5552.20),
    (104, 'Lockbox 3', 5418.10),
    (105, 'Lockbox 3', 5295.00),
    (106, 'Lockbox 3', 5374.90),
    (107, 'Lockbox 3', 5314.80),
    (108, 'Lockbox 3', 5279.70),
    (109, 'Lockbox 3', 5338.60),
    (110, 'Lockbox 3', 5250.50),
    (111, 'Lockbox 3', 5185.40),
    (112, 'Lockbox 3', 5145.30),
    (113, 'Lockbox 3', 5125.20),
    (114, 'Lockbox 3', 5057.10),
    (115, 'Lockbox 3', 5016.00),
    (116, 'Lockbox 3', 4930.90),
    (117, 'Lockbox 3', 4882.80),
    (118, 'Lockbox 3', 4919.70),
    (119, 'Lockbox 3', 4865.60),
    (120, 'Lockbox 3', 4978.50),
    (121, 'Lockbox 3', 4846.40),
    (122, 'Lockbox 3', 4799.30),
    (123, 'Lockbox 3', 4718.20),
    (124, 'Lockbox 3', 4791.10),
    (125, 'Lockbox 3', 4754.00),
    (126, 'Lockbox 3', 4673.90),
    (127, 'Lockbox 3', 4637.80),
    (128, 'Lockbox 3', 4577.70),
    (129, 'Lockbox 3', 4538.60),
    (130, 'Lockbox 3', 4461.50),
    (131, 'Lockbox 3', 4421.40),
    (132, 'Lockbox 3', 4343.30),
    (133, 'Lockbox 3', 4387.20),
    (134, 'Lockbox 3', 4303.10),
    (135, 'Lockbox 3', 4262.00),
    (136, 'Lockbox 3', 4221.90),
    (137, 'Lockbox 3', 4147.80),
    (138, 'Lockbox 3', 4107.70),
    (139, 'Lockbox 3', 4030.60),
    (140, 'Lockbox 3', 3990.50),
    (141, 'Lockbox 3', 3916.40),
    (142, 'Lockbox 3', 3960.30),
    (143, 'Lockbox 3', 3879.20),
    (144, 'Lockbox 3', 3816.10),
    (145, 'Lockbox 3', 3771.00),
    (146, 'Lockbox 3', 3725.90),
    (147, 'Lockbox 3', 3678.80),
    (148, 'Lockbox 3', 3594.70),
    (149, 'Lockbox 3', 3643.60),
    (150, 'Lockbox 3', 3563.50),
    (151, 'Lockbox 3', 3521.40),
    (152, 'Lockbox 3', 3442.30),
    (153, 'Lockbox 3', 3479.20),
    (154, 'Lockbox 3', 3402.10),
    (155, 'Lockbox 3', 3359.00),
    (156, 'Lockbox 3', 3285.90),
    (157, 'Lockbox 3', 3318.80),
    (158, 'Lockbox 3', 3241.70),
    (159, 'Lockbox 3', 3201.60),
    (160, 'Lockbox 3', 3160.50),
    (161, 'Lockbox 3', 3116.40),
    (162, 'Lockbox 3', 3038.30),
    (163, 'Lockbox 3', 3083.20),
    (164, 'Lockbox 3', 3004.10),
    (165, 'Lockbox 3', 2962.00),
    (166, 'Lockbox 3', 2882.90),
    (167, 'Lockbox 3', 2925.80),
    (168, 'Lockbox 3', 2848.70),
    (169, 'Lockbox 3', 2806.60),
    (170, 'Lockbox 3', 2730.50),
    (171, 'Lockbox 3', 2773.40),
    (172, 'Lockbox 3', 2693.30),
    (173, 'Lockbox 3', 3663.00),
    (174, 'Lockbox 3', 33056.00),
    (175, 'Lockbox 3', 63056.00);
