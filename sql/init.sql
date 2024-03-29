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


CREATE TABLE public.commercial_payment
(
    commercial_payment_id int8    NOT NULL,
    amount                int8    NULL,
    code                  varchar NULL,
    sort_order            int4    NOT NULL,
    trend                 int4    NULL,
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
    (id, code, amount, sort_order, trend)
values (1, 'Lockbox 1', 203280, 0, 1),
       (2, 'Lockbox 2', 435600, 1, 1),
       (3, 'Lockbox 3', 609840, 2, 1),
       (4, 'Electronic payments Bank 1', 726000, 3, 1),
       (5, 'Electronic payments Bank 2', 842160, 4, 2),
       (6, 'Credit cards', 58080, 5, 0);


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

