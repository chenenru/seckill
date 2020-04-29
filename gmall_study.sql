/*
 Navicat Premium Data Transfer

 Source Server         : mysql_local
 Source Server Type    : MySQL
 Source Server Version : 80019
 Source Host           : localhost:3306
 Source Schema         : gmall_study

 Target Server Type    : MySQL
 Target Server Version : 80019
 File Encoding         : 65001

 Date: 14/04/2020 00:40:24
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for item_kill
-- ----------------------------
DROP TABLE IF EXISTS `item_kill`;
CREATE TABLE `item_kill`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `item_id` bigint(0) NULL DEFAULT NULL COMMENT '商品id',
  `total` int(0) NULL DEFAULT NULL COMMENT '可被秒杀的总数',
  `start_time` timestamp(0) NULL DEFAULT NULL COMMENT '秒杀开始时间',
  `end_time` timestamp(0) NULL DEFAULT NULL COMMENT '秒杀结束时间',
  `is_active` tinyint(0) NULL DEFAULT 1 COMMENT '是否有效（1=是；0=否）',
  `create_time` timestamp(0) NULL DEFAULT NULL COMMENT '创建的时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '待秒杀商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of item_kill
-- ----------------------------
INSERT INTO `item_kill` VALUES (4, 122, 10, '2020-03-13 16:24:56', '2020-05-01 16:25:00', 1, '2020-03-13 16:25:11');
INSERT INTO `item_kill` VALUES (5, 130, 10, '2020-03-13 16:25:34', '2020-05-01 16:25:37', 1, '2020-03-13 16:25:42');
INSERT INTO `item_kill` VALUES (6, 135, 10, '2020-03-13 16:26:01', '2020-04-01 16:26:04', 1, '2020-03-13 16:26:08');
INSERT INTO `item_kill` VALUES (8, 122, 100, '2020-04-09 10:56:45', '2020-04-11 10:56:45', 1, '2020-04-09 10:56:45');
INSERT INTO `item_kill` VALUES (9, 123, 0, '2020-04-09 11:57:11', '2020-04-09 11:57:11', 1, '2020-04-09 11:57:11');

-- ----------------------------
-- Table structure for item_kill_success
-- ----------------------------
DROP TABLE IF EXISTS `item_kill_success`;
CREATE TABLE `item_kill_success`  (
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '秒杀成功生成的订单编号',
  `item_id` int(0) NULL DEFAULT NULL COMMENT '商品id',
  `kill_id` bigint(0) NULL DEFAULT NULL COMMENT '秒杀id',
  `user_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户id',
  `status` tinyint(0) NULL DEFAULT -1 COMMENT '秒杀结果: -1无效  0成功(未付款)  1已付款  2已取消',
  `create_time` timestamp(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '秒杀成功订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of item_kill_success
-- ----------------------------
INSERT INTO `item_kill_success` VALUES ('436551301086851072', 130, 5, '42', 2, '2020-03-15 13:00:07');
INSERT INTO `item_kill_success` VALUES ('436551636471787520', 135, 6, '42', -1, '2020-03-15 13:01:27');
INSERT INTO `item_kill_success` VALUES ('436552739418550272', 122, 4, '42', -1, '2020-03-15 13:05:49');
INSERT INTO `item_kill_success` VALUES ('438121741899018240', 130, 5, '42', -1, '2020-03-19 21:00:29');
INSERT INTO `item_kill_success` VALUES ('438145940583624704', 122, 4, '10010', -1, '2020-03-19 22:36:38');
INSERT INTO `item_kill_success` VALUES ('438145942043242496', 122, 4, '10011', -1, '2020-03-19 22:36:39');
INSERT INTO `item_kill_success` VALUES ('438145944584990720', 122, 4, '10012', -1, '2020-03-19 22:36:39');
INSERT INTO `item_kill_success` VALUES ('438145945834893312', 122, 4, '10013', -1, '2020-03-19 22:36:39');
INSERT INTO `item_kill_success` VALUES ('438145947038658560', 122, 4, '10014', -1, '2020-03-19 22:36:40');
INSERT INTO `item_kill_success` VALUES ('444661122235379712', 130, 5, '42', -1, '2020-04-06 22:05:39');
INSERT INTO `item_kill_success` VALUES ('444680229051707392', 130, 5, '42', -1, '2020-04-06 23:21:34');

-- ----------------------------
-- Table structure for oms_cart_item
-- ----------------------------
DROP TABLE IF EXISTS `oms_cart_item`;
CREATE TABLE `oms_cart_item`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(0) NULL DEFAULT NULL,
  `product_sku_id` bigint(0) NULL DEFAULT NULL,
  `member_id` bigint(0) NULL DEFAULT NULL,
  `quantity` int(0) NULL DEFAULT NULL COMMENT '购买数量',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '添加到购物车的价格',
  `sp1` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售属性1',
  `sp2` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售属性2',
  `sp3` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售属性3',
  `product_pic` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品主图',
  `product_name` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `product_sub_title` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品副标题（卖点）',
  `product_sku_code` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品sku条码',
  `member_nickname` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '会员昵称',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `modify_date` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `delete_status` int(0) NULL DEFAULT 0 COMMENT '是否删除',
  `product_category_id` bigint(0) NULL DEFAULT NULL COMMENT '商品分类',
  `product_brand` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `product_sn` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `product_attr` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品销售属性:[{\"key\":\"颜色\",\"value\":\"颜色\"},{\"key\":\"容量\",\"value\":\"4G\"}]',
  `is_checked` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '购物车表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oms_cart_item
-- ----------------------------
INSERT INTO `oms_cart_item` VALUES (28, 75, 127, 42, 2, 1299.00, NULL, NULL, NULL, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAJ5rTAAD1GuhjFLk280.jpg', '男子篮球鞋 Air Jordan XXXIII PF ', NULL, 'b7ad57e6-34ba-426f-adee-cf3643a7c287', 'test小明', '2020-03-19 20:34:10', '2020-03-19 20:34:10', 0, 1261, '', NULL, '', '0');
INSERT INTO `oms_cart_item` VALUES (29, 77, 136, 42, 2, 1099.00, NULL, NULL, NULL, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAGpIxAAEXLFNyeE8886.jpg', '男子篮球鞋 Jordan Why Not Zer0.3 PF ', NULL, '5d67d317-e04a-4f9a-8cda-bf5958d01d18', 'test小明', '2020-03-20 22:49:44', '2020-03-20 22:49:44', 0, 1261, '', NULL, '', '1');

-- ----------------------------
-- Table structure for oms_company_address
-- ----------------------------
DROP TABLE IF EXISTS `oms_company_address`;
CREATE TABLE `oms_company_address`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `address_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '地址名称',
  `send_status` int(0) NULL DEFAULT NULL COMMENT '默认发货地址：0->否；1->是',
  `receive_status` int(0) NULL DEFAULT NULL COMMENT '是否默认收货地址：0->否；1->是',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收发货人姓名',
  `phone` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货人电话',
  `province` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '省/直辖市',
  `city` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '市',
  `region` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '区',
  `detail_address` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '公司收发货地址表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for oms_order
-- ----------------------------
DROP TABLE IF EXISTS `oms_order`;
CREATE TABLE `oms_order`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '订单id',
  `member_id` bigint(0) NOT NULL,
  `coupon_id` bigint(0) NULL DEFAULT NULL,
  `order_sn` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '提交时间',
  `member_username` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户帐号',
  `total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '订单总金额',
  `pay_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '应付金额（实际支付金额）',
  `freight_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '运费金额',
  `promotion_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '促销优化金额（促销价、满减、阶梯价）',
  `integration_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '积分抵扣金额',
  `coupon_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '优惠券抵扣金额',
  `discount_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '管理员后台调整订单使用的折扣金额',
  `pay_type` int(0) NULL DEFAULT NULL COMMENT '支付方式：0->未支付；1->支付宝；2->微信',
  `source_type` int(0) NULL DEFAULT NULL COMMENT '订单来源：0->PC订单；1->app订单',
  `status` int(0) NULL DEFAULT NULL COMMENT '订单状态：0->待付款；1->待发货；2->已发货；3->已完成；4->已关闭；5->无效订单',
  `order_type` int(0) NULL DEFAULT NULL COMMENT '订单类型：0->正常订单；1->秒杀订单',
  `delivery_company` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物流公司(配送方式)',
  `delivery_sn` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物流单号',
  `auto_confirm_day` int(0) NULL DEFAULT NULL COMMENT '自动确认时间（天）',
  `integration` int(0) NULL DEFAULT NULL COMMENT '可以获得的积分',
  `growth` int(0) NULL DEFAULT NULL COMMENT '可以活动的成长值',
  `promotion_info` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '活动信息',
  `bill_type` int(0) NULL DEFAULT NULL COMMENT '发票类型：0->不开发票；1->电子发票；2->纸质发票',
  `bill_header` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发票抬头',
  `bill_content` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发票内容',
  `bill_receiver_phone` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收票人电话',
  `bill_receiver_email` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收票人邮箱',
  `receiver_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '收货人姓名',
  `receiver_phone` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '收货人电话',
  `receiver_post_code` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货人邮编',
  `receiver_province` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '省份/直辖市',
  `receiver_city` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '城市',
  `receiver_region` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '区',
  `receiver_detail_address` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `note` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单备注',
  `confirm_status` int(0) NULL DEFAULT NULL COMMENT '确认收货状态：0->未确认；1->已确认',
  `delete_status` int(0) NOT NULL DEFAULT 0 COMMENT '删除状态：0->未删除；1->已删除',
  `use_integration` int(0) NULL DEFAULT NULL COMMENT '下单时使用的积分',
  `payment_time` datetime(0) NULL DEFAULT NULL COMMENT '支付时间',
  `delivery_time` datetime(0) NULL DEFAULT NULL COMMENT '发货时间',
  `receive_time` datetime(0) NULL DEFAULT NULL COMMENT '确认收货时间',
  `comment_time` datetime(0) NULL DEFAULT NULL COMMENT '评价时间',
  `modify_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oms_order
-- ----------------------------
INSERT INTO `oms_order` VALUES (52, 42, NULL, 'gmall158424818417820200375125624', '2020-03-15 12:56:24', 'enru', 3897.00, 3897.00, NULL, NULL, NULL, NULL, NULL, 1, 0, 3, 0, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'chenenru', '13556510557', '524241', '广东', '湛江市', '雷州市', '东坎村234号', '快点发货', 1, 0, NULL, '2020-04-08 10:53:20', '2020-04-09 11:00:00', '2020-03-19 20:53:41', NULL, '2020-04-09 11:56:14');
INSERT INTO `oms_order` VALUES (53, 42, NULL, 'gmall158424834327520200375125903', '2020-03-15 12:59:03', 'enru', 1299.00, 1299.00, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'chenenru', '13556510557', '524241', '广东', '湛江市', '雷州市', '东坎村234号', '快点发货', NULL, 0, NULL, NULL, NULL, '2020-03-16 12:59:03', NULL, NULL);
INSERT INTO `oms_order` VALUES (54, 42, NULL, '436551301086851072', '2020-03-15 13:00:08', 'chenenru', 999.00, 999.00, NULL, NULL, NULL, NULL, NULL, 1, 0, 2, 1, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'chenenru', '13556510557', '524241', '广东', '湛江市', '雷州市', '东坎村234号', '快点发货', NULL, 0, NULL, NULL, '2020-03-15 13:30:00', '2020-03-16 13:00:08', NULL, NULL);
INSERT INTO `oms_order` VALUES (55, 42, NULL, '436551636471787520', '2020-03-15 13:01:27', 'chenenru', 1299.00, 1299.00, NULL, NULL, NULL, NULL, NULL, 0, 0, 5, 1, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'chenenru', '13556510557', '524241', '广东', '湛江市', '雷州市', '东坎村234号', '快点发货', NULL, 0, NULL, NULL, NULL, '2020-03-16 13:01:27', NULL, NULL);
INSERT INTO `oms_order` VALUES (56, 42, NULL, '436552739418550272', '2020-03-15 13:05:50', 'chenenru', 899.00, 899.00, NULL, NULL, NULL, NULL, NULL, 1, 0, 2, 1, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'chenenru', '13556510557', '524241', '广东', '湛江市', '雷州市', '东坎村234号', '快点发货', NULL, 0, NULL, NULL, '2020-03-15 13:30:00', '2020-03-16 13:05:50', NULL, NULL);
INSERT INTO `oms_order` VALUES (57, 42, NULL, 'gmall158424887856320200375130758', '2020-03-15 13:07:59', 'enru', 999.00, 999.00, NULL, NULL, NULL, NULL, NULL, 1, 0, 2, 0, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'chenenru', '13556510557', '524141', '广东', '肇庆', '端州', '肇庆学院主校区', '快点发货', NULL, 0, NULL, NULL, '2020-03-15 13:30:01', '2020-03-16 13:07:59', NULL, NULL);
INSERT INTO `oms_order` VALUES (58, 42, NULL, 'gmall158462160918120200379204009', '2020-03-19 20:40:09', 'enru', 2598.00, 2598.00, NULL, NULL, NULL, NULL, NULL, 1, 0, 2, 0, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'chenenru', '13556510557', '524141', '广东', '肇庆', '端州', '肇庆学院主校区', '快点发货', NULL, 0, NULL, NULL, '2020-03-26 11:30:00', '2020-03-20 20:40:09', NULL, NULL);
INSERT INTO `oms_order` VALUES (59, 42, NULL, '438121741899018240', '2020-03-19 21:00:30', 'chenenru', 999.00, 999.00, NULL, NULL, NULL, NULL, NULL, 0, 0, 5, 1, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'chenenru', '13556510557', '524241', '广东', '湛江市', '雷州市', '东坎村234号', '快点发货', NULL, 0, NULL, NULL, NULL, '2020-03-20 21:00:30', NULL, NULL);
INSERT INTO `oms_order` VALUES (60, 42, NULL, 'gmall158471657351220200380230253', '2020-03-20 23:02:54', 'enru', 2198.00, 2198.00, NULL, NULL, NULL, NULL, NULL, 0, 0, 5, 0, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'chenenru', '13556510557', '524241', '广东', '湛江市', '雷州市', '东坎村234号', '快点发货', NULL, 0, NULL, NULL, NULL, '2020-03-21 23:03:10', NULL, NULL);
INSERT INTO `oms_order` VALUES (61, 42, NULL, 'gmall158471851876020200380233518', '2020-03-20 23:35:19', 'enru', 899.00, 899.00, NULL, NULL, NULL, NULL, NULL, 0, 0, 5, 0, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'chenenru', '13556510557', '524241', '广东', '湛江市', '雷州市', '东坎村234号', '快点发货', NULL, 0, NULL, NULL, NULL, '2020-03-21 23:35:19', NULL, NULL);
INSERT INTO `oms_order` VALUES (62, 42, NULL, 'gmall158471957518620200380235255', '2020-03-20 23:52:55', 'enru', 899.00, 899.00, NULL, NULL, NULL, NULL, NULL, 0, 0, 5, 0, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'chenenru', '13556510557', '524241', '广东', '湛江市', '雷州市', '东坎村234号', '快点发货', NULL, 1, NULL, NULL, NULL, '2020-03-21 23:52:55', NULL, NULL);
INSERT INTO `oms_order` VALUES (63, 42, NULL, '444661122235379712', '2020-04-06 22:05:42', 'chenenru', 999.00, 999.00, NULL, NULL, NULL, NULL, NULL, 1, 0, 2, 1, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'chenenru', '13556510557', '524241', '广东', '湛江市', '雷州市', '东坎村234号', '快点发货', NULL, 0, NULL, '2020-04-08 11:05:54', '2020-04-09 11:00:01', '2020-04-07 22:05:42', NULL, NULL);
INSERT INTO `oms_order` VALUES (64, 42, NULL, '444680229051707392', '2020-04-06 23:21:35', 'chenenru', 999.00, 999.00, NULL, NULL, NULL, NULL, NULL, 0, 0, 5, 1, NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'chenenru', '13556510557', '524241', '广东', '湛江市', '雷州市', '东坎村234号', '快点发货', NULL, 1, NULL, NULL, NULL, '2020-04-07 23:21:35', NULL, NULL);

-- ----------------------------
-- Table structure for oms_order_item
-- ----------------------------
DROP TABLE IF EXISTS `oms_order_item`;
CREATE TABLE `oms_order_item`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(0) NULL DEFAULT NULL COMMENT '订单id',
  `order_sn` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号',
  `product_id` bigint(0) NULL DEFAULT NULL,
  `product_pic` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `product_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `product_brand` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `product_sn` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `product_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售价格',
  `product_quantity` int(0) NULL DEFAULT NULL COMMENT '购买数量',
  `product_sku_id` bigint(0) NULL DEFAULT NULL COMMENT '商品sku编号',
  `product_sku_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品sku条码',
  `product_category_id` bigint(0) NULL DEFAULT NULL COMMENT '商品分类id',
  `sp1` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品的销售属性',
  `sp2` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sp3` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `promotion_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品促销名称',
  `promotion_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '商品促销分解金额',
  `coupon_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '优惠券优惠分解金额',
  `integration_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '积分优惠分解金额',
  `real_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '该商品经过优惠后的分解金额',
  `gift_integration` int(0) NULL DEFAULT 0,
  `gift_growth` int(0) NULL DEFAULT 0,
  `product_attr` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品销售属性:[{\"key\":\"颜色\",\"value\":\"颜色\"},{\"key\":\"容量\",\"value\":\"4G\"}]',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 88 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '订单中所包含的商品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of oms_order_item
-- ----------------------------
INSERT INTO `oms_order_item` VALUES (75, 52, 'gmall158424818417820200375125624', 75, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAJ5rTAAD1GuhjFLk280.jpg', '男子篮球鞋 Air Jordan XXXIII PF ', NULL, '仓库对应的商品编号', 1299.00, 3, 127, '7fbdc0ce-84f5-490e-a633-77fd007058ed', 1261, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3897.00, 0, 0, NULL);
INSERT INTO `oms_order_item` VALUES (76, 53, 'gmall158424834327520200375125903', 75, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAY4mMAADyiN9DJGY593.jpg', '男子篮球鞋 Air Jordan XXXIII PF ', NULL, '仓库对应的商品编号', 1299.00, 1, 128, '294b60b2-e433-45f4-8bd5-4abc049df394', 1261, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1299.00, 0, 0, NULL);
INSERT INTO `oms_order_item` VALUES (77, 54, '436551301086851072', 76, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAEksgAADRZjbivvc089.jpg', '女子运动鞋 Air Jordan 1 Mid', NULL, '仓库对应的商品编号', 999.00, 1, 130, '14f088f4-640e-49ca-9870-f05cf0e444b1', 1261, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 999.00, 0, 0, NULL);
INSERT INTO `oms_order_item` VALUES (78, 55, '436551636471787520', 77, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAZ1G8AAEEQUa8Sck191.jpg', '男子篮球鞋 Jordan Why Not Zer0.3 PF ', NULL, '仓库对应的商品编号', 1299.00, 1, 135, '20acffe8-a2d7-48e0-88f6-67bb3bf2cb8e', 1261, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1299.00, 0, 0, NULL);
INSERT INTO `oms_order_item` VALUES (79, 56, '436552739418550272', 74, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAQOb6AAEUAHJ_kVA423.jpg', '男子篮球鞋 LeBron XVII PRM EP', NULL, '仓库对应的商品编号', 899.00, 1, 122, 'a59c504f-3de6-4c04-b69a-bdd171a145f0', 1261, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 899.00, 0, 0, NULL);
INSERT INTO `oms_order_item` VALUES (80, 57, 'gmall158424887856320200375130758', 76, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAEIYWAAC-FkT4ZyU808.jpg', '女子运动鞋 Air Jordan 1 Mid ', NULL, '仓库对应的商品编号', 999.00, 1, 133, '4ac5db6c-3c95-4bc6-8fd7-45fee485f9e8', 1261, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 999.00, 0, 0, NULL);
INSERT INTO `oms_order_item` VALUES (81, 58, 'gmall158462160918120200379204009', 75, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAJ5rTAAD1GuhjFLk280.jpg', '男子篮球鞋 Air Jordan XXXIII PF ', NULL, '仓库对应的商品编号', 1299.00, 2, 127, '29d338db-36cd-4702-94bb-f9ac48d4f3a1', 1261, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2598.00, 0, 0, NULL);
INSERT INTO `oms_order_item` VALUES (82, 59, '438121741899018240', 76, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAEksgAADRZjbivvc089.jpg', '女子运动鞋 Air Jordan 1 Mid', NULL, '仓库对应的商品编号', 999.00, 1, 130, '043ee2bc-5d36-4af0-9dea-090d74782a2a', 1261, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 999.00, 0, 0, NULL);
INSERT INTO `oms_order_item` VALUES (83, 60, 'gmall158471657351220200380230253', 77, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAGpIxAAEXLFNyeE8886.jpg', '男子篮球鞋 Jordan Why Not Zer0.3 PF ', NULL, '仓库对应的商品编号', 1099.00, 2, 136, 'b5e11a3c-3705-44c4-93f4-a480739359dd', 1261, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2198.00, 0, 0, NULL);
INSERT INTO `oms_order_item` VALUES (84, 61, 'gmall158471851876020200380233518', 77, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAGpIxAAEXLFNyeE8886.jpg', '男子篮球鞋 Jordan Why Not Zer0.3 PF ', NULL, '仓库对应的商品编号', 1099.00, 2, 136, 'a09611c3-2d4a-4bc2-b2a9-59673fa722c2', 1261, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2198.00, 0, 0, NULL);
INSERT INTO `oms_order_item` VALUES (85, 62, 'gmall158471957518620200380235255', 77, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAGpIxAAEXLFNyeE8886.jpg', '男子篮球鞋 Jordan Why Not Zer0.3 PF ', NULL, '仓库对应的商品编号', 1099.00, 2, 136, '932403b7-095f-4940-8d65-95d390d6fde6', 1261, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2198.00, 0, 0, NULL);
INSERT INTO `oms_order_item` VALUES (86, 63, '444661122235379712', 76, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAEksgAADRZjbivvc089.jpg', '女子运动鞋 Air Jordan 1 Mid', NULL, '仓库对应的商品编号', 999.00, 1, 130, '67b5e88a-3e46-4bf3-8441-770a8872437f', 1261, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 999.00, 0, 0, NULL);
INSERT INTO `oms_order_item` VALUES (87, 64, '444680229051707392', 76, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAEksgAADRZjbivvc089.jpg', '女子运动鞋 Air Jordan 1 Mid', NULL, '仓库对应的商品编号', 999.00, 1, 130, 'e93fb47a-5848-437b-8a89-a93f3297ee6f', 1261, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 999.00, 0, 0, NULL);

-- ----------------------------
-- Table structure for payment_info
-- ----------------------------
DROP TABLE IF EXISTS `payment_info`;
CREATE TABLE `payment_info`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `order_sn` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对外业务编号',
  `order_id` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单编号',
  `alipay_trade_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付宝交易编号',
  `total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '支付金额',
  `subject` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交易内容',
  `payment_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付状态',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `confirm_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `callback_content` varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '回调信息',
  `callback_time` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 306 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '支付信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of payment_info
-- ----------------------------
INSERT INTO `payment_info` VALUES (300, 'gmall158424818417820200375125624', '52', '2020031522001409181429095067', 3897.00, '秒杀牌子鞋商城商品一件', '已支付', '2020-03-15 12:56:48', NULL, 'charset=utf-8&out_trade_no=gmall158424818417820200375125624&method=alipay.trade.page.pay.return&total_amount=0.01&sign=WTpbY%2B7tQ0iMWvKTFQNyYlLMH73LPWzkfK8%2BODESyIQgorUKjSjP7sdZSOkFDrNdX%2BQvag2Ugg8H6UyYvr2BJixobhNycqdIULFmI00bIxBdDcD16v%2F%2F6Viv0yR%2FC3r1ZJdv6xnNgCpt37pD1hVLN9VcRzD%2BCMGkXHiaDaBEVrCPBjVgXTWD54xo0n1UB8Rwm1kQdV7J6Bknm%2FRQsPNh7ckbn1ioIZvbhi5y9e1VcTjq9UiCQcgw%2FA9aMcov4LcWkplzCJW5cmWdvEdExYPctRq7Fyf9zkFGOXSiSFhltiFt%2B%2BUB8wQKRDpuOVL%2FTdoMqZ45hPkf17nfr0iCVrWjKg%3D%3D&trade_no=2020031522001409181429095067&auth_app_id=2018020102122556&version=1.0&app_id=2018020102122556&sign_type=RSA2&seller_id=2088921750292524&timestamp=2020-03-15+12%3A57%3A12', '2020-03-15 12:57:18');
INSERT INTO `payment_info` VALUES (301, 'gmall158424834327520200375125903', '53', NULL, 1299.00, '秒杀牌子鞋商城商品一件', '未付款', '2020-03-15 12:59:08', NULL, NULL, NULL);
INSERT INTO `payment_info` VALUES (302, '436551301086851072', '54', '2020031522001409181429242233', 999.00, '秒杀牌子鞋商城商品一件', '已支付', '2020-03-15 13:00:33', NULL, 'charset=utf-8&out_trade_no=436551301086851072&method=alipay.trade.page.pay.return&total_amount=0.01&sign=EDWJExTAhJWehv2c7d8glThZw5NTgScr6q%2FJPC2noSU5q%2BCoGYVhK63cdMEO7uUf2o9iXrVShJAZRIGBqNLFhDAlAXQCfD6ulVSxSez8zhdiX8e7Sz0lOybFyfLrIMsxEnzZKKFfZuxMctaZT6VNsKgSik1bd7Bc97z5M7x%2FD6wFrcasmYY%2FpktW%2BqhiFNX3nMuPvyONAcG7j8csO5RStfcukL%2FiERmWnlfbJvOQ8TJeUZrVDGyMTXA180KvzrpNCGdkFkZLP%2BewWYZDHLxt%2Br%2FlWKKYXY9worajFCCr7NS%2Bnb0NlnYOyeOH6J5JsygbfxDO7ojP7YjR4MUu6YpBLA%3D%3D&trade_no=2020031522001409181429242233&auth_app_id=2018020102122556&version=1.0&app_id=2018020102122556&sign_type=RSA2&seller_id=2088921750292524&timestamp=2020-03-15+13%3A00%3A53', '2020-03-15 13:00:59');
INSERT INTO `payment_info` VALUES (303, '436552739418550272', '56', '2020031522001409181429088622', 899.00, '秒杀牌子鞋商城商品一件', '已支付', '2020-03-15 13:06:11', NULL, 'charset=utf-8&out_trade_no=436552739418550272&method=alipay.trade.page.pay.return&total_amount=0.01&sign=WvgloCDsNc%2B3IoFsbJZmHRkNXZ0%2FbJGzWYU7I%2F8uddbHZUNbTnaIlKrNuZoIgt%2FSzvPDpoX0t0JoeiKr79HfvsIpuVnrjcEQkic56TMw4e%2BoDEzEsE5P0yCkz2iIczBgVOcfbrFX34YOABIo7rQaVBjHVgToaIAQCNpQqGlwxrXPsRkZ%2FJRsid5SqlD0g5QhYxMmR2o0A4lJW7WREBKndV8cj%2F552AuhBJO9XornGtvNz%2FUuT%2FyYCsJ1XdBc%2F1mNK4jv0ZJo5IDOSGGHYcL8SvDrctZhhIZ2iqCabCxnq9GJUlmM11Cy9EU6yfWWIwRExf6POUxqnd4wdERZ2IlJyA%3D%3D&trade_no=2020031522001409181429088622&auth_app_id=2018020102122556&version=1.0&app_id=2018020102122556&sign_type=RSA2&seller_id=2088921750292524&timestamp=2020-03-15+13%3A06%3A31', '2020-03-15 13:06:36');
INSERT INTO `payment_info` VALUES (304, 'gmall158424887856320200375130758', '57', '2020031522001409181429218201', 999.00, '秒杀牌子鞋商城商品一件', '已支付', '2020-03-15 13:08:02', NULL, 'charset=utf-8&out_trade_no=gmall158424887856320200375130758&method=alipay.trade.page.pay.return&total_amount=0.01&sign=bNdxymYm4Y11VukuEZhsBCc2xNWHbI57UkrwX9QZofLZg6gIZQl6zaRNjItGV0M77BF6kiVs9uRkF4ebPz6hTE5wPlGHbWMAlL0%2BA63lLPjazF8x3PLbPXXPJf79Qhm%2FA5eOztkAzCpt0MiEs%2BgUZ0GqnE8knVLgNUcejBwbhe0GhlFbgJ0h8tFIXompdP5sIrZKMnYXR55wVQCCkPosmIqx4wZKWtcpvLtXhVGSficwCZQVSRcGLs5%2BWbvS%2FV36VRe6g4Jva4vCQb9imnPQ%2F6p%2Bw0dhCMTq8Axa4wnHPJvzOPXN%2Bwgm80WaOb%2F2ypsWp9xjorIoaGJ8DE6NBqdW4g%3D%3D&trade_no=2020031522001409181429218201&auth_app_id=2018020102122556&version=1.0&app_id=2018020102122556&sign_type=RSA2&seller_id=2088921750292524&timestamp=2020-03-15+13%3A08%3A23', '2020-03-15 13:08:28');
INSERT INTO `payment_info` VALUES (305, 'gmall158462160918120200379204009', '58', '2020031922001409181431223697', 2598.00, '秒杀牌子鞋商城商品一件', '已支付', '2020-03-19 20:40:55', NULL, 'charset=utf-8&out_trade_no=gmall158462160918120200379204009&method=alipay.trade.page.pay.return&total_amount=0.01&sign=frDXZqPIvwaUeh5pbtoBQHDmPc8vTLYQf%2FV2XytrYOGEzVvZye2wkrbz5r8Pia84n6%2FcoHTVLqfSAaeUOWRutvmDKbc5qGMN59tAcYZ%2FzU5O1kH%2Bizy5A6FXbeCCzgq%2FCtOubCLUBhtU55ZohOpyT8V%2FqOEpOgD%2B33jRJPDJLO1b0DC7NpsswiJc7xxdVEOoUJvOl2HH9UcLk9nQk7pOnw1ByD9GQ9FZzNzuk8LkE0AsgbUVleV7Y9azCIUrHo3riE9rXurVguO4ZiLawEhob7Rs8mgabqFJN05ibm%2BzOJNpV%2B9tkOsNF9LacovNnAweSc7dQqPohD3FJbPhcrvMxA%3D%3D&trade_no=2020031922001409181431223697&auth_app_id=2018020102122556&version=1.0&app_id=2018020102122556&sign_type=RSA2&seller_id=2088921750292524&timestamp=2020-03-19+20%3A43%3A18', '2020-03-19 20:43:23');

-- ----------------------------
-- Table structure for pms_base_attr_info
-- ----------------------------
DROP TABLE IF EXISTS `pms_base_attr_info`;
CREATE TABLE `pms_base_attr_info`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `attr_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '属性名称',
  `catalog3_id` bigint(0) NULL DEFAULT NULL,
  `is_enabled` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '启用：1 停用：0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 54 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '属性表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pms_base_attr_info
-- ----------------------------
INSERT INTO `pms_base_attr_info` VALUES (46, '鞋面材质', 1261, NULL);
INSERT INTO `pms_base_attr_info` VALUES (47, '内里材质', 1261, NULL);
INSERT INTO `pms_base_attr_info` VALUES (48, '鞋垫材质', 1261, NULL);
INSERT INTO `pms_base_attr_info` VALUES (49, '鞋底材质', 1261, NULL);
INSERT INTO `pms_base_attr_info` VALUES (50, '闭合方式', 1261, NULL);
INSERT INTO `pms_base_attr_info` VALUES (51, '鞋头形状', 1261, NULL);
INSERT INTO `pms_base_attr_info` VALUES (52, '元素', 1261, NULL);
INSERT INTO `pms_base_attr_info` VALUES (53, '鞋子款式', 1261, NULL);

-- ----------------------------
-- Table structure for pms_base_attr_value
-- ----------------------------
DROP TABLE IF EXISTS `pms_base_attr_value`;
CREATE TABLE `pms_base_attr_value`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `value_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '属性值名称',
  `attr_id` bigint(0) NULL DEFAULT NULL COMMENT '属性id',
  `is_enabled` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '启用：1 停用：0 1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 185 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '属性值表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pms_base_attr_value
-- ----------------------------
INSERT INTO `pms_base_attr_value` VALUES (125, '帆布', 46, NULL);
INSERT INTO `pms_base_attr_value` VALUES (126, '棉布', 46, NULL);
INSERT INTO `pms_base_attr_value` VALUES (127, '天鹅绒', 46, NULL);
INSERT INTO `pms_base_attr_value` VALUES (128, '法兰绒', 46, NULL);
INSERT INTO `pms_base_attr_value` VALUES (129, '弹力布', 46, NULL);
INSERT INTO `pms_base_attr_value` VALUES (130, '涤纶', 46, NULL);
INSERT INTO `pms_base_attr_value` VALUES (131, '合成纤维', 46, NULL);
INSERT INTO `pms_base_attr_value` VALUES (132, 'PVC', 46, NULL);
INSERT INTO `pms_base_attr_value` VALUES (133, 'PC', 46, NULL);
INSERT INTO `pms_base_attr_value` VALUES (134, '尼龙', 46, NULL);
INSERT INTO `pms_base_attr_value` VALUES (135, '无内里', 47, NULL);
INSERT INTO `pms_base_attr_value` VALUES (136, '布', 47, NULL);
INSERT INTO `pms_base_attr_value` VALUES (137, '天鹅绒', 47, NULL);
INSERT INTO `pms_base_attr_value` VALUES (138, '法兰绒', 47, NULL);
INSERT INTO `pms_base_attr_value` VALUES (139, '涤纶', 47, NULL);
INSERT INTO `pms_base_attr_value` VALUES (140, '尼龙', 47, NULL);
INSERT INTO `pms_base_attr_value` VALUES (141, '合成布', 47, NULL);
INSERT INTO `pms_base_attr_value` VALUES (142, 'PU', 47, NULL);
INSERT INTO `pms_base_attr_value` VALUES (143, 'PVC', 47, NULL);
INSERT INTO `pms_base_attr_value` VALUES (144, '丝绸', 47, NULL);
INSERT INTO `pms_base_attr_value` VALUES (145, '纯羊毛', 48, NULL);
INSERT INTO `pms_base_attr_value` VALUES (146, '布', 48, NULL);
INSERT INTO `pms_base_attr_value` VALUES (147, 'EVA', 48, NULL);
INSERT INTO `pms_base_attr_value` VALUES (148, 'PU', 48, NULL);
INSERT INTO `pms_base_attr_value` VALUES (149, 'PVC', 48, NULL);
INSERT INTO `pms_base_attr_value` VALUES (150, '软木', 49, NULL);
INSERT INTO `pms_base_attr_value` VALUES (151, 'EVA', 49, NULL);
INSERT INTO `pms_base_attr_value` VALUES (152, 'PVC', 49, NULL);
INSERT INTO `pms_base_attr_value` VALUES (153, 'TR', 49, NULL);
INSERT INTO `pms_base_attr_value` VALUES (154, 'TPR', 49, NULL);
INSERT INTO `pms_base_attr_value` VALUES (155, '皮底', 49, NULL);
INSERT INTO `pms_base_attr_value` VALUES (156, '塑料', 49, NULL);
INSERT INTO `pms_base_attr_value` VALUES (157, '橡胶', 49, NULL);
INSERT INTO `pms_base_attr_value` VALUES (158, '松紧带', 50, NULL);
INSERT INTO `pms_base_attr_value` VALUES (159, '魔术贴', 50, NULL);
INSERT INTO `pms_base_attr_value` VALUES (160, '系带', 50, NULL);
INSERT INTO `pms_base_attr_value` VALUES (161, '不系带套口', 50, NULL);
INSERT INTO `pms_base_attr_value` VALUES (162, '拉链', 50, NULL);
INSERT INTO `pms_base_attr_value` VALUES (163, '纽扣', 50, NULL);
INSERT INTO `pms_base_attr_value` VALUES (164, '搭扣', 50, NULL);
INSERT INTO `pms_base_attr_value` VALUES (165, '尖头', 51, NULL);
INSERT INTO `pms_base_attr_value` VALUES (166, '圆头', 51, NULL);
INSERT INTO `pms_base_attr_value` VALUES (167, '方头', 51, NULL);
INSERT INTO `pms_base_attr_value` VALUES (168, '鱼嘴', 51, NULL);
INSERT INTO `pms_base_attr_value` VALUES (169, '脚踝绑带', 52, NULL);
INSERT INTO `pms_base_attr_value` VALUES (170, '贴花', 52, NULL);
INSERT INTO `pms_base_attr_value` VALUES (171, '图腾', 52, NULL);
INSERT INTO `pms_base_attr_value` VALUES (172, '车缝线', 52, NULL);
INSERT INTO `pms_base_attr_value` VALUES (173, '丝带', 52, NULL);
INSERT INTO `pms_base_attr_value` VALUES (174, '防水台', 52, NULL);
INSERT INTO `pms_base_attr_value` VALUES (175, '饰物', 52, NULL);
INSERT INTO `pms_base_attr_value` VALUES (176, '金属装饰', 52, NULL);
INSERT INTO `pms_base_attr_value` VALUES (177, '镂空', 52, NULL);
INSERT INTO `pms_base_attr_value` VALUES (178, '交叉系带', 52, NULL);
INSERT INTO `pms_base_attr_value` VALUES (179, 'T型系带', 52, NULL);
INSERT INTO `pms_base_attr_value` VALUES (180, '交叉系带', 53, NULL);
INSERT INTO `pms_base_attr_value` VALUES (181, '脚踝包带', 53, NULL);
INSERT INTO `pms_base_attr_value` VALUES (182, '基本款', 53, NULL);
INSERT INTO `pms_base_attr_value` VALUES (183, 'T型带', 53, NULL);
INSERT INTO `pms_base_attr_value` VALUES (184, '松糕鞋底', 53, NULL);

-- ----------------------------
-- Table structure for pms_base_catalog1
-- ----------------------------
DROP TABLE IF EXISTS `pms_base_catalog1`;
CREATE TABLE `pms_base_catalog1`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分类名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '一级分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pms_base_catalog1
-- ----------------------------
INSERT INTO `pms_base_catalog1` VALUES (11, 'nike');
INSERT INTO `pms_base_catalog1` VALUES (12, 'adidas');
INSERT INTO `pms_base_catalog1` VALUES (13, 'new balance');
INSERT INTO `pms_base_catalog1` VALUES (14, '安踏');
INSERT INTO `pms_base_catalog1` VALUES (15, '李宁');
INSERT INTO `pms_base_catalog1` VALUES (16, '361');
INSERT INTO `pms_base_catalog1` VALUES (17, 'vans');
INSERT INTO `pms_base_catalog1` VALUES (18, 'under armour');
INSERT INTO `pms_base_catalog1` VALUES (19, 'puma');

-- ----------------------------
-- Table structure for pms_base_catalog2
-- ----------------------------
DROP TABLE IF EXISTS `pms_base_catalog2`;
CREATE TABLE `pms_base_catalog2`  (
  `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '二级分类名称',
  `catalog1_id` int(0) NULL DEFAULT NULL COMMENT '一级分类编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 181 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pms_base_catalog2
-- ----------------------------
INSERT INTO `pms_base_catalog2` VALUES (61, '鞋类', 11);
INSERT INTO `pms_base_catalog2` VALUES (62, '品牌', 11);
INSERT INTO `pms_base_catalog2` VALUES (63, '鞋类', 11);
INSERT INTO `pms_base_catalog2` VALUES (64, '经典', 11);
INSERT INTO `pms_base_catalog2` VALUES (65, 'Air Max', 11);
INSERT INTO `pms_base_catalog2` VALUES (66, '技术', 11);
INSERT INTO `pms_base_catalog2` VALUES (67, '运动员', 11);
INSERT INTO `pms_base_catalog2` VALUES (68, '鞋高', 11);
INSERT INTO `pms_base_catalog2` VALUES (69, '宽度', 11);
INSERT INTO `pms_base_catalog2` VALUES (70, '脚感', 11);
INSERT INTO `pms_base_catalog2` VALUES (71, '场地', 11);
INSERT INTO `pms_base_catalog2` VALUES (72, '室内', 11);
INSERT INTO `pms_base_catalog2` VALUES (73, '产品系列', 12);
INSERT INTO `pms_base_catalog2` VALUES (74, '产品分类', 12);
INSERT INTO `pms_base_catalog2` VALUES (75, '运动类型', 12);
INSERT INTO `pms_base_catalog2` VALUES (76, '适穿类型', 12);
INSERT INTO `pms_base_catalog2` VALUES (150, '鞋子', 13);
INSERT INTO `pms_base_catalog2` VALUES (151, '产品分类', 13);
INSERT INTO `pms_base_catalog2` VALUES (153, '品类', 14);
INSERT INTO `pms_base_catalog2` VALUES (155, '季节', 14);
INSERT INTO `pms_base_catalog2` VALUES (157, '系列', 14);
INSERT INTO `pms_base_catalog2` VALUES (158, '版型', 14);
INSERT INTO `pms_base_catalog2` VALUES (159, '男鞋', 15);
INSERT INTO `pms_base_catalog2` VALUES (160, '女鞋', 15);
INSERT INTO `pms_base_catalog2` VALUES (161, '男童鞋', 15);
INSERT INTO `pms_base_catalog2` VALUES (162, '女童鞋', 15);
INSERT INTO `pms_base_catalog2` VALUES (163, '篮球', 16);
INSERT INTO `pms_base_catalog2` VALUES (164, '跑步', 16);
INSERT INTO `pms_base_catalog2` VALUES (165, '生活', 16);
INSERT INTO `pms_base_catalog2` VALUES (166, '综训', 16);
INSERT INTO `pms_base_catalog2` VALUES (169, '鞋服配', 17);
INSERT INTO `pms_base_catalog2` VALUES (170, '穿法', 17);
INSERT INTO `pms_base_catalog2` VALUES (171, '鞋帮', 17);
INSERT INTO `pms_base_catalog2` VALUES (172, '鞋款', 17);
INSERT INTO `pms_base_catalog2` VALUES (173, '鞋类', 18);
INSERT INTO `pms_base_catalog2` VALUES (174, '新品推荐', 18);
INSERT INTO `pms_base_catalog2` VALUES (175, '适合运动', 18);
INSERT INTO `pms_base_catalog2` VALUES (178, '鞋类', 19);

-- ----------------------------
-- Table structure for pms_base_catalog3
-- ----------------------------
DROP TABLE IF EXISTS `pms_base_catalog3`;
CREATE TABLE `pms_base_catalog3`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '三级分类名称',
  `catalog2_id` bigint(0) NULL DEFAULT NULL COMMENT '二级分类编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1555 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pms_base_catalog3
-- ----------------------------
INSERT INTO `pms_base_catalog3` VALUES (1260, '休闲款', 61);
INSERT INTO `pms_base_catalog3` VALUES (1261, 'Jordan', 61);
INSERT INTO `pms_base_catalog3` VALUES (1262, '跑步', 61);
INSERT INTO `pms_base_catalog3` VALUES (1263, '篮球', 61);
INSERT INTO `pms_base_catalog3` VALUES (1264, '训练/健身', 61);
INSERT INTO `pms_base_catalog3` VALUES (1265, '足球', 61);
INSERT INTO `pms_base_catalog3` VALUES (1266, '滑板', 61);
INSERT INTO `pms_base_catalog3` VALUES (1267, '高尔夫', 61);
INSERT INTO `pms_base_catalog3` VALUES (1268, '网球', 61);
INSERT INTO `pms_base_catalog3` VALUES (1269, '步行', 61);
INSERT INTO `pms_base_catalog3` VALUES (1270, 'Nike', 62);
INSERT INTO `pms_base_catalog3` VALUES (1271, 'Nike Sportstwear', 62);
INSERT INTO `pms_base_catalog3` VALUES (1272, 'Jordan', 62);
INSERT INTO `pms_base_catalog3` VALUES (1273, 'NikeLab', 62);
INSERT INTO `pms_base_catalog3` VALUES (1274, 'Nike By You', 62);
INSERT INTO `pms_base_catalog3` VALUES (1275, 'ACG', 62);
INSERT INTO `pms_base_catalog3` VALUES (1276, '靴类', 63);
INSERT INTO `pms_base_catalog3` VALUES (1277, '钉鞋', 63);
INSERT INTO `pms_base_catalog3` VALUES (1278, '凉鞋/拖鞋', 63);
INSERT INTO `pms_base_catalog3` VALUES (1279, 'Air Force 1', 64);
INSERT INTO `pms_base_catalog3` VALUES (1280, 'Air Max', 64);
INSERT INTO `pms_base_catalog3` VALUES (1281, 'Blazer', 64);
INSERT INTO `pms_base_catalog3` VALUES (1282, 'Bruin', 64);
INSERT INTO `pms_base_catalog3` VALUES (1283, 'Cortez', 64);
INSERT INTO `pms_base_catalog3` VALUES (1284, 'Huarache', 64);
INSERT INTO `pms_base_catalog3` VALUES (1285, 'Hyperdunk', 64);
INSERT INTO `pms_base_catalog3` VALUES (1286, 'Internationalist', 64);
INSERT INTO `pms_base_catalog3` VALUES (1287, 'Mercurial 刺客系列', 64);
INSERT INTO `pms_base_catalog3` VALUES (1288, 'Metcon', 64);
INSERT INTO `pms_base_catalog3` VALUES (1289, 'Nike Dunk', 64);
INSERT INTO `pms_base_catalog3` VALUES (1290, 'Nike Epic React', 64);
INSERT INTO `pms_base_catalog3` VALUES (1291, 'Nike Free RN', 64);
INSERT INTO `pms_base_catalog3` VALUES (1292, 'Pegasus', 64);
INSERT INTO `pms_base_catalog3` VALUES (1293, 'Phantom', 64);
INSERT INTO `pms_base_catalog3` VALUES (1294, 'Presto', 64);
INSERT INTO `pms_base_catalog3` VALUES (1295, 'Roshe', 64);
INSERT INTO `pms_base_catalog3` VALUES (1296, 'Structure', 64);
INSERT INTO `pms_base_catalog3` VALUES (1297, 'Tiempo 传奇系列', 64);
INSERT INTO `pms_base_catalog3` VALUES (1299, 'Vomero', 64);
INSERT INTO `pms_base_catalog3` VALUES (1300, 'Air Max 1', 65);
INSERT INTO `pms_base_catalog3` VALUES (1301, 'Air Max 90', 65);
INSERT INTO `pms_base_catalog3` VALUES (1302, 'Air Max 95', 65);
INSERT INTO `pms_base_catalog3` VALUES (1303, 'Air Max 97', 65);
INSERT INTO `pms_base_catalog3` VALUES (1304, 'Air Max 98', 65);
INSERT INTO `pms_base_catalog3` VALUES (1305, 'Air Max 200', 65);
INSERT INTO `pms_base_catalog3` VALUES (1306, 'Air Max 270', 65);
INSERT INTO `pms_base_catalog3` VALUES (1307, 'Air Max 720', 65);
INSERT INTO `pms_base_catalog3` VALUES (1308, 'Air Max Dia', 65);
INSERT INTO `pms_base_catalog3` VALUES (1309, 'VaporMax', 65);
INSERT INTO `pms_base_catalog3` VALUES (1310, 'Nike Joyride', 66);
INSERT INTO `pms_base_catalog3` VALUES (1311, 'Nike Flyknit', 66);
INSERT INTO `pms_base_catalog3` VALUES (1312, 'Nike Flywire', 66);
INSERT INTO `pms_base_catalog3` VALUES (1313, 'Nike Lunarlon', 66);
INSERT INTO `pms_base_catalog3` VALUES (1314, 'Nike Max Air', 66);
INSERT INTO `pms_base_catalog3` VALUES (1315, 'Nike Air', 66);
INSERT INTO `pms_base_catalog3` VALUES (1316, 'Nike Free', 66);
INSERT INTO `pms_base_catalog3` VALUES (1317, 'Nike React', 66);
INSERT INTO `pms_base_catalog3` VALUES (1318, 'Nike Shield', 66);
INSERT INTO `pms_base_catalog3` VALUES (1319, 'Nike Zoom Air', 66);
INSERT INTO `pms_base_catalog3` VALUES (1320, 'Nike ZoomX', 66);
INSERT INTO `pms_base_catalog3` VALUES (1321, '勒布朗·詹姆斯', 67);
INSERT INTO `pms_base_catalog3` VALUES (1322, '凯里·欧文', 67);
INSERT INTO `pms_base_catalog3` VALUES (1323, '克里斯蒂亚诺·罗纳尔多', 67);
INSERT INTO `pms_base_catalog3` VALUES (1324, '斯蒂芬·基诺斯基', 67);
INSERT INTO `pms_base_catalog3` VALUES (1325, '克里斯·保罗', 67);
INSERT INTO `pms_base_catalog3` VALUES (1326, '低帮', 68);
INSERT INTO `pms_base_catalog3` VALUES (1327, '中帮', 68);
INSERT INTO `pms_base_catalog3` VALUES (1328, '高帮', 68);
INSERT INTO `pms_base_catalog3` VALUES (1329, '常规版', 69);
INSERT INTO `pms_base_catalog3` VALUES (1330, '宽版', 69);
INSERT INTO `pms_base_catalog3` VALUES (1331, '宛如赤足的感受', 70);
INSERT INTO `pms_base_catalog3` VALUES (1332, '柔缓感受', 70);
INSERT INTO `pms_base_catalog3` VALUES (1333, '稳定性能', 70);
INSERT INTO `pms_base_catalog3` VALUES (1334, '力量型', 70);
INSERT INTO `pms_base_catalog3` VALUES (1335, '支撑力', 70);
INSERT INTO `pms_base_catalog3` VALUES (1336, '人造草地', 71);
INSERT INTO `pms_base_catalog3` VALUES (1337, '天然硬质草地', 71);
INSERT INTO `pms_base_catalog3` VALUES (1338, '草地球场', 71);
INSERT INTO `pms_base_catalog3` VALUES (1339, '硬地球场', 71);
INSERT INTO `pms_base_catalog3` VALUES (1340, '室内球场', 72);
INSERT INTO `pms_base_catalog3` VALUES (1341, '多种场地', 72);
INSERT INTO `pms_base_catalog3` VALUES (1342, '室外球场', 72);
INSERT INTO `pms_base_catalog3` VALUES (1343, '公路', 72);
INSERT INTO `pms_base_catalog3` VALUES (1344, '天然松软草地', 72);
INSERT INTO `pms_base_catalog3` VALUES (1345, '小径', 72);
INSERT INTO `pms_base_catalog3` VALUES (1346, '人造场地', 72);
INSERT INTO `pms_base_catalog3` VALUES (1347, 'Superstar', 73);
INSERT INTO `pms_base_catalog3` VALUES (1348, 'Stan Smith', 73);
INSERT INTO `pms_base_catalog3` VALUES (1349, 'NMD', 73);
INSERT INTO `pms_base_catalog3` VALUES (1350, 'UltraBOOST', 73);
INSERT INTO `pms_base_catalog3` VALUES (1351, 'UltraBOOST 19', 73);
INSERT INTO `pms_base_catalog3` VALUES (1352, 'PureBOOST', 73);
INSERT INTO `pms_base_catalog3` VALUES (1353, 'AlphaBOUNC', 73);
INSERT INTO `pms_base_catalog3` VALUES (1354, 'adizero', 73);
INSERT INTO `pms_base_catalog3` VALUES (1355, 'Advantag', 73);
INSERT INTO `pms_base_catalog3` VALUES (1356, 'Continenta', 73);
INSERT INTO `pms_base_catalog3` VALUES (1357, 'COPA', 73);
INSERT INTO `pms_base_catalog3` VALUES (1358, 'Crazychaos', 73);
INSERT INTO `pms_base_catalog3` VALUES (1359, 'Damian Lillard', 73);
INSERT INTO `pms_base_catalog3` VALUES (1360, 'Derrick Rose', 73);
INSERT INTO `pms_base_catalog3` VALUES (1361, 'EQT', 73);
INSERT INTO `pms_base_catalog3` VALUES (1362, 'Falcon', 73);
INSERT INTO `pms_base_catalog3` VALUES (1363, 'Grand Court', 73);
INSERT INTO `pms_base_catalog3` VALUES (1364, 'Hoops', 73);
INSERT INTO `pms_base_catalog3` VALUES (1365, 'James Harden', 73);
INSERT INTO `pms_base_catalog3` VALUES (1366, 'NEMEZIZ', 73);
INSERT INTO `pms_base_catalog3` VALUES (1367, 'Nite Jogge', 73);
INSERT INTO `pms_base_catalog3` VALUES (1368, 'POD', 73);
INSERT INTO `pms_base_catalog3` VALUES (1369, 'PREDATOR', 73);
INSERT INTO `pms_base_catalog3` VALUES (1370, 'Prophere', 73);
INSERT INTO `pms_base_catalog3` VALUES (1371, 'Questar', 73);
INSERT INTO `pms_base_catalog3` VALUES (1372, 'TERREX', 73);
INSERT INTO `pms_base_catalog3` VALUES (1373, 'X', 73);
INSERT INTO `pms_base_catalog3` VALUES (1374, 'Yung', 73);
INSERT INTO `pms_base_catalog3` VALUES (1376, 'adilette', 73);
INSERT INTO `pms_base_catalog3` VALUES (1377, '鞋类', 74);
INSERT INTO `pms_base_catalog3` VALUES (1378, '品牌', 74);
INSERT INTO `pms_base_catalog3` VALUES (1379, '运动表现', 74);
INSERT INTO `pms_base_catalog3` VALUES (1380, 'ORIGINALS', 74);
INSERT INTO `pms_base_catalog3` VALUES (1381, 'adidas neo', 74);
INSERT INTO `pms_base_catalog3` VALUES (1382, 'adidas by Stella', 74);
INSERT INTO `pms_base_catalog3` VALUES (1383, 'McCartney', 74);
INSERT INTO `pms_base_catalog3` VALUES (1384, '跑步', 75);
INSERT INTO `pms_base_catalog3` VALUES (1385, '训练', 75);
INSERT INTO `pms_base_catalog3` VALUES (1386, '户外', 75);
INSERT INTO `pms_base_catalog3` VALUES (1387, '游泳', 75);
INSERT INTO `pms_base_catalog3` VALUES (1388, '网球', 75);
INSERT INTO `pms_base_catalog3` VALUES (1389, '羽毛球', 75);
INSERT INTO `pms_base_catalog3` VALUES (1390, '高尔夫', 75);
INSERT INTO `pms_base_catalog3` VALUES (1391, '长跑', 76);
INSERT INTO `pms_base_catalog3` VALUES (1392, '城市跑', 76);
INSERT INTO `pms_base_catalog3` VALUES (1393, '动能跑', 76);
INSERT INTO `pms_base_catalog3` VALUES (1394, '休闲', 150);
INSERT INTO `pms_base_catalog3` VALUES (1395, '英美产系列', 150);
INSERT INTO `pms_base_catalog3` VALUES (1396, '老爹鞋', 150);
INSERT INTO `pms_base_catalog3` VALUES (1397, '男款跑步鞋', 150);
INSERT INTO `pms_base_catalog3` VALUES (1398, '中性款', 150);
INSERT INTO `pms_base_catalog3` VALUES (1399, '凉鞋/拖鞋', 150);
INSERT INTO `pms_base_catalog3` VALUES (1400, '篮球鞋', 150);
INSERT INTO `pms_base_catalog3` VALUES (1401, '板鞋', 150);
INSERT INTO `pms_base_catalog3` VALUES (1402, '女款跑步鞋', 150);
INSERT INTO `pms_base_catalog3` VALUES (1403, '训练', 150);
INSERT INTO `pms_base_catalog3` VALUES (1404, '997S系列', 151);
INSERT INTO `pms_base_catalog3` VALUES (1405, '850系列', 151);
INSERT INTO `pms_base_catalog3` VALUES (1406, '580系列', 151);
INSERT INTO `pms_base_catalog3` VALUES (1407, '574系列', 151);
INSERT INTO `pms_base_catalog3` VALUES (1408, '997H系列', 151);
INSERT INTO `pms_base_catalog3` VALUES (1409, 'x-racer系列', 151);
INSERT INTO `pms_base_catalog3` VALUES (1410, 'CRT300系列', 151);
INSERT INTO `pms_base_catalog3` VALUES (1411, '996系列', 151);
INSERT INTO `pms_base_catalog3` VALUES (1412, '其他系列休闲鞋', 151);
INSERT INTO `pms_base_catalog3` VALUES (1413, '滑板鞋', 151);
INSERT INTO `pms_base_catalog3` VALUES (1414, '574S系列', 151);
INSERT INTO `pms_base_catalog3` VALUES (1415, '878系列', 151);
INSERT INTO `pms_base_catalog3` VALUES (1416, '999系列', 151);
INSERT INTO `pms_base_catalog3` VALUES (1417, '老爹鞋', 151);
INSERT INTO `pms_base_catalog3` VALUES (1418, '英美产系列', 151);
INSERT INTO `pms_base_catalog3` VALUES (1419, 'Fresh Foam系列', 151);
INSERT INTO `pms_base_catalog3` VALUES (1420, 'fuel系列', 151);
INSERT INTO `pms_base_catalog3` VALUES (1421, 'Hanzo系列', 151);
INSERT INTO `pms_base_catalog3` VALUES (1422, 'NBx系列', 151);
INSERT INTO `pms_base_catalog3` VALUES (1423, '其他系列跑鞋', 151);
INSERT INTO `pms_base_catalog3` VALUES (1424, '篮球鞋', 153);
INSERT INTO `pms_base_catalog3` VALUES (1425, '跑鞋', 153);
INSERT INTO `pms_base_catalog3` VALUES (1426, '综训鞋', 153);
INSERT INTO `pms_base_catalog3` VALUES (1427, '板鞋', 153);
INSERT INTO `pms_base_catalog3` VALUES (1428, '休闲鞋', 153);
INSERT INTO `pms_base_catalog3` VALUES (1429, '棉鞋', 153);
INSERT INTO `pms_base_catalog3` VALUES (1430, '户外鞋', 153);
INSERT INTO `pms_base_catalog3` VALUES (1431, '拖鞋·凉鞋', 153);
INSERT INTO `pms_base_catalog3` VALUES (1432, '帆布鞋', 153);
INSERT INTO `pms_base_catalog3` VALUES (1433, '硫化鞋', 153);
INSERT INTO `pms_base_catalog3` VALUES (1434, '秋季', 155);
INSERT INTO `pms_base_catalog3` VALUES (1435, '冬季', 155);
INSERT INTO `pms_base_catalog3` VALUES (1436, '春季', 155);
INSERT INTO `pms_base_catalog3` VALUES (1437, '夏季', 155);
INSERT INTO `pms_base_catalog3` VALUES (1438, '跑步系列', 157);
INSERT INTO `pms_base_catalog3` VALUES (1439, '综训系列', 157);
INSERT INTO `pms_base_catalog3` VALUES (1440, '生活系列', 157);
INSERT INTO `pms_base_catalog3` VALUES (1441, '户外系列', 157);
INSERT INTO `pms_base_catalog3` VALUES (1442, '篮球系列', 157);
INSERT INTO `pms_base_catalog3` VALUES (1443, '宽松鞋型', 158);
INSERT INTO `pms_base_catalog3` VALUES (1444, '适脚鞋型', 158);
INSERT INTO `pms_base_catalog3` VALUES (1445, '跑步鞋', 159);
INSERT INTO `pms_base_catalog3` VALUES (1446, '篮球鞋', 159);
INSERT INTO `pms_base_catalog3` VALUES (1447, '运动时尚鞋', 159);
INSERT INTO `pms_base_catalog3` VALUES (1448, '户外鞋', 159);
INSERT INTO `pms_base_catalog3` VALUES (1449, '羽毛球鞋', 159);
INSERT INTO `pms_base_catalog3` VALUES (1450, '乒乓球鞋', 159);
INSERT INTO `pms_base_catalog3` VALUES (1451, '训练鞋', 159);
INSERT INTO `pms_base_catalog3` VALUES (1452, '足球鞋', 159);
INSERT INTO `pms_base_catalog3` VALUES (1453, '凉鞋/拖鞋', 159);
INSERT INTO `pms_base_catalog3` VALUES (1454, '跑步鞋', 160);
INSERT INTO `pms_base_catalog3` VALUES (1455, '运动时尚鞋', 160);
INSERT INTO `pms_base_catalog3` VALUES (1456, '羽毛球鞋', 160);
INSERT INTO `pms_base_catalog3` VALUES (1457, '乒乓球鞋', 160);
INSERT INTO `pms_base_catalog3` VALUES (1458, '训练鞋', 160);
INSERT INTO `pms_base_catalog3` VALUES (1459, '凉鞋/拖鞋', 160);
INSERT INTO `pms_base_catalog3` VALUES (1460, '篮球鞋', 160);
INSERT INTO `pms_base_catalog3` VALUES (1461, '跑步鞋', 161);
INSERT INTO `pms_base_catalog3` VALUES (1462, '篮球鞋', 161);
INSERT INTO `pms_base_catalog3` VALUES (1463, '休闲鞋', 161);
INSERT INTO `pms_base_catalog3` VALUES (1464, '训练鞋运动时尚鞋', 161);
INSERT INTO `pms_base_catalog3` VALUES (1465, '凉鞋/拖鞋', 161);
INSERT INTO `pms_base_catalog3` VALUES (1466, '跑步鞋', 162);
INSERT INTO `pms_base_catalog3` VALUES (1467, '训练鞋', 162);
INSERT INTO `pms_base_catalog3` VALUES (1468, '凉鞋/拖鞋', 162);
INSERT INTO `pms_base_catalog3` VALUES (1469, '运动时尚鞋', 162);
INSERT INTO `pms_base_catalog3` VALUES (1470, 'BIG3 篮球鞋', 163);
INSERT INTO `pms_base_catalog3` VALUES (1471, 'BIG3-建盏 篮球鞋', 163);
INSERT INTO `pms_base_catalog3` VALUES (1472, '寂寞大神篮球鞋', 163);
INSERT INTO `pms_base_catalog3` VALUES (1473, '篮潮文化鞋', 163);
INSERT INTO `pms_base_catalog3` VALUES (1474, '篮球鞋', 163);
INSERT INTO `pms_base_catalog3` VALUES (1475, '磨砺悍将篮球鞋', 163);
INSERT INTO `pms_base_catalog3` VALUES (1476, '百事防泼水涂鸦鞋', 164);
INSERT INTO `pms_base_catalog3` VALUES (1477, '百事防泼水雨屏鞋', 164);
INSERT INTO `pms_base_catalog3` VALUES (1478, '锋熠跑鞋', 164);
INSERT INTO `pms_base_catalog3` VALUES (1479, '高达系列 Q弹', 164);
INSERT INTO `pms_base_catalog3` VALUES (1480, '猎风3轻质跑鞋', 164);
INSERT INTO `pms_base_catalog3` VALUES (1481, 'M1°RO SPIRE 3', 164);
INSERT INTO `pms_base_catalog3` VALUES (1482, '钛速跑鞋', 164);
INSERT INTO `pms_base_catalog3` VALUES (1483, 'SACAIRPLUS 气能缓震跑鞋', 164);
INSERT INTO `pms_base_catalog3` VALUES (1484, '跑步文化鞋', 164);
INSERT INTO `pms_base_catalog3` VALUES (1485, 'M1?RO 跑步鞋', 164);
INSERT INTO `pms_base_catalog3` VALUES (1486, 'SPIRE', 164);
INSERT INTO `pms_base_catalog3` VALUES (1487, 'SACAIR跑步文化鞋', 164);
INSERT INTO `pms_base_catalog3` VALUES (1488, 'MERAKI-2', 164);
INSERT INTO `pms_base_catalog3` VALUES (1489, 'SPIRE 3', 164);
INSERT INTO `pms_base_catalog3` VALUES (1490, 'SACAIR全掌气垫耐磨跑鞋', 164);
INSERT INTO `pms_base_catalog3` VALUES (1491, 'RUNSPARK都市型格跑鞋', 164);
INSERT INTO `pms_base_catalog3` VALUES (1492, 'TITAN专业跑鞋', 164);
INSERT INTO `pms_base_catalog3` VALUES (1493, 'RUNSPARK都市型格跑鞋', 164);
INSERT INTO `pms_base_catalog3` VALUES (1494, '【CF联名】休闲运动鞋', 165);
INSERT INTO `pms_base_catalog3` VALUES (1495, '【CF联名-潜伏】耐磨Q弹篮球鞋', 165);
INSERT INTO `pms_base_catalog3` VALUES (1496, '【CF联名-勋章】高帮复古休闲板鞋', 165);
INSERT INTO `pms_base_catalog3` VALUES (1497, '【CF联名-荣光】魔术贴潮流休闲鞋高达系列 扎古', 165);
INSERT INTO `pms_base_catalog3` VALUES (1498, '高达系列 RX-78', 165);
INSERT INTO `pms_base_catalog3` VALUES (1499, '高达系列 扎古', 165);
INSERT INTO `pms_base_catalog3` VALUES (1500, 'M1°RO SPIRE1', 165);
INSERT INTO `pms_base_catalog3` VALUES (1501, '复古潮流休闲鞋', 165);
INSERT INTO `pms_base_catalog3` VALUES (1502, '网面透气休闲鞋', 165);
INSERT INTO `pms_base_catalog3` VALUES (1503, '复古文化鞋', 165);
INSERT INTO `pms_base_catalog3` VALUES (1504, '精英训练鞋', 166);
INSERT INTO `pms_base_catalog3` VALUES (1505, '壹穿健走鞋', 166);
INSERT INTO `pms_base_catalog3` VALUES (1506, '轻便透气综训鞋', 166);
INSERT INTO `pms_base_catalog3` VALUES (1507, '防滑综训鞋', 166);
INSERT INTO `pms_base_catalog3` VALUES (1508, '鞋', 169);
INSERT INTO `pms_base_catalog3` VALUES (1509, '服装', 169);
INSERT INTO `pms_base_catalog3` VALUES (1510, '配件', 169);
INSERT INTO `pms_base_catalog3` VALUES (1511, '系带', 170);
INSERT INTO `pms_base_catalog3` VALUES (1512, '一脚蹬', 170);
INSERT INTO `pms_base_catalog3` VALUES (1513, '魔术贴', 170);
INSERT INTO `pms_base_catalog3` VALUES (1514, '低帮', 171);
INSERT INTO `pms_base_catalog3` VALUES (1515, '中帮', 171);
INSERT INTO `pms_base_catalog3` VALUES (1516, '高帮', 171);
INSERT INTO `pms_base_catalog3` VALUES (1517, 'AUTHENTIC', 172);
INSERT INTO `pms_base_catalog3` VALUES (1518, 'ERA', 172);
INSERT INTO `pms_base_catalog3` VALUES (1519, 'SLIP-ON', 172);
INSERT INTO `pms_base_catalog3` VALUES (1520, 'OLD SKOOL', 172);
INSERT INTO `pms_base_catalog3` VALUES (1521, 'SK8-H', 172);
INSERT INTO `pms_base_catalog3` VALUES (1522, 'VAULT系列', 172);
INSERT INTO `pms_base_catalog3` VALUES (1523, '经典系列', 172);
INSERT INTO `pms_base_catalog3` VALUES (1524, 'COMFYCUSH系列', 172);
INSERT INTO `pms_base_catalog3` VALUES (1525, '滑板系列', 172);
INSERT INTO `pms_base_catalog3` VALUES (1526, '冲浪系列', 172);
INSERT INTO `pms_base_catalog3` VALUES (1527, 'CUSTOMS定制鞋', 172);
INSERT INTO `pms_base_catalog3` VALUES (1528, 'CLASSICS 经典款', 172);
INSERT INTO `pms_base_catalog3` VALUES (1529, 'PRO SKATE 职业鞋款', 172);
INSERT INTO `pms_base_catalog3` VALUES (1530, 'VAULT BY VANS', 172);
INSERT INTO `pms_base_catalog3` VALUES (1531, '安纳海姆', 172);
INSERT INTO `pms_base_catalog3` VALUES (1532, 'SNOW BOOTS 职业滑雪鞋款', 172);
INSERT INTO `pms_base_catalog3` VALUES (1533, '跑鞋', 173);
INSERT INTO `pms_base_catalog3` VALUES (1534, '篮球鞋', 173);
INSERT INTO `pms_base_catalog3` VALUES (1535, '训练鞋', 173);
INSERT INTO `pms_base_catalog3` VALUES (1536, '运动休闲鞋', 173);
INSERT INTO `pms_base_catalog3` VALUES (1537, '拖鞋', 173);
INSERT INTO `pms_base_catalog3` VALUES (1538, '其他', 173);
INSERT INTO `pms_base_catalog3` VALUES (1539, '配件', 173);
INSERT INTO `pms_base_catalog3` VALUES (1540, '男子PROJECT ROCK系列', 174);
INSERT INTO `pms_base_catalog3` VALUES (1541, '男子RUSH系列', 174);
INSERT INTO `pms_base_catalog3` VALUES (1542, '男子HOVR系列', 174);
INSERT INTO `pms_base_catalog3` VALUES (1543, '男子CURRY专区系列', 174);
INSERT INTO `pms_base_catalog3` VALUES (1544, '男子TRIBASE系列', 174);
INSERT INTO `pms_base_catalog3` VALUES (1545, '跑步', 175);
INSERT INTO `pms_base_catalog3` VALUES (1546, '休闲', 175);
INSERT INTO `pms_base_catalog3` VALUES (1547, '高尔夫', 175);
INSERT INTO `pms_base_catalog3` VALUES (1548, '户外', 175);
INSERT INTO `pms_base_catalog3` VALUES (1549, '篮球', 175);
INSERT INTO `pms_base_catalog3` VALUES (1550, '垂钓', 175);
INSERT INTO `pms_base_catalog3` VALUES (1551, '休闲鞋', 178);
INSERT INTO `pms_base_catalog3` VALUES (1552, '跑步鞋', 178);
INSERT INTO `pms_base_catalog3` VALUES (1553, '训练鞋', 178);
INSERT INTO `pms_base_catalog3` VALUES (1554, '赛车鞋', 178);

-- ----------------------------
-- Table structure for pms_base_sale_attr
-- ----------------------------
DROP TABLE IF EXISTS `pms_base_sale_attr`;
CREATE TABLE `pms_base_sale_attr`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '销售属性名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pms_base_sale_attr
-- ----------------------------
INSERT INTO `pms_base_sale_attr` VALUES (1, '颜色');
INSERT INTO `pms_base_sale_attr` VALUES (2, '尺寸');

-- ----------------------------
-- Table structure for pms_brand
-- ----------------------------
DROP TABLE IF EXISTS `pms_brand`;
CREATE TABLE `pms_brand`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `first_letter` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '首字母',
  `sort` int(0) NULL DEFAULT NULL,
  `factory_status` int(0) NULL DEFAULT NULL COMMENT '是否为品牌制造商：0->不是；1->是',
  `show_status` int(0) NULL DEFAULT NULL,
  `product_count` int(0) NULL DEFAULT NULL COMMENT '产品数量',
  `product_comment_count` int(0) NULL DEFAULT NULL COMMENT '产品评论数量',
  `logo` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '品牌logo',
  `big_pic` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '专区大图',
  `brand_story` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '品牌故事',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 52 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '品牌表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pms_brand
-- ----------------------------
INSERT INTO `pms_brand` VALUES (1, '万和', 'W', 0, 1, 1, 100, 100, 'http://macro-oss.oss-cn-shenzhen.aliyuncs.com/mall/images/20180607/timg(5).jpg', '', 'Victoria\'s Secret的故事');
INSERT INTO `pms_brand` VALUES (2, '三星', 'S', 100, 1, 1, 100, 100, 'http://macro-oss.oss-cn-shenzhen.aliyuncs.com/mall/images/20180607/timg (1).jpg', NULL, '三星的故事');
INSERT INTO `pms_brand` VALUES (4, '格力', 'G', 30, 1, 1, 100, 100, 'http://macro-oss.oss-cn-shenzhen.aliyuncs.com/mall/images/20190129/dc794e7e74121272bbe3ce9bc41ec8c3_222_222.jpg', NULL, 'Victoria\'s Secret的故事');
INSERT INTO `pms_brand` VALUES (5, '方太', 'F', 20, 1, 1, 100, 100, 'http://macro-oss.oss-cn-shenzhen.aliyuncs.com/mall/images/20180607/timg (4).jpg', NULL, 'Victoria\'s Secret的故事');
INSERT INTO `pms_brand` VALUES (6, '小米', 'X', 0, 1, 1, 100, 200, NULL, NULL, NULL);
INSERT INTO `pms_brand` VALUES (21, 'OPPO', 'O', 0, 1, 1, 88, 500, 'http://macro-oss.oss-cn-shenzhen.aliyuncs.com/mall/images/20180607/timg(6).jpg', '', 'string');
INSERT INTO `pms_brand` VALUES (49, '七匹狼', 'S', 200, 1, 1, 77, 400, 'http://macro-oss.oss-cn-shenzhen.aliyuncs.com/mall/images/20190129/18d8bc3eb13533fab466d702a0d3fd1f40345bcd.jpg', NULL, 'BOOB的故事');
INSERT INTO `pms_brand` VALUES (50, '海澜之家', 'H', 200, 1, 1, 66, 300, 'http://macro-oss.oss-cn-shenzhen.aliyuncs.com/mall/images/20190129/99d3279f1029d32b929343b09d3c72de_222_222.jpg', '', '海澜之家的故事');
INSERT INTO `pms_brand` VALUES (51, '苹果', 'A', 200, 1, 1, 55, 200, 'http://macro-oss.oss-cn-shenzhen.aliyuncs.com/mall/images/20180607/timg.jpg', NULL, '苹果的故事');
INSERT INTO `pms_brand` VALUES (52, 'ggg', 'g', 0, 0, 0, NULL, NULL, 'http://leifengyang.oss-cn-beijing.aliyuncs.com/gmall/images/20190315/7.jpg', '', '');

-- ----------------------------
-- Table structure for pms_comment
-- ----------------------------
DROP TABLE IF EXISTS `pms_comment`;
CREATE TABLE `pms_comment`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(0) NULL DEFAULT NULL,
  `member_nick_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `product_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `star` int(0) NULL DEFAULT NULL COMMENT '评价星数：0->5',
  `member_ip` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '评价的ip',
  `create_time` datetime(0) NULL DEFAULT NULL,
  `show_status` int(0) NULL DEFAULT NULL,
  `product_attribute` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '购买时的商品属性',
  `collect_couont` int(0) NULL DEFAULT NULL,
  `read_count` int(0) NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `pics` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上传图片地址，以逗号隔开',
  `member_icon` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '评论用户头像',
  `replay_count` int(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品评价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pms_comment_replay
-- ----------------------------
DROP TABLE IF EXISTS `pms_comment_replay`;
CREATE TABLE `pms_comment_replay`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `comment_id` bigint(0) NULL DEFAULT NULL,
  `member_nick_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `member_icon` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `content` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `type` int(0) NULL DEFAULT NULL COMMENT '评论人员类型；0->会员；1->管理员',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '产品评价回复表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pms_product_image
-- ----------------------------
DROP TABLE IF EXISTS `pms_product_image`;
CREATE TABLE `pms_product_image`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `product_id` bigint(0) NULL DEFAULT NULL COMMENT '商品id',
  `img_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片名称',
  `img_url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 282 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品图片表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pms_product_image
-- ----------------------------
INSERT INTO `pms_product_image` VALUES (212, 74, 'bh7fpkga6i1220ge4xhh.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAXgnqAAC-Hoqs7BE647.jpg');
INSERT INTO `pms_product_image` VALUES (213, 74, 'l18k1ioczyw4rlpvwu6w.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAH6UQAADlSqtss64235.jpg');
INSERT INTO `pms_product_image` VALUES (214, 74, 'pml7sicrfod8osyhyfro.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAHoTZAADE9gpZr8g264.jpg');
INSERT INTO `pms_product_image` VALUES (215, 74, 'rnkjukdrakjz4y922geh.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAQhvUAACiwrmEN0E827.jpg');
INSERT INTO `pms_product_image` VALUES (216, 74, 'ciuenu9xhg41an1bbgs1.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAD1bGAAGqeIjQkeM065.jpg');
INSERT INTO `pms_product_image` VALUES (217, 74, 'p0gmlgf3vuub5yaxgncb.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAQOb6AAEUAHJ_kVA423.jpg');
INSERT INTO `pms_product_image` VALUES (218, 74, 'tfidhgryldwqctjwxiid.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAd938AADDfsNm_B8423.jpg');
INSERT INTO `pms_product_image` VALUES (219, 74, 'taolt94hxyv2jz7rhqgd.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAXZxCAAD3sOBCB9w401.jpg');
INSERT INTO `pms_product_image` VALUES (220, 74, 'jh0lobmvzxutdvrfbz0d.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAZnLlAAC0gvA1cd0209.jpg');
INSERT INTO `pms_product_image` VALUES (221, 74, 'wucrcjujt3609n4sohix.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAEAI9AAEIyC2XEsY354.jpg');
INSERT INTO `pms_product_image` VALUES (222, 75, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (2).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAVnj_AAE5nVjWl9k872.jpg');
INSERT INTO `pms_product_image` VALUES (223, 75, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (10).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAY4mMAADyiN9DJGY593.jpg');
INSERT INTO `pms_product_image` VALUES (224, 75, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (9).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAB5TqAAEvDsDUW58303.jpg');
INSERT INTO `pms_product_image` VALUES (225, 75, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (4).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAaDWYAAD1GuhjFLk077.jpg');
INSERT INTO `pms_product_image` VALUES (226, 75, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (8).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAKKWSAADCzIqND8s910.jpg');
INSERT INTO `pms_product_image` VALUES (227, 75, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (7).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAMQEsAACq8qpAztI800.jpg');
INSERT INTO `pms_product_image` VALUES (228, 75, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (3).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAfmRTAADLD3dXlEc065.jpg');
INSERT INTO `pms_product_image` VALUES (229, 75, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (5).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAYxzmAADbcLxBMcw930.jpg');
INSERT INTO `pms_product_image` VALUES (230, 75, 'air-jordan-33-pf-男子篮球鞋-7L0rd9.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAJ5rTAAD1GuhjFLk280.jpg');
INSERT INTO `pms_product_image` VALUES (231, 75, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (6).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAMpWNAADLmtnc1xc469.jpg');
INSERT INTO `pms_product_image` VALUES (232, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (1).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAO0NtAADAnz7rYqQ782.jpg');
INSERT INTO `pms_product_image` VALUES (233, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (2).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAZTWZAAC8xapgoE4848.jpg');
INSERT INTO `pms_product_image` VALUES (234, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (9).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAOHjBAAEi9zJjgBE251.jpg');
INSERT INTO `pms_product_image` VALUES (235, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (8).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAG5liAAFck5UdRuI917.jpg');
INSERT INTO `pms_product_image` VALUES (236, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (7).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OACt0mAAEi9zJjgBE851.jpg');
INSERT INTO `pms_product_image` VALUES (237, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (3).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAEksgAADRZjbivvc089.jpg');
INSERT INTO `pms_product_image` VALUES (238, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (4).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAJI7kAAEk4Q1zXqU817.jpg');
INSERT INTO `pms_product_image` VALUES (239, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (5).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAetRrAAEQ18BqkF8553.jpg');
INSERT INTO `pms_product_image` VALUES (240, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (11).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OALINOAAC9SmItHrA718.jpg');
INSERT INTO `pms_product_image` VALUES (241, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (12).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAKm7wAADeZKaNaVk469.jpg');
INSERT INTO `pms_product_image` VALUES (242, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (13).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAFgU5AAFpmIdAXyg852.jpg');
INSERT INTO `pms_product_image` VALUES (243, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (10).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAfbK9AADMExhsqyY429.jpg');
INSERT INTO `pms_product_image` VALUES (244, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (6).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAQe_XAAEKm4d7tH8223.jpg');
INSERT INTO `pms_product_image` VALUES (245, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (14).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OACMW8AAC-r0iSnw4408.jpg');
INSERT INTO `pms_product_image` VALUES (246, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (15).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAar_kAAC98bWG-no154.jpg');
INSERT INTO `pms_product_image` VALUES (247, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (16).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAS63WAACxsavs1_c086.jpg');
INSERT INTO `pms_product_image` VALUES (248, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (17).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAOqnkAADF5t-qnkQ031.jpg');
INSERT INTO `pms_product_image` VALUES (249, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (19).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAb6A1AADyL52-Bks666.jpg');
INSERT INTO `pms_product_image` VALUES (250, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (18).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAEIYWAAC-FkT4ZyU808.jpg');
INSERT INTO `pms_product_image` VALUES (251, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (20).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAUci-AADaqrRA3Eo662.jpg');
INSERT INTO `pms_product_image` VALUES (252, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (23).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAC1QeAADzIbJx8vE582.jpg');
INSERT INTO `pms_product_image` VALUES (253, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (22).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAIB23AAD4rRCwMPY243.jpg');
INSERT INTO `pms_product_image` VALUES (254, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (21).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAUPSiAADPvn9-d7E811.jpg');
INSERT INTO `pms_product_image` VALUES (255, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAeo88AACN_GuWQB0448.jpg');
INSERT INTO `pms_product_image` VALUES (256, 76, 'air-jordan-1-mid-女子运动鞋-5PtCth (24).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAZA9oAAGOoa8ECgU542.jpg');
INSERT INTO `pms_product_image` VALUES (257, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (1).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAIQ1SAACv3GCwJjA116.jpg');
INSERT INTO `pms_product_image` VALUES (258, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (9).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAJj8OAAD_TLgi7zQ188.jpg');
INSERT INTO `pms_product_image` VALUES (259, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (8).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAJcEZAAEJb2buIpc365.jpg');
INSERT INTO `pms_product_image` VALUES (260, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (7).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimANVGeAAEV8xKvJV8196.jpg');
INSERT INTO `pms_product_image` VALUES (261, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (2).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAcHSBAADyP97GNw4080.jpg');
INSERT INTO `pms_product_image` VALUES (262, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (3).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAOhJbAAFfMZlotOA788.jpg');
INSERT INTO `pms_product_image` VALUES (263, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (10).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimADY3yAADqVcHz-0U434.jpg');
INSERT INTO `pms_product_image` VALUES (264, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (11).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAShP7AADQgxDAFqo044.jpg');
INSERT INTO `pms_product_image` VALUES (265, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (12).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAeDhGAADzaFGaUw0251.jpg');
INSERT INTO `pms_product_image` VALUES (266, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (13).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAbxvcAADPb7_mZo4448.jpg');
INSERT INTO `pms_product_image` VALUES (267, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (4).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAIbt0AAEGHKH9vk4319.jpg');
INSERT INTO `pms_product_image` VALUES (268, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (5).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimASCcyAAErP2LxToY168.jpg');
INSERT INTO `pms_product_image` VALUES (269, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (6).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAQTt-AAGHhFvUW_o745.jpg');
INSERT INTO `pms_product_image` VALUES (270, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAdRN7AAD-Ze5WR4s826.jpg');
INSERT INTO `pms_product_image` VALUES (271, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (1).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimACRtrAADaH8YE2ME884.jpg');
INSERT INTO `pms_product_image` VALUES (272, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (2).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAAg4rAAD2w2Mjeus358.jpg');
INSERT INTO `pms_product_image` VALUES (273, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (14).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAET4yAAEp8suNfRE028.jpg');
INSERT INTO `pms_product_image` VALUES (274, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (15).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimACLliAADzJTIlRkk658.jpg');
INSERT INTO `pms_product_image` VALUES (275, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (4).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAGpIxAAEXLFNyeE8886.jpg');
INSERT INTO `pms_product_image` VALUES (276, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (3).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimASapzAAGbP-Z1HZw021.jpg');
INSERT INTO `pms_product_image` VALUES (277, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (5).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAUjBbAAENZvYrZW4152.jpg');
INSERT INTO `pms_product_image` VALUES (278, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (8).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAPnxPAAFoi8aNasw972.jpg');
INSERT INTO `pms_product_image` VALUES (279, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (9).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAZ1G8AAEEQUa8Sck191.jpg');
INSERT INTO `pms_product_image` VALUES (280, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAQjnNAAEArnxaMbY002.jpg');
INSERT INTO `pms_product_image` VALUES (281, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (7).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAY_57AAEF03nIGIk195.jpg');
INSERT INTO `pms_product_image` VALUES (282, 77, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (6).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAae8MAADue3GgzBE885.jpg');

-- ----------------------------
-- Table structure for pms_product_info
-- ----------------------------
DROP TABLE IF EXISTS `pms_product_info`;
CREATE TABLE `pms_product_info`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `product_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `description` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品描述(后台简述）',
  `catalog3_id` bigint(0) NULL DEFAULT NULL COMMENT '三级分类id',
  `tm_id` bigint(0) NULL DEFAULT NULL COMMENT '品牌id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 78 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pms_product_info
-- ----------------------------
INSERT INTO `pms_product_info` VALUES (74, '男子篮球鞋 LeBron XVII PRM EP', 'LeBron XVII PRM EP 篮球鞋依托勒布朗的力量和速度，塑就出众包覆性和支撑力，助你制霸赛场。采用轻盈的针织和模压纱线组合设计，塑就耐穿外观和质感。组合缓震设计，为勒布朗带来出色减震支撑效果和灵敏响应回弹能量，助力畅享漫长赛季。', 1261, NULL);
INSERT INTO `pms_product_info` VALUES (75, '男子篮球鞋 Air Jordan XXXIII PF', 'Air Jordan XXXIII PF 篮球鞋焕新演绎一流篮球鞋经典设计。革命性扣合系统帮助稳定双足，助力实现凌跃表现，结合经过精心调整的全新 FlightSpeed 技术，带来源源不断的能量回馈。', 1261, NULL);
INSERT INTO `pms_product_info` VALUES (76, '女子运动鞋 Air Jordan 1 Mid', 'Air Jordan 1 Mid 集掌控全场的霸气风范、非凡舒适性及标志性外形于一体。鞋底加入 Air 缓震技术，专为硬木球场设计，加垫鞋口赋予脚踝出色支撑力。', 1261, NULL);
INSERT INTO `pms_product_info` VALUES (77, '男子篮球鞋 Jordan Why Not Zer0.3 PF', '作为叱咤球场的参赛者之一，三双王拉塞尔·威斯布鲁克刚猛的动作、发达的肌肉和强大的意志，与他出众的表现相匹配，而他强大的统计数据也证明了这一点。Jordan Why Not Zer0.3 PF 男子篮球鞋专为缔造户外球场出众表现而设计。Jordan Why Not Zer0.3 PF 男子篮球鞋为诸如拉塞尔的球员打造微调版型，他凭借其非凡线速和锐意进取表现击败对手。', 1261, NULL);

-- ----------------------------
-- Table structure for pms_product_sale_attr
-- ----------------------------
DROP TABLE IF EXISTS `pms_product_sale_attr`;
CREATE TABLE `pms_product_sale_attr`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `product_id` bigint(0) NULL DEFAULT NULL COMMENT '商品id',
  `sale_attr_id` bigint(0) NULL DEFAULT NULL COMMENT '销售属性id',
  `sale_attr_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售属性名称(冗余)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 125 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pms_product_sale_attr
-- ----------------------------
INSERT INTO `pms_product_sale_attr` VALUES (117, 74, 1, '颜色');
INSERT INTO `pms_product_sale_attr` VALUES (118, 74, 2, '尺寸');
INSERT INTO `pms_product_sale_attr` VALUES (119, 75, 1, '颜色');
INSERT INTO `pms_product_sale_attr` VALUES (120, 75, 2, '尺寸');
INSERT INTO `pms_product_sale_attr` VALUES (121, 76, 1, '颜色');
INSERT INTO `pms_product_sale_attr` VALUES (122, 76, 2, '尺寸');
INSERT INTO `pms_product_sale_attr` VALUES (123, 77, 1, '颜色');
INSERT INTO `pms_product_sale_attr` VALUES (124, 77, 2, '尺寸');

-- ----------------------------
-- Table structure for pms_product_sale_attr_value
-- ----------------------------
DROP TABLE IF EXISTS `pms_product_sale_attr_value`;
CREATE TABLE `pms_product_sale_attr_value`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `product_id` bigint(0) NULL DEFAULT NULL COMMENT '商品id',
  `sale_attr_id` bigint(0) NULL DEFAULT NULL COMMENT '销售属性id',
  `sale_attr_value_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售属性值名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 306 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'spu销售属性值' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pms_product_sale_attr_value
-- ----------------------------
INSERT INTO `pms_product_sale_attr_value` VALUES (278, 74, 1, '赭石沙色/杉木红/金属金');
INSERT INTO `pms_product_sale_attr_value` VALUES (279, 74, 1, '赛车蓝/黑/白色');
INSERT INTO `pms_product_sale_attr_value` VALUES (280, 74, 2, 'CT3467-001');
INSERT INTO `pms_product_sale_attr_value` VALUES (281, 74, 2, 'CT3465-400');
INSERT INTO `pms_product_sale_attr_value` VALUES (282, 75, 1, '白色/苍野灰/岛绿/金属银');
INSERT INTO `pms_product_sale_attr_value` VALUES (283, 75, 1, '苍野灰/白色/帆白/空间蓝');
INSERT INTO `pms_product_sale_attr_value` VALUES (284, 75, 2, 'BV5072-101');
INSERT INTO `pms_product_sale_attr_value` VALUES (285, 75, 2, 'BV5072-004');
INSERT INTO `pms_product_sale_attr_value` VALUES (286, 76, 1, '黑/贵族红/白色');
INSERT INTO `pms_product_sale_attr_value` VALUES (287, 76, 1, '黑/红杉绿/骑兵灰绿');
INSERT INTO `pms_product_sale_attr_value` VALUES (288, 76, 1, '亮深红/黑');
INSERT INTO `pms_product_sale_attr_value` VALUES (289, 76, 1, '白色/白色/暗白蓝');
INSERT INTO `pms_product_sale_attr_value` VALUES (290, 76, 1, '黑/潘趣红/白色/荧光黄');
INSERT INTO `pms_product_sale_attr_value` VALUES (291, 76, 2, 'BQ6472-016');
INSERT INTO `pms_product_sale_attr_value` VALUES (292, 76, 2, 'BQ6472-030');
INSERT INTO `pms_product_sale_attr_value` VALUES (293, 76, 2, 'BQ6472-600');
INSERT INTO `pms_product_sale_attr_value` VALUES (294, 76, 2, ' BQ6472-114');
INSERT INTO `pms_product_sale_attr_value` VALUES (295, 76, 2, 'BQ6472-006');
INSERT INTO `pms_product_sale_attr_value` VALUES (296, 77, 1, '白色/黑/大气灰/亮深红');
INSERT INTO `pms_product_sale_attr_value` VALUES (297, 77, 1, '白色/冷灰/狼灰/白色');
INSERT INTO `pms_product_sale_attr_value` VALUES (298, 77, 1, '黑/白色/金属金');
INSERT INTO `pms_product_sale_attr_value` VALUES (299, 77, 1, '白色/赛车粉/阴影绿/黑');
INSERT INTO `pms_product_sale_attr_value` VALUES (300, 77, 1, '微粒灰/黑/铁灰/爆炸粉');
INSERT INTO `pms_product_sale_attr_value` VALUES (301, 77, 2, 'CD3002-101');
INSERT INTO `pms_product_sale_attr_value` VALUES (302, 77, 2, 'CD3002-100');
INSERT INTO `pms_product_sale_attr_value` VALUES (303, 77, 2, 'CD3002-001');
INSERT INTO `pms_product_sale_attr_value` VALUES (304, 77, 2, 'CD3002-102');
INSERT INTO `pms_product_sale_attr_value` VALUES (305, 77, 2, 'CD3002-003');

-- ----------------------------
-- Table structure for pms_product_vertify_record
-- ----------------------------
DROP TABLE IF EXISTS `pms_product_vertify_record`;
CREATE TABLE `pms_product_vertify_record`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(0) NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT NULL,
  `vertify_man` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核人',
  `status` int(0) NULL DEFAULT NULL,
  `detail` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '反馈详情',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品审核记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pms_sku_attr_value
-- ----------------------------
DROP TABLE IF EXISTS `pms_sku_attr_value`;
CREATE TABLE `pms_sku_attr_value`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `attr_id` bigint(0) NULL DEFAULT NULL COMMENT '属性id（冗余)',
  `value_id` bigint(0) NULL DEFAULT NULL COMMENT '属性值id',
  `sku_id` bigint(0) NULL DEFAULT NULL COMMENT '库存单元skuId',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1105 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'sku平台属性值关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pms_sku_attr_value
-- ----------------------------
INSERT INTO `pms_sku_attr_value` VALUES (961, 46, 129, 122);
INSERT INTO `pms_sku_attr_value` VALUES (962, 47, 137, 122);
INSERT INTO `pms_sku_attr_value` VALUES (963, 48, 145, 122);
INSERT INTO `pms_sku_attr_value` VALUES (964, 49, 157, 122);
INSERT INTO `pms_sku_attr_value` VALUES (965, 50, 159, 122);
INSERT INTO `pms_sku_attr_value` VALUES (966, 51, 166, 122);
INSERT INTO `pms_sku_attr_value` VALUES (967, 52, 171, 122);
INSERT INTO `pms_sku_attr_value` VALUES (968, 53, 181, 122);
INSERT INTO `pms_sku_attr_value` VALUES (969, 46, 129, 123);
INSERT INTO `pms_sku_attr_value` VALUES (970, 47, 137, 123);
INSERT INTO `pms_sku_attr_value` VALUES (971, 48, 145, 123);
INSERT INTO `pms_sku_attr_value` VALUES (972, 49, 157, 123);
INSERT INTO `pms_sku_attr_value` VALUES (973, 50, 159, 123);
INSERT INTO `pms_sku_attr_value` VALUES (974, 51, 166, 123);
INSERT INTO `pms_sku_attr_value` VALUES (975, 52, 171, 123);
INSERT INTO `pms_sku_attr_value` VALUES (976, 53, 181, 123);
INSERT INTO `pms_sku_attr_value` VALUES (977, 46, 129, 124);
INSERT INTO `pms_sku_attr_value` VALUES (978, 47, 137, 124);
INSERT INTO `pms_sku_attr_value` VALUES (979, 48, 145, 124);
INSERT INTO `pms_sku_attr_value` VALUES (980, 49, 157, 124);
INSERT INTO `pms_sku_attr_value` VALUES (981, 50, 159, 124);
INSERT INTO `pms_sku_attr_value` VALUES (982, 51, 166, 124);
INSERT INTO `pms_sku_attr_value` VALUES (983, 52, 171, 124);
INSERT INTO `pms_sku_attr_value` VALUES (984, 53, 181, 124);
INSERT INTO `pms_sku_attr_value` VALUES (985, 46, 129, 125);
INSERT INTO `pms_sku_attr_value` VALUES (986, 47, 137, 125);
INSERT INTO `pms_sku_attr_value` VALUES (987, 48, 145, 125);
INSERT INTO `pms_sku_attr_value` VALUES (988, 49, 157, 125);
INSERT INTO `pms_sku_attr_value` VALUES (989, 50, 159, 125);
INSERT INTO `pms_sku_attr_value` VALUES (990, 51, 166, 125);
INSERT INTO `pms_sku_attr_value` VALUES (991, 52, 171, 125);
INSERT INTO `pms_sku_attr_value` VALUES (992, 53, 181, 125);
INSERT INTO `pms_sku_attr_value` VALUES (993, 46, 129, 126);
INSERT INTO `pms_sku_attr_value` VALUES (994, 47, 137, 126);
INSERT INTO `pms_sku_attr_value` VALUES (995, 48, 145, 126);
INSERT INTO `pms_sku_attr_value` VALUES (996, 49, 157, 126);
INSERT INTO `pms_sku_attr_value` VALUES (997, 50, 159, 126);
INSERT INTO `pms_sku_attr_value` VALUES (998, 51, 166, 126);
INSERT INTO `pms_sku_attr_value` VALUES (999, 52, 171, 126);
INSERT INTO `pms_sku_attr_value` VALUES (1000, 53, 181, 126);
INSERT INTO `pms_sku_attr_value` VALUES (1001, 46, 129, 127);
INSERT INTO `pms_sku_attr_value` VALUES (1002, 47, 137, 127);
INSERT INTO `pms_sku_attr_value` VALUES (1003, 48, 145, 127);
INSERT INTO `pms_sku_attr_value` VALUES (1004, 49, 157, 127);
INSERT INTO `pms_sku_attr_value` VALUES (1005, 50, 159, 127);
INSERT INTO `pms_sku_attr_value` VALUES (1006, 51, 166, 127);
INSERT INTO `pms_sku_attr_value` VALUES (1007, 52, 171, 127);
INSERT INTO `pms_sku_attr_value` VALUES (1008, 53, 181, 127);
INSERT INTO `pms_sku_attr_value` VALUES (1009, 46, 129, 128);
INSERT INTO `pms_sku_attr_value` VALUES (1010, 47, 137, 128);
INSERT INTO `pms_sku_attr_value` VALUES (1011, 48, 145, 128);
INSERT INTO `pms_sku_attr_value` VALUES (1012, 49, 157, 128);
INSERT INTO `pms_sku_attr_value` VALUES (1013, 50, 159, 128);
INSERT INTO `pms_sku_attr_value` VALUES (1014, 51, 166, 128);
INSERT INTO `pms_sku_attr_value` VALUES (1015, 52, 171, 128);
INSERT INTO `pms_sku_attr_value` VALUES (1016, 53, 181, 128);
INSERT INTO `pms_sku_attr_value` VALUES (1017, 46, 129, 129);
INSERT INTO `pms_sku_attr_value` VALUES (1018, 47, 137, 129);
INSERT INTO `pms_sku_attr_value` VALUES (1019, 48, 145, 129);
INSERT INTO `pms_sku_attr_value` VALUES (1020, 49, 157, 129);
INSERT INTO `pms_sku_attr_value` VALUES (1021, 50, 159, 129);
INSERT INTO `pms_sku_attr_value` VALUES (1022, 51, 166, 129);
INSERT INTO `pms_sku_attr_value` VALUES (1023, 52, 171, 129);
INSERT INTO `pms_sku_attr_value` VALUES (1024, 53, 181, 129);
INSERT INTO `pms_sku_attr_value` VALUES (1025, 46, 127, 130);
INSERT INTO `pms_sku_attr_value` VALUES (1026, 47, 138, 130);
INSERT INTO `pms_sku_attr_value` VALUES (1027, 48, 145, 130);
INSERT INTO `pms_sku_attr_value` VALUES (1028, 49, 152, 130);
INSERT INTO `pms_sku_attr_value` VALUES (1029, 50, 160, 130);
INSERT INTO `pms_sku_attr_value` VALUES (1030, 51, 166, 130);
INSERT INTO `pms_sku_attr_value` VALUES (1031, 52, 178, 130);
INSERT INTO `pms_sku_attr_value` VALUES (1032, 53, 182, 130);
INSERT INTO `pms_sku_attr_value` VALUES (1033, 46, 127, 131);
INSERT INTO `pms_sku_attr_value` VALUES (1034, 47, 138, 131);
INSERT INTO `pms_sku_attr_value` VALUES (1035, 48, 145, 131);
INSERT INTO `pms_sku_attr_value` VALUES (1036, 49, 152, 131);
INSERT INTO `pms_sku_attr_value` VALUES (1037, 50, 160, 131);
INSERT INTO `pms_sku_attr_value` VALUES (1038, 51, 166, 131);
INSERT INTO `pms_sku_attr_value` VALUES (1039, 52, 178, 131);
INSERT INTO `pms_sku_attr_value` VALUES (1040, 53, 182, 131);
INSERT INTO `pms_sku_attr_value` VALUES (1041, 46, 127, 132);
INSERT INTO `pms_sku_attr_value` VALUES (1042, 47, 138, 132);
INSERT INTO `pms_sku_attr_value` VALUES (1043, 48, 145, 132);
INSERT INTO `pms_sku_attr_value` VALUES (1044, 49, 152, 132);
INSERT INTO `pms_sku_attr_value` VALUES (1045, 50, 160, 132);
INSERT INTO `pms_sku_attr_value` VALUES (1046, 51, 166, 132);
INSERT INTO `pms_sku_attr_value` VALUES (1047, 52, 178, 132);
INSERT INTO `pms_sku_attr_value` VALUES (1048, 53, 182, 132);
INSERT INTO `pms_sku_attr_value` VALUES (1049, 46, 127, 133);
INSERT INTO `pms_sku_attr_value` VALUES (1050, 47, 138, 133);
INSERT INTO `pms_sku_attr_value` VALUES (1051, 48, 145, 133);
INSERT INTO `pms_sku_attr_value` VALUES (1052, 49, 152, 133);
INSERT INTO `pms_sku_attr_value` VALUES (1053, 50, 160, 133);
INSERT INTO `pms_sku_attr_value` VALUES (1054, 51, 166, 133);
INSERT INTO `pms_sku_attr_value` VALUES (1055, 52, 178, 133);
INSERT INTO `pms_sku_attr_value` VALUES (1056, 53, 182, 133);
INSERT INTO `pms_sku_attr_value` VALUES (1057, 46, 127, 134);
INSERT INTO `pms_sku_attr_value` VALUES (1058, 47, 138, 134);
INSERT INTO `pms_sku_attr_value` VALUES (1059, 48, 145, 134);
INSERT INTO `pms_sku_attr_value` VALUES (1060, 49, 152, 134);
INSERT INTO `pms_sku_attr_value` VALUES (1061, 50, 160, 134);
INSERT INTO `pms_sku_attr_value` VALUES (1062, 51, 166, 134);
INSERT INTO `pms_sku_attr_value` VALUES (1063, 52, 178, 134);
INSERT INTO `pms_sku_attr_value` VALUES (1064, 53, 182, 134);
INSERT INTO `pms_sku_attr_value` VALUES (1065, 46, 129, 135);
INSERT INTO `pms_sku_attr_value` VALUES (1066, 47, 139, 135);
INSERT INTO `pms_sku_attr_value` VALUES (1067, 48, 148, 135);
INSERT INTO `pms_sku_attr_value` VALUES (1068, 49, 152, 135);
INSERT INTO `pms_sku_attr_value` VALUES (1069, 50, 159, 135);
INSERT INTO `pms_sku_attr_value` VALUES (1070, 51, 165, 135);
INSERT INTO `pms_sku_attr_value` VALUES (1071, 52, 173, 135);
INSERT INTO `pms_sku_attr_value` VALUES (1072, 53, 181, 135);
INSERT INTO `pms_sku_attr_value` VALUES (1073, 46, 129, 136);
INSERT INTO `pms_sku_attr_value` VALUES (1074, 47, 138, 136);
INSERT INTO `pms_sku_attr_value` VALUES (1075, 48, 147, 136);
INSERT INTO `pms_sku_attr_value` VALUES (1076, 49, 152, 136);
INSERT INTO `pms_sku_attr_value` VALUES (1077, 50, 158, 136);
INSERT INTO `pms_sku_attr_value` VALUES (1078, 51, 166, 136);
INSERT INTO `pms_sku_attr_value` VALUES (1079, 52, 173, 136);
INSERT INTO `pms_sku_attr_value` VALUES (1080, 53, 181, 136);
INSERT INTO `pms_sku_attr_value` VALUES (1081, 46, 129, 137);
INSERT INTO `pms_sku_attr_value` VALUES (1082, 47, 138, 137);
INSERT INTO `pms_sku_attr_value` VALUES (1083, 48, 147, 137);
INSERT INTO `pms_sku_attr_value` VALUES (1084, 49, 152, 137);
INSERT INTO `pms_sku_attr_value` VALUES (1085, 50, 158, 137);
INSERT INTO `pms_sku_attr_value` VALUES (1086, 51, 166, 137);
INSERT INTO `pms_sku_attr_value` VALUES (1087, 52, 173, 137);
INSERT INTO `pms_sku_attr_value` VALUES (1088, 53, 181, 137);
INSERT INTO `pms_sku_attr_value` VALUES (1089, 46, 129, 138);
INSERT INTO `pms_sku_attr_value` VALUES (1090, 47, 138, 138);
INSERT INTO `pms_sku_attr_value` VALUES (1091, 48, 147, 138);
INSERT INTO `pms_sku_attr_value` VALUES (1092, 49, 152, 138);
INSERT INTO `pms_sku_attr_value` VALUES (1093, 50, 158, 138);
INSERT INTO `pms_sku_attr_value` VALUES (1094, 51, 166, 138);
INSERT INTO `pms_sku_attr_value` VALUES (1095, 52, 173, 138);
INSERT INTO `pms_sku_attr_value` VALUES (1096, 53, 181, 138);
INSERT INTO `pms_sku_attr_value` VALUES (1097, 46, 129, 139);
INSERT INTO `pms_sku_attr_value` VALUES (1098, 47, 138, 139);
INSERT INTO `pms_sku_attr_value` VALUES (1099, 48, 147, 139);
INSERT INTO `pms_sku_attr_value` VALUES (1100, 49, 152, 139);
INSERT INTO `pms_sku_attr_value` VALUES (1101, 50, 158, 139);
INSERT INTO `pms_sku_attr_value` VALUES (1102, 51, 166, 139);
INSERT INTO `pms_sku_attr_value` VALUES (1103, 52, 173, 139);
INSERT INTO `pms_sku_attr_value` VALUES (1104, 53, 181, 139);

-- ----------------------------
-- Table structure for pms_sku_image
-- ----------------------------
DROP TABLE IF EXISTS `pms_sku_image`;
CREATE TABLE `pms_sku_image`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `sku_id` bigint(0) NULL DEFAULT NULL COMMENT '库存单元skuId',
  `img_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片名称（冗余）',
  `img_url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片路径(冗余)',
  `spu_img_id` bigint(0) NULL DEFAULT NULL COMMENT '商品图片id',
  `is_default` varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '是否默认',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1168 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '库存单元图片表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pms_sku_image
-- ----------------------------
INSERT INTO `pms_sku_image` VALUES (1079, 122, 'bh7fpkga6i1220ge4xhh.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAXgnqAAC-Hoqs7BE647.jpg', 212, '0');
INSERT INTO `pms_sku_image` VALUES (1080, 122, 'l18k1ioczyw4rlpvwu6w.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAH6UQAADlSqtss64235.jpg', 213, '0');
INSERT INTO `pms_sku_image` VALUES (1081, 122, 'ciuenu9xhg41an1bbgs1.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAD1bGAAGqeIjQkeM065.jpg', 216, '0');
INSERT INTO `pms_sku_image` VALUES (1082, 122, 'p0gmlgf3vuub5yaxgncb.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAQOb6AAEUAHJ_kVA423.jpg', 217, '1');
INSERT INTO `pms_sku_image` VALUES (1083, 122, 'taolt94hxyv2jz7rhqgd.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAXZxCAAD3sOBCB9w401.jpg', 219, '0');
INSERT INTO `pms_sku_image` VALUES (1084, 123, 'pml7sicrfod8osyhyfro.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAHoTZAADE9gpZr8g264.jpg', 214, '1');
INSERT INTO `pms_sku_image` VALUES (1085, 123, 'rnkjukdrakjz4y922geh.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAQhvUAACiwrmEN0E827.jpg', 215, '0');
INSERT INTO `pms_sku_image` VALUES (1086, 123, 'tfidhgryldwqctjwxiid.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAd938AADDfsNm_B8423.jpg', 218, '0');
INSERT INTO `pms_sku_image` VALUES (1087, 123, 'jh0lobmvzxutdvrfbz0d.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAZnLlAAC0gvA1cd0209.jpg', 220, '0');
INSERT INTO `pms_sku_image` VALUES (1088, 123, 'wucrcjujt3609n4sohix.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAEAI9AAEIyC2XEsY354.jpg', 221, '0');
INSERT INTO `pms_sku_image` VALUES (1089, 124, 'pml7sicrfod8osyhyfro.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAHoTZAADE9gpZr8g264.jpg', 214, '1');
INSERT INTO `pms_sku_image` VALUES (1090, 124, 'rnkjukdrakjz4y922geh.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAQhvUAACiwrmEN0E827.jpg', 215, '0');
INSERT INTO `pms_sku_image` VALUES (1091, 124, 'tfidhgryldwqctjwxiid.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAd938AADDfsNm_B8423.jpg', 218, '0');
INSERT INTO `pms_sku_image` VALUES (1092, 124, 'jh0lobmvzxutdvrfbz0d.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAZnLlAAC0gvA1cd0209.jpg', 220, '0');
INSERT INTO `pms_sku_image` VALUES (1093, 124, 'wucrcjujt3609n4sohix.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAEAI9AAEIyC2XEsY354.jpg', 221, '0');
INSERT INTO `pms_sku_image` VALUES (1094, 125, 'pml7sicrfod8osyhyfro.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAHoTZAADE9gpZr8g264.jpg', 214, '1');
INSERT INTO `pms_sku_image` VALUES (1095, 125, 'rnkjukdrakjz4y922geh.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAQhvUAACiwrmEN0E827.jpg', 215, '0');
INSERT INTO `pms_sku_image` VALUES (1096, 125, 'tfidhgryldwqctjwxiid.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAd938AADDfsNm_B8423.jpg', 218, '0');
INSERT INTO `pms_sku_image` VALUES (1097, 125, 'jh0lobmvzxutdvrfbz0d.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAZnLlAAC0gvA1cd0209.jpg', 220, '0');
INSERT INTO `pms_sku_image` VALUES (1098, 125, 'wucrcjujt3609n4sohix.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAEAI9AAEIyC2XEsY354.jpg', 221, '0');
INSERT INTO `pms_sku_image` VALUES (1099, 126, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (2).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAVnj_AAE5nVjWl9k872.jpg', 222, '0');
INSERT INTO `pms_sku_image` VALUES (1100, 126, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (4).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAaDWYAAD1GuhjFLk077.jpg', 225, '1');
INSERT INTO `pms_sku_image` VALUES (1101, 126, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (3).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAfmRTAADLD3dXlEc065.jpg', 228, '0');
INSERT INTO `pms_sku_image` VALUES (1102, 126, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (5).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAYxzmAADbcLxBMcw930.jpg', 229, '0');
INSERT INTO `pms_sku_image` VALUES (1103, 126, 'air-jordan-33-pf-男子篮球鞋-7L0rd9.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAJ5rTAAD1GuhjFLk280.jpg', 230, '0');
INSERT INTO `pms_sku_image` VALUES (1104, 127, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (2).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAVnj_AAE5nVjWl9k872.jpg', 222, '0');
INSERT INTO `pms_sku_image` VALUES (1105, 127, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (4).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAaDWYAAD1GuhjFLk077.jpg', 225, '0');
INSERT INTO `pms_sku_image` VALUES (1106, 127, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (3).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAfmRTAADLD3dXlEc065.jpg', 228, '0');
INSERT INTO `pms_sku_image` VALUES (1107, 127, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (5).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAYxzmAADbcLxBMcw930.jpg', 229, '0');
INSERT INTO `pms_sku_image` VALUES (1108, 127, 'air-jordan-33-pf-男子篮球鞋-7L0rd9.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAJ5rTAAD1GuhjFLk280.jpg', 230, '1');
INSERT INTO `pms_sku_image` VALUES (1109, 128, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (10).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAY4mMAADyiN9DJGY593.jpg', 223, '1');
INSERT INTO `pms_sku_image` VALUES (1110, 128, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (9).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAB5TqAAEvDsDUW58303.jpg', 224, '0');
INSERT INTO `pms_sku_image` VALUES (1111, 128, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (8).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAKKWSAADCzIqND8s910.jpg', 226, '0');
INSERT INTO `pms_sku_image` VALUES (1112, 128, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (7).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAMQEsAACq8qpAztI800.jpg', 227, '0');
INSERT INTO `pms_sku_image` VALUES (1113, 128, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (6).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAMpWNAADLmtnc1xc469.jpg', 231, '0');
INSERT INTO `pms_sku_image` VALUES (1114, 129, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (10).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAY4mMAADyiN9DJGY593.jpg', 223, '1');
INSERT INTO `pms_sku_image` VALUES (1115, 129, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (9).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAB5TqAAEvDsDUW58303.jpg', 224, '0');
INSERT INTO `pms_sku_image` VALUES (1116, 129, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (8).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAKKWSAADCzIqND8s910.jpg', 226, '0');
INSERT INTO `pms_sku_image` VALUES (1117, 129, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (7).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAMQEsAACq8qpAztI800.jpg', 227, '0');
INSERT INTO `pms_sku_image` VALUES (1118, 129, 'air-jordan-33-pf-男子篮球鞋-7L0rd9 (6).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAMpWNAADLmtnc1xc469.jpg', 231, '0');
INSERT INTO `pms_sku_image` VALUES (1119, 130, 'air-jordan-1-mid-女子运动鞋-5PtCth (1).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAO0NtAADAnz7rYqQ782.jpg', 232, '0');
INSERT INTO `pms_sku_image` VALUES (1120, 130, 'air-jordan-1-mid-女子运动鞋-5PtCth (2).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAZTWZAAC8xapgoE4848.jpg', 233, '0');
INSERT INTO `pms_sku_image` VALUES (1121, 130, 'air-jordan-1-mid-女子运动鞋-5PtCth (3).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAEksgAADRZjbivvc089.jpg', 237, '1');
INSERT INTO `pms_sku_image` VALUES (1122, 130, 'air-jordan-1-mid-女子运动鞋-5PtCth.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAeo88AACN_GuWQB0448.jpg', 255, '0');
INSERT INTO `pms_sku_image` VALUES (1123, 130, 'air-jordan-1-mid-女子运动鞋-5PtCth (14).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OACMW8AAC-r0iSnw4408.jpg', 245, '0');
INSERT INTO `pms_sku_image` VALUES (1124, 131, 'air-jordan-1-mid-女子运动鞋-5PtCth (9).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAOHjBAAEi9zJjgBE251.jpg', 234, '1');
INSERT INTO `pms_sku_image` VALUES (1125, 131, 'air-jordan-1-mid-女子运动鞋-5PtCth (8).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAG5liAAFck5UdRuI917.jpg', 235, '0');
INSERT INTO `pms_sku_image` VALUES (1126, 131, 'air-jordan-1-mid-女子运动鞋-5PtCth (7).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OACt0mAAEi9zJjgBE851.jpg', 236, '0');
INSERT INTO `pms_sku_image` VALUES (1127, 131, 'air-jordan-1-mid-女子运动鞋-5PtCth (5).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAetRrAAEQ18BqkF8553.jpg', 239, '0');
INSERT INTO `pms_sku_image` VALUES (1128, 131, 'air-jordan-1-mid-女子运动鞋-5PtCth (6).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAQe_XAAEKm4d7tH8223.jpg', 244, '0');
INSERT INTO `pms_sku_image` VALUES (1129, 132, 'air-jordan-1-mid-女子运动鞋-5PtCth.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAeo88AACN_GuWQB0448.jpg', 255, '0');
INSERT INTO `pms_sku_image` VALUES (1130, 132, 'air-jordan-1-mid-女子运动鞋-5PtCth (4).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAJI7kAAEk4Q1zXqU817.jpg', 238, '0');
INSERT INTO `pms_sku_image` VALUES (1131, 132, 'air-jordan-1-mid-女子运动鞋-5PtCth (3).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAEksgAADRZjbivvc089.jpg', 237, '1');
INSERT INTO `pms_sku_image` VALUES (1132, 132, 'air-jordan-1-mid-女子运动鞋-5PtCth (2).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAZTWZAAC8xapgoE4848.jpg', 233, '0');
INSERT INTO `pms_sku_image` VALUES (1133, 132, 'air-jordan-1-mid-女子运动鞋-5PtCth (1).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAO0NtAADAnz7rYqQ782.jpg', 232, '0');
INSERT INTO `pms_sku_image` VALUES (1134, 133, 'air-jordan-1-mid-女子运动鞋-5PtCth (15).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAar_kAAC98bWG-no154.jpg', 246, '0');
INSERT INTO `pms_sku_image` VALUES (1135, 133, 'air-jordan-1-mid-女子运动鞋-5PtCth (16).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAS63WAACxsavs1_c086.jpg', 247, '0');
INSERT INTO `pms_sku_image` VALUES (1136, 133, 'air-jordan-1-mid-女子运动鞋-5PtCth (17).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAOqnkAADF5t-qnkQ031.jpg', 248, '0');
INSERT INTO `pms_sku_image` VALUES (1137, 133, 'air-jordan-1-mid-女子运动鞋-5PtCth (19).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAb6A1AADyL52-Bks666.jpg', 249, '0');
INSERT INTO `pms_sku_image` VALUES (1138, 133, 'air-jordan-1-mid-女子运动鞋-5PtCth (18).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAEIYWAAC-FkT4ZyU808.jpg', 250, '1');
INSERT INTO `pms_sku_image` VALUES (1139, 134, 'air-jordan-1-mid-女子运动鞋-5PtCth (24).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAZA9oAAGOoa8ECgU542.jpg', 256, '0');
INSERT INTO `pms_sku_image` VALUES (1140, 134, 'air-jordan-1-mid-女子运动鞋-5PtCth (23).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAC1QeAADzIbJx8vE582.jpg', 252, '1');
INSERT INTO `pms_sku_image` VALUES (1141, 134, 'air-jordan-1-mid-女子运动鞋-5PtCth (20).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAUci-AADaqrRA3Eo662.jpg', 251, '0');
INSERT INTO `pms_sku_image` VALUES (1142, 134, 'air-jordan-1-mid-女子运动鞋-5PtCth (22).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAIB23AAD4rRCwMPY243.jpg', 253, '0');
INSERT INTO `pms_sku_image` VALUES (1143, 134, 'air-jordan-1-mid-女子运动鞋-5PtCth (21).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAUPSiAADPvn9-d7E811.jpg', 254, '0');
INSERT INTO `pms_sku_image` VALUES (1144, 135, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (9).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAZ1G8AAEEQUa8Sck191.jpg', 279, '1');
INSERT INTO `pms_sku_image` VALUES (1145, 135, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (8).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAPnxPAAFoi8aNasw972.jpg', 278, '0');
INSERT INTO `pms_sku_image` VALUES (1146, 135, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (6).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAae8MAADue3GgzBE885.jpg', 282, '0');
INSERT INTO `pms_sku_image` VALUES (1147, 135, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (7).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAY_57AAEF03nIGIk195.jpg', 281, '0');
INSERT INTO `pms_sku_image` VALUES (1148, 135, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (5).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAUjBbAAENZvYrZW4152.jpg', 277, '0');
INSERT INTO `pms_sku_image` VALUES (1149, 136, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (2).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAAg4rAAD2w2Mjeus358.jpg', 272, '0');
INSERT INTO `pms_sku_image` VALUES (1150, 136, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (4).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAGpIxAAEXLFNyeE8886.jpg', 275, '1');
INSERT INTO `pms_sku_image` VALUES (1151, 136, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96 (3).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimASapzAAGbP-Z1HZw021.jpg', 276, '0');
INSERT INTO `pms_sku_image` VALUES (1152, 136, 'jordan-why-not-zer0-3-pf-男子篮球鞋-kGJZ96.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAQjnNAAEArnxaMbY002.jpg', 280, '0');
INSERT INTO `pms_sku_image` VALUES (1153, 136, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (10).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimADY3yAADqVcHz-0U434.jpg', 263, '0');
INSERT INTO `pms_sku_image` VALUES (1154, 137, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (11).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAShP7AADQgxDAFqo044.jpg', 264, '0');
INSERT INTO `pms_sku_image` VALUES (1155, 137, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (12).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAeDhGAADzaFGaUw0251.jpg', 265, '0');
INSERT INTO `pms_sku_image` VALUES (1156, 137, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (13).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAbxvcAADPb7_mZo4448.jpg', 266, '0');
INSERT INTO `pms_sku_image` VALUES (1157, 137, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (14).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAET4yAAEp8suNfRE028.jpg', 273, '0');
INSERT INTO `pms_sku_image` VALUES (1158, 137, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (15).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimACLliAADzJTIlRkk658.jpg', 274, '1');
INSERT INTO `pms_sku_image` VALUES (1159, 138, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (9).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAJj8OAAD_TLgi7zQ188.jpg', 258, '0');
INSERT INTO `pms_sku_image` VALUES (1160, 138, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (8).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAJcEZAAEJb2buIpc365.jpg', 259, '0');
INSERT INTO `pms_sku_image` VALUES (1161, 138, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (10).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimADY3yAADqVcHz-0U434.jpg', 263, '0');
INSERT INTO `pms_sku_image` VALUES (1162, 138, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (5).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimASCcyAAErP2LxToY168.jpg', 268, '1');
INSERT INTO `pms_sku_image` VALUES (1163, 138, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (6).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAQTt-AAGHhFvUW_o745.jpg', 269, '0');
INSERT INTO `pms_sku_image` VALUES (1164, 139, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (2).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAcHSBAADyP97GNw4080.jpg', 261, '0');
INSERT INTO `pms_sku_image` VALUES (1165, 139, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (3).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAOhJbAAFfMZlotOA788.jpg', 262, '0');
INSERT INTO `pms_sku_image` VALUES (1166, 139, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (4).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAIbt0AAEGHKH9vk4319.jpg', 267, '1');
INSERT INTO `pms_sku_image` VALUES (1167, 139, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp.jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAdRN7AAD-Ze5WR4s826.jpg', 270, '0');
INSERT INTO `pms_sku_image` VALUES (1168, 139, 'jordan-why-not-zer0-3-pf-男子篮球鞋-gdrwsp (1).jpg', 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAIQ1SAACv3GCwJjA116.jpg', 257, '0');

-- ----------------------------
-- Table structure for pms_sku_info
-- ----------------------------
DROP TABLE IF EXISTS `pms_sku_info`;
CREATE TABLE `pms_sku_info`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '库存id(itemID)',
  `product_id` bigint(0) NULL DEFAULT NULL COMMENT '商品id',
  `price` double NULL DEFAULT NULL COMMENT '价格',
  `sku_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'sku名称',
  `sku_desc` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品规格描述',
  `weight` double NULL DEFAULT NULL,
  `tm_id` bigint(0) NULL DEFAULT NULL COMMENT '品牌(冗余)',
  `catalog3_id` bigint(0) NULL DEFAULT NULL COMMENT '三级分类id（冗余)',
  `sku_default_img` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '默认显示图片(冗余)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sku_info_sku_name`(`sku_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 140 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '库存单元表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pms_sku_info
-- ----------------------------
INSERT INTO `pms_sku_info` VALUES (122, 74, 899, '男子篮球鞋 LeBron XVII PRM EP', 'LeBron XVII PRM EP 篮球鞋依托勒布朗的力量和速度，塑就出众包覆性和支撑力，助你制霸赛场。采用轻盈的针织和模压纱线组合设计，塑就耐穿外观和质感。组合缓震设计，为勒布朗带来出色减震支撑效果和灵敏响应回弹能量，助力畅享漫长赛季。', 0.15, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAQOb6AAEUAHJ_kVA423.jpg');
INSERT INTO `pms_sku_info` VALUES (123, 74, 899, '男子篮球鞋 LeBron XVII PRM EP ', 'LeBron XVII PRM EP 篮球鞋依托勒布朗的力量和速度，塑就出众包覆性和支撑力，助你制霸赛场。采用轻盈的针织和模压纱线组合设计，塑就耐穿外观和质感。组合缓震设计，为勒布朗带来出色减震支撑效果和灵敏响应回弹能量，助力畅享漫长赛季。', 0.15, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAHoTZAADE9gpZr8g264.jpg');
INSERT INTO `pms_sku_info` VALUES (124, 74, 899, '男子篮球鞋 LeBron XVII PRM EP ', 'LeBron XVII PRM EP 篮球鞋依托勒布朗的力量和速度，塑就出众包覆性和支撑力，助你制霸赛场。采用轻盈的针织和模压纱线组合设计，塑就耐穿外观和质感。组合缓震设计，为勒布朗带来出色减震支撑效果和灵敏响应回弹能量，助力畅享漫长赛季。', 0.15, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAHoTZAADE9gpZr8g264.jpg');
INSERT INTO `pms_sku_info` VALUES (125, 74, 899, '男子篮球鞋 LeBron XVII PRM EP ', 'LeBron XVII PRM EP 篮球鞋依托勒布朗的力量和速度，塑就出众包覆性和支撑力，助你制霸赛场。采用轻盈的针织和模压纱线组合设计，塑就耐穿外观和质感。组合缓震设计，为勒布朗带来出色减震支撑效果和灵敏响应回弹能量，助力畅享漫长赛季。', 0.15, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rEIaAHoTZAADE9gpZr8g264.jpg');
INSERT INTO `pms_sku_info` VALUES (126, 75, 1299, '男子篮球鞋 Air Jordan XXXIII PF', 'Air Jordan XXXIII PF 篮球鞋焕新演绎一流篮球鞋经典设计。革命性扣合系统帮助稳定双足，助力实现凌跃表现，结合经过精心调整的全新 FlightSpeed 技术，带来源源不断的能量回馈。', 0.2, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAaDWYAAD1GuhjFLk077.jpg');
INSERT INTO `pms_sku_info` VALUES (127, 75, 1299, '男子篮球鞋 Air Jordan XXXIII PF ', 'Air Jordan XXXIII PF 篮球鞋焕新演绎一流篮球鞋经典设计。革命性扣合系统帮助稳定双足，助力实现凌跃表现，结合经过精心调整的全新 FlightSpeed 技术，带来源源不断的能量回馈。', 0.2, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAJ5rTAAD1GuhjFLk280.jpg');
INSERT INTO `pms_sku_info` VALUES (128, 75, 1299, '男子篮球鞋 Air Jordan XXXIII PF ', 'Air Jordan XXXIII PF 篮球鞋焕新演绎一流篮球鞋经典设计。革命性扣合系统帮助稳定双足，助力实现凌跃表现，结合经过精心调整的全新 FlightSpeed 技术，带来源源不断的能量回馈。', 0.2, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAY4mMAADyiN9DJGY593.jpg');
INSERT INTO `pms_sku_info` VALUES (129, 75, 1299, '男子篮球鞋 Air Jordan XXXIII PF ', 'Air Jordan XXXIII PF 篮球鞋焕新演绎一流篮球鞋经典设计。革命性扣合系统帮助稳定双足，助力实现凌跃表现，结合经过精心调整的全新 FlightSpeed 技术，带来源源不断的能量回馈。', 0.2, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rGiGAY4mMAADyiN9DJGY593.jpg');
INSERT INTO `pms_sku_info` VALUES (130, 76, 999, '女子运动鞋 Air Jordan 1 Mid', 'Air Jordan 1 Mid 集掌控全场的霸气风范、非凡舒适性及标志性外形于一体。鞋底加入 Air 缓震技术，专为硬木球场设计，加垫鞋口赋予脚踝出色支撑力。', 0.1, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAEksgAADRZjbivvc089.jpg');
INSERT INTO `pms_sku_info` VALUES (131, 76, 999, '女子运动鞋 Air Jordan 1 Mid ', 'Air Jordan 1 Mid 集掌控全场的霸气风范、非凡舒适性及标志性外形于一体。鞋底加入 Air 缓震技术，专为硬木球场设计，加垫鞋口赋予脚踝出色支撑力。', 0.1, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAOHjBAAEi9zJjgBE251.jpg');
INSERT INTO `pms_sku_info` VALUES (132, 76, 999, '女子运动鞋 Air Jordan 1 Mid ', 'Air Jordan 1 Mid 集掌控全场的霸气风范、非凡舒适性及标志性外形于一体。鞋底加入 Air 缓震技术，专为硬木球场设计，加垫鞋口赋予脚踝出色支撑力。', 0.1, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAEksgAADRZjbivvc089.jpg');
INSERT INTO `pms_sku_info` VALUES (133, 76, 999, '女子运动鞋 Air Jordan 1 Mid ', 'Air Jordan 1 Mid 集掌控全场的霸气风范、非凡舒适性及标志性外形于一体。鞋底加入 Air 缓震技术，专为硬木球场设计，加垫鞋口赋予脚踝出色支撑力。', 0.1, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAEIYWAAC-FkT4ZyU808.jpg');
INSERT INTO `pms_sku_info` VALUES (134, 76, 999, '女子运动鞋 Air Jordan 1 Mid ', 'Air Jordan 1 Mid 集掌控全场的霸气风范、非凡舒适性及标志性外形于一体。鞋底加入 Air 缓震技术，专为硬木球场设计，加垫鞋口赋予脚踝出色支撑力。', 0.1, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rG7OAC1QeAADzIbJx8vE582.jpg');
INSERT INTO `pms_sku_info` VALUES (135, 77, 1299, '男子篮球鞋 Jordan Why Not Zer0.3 PF ', '作为叱咤球场的参赛者之一，三双王拉塞尔·威斯布鲁克刚猛的动作、发达的肌肉和强大的意志，与他出众的表现相匹配，而他强大的统计数据也证明了这一点。Jordan Why Not Zer0.3 PF 男子篮球鞋专为缔造户外球场出众表现而设计。Jordan Why Not Zer0.3 PF 男子篮球鞋为诸如拉塞尔的球员打造微调版型，他凭借其非凡线速和锐意进取表现击败对手。', 0.2, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAZ1G8AAEEQUa8Sck191.jpg');
INSERT INTO `pms_sku_info` VALUES (136, 77, 1099, '男子篮球鞋 Jordan Why Not Zer0.3 PF ', '作为叱咤球场的参赛者之一，三双王拉塞尔·威斯布鲁克刚猛的动作、发达的肌肉和强大的意志，与他出众的表现相匹配，而他强大的统计数据也证明了这一点。Jordan Why Not Zer0.3 PF 男子篮球鞋专为缔造户外球场出众表现而设计。Jordan Why Not Zer0.3 PF 男子篮球鞋为诸如拉塞尔的球员打造微调版型，他凭借其非凡线速和锐意进取表现击败对手。\n', 0.2, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAGpIxAAEXLFNyeE8886.jpg');
INSERT INTO `pms_sku_info` VALUES (137, 77, 1099, '男子篮球鞋 Jordan Why Not Zer0.3 PF ', '作为叱咤球场的参赛者之一，三双王拉塞尔·威斯布鲁克刚猛的动作、发达的肌肉和强大的意志，与他出众的表现相匹配，而他强大的统计数据也证明了这一点。Jordan Why Not Zer0.3 PF 男子篮球鞋专为缔造户外球场出众表现而设计。Jordan Why Not Zer0.3 PF 男子篮球鞋为诸如拉塞尔的球员打造微调版型，他凭借其非凡线速和锐意进取表现击败对手。\n', 0.2, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimACLliAADzJTIlRkk658.jpg');
INSERT INTO `pms_sku_info` VALUES (138, 77, 1099, '男子篮球鞋 Jordan Why Not Zer0.3 PF ', '作为叱咤球场的参赛者之一，三双王拉塞尔·威斯布鲁克刚猛的动作、发达的肌肉和强大的意志，与他出众的表现相匹配，而他强大的统计数据也证明了这一点。Jordan Why Not Zer0.3 PF 男子篮球鞋专为缔造户外球场出众表现而设计。Jordan Why Not Zer0.3 PF 男子篮球鞋为诸如拉塞尔的球员打造微调版型，他凭借其非凡线速和锐意进取表现击败对手。\n', 0.2, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimASCcyAAErP2LxToY168.jpg');
INSERT INTO `pms_sku_info` VALUES (139, 77, 1099, '男子篮球鞋 Jordan Why Not Zer0.3 PF ', '作为叱咤球场的参赛者之一，三双王拉塞尔·威斯布鲁克刚猛的动作、发达的肌肉和强大的意志，与他出众的表现相匹配，而他强大的统计数据也证明了这一点。Jordan Why Not Zer0.3 PF 男子篮球鞋专为缔造户外球场出众表现而设计。Jordan Why Not Zer0.3 PF 男子篮球鞋为诸如拉塞尔的球员打造微调版型，他凭借其非凡线速和锐意进取表现击败对手。\n', 0.2, NULL, 1261, 'http://192.168.99.100:8888/group1/M00/00/00/wKhjZF5rHimAIbt0AAEGHKH9vk4319.jpg');

-- ----------------------------
-- Table structure for pms_sku_sale_attr_value
-- ----------------------------
DROP TABLE IF EXISTS `pms_sku_sale_attr_value`;
CREATE TABLE `pms_sku_sale_attr_value`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `sku_id` bigint(0) NULL DEFAULT NULL COMMENT '库存单元id',
  `sale_attr_id` bigint(0) NULL DEFAULT NULL COMMENT '销售属性id（冗余)',
  `sale_attr_value_id` bigint(0) NULL DEFAULT NULL COMMENT '销售属性值id',
  `sale_attr_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售属性名称(冗余)',
  `sale_attr_value_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售属性值名称(冗余)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 532 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'sku销售属性值' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pms_sku_sale_attr_value
-- ----------------------------
INSERT INTO `pms_sku_sale_attr_value` VALUES (496, 122, 1, 278, '颜色', '赭石沙色/杉木红/金属金');
INSERT INTO `pms_sku_sale_attr_value` VALUES (497, 122, 2, 280, '尺寸', 'CT3467-001');
INSERT INTO `pms_sku_sale_attr_value` VALUES (498, 123, 1, 278, '颜色', '赭石沙色/杉木红/金属金');
INSERT INTO `pms_sku_sale_attr_value` VALUES (499, 123, 2, 281, '尺寸', 'CT3465-400');
INSERT INTO `pms_sku_sale_attr_value` VALUES (500, 124, 1, 279, '颜色', '赛车蓝/黑/白色');
INSERT INTO `pms_sku_sale_attr_value` VALUES (501, 124, 2, 281, '尺寸', 'CT3465-400');
INSERT INTO `pms_sku_sale_attr_value` VALUES (502, 125, 1, 279, '颜色', '赛车蓝/黑/白色');
INSERT INTO `pms_sku_sale_attr_value` VALUES (503, 125, 2, 280, '尺寸', 'CT3467-001');
INSERT INTO `pms_sku_sale_attr_value` VALUES (504, 126, 1, 282, '颜色', '白色/苍野灰/岛绿/金属银');
INSERT INTO `pms_sku_sale_attr_value` VALUES (505, 126, 2, 284, '尺寸', 'BV5072-101');
INSERT INTO `pms_sku_sale_attr_value` VALUES (506, 127, 1, 282, '颜色', '白色/苍野灰/岛绿/金属银');
INSERT INTO `pms_sku_sale_attr_value` VALUES (507, 127, 2, 285, '尺寸', 'BV5072-004');
INSERT INTO `pms_sku_sale_attr_value` VALUES (508, 128, 1, 283, '颜色', '苍野灰/白色/帆白/空间蓝');
INSERT INTO `pms_sku_sale_attr_value` VALUES (509, 128, 2, 284, '尺寸', 'BV5072-101');
INSERT INTO `pms_sku_sale_attr_value` VALUES (510, 129, 1, 283, '颜色', '苍野灰/白色/帆白/空间蓝');
INSERT INTO `pms_sku_sale_attr_value` VALUES (511, 129, 2, 285, '尺寸', 'BV5072-004');
INSERT INTO `pms_sku_sale_attr_value` VALUES (512, 130, 1, 286, '颜色', '黑/贵族红/白色');
INSERT INTO `pms_sku_sale_attr_value` VALUES (513, 130, 2, 291, '尺寸', 'BQ6472-016');
INSERT INTO `pms_sku_sale_attr_value` VALUES (514, 131, 1, 287, '颜色', '黑/红杉绿/骑兵灰绿');
INSERT INTO `pms_sku_sale_attr_value` VALUES (515, 131, 2, 292, '尺寸', 'BQ6472-030');
INSERT INTO `pms_sku_sale_attr_value` VALUES (516, 132, 1, 288, '颜色', '亮深红/黑');
INSERT INTO `pms_sku_sale_attr_value` VALUES (517, 132, 2, 293, '尺寸', 'BQ6472-600');
INSERT INTO `pms_sku_sale_attr_value` VALUES (518, 133, 1, 289, '颜色', '白色/白色/暗白蓝');
INSERT INTO `pms_sku_sale_attr_value` VALUES (519, 133, 2, 294, '尺寸', ' BQ6472-114');
INSERT INTO `pms_sku_sale_attr_value` VALUES (520, 134, 1, 290, '颜色', '黑/潘趣红/白色/荧光黄');
INSERT INTO `pms_sku_sale_attr_value` VALUES (521, 134, 2, 295, '尺寸', 'BQ6472-006');
INSERT INTO `pms_sku_sale_attr_value` VALUES (522, 135, 1, 300, '颜色', '微粒灰/黑/铁灰/爆炸粉');
INSERT INTO `pms_sku_sale_attr_value` VALUES (523, 135, 2, 305, '尺寸', 'CD3002-003');
INSERT INTO `pms_sku_sale_attr_value` VALUES (524, 136, 1, 299, '颜色', '白色/赛车粉/阴影绿/黑');
INSERT INTO `pms_sku_sale_attr_value` VALUES (525, 136, 2, 304, '尺寸', 'CD3002-102');
INSERT INTO `pms_sku_sale_attr_value` VALUES (526, 137, 1, 298, '颜色', '黑/白色/金属金');
INSERT INTO `pms_sku_sale_attr_value` VALUES (527, 137, 2, 303, '尺寸', 'CD3002-001');
INSERT INTO `pms_sku_sale_attr_value` VALUES (528, 138, 1, 297, '颜色', '白色/冷灰/狼灰/白色');
INSERT INTO `pms_sku_sale_attr_value` VALUES (529, 138, 2, 302, '尺寸', 'CD3002-100');
INSERT INTO `pms_sku_sale_attr_value` VALUES (530, 139, 1, 296, '颜色', '白色/黑/大气灰/亮深红');
INSERT INTO `pms_sku_sale_attr_value` VALUES (531, 139, 2, 301, '尺寸', 'CD3002-101');

-- ----------------------------
-- Table structure for ums_member
-- ----------------------------
DROP TABLE IF EXISTS `ums_member`;
CREATE TABLE `ums_member`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `member_level_id` bigint(0) NULL DEFAULT NULL,
  `username` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码',
  `nickname` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '昵称',
  `phone` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号码',
  `status` int(0) NULL DEFAULT NULL COMMENT '帐号启用状态:0->禁用；1->启用',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '注册时间',
  `icon` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '头像',
  `gender` int(0) NULL DEFAULT NULL COMMENT '性别：0->未知；1->男；2->女',
  `birthday` date NULL DEFAULT NULL COMMENT '生日',
  `city` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所做城市',
  `job` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '职业',
  `personalized_signature` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '个性签名',
  `source_type` int(0) NULL DEFAULT NULL COMMENT '用户来源:1本网站拥护，2微博用户',
  `integration` int(0) NULL DEFAULT NULL COMMENT '积分',
  `growth` int(0) NULL DEFAULT NULL COMMENT '成长值',
  `luckey_count` int(0) NULL DEFAULT NULL COMMENT '剩余抽奖次数',
  `history_integration` int(0) NULL DEFAULT NULL COMMENT '历史积分数量',
  `access_token` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `access_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '第三方授权码',
  `source_uid` bigint(0) NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_username`(`username`) USING BTREE,
  UNIQUE INDEX `idx_phone`(`phone`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '会员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ums_member
-- ----------------------------
INSERT INTO `ums_member` VALUES (42, 4, 'chenenru', '83cebd5ba9e78d24d49ff7d6784cd4c0', 'enru', '13556510557', 1, '2020-03-14 17:57:17', NULL, 0, '2020-03-14', '湛江', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3326257306@qq.com');
INSERT INTO `ums_member` VALUES (43, 4, '陈恩如', '83cebd5ba9e78d24d49ff7d6784cd4c0', '小如', '13556510558', 1, '2020-03-14 17:59:51', NULL, 1, '2020-03-14', '湛江', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3326257306@qq.com');

-- ----------------------------
-- Table structure for ums_member_level
-- ----------------------------
DROP TABLE IF EXISTS `ums_member_level`;
CREATE TABLE `ums_member_level`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `growth_point` int(0) NULL DEFAULT NULL,
  `default_status` int(0) NULL DEFAULT NULL COMMENT '是否为默认等级：0->不是；1->是',
  `free_freight_point` decimal(10, 2) NULL DEFAULT NULL COMMENT '免运费标准',
  `comment_growth_point` int(0) NULL DEFAULT NULL COMMENT '每次评价获取的成长值',
  `priviledge_free_freight` int(0) NULL DEFAULT NULL COMMENT '是否有免邮特权',
  `priviledge_sign_in` int(0) NULL DEFAULT NULL COMMENT '是否有签到特权',
  `priviledge_comment` int(0) NULL DEFAULT NULL COMMENT '是否有评论获奖励特权',
  `priviledge_promotion` int(0) NULL DEFAULT NULL COMMENT '是否有专享活动特权',
  `priviledge_member_price` int(0) NULL DEFAULT NULL COMMENT '是否有会员价格特权',
  `priviledge_birthday` int(0) NULL DEFAULT NULL COMMENT '是否有生日特权',
  `note` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '会员等级表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ums_member_receive_address
-- ----------------------------
DROP TABLE IF EXISTS `ums_member_receive_address`;
CREATE TABLE `ums_member_receive_address`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `member_id` bigint(0) NULL DEFAULT NULL,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货人名称',
  `phone_number` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `default_status` bigint(0) NULL DEFAULT NULL COMMENT '是否为默认',
  `post_code` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮政编码',
  `province` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '省份/直辖市',
  `city` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '城市',
  `region` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '区',
  `detail_address` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '详细地址(街道)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '会员收货地址表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ums_member_receive_address
-- ----------------------------
INSERT INTO `ums_member_receive_address` VALUES (26, 42, 'chenenru', '13556510557', 1, '524241', '广东省', '湛江', '雷州市', '东坎村234号');
INSERT INTO `ums_member_receive_address` VALUES (27, 43, '陈恩如', '13556510558', 1, '524241', '广东省', '湛江', '雷州市', '东坎村234号');
INSERT INTO `ums_member_receive_address` VALUES (28, 42, 'chenenru', '13556510557', 0, '524141', '广东', '肇庆', '端州', '肇庆学院主校区');

-- ----------------------------
-- Table structure for ware_info
-- ----------------------------
DROP TABLE IF EXISTS `ware_info`;
CREATE TABLE `ware_info`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `address` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `areacode` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `id`(`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ware_info
-- ----------------------------
INSERT INTO `ware_info` VALUES (1, '朝阳1号仓库', '北京', '110000');
INSERT INTO `ware_info` VALUES (2, '大兴2号仓库', '北京', '110000');
INSERT INTO `ware_info` VALUES (3, '大兴3号仓库', '京', '123123');
INSERT INTO `ware_info` VALUES (4, '朝阳2号仓库', '京', '123123');
INSERT INTO `ware_info` VALUES (5, '朝阳3号仓库', '京', '123123');
INSERT INTO `ware_info` VALUES (6, '朝41号仓库', '京', '123123');
INSERT INTO `ware_info` VALUES (7, '朝阳5号仓库', '京', '123123');
INSERT INTO `ware_info` VALUES (8, '朝阳6号仓库', '京', '123123');

-- ----------------------------
-- Table structure for ware_order_task
-- ----------------------------
DROP TABLE IF EXISTS `ware_order_task`;
CREATE TABLE `ware_order_task`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `order_id` bigint(0) NULL DEFAULT NULL COMMENT '订单编号',
  `consignee` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货人',
  `consignee_tel` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货人电话',
  `delivery_address` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货地址',
  `order_comment` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单备注',
  `payment_way` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款方式 1:在线付款 2:货到付款',
  `task_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `order_body` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单描述',
  `tracking_no` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物流单号',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `ware_id` bigint(0) NULL DEFAULT NULL COMMENT '仓库编号',
  `task_comment` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '工作单备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 185 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '库存工作单表 库存工作单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ware_order_task
-- ----------------------------
INSERT INTO `ware_order_task` VALUES (175, 50, 'chenenru', '13556510557', '东坎村234号', NULL, NULL, 'PAID', NULL, NULL, '2020-03-15 01:04:26', NULL, NULL);
INSERT INTO `ware_order_task` VALUES (176, 51, '陈恩如', '13556510558', '东坎村234号', NULL, NULL, 'PAID', NULL, NULL, '2020-03-15 11:06:07', NULL, NULL);
INSERT INTO `ware_order_task` VALUES (177, 52, 'chenenru', '13556510557', '东坎村234号', NULL, NULL, 'PAID', NULL, NULL, '2020-03-15 12:57:22', NULL, NULL);
INSERT INTO `ware_order_task` VALUES (178, 54, 'chenenru', '13556510557', '东坎村234号', NULL, NULL, 'PAID', NULL, NULL, '2020-03-15 13:01:00', NULL, NULL);
INSERT INTO `ware_order_task` VALUES (179, 54, 'chenenru', '13556510557', '东坎村234号', NULL, NULL, 'PAID', NULL, NULL, '2020-03-15 13:01:00', NULL, NULL);
INSERT INTO `ware_order_task` VALUES (180, 56, 'chenenru', '13556510557', '东坎村234号', NULL, NULL, 'PAID', NULL, NULL, '2020-03-15 13:06:38', NULL, NULL);
INSERT INTO `ware_order_task` VALUES (181, 56, 'chenenru', '13556510557', '东坎村234号', NULL, NULL, 'PAID', NULL, NULL, '2020-03-15 13:06:38', NULL, NULL);
INSERT INTO `ware_order_task` VALUES (182, 57, 'chenenru', '13556510557', '肇庆学院主校区', NULL, NULL, 'PAID', NULL, NULL, '2020-03-15 13:08:30', NULL, NULL);
INSERT INTO `ware_order_task` VALUES (183, 57, 'chenenru', '13556510557', '肇庆学院主校区', NULL, NULL, 'PAID', NULL, NULL, '2020-03-15 13:08:30', NULL, NULL);
INSERT INTO `ware_order_task` VALUES (184, 58, 'chenenru', '13556510557', '肇庆学院主校区', NULL, NULL, 'PAID', NULL, NULL, '2020-03-19 20:43:26', NULL, NULL);

-- ----------------------------
-- Table structure for ware_order_task_detail
-- ----------------------------
DROP TABLE IF EXISTS `ware_order_task_detail`;
CREATE TABLE `ware_order_task_detail`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `sku_id` bigint(0) NULL DEFAULT NULL COMMENT 'sku_id',
  `sku_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'sku名称',
  `sku_nums` int(0) NULL DEFAULT NULL COMMENT '购买个数',
  `task_id` bigint(0) NULL DEFAULT NULL COMMENT '工作单编号',
  `sku_num` int(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 309 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ware_order_task_detail
-- ----------------------------
INSERT INTO `ware_order_task_detail` VALUES (286, 103, '黑鲨游戏手机Gmall1015系列低配双核版', NULL, 162, 1);
INSERT INTO `ware_order_task_detail` VALUES (287, 103, '黑鲨游戏手机Gmall1015系列低配双核版', NULL, 163, 1);
INSERT INTO `ware_order_task_detail` VALUES (288, 103, '黑鲨游戏手机Gmall1015系列低配双核版', NULL, 164, 1);
INSERT INTO `ware_order_task_detail` VALUES (289, 103, '黑鲨游戏手机Gmall1015系列低配双核版', NULL, 165, 1);
INSERT INTO `ware_order_task_detail` VALUES (290, 103, '黑鲨游戏手机Gmall1015系列低配双核版', NULL, 166, 1);
INSERT INTO `ware_order_task_detail` VALUES (291, 103, '黑鲨游戏手机Gmall1015系列低配双核版', NULL, 167, 1);
INSERT INTO `ware_order_task_detail` VALUES (292, 120, '男子篮球鞋 LeBron Witness IV EP  黑/金属金/白色/队橙 款式： CD0188-003', NULL, 168, 1);
INSERT INTO `ware_order_task_detail` VALUES (293, 120, '男子篮球鞋 LeBron Witness IV EP  黑/金属金/白色/队橙 款式： CD0188-003', NULL, 169, 2);
INSERT INTO `ware_order_task_detail` VALUES (294, 121, '男子篮球鞋 LeBron Witness IV EP 显示颜色： 白色/电压紫/白金色/金属金 款式： CD0188-100', NULL, 170, 1);
INSERT INTO `ware_order_task_detail` VALUES (295, 120, '男子篮球鞋 LeBron Witness IV EP  黑/金属金/白色/队橙 款式： CD0188-003', NULL, 170, 2);
INSERT INTO `ware_order_task_detail` VALUES (296, 121, '男子篮球鞋 LeBron Witness IV EP 显示颜色： 白色/电压紫/白金色/金属金 款式： CD0188-100', NULL, 171, 1);
INSERT INTO `ware_order_task_detail` VALUES (297, 120, '男子篮球鞋 LeBron Witness IV EP  黑/金属金/白色/队橙 款式： CD0188-003', NULL, 172, 1);
INSERT INTO `ware_order_task_detail` VALUES (298, 120, '男子篮球鞋 LeBron Witness IV EP  黑/金属金/白色/队橙 款式： CD0188-003', NULL, 173, 1);
INSERT INTO `ware_order_task_detail` VALUES (299, 120, '男子篮球鞋 LeBron Witness IV EP  黑/金属金/白色/队橙 款式： CD0188-003', NULL, 174, 1);
INSERT INTO `ware_order_task_detail` VALUES (300, 122, '男子篮球鞋 LeBron XVII PRM EP', NULL, 175, 1);
INSERT INTO `ware_order_task_detail` VALUES (301, 135, '男子篮球鞋 Jordan Why Not Zer0.3 PF ', NULL, 176, 1);
INSERT INTO `ware_order_task_detail` VALUES (302, 127, '男子篮球鞋 Air Jordan XXXIII PF ', NULL, 177, 3);
INSERT INTO `ware_order_task_detail` VALUES (303, 130, '女子运动鞋 Air Jordan 1 Mid', NULL, 178, 1);
INSERT INTO `ware_order_task_detail` VALUES (304, 130, '女子运动鞋 Air Jordan 1 Mid', NULL, 179, 1);
INSERT INTO `ware_order_task_detail` VALUES (305, 122, '男子篮球鞋 LeBron XVII PRM EP', NULL, 180, 1);
INSERT INTO `ware_order_task_detail` VALUES (306, 122, '男子篮球鞋 LeBron XVII PRM EP', NULL, 181, 1);
INSERT INTO `ware_order_task_detail` VALUES (307, 133, '女子运动鞋 Air Jordan 1 Mid ', NULL, 182, 1);
INSERT INTO `ware_order_task_detail` VALUES (308, 133, '女子运动鞋 Air Jordan 1 Mid ', NULL, 183, 1);
INSERT INTO `ware_order_task_detail` VALUES (309, 127, '男子篮球鞋 Air Jordan XXXIII PF ', NULL, 184, 2);

-- ----------------------------
-- Table structure for ware_sku
-- ----------------------------
DROP TABLE IF EXISTS `ware_sku`;
CREATE TABLE `ware_sku`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `sku_id` bigint(0) NULL DEFAULT NULL COMMENT 'skuid',
  `warehouse_id` bigint(0) NULL DEFAULT NULL COMMENT '仓库id',
  `stock` int(0) NULL DEFAULT 0 COMMENT '库存数',
  `stock_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '存货名称',
  `stock_locked` int(0) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_skuid`(`sku_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ware_sku
-- ----------------------------
INSERT INTO `ware_sku` VALUES (9, 80, 2, 10, '测试编号80sku库存', 10);
INSERT INTO `ware_sku` VALUES (11, 22, 2, 100, '小米美颜', 1);
INSERT INTO `ware_sku` VALUES (12, 13, 2, 100, '一堆小米6 全网通 6GB+128GB 亮黑色 移动联通电信4G手机 双卡双待', 1);
INSERT INTO `ware_sku` VALUES (13, 88, 2, 100, '又一联想拯救者', 1);
INSERT INTO `ware_sku` VALUES (14, 94, 1, 100, '一堆尚硅谷超长待机', 1);
INSERT INTO `ware_sku` VALUES (15, 85, 6, 10, '进了一批iphoneXs', 2);
INSERT INTO `ware_sku` VALUES (16, 97, 5, 10, '刚刚进货的iphoneRx一批', 0);
INSERT INTO `ware_sku` VALUES (18, 95, 4, 10, '一堆尚硅谷无人驾驶手机R720', 3);
INSERT INTO `ware_sku` VALUES (19, 98, 6, 100, '18年12月21日新入库一堆硅谷gmall0725全面屏游戏智能手机 6GB+64GB 红色 硅谷纪念限量版手机', 3);
INSERT INTO `ware_sku` VALUES (20, 96, 6, 10, '突然到货一拼商品', 0);
INSERT INTO `ware_sku` VALUES (21, 96, 1, 10, '突然到货一堆sku96商品手机', 1);
INSERT INTO `ware_sku` VALUES (22, 100, 1, 100, '一堆尚硅谷游戏机', 1);
INSERT INTO `ware_sku` VALUES (23, 102, 6, 10, '一堆手机0906系列256G大内存容量版', 1);
INSERT INTO `ware_sku` VALUES (28, 104, 3, 10, '10台尚硅谷黑鲨系列手机gmall1015', 0);
INSERT INTO `ware_sku` VALUES (29, 103, 2, 10, '黑纱gmall1015低配版', 5);
INSERT INTO `ware_sku` VALUES (30, 119, 1, 100, '华为荣耀Magic2 手机 渐变黑 全网通8G+256G', 0);

SET FOREIGN_KEY_CHECKS = 1;
