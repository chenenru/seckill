<<<<<<< HEAD
# gmall0105本地修改版本

#gmall-user用户服务8080
user.gmall.com/==localhost:8081/

#提供与 用户 相关的服务：登录、用户地址等
gmall-user-service用户服务8078 spring.dubbo.protocol.port=20881
gmall-user用户服务8081(用于测试)
gmall-user-web用户服务8091 20882 user.gmall.com

#提供 商品管理有 关的服务：spu、sku、图片、分布式文件存储系统等
gmall-manage-service商品管理的服务8072 20883
gmall-manage-web商品管理服务8092 20884 manage.gmall.com

#提供 商品详情 有关的服务
#gmall-item-service前台的商品详情8073
gmall-item-web前台的商品详情展示8093 20885 item.gmall.com

#提供 商品搜索、商品首页、商品列表 有关的服务
gmall-search-service搜索服务的后台8074 20886
gmall-search-web搜索服务前台8094 20887 search.gmall.com

#提供 购物车 有关的服务
gmall-cart-service为后台提供购物车服务8076 20888
gmall-cart-web为前台提供购物车服务8095 20889 cart.gmall.com

#提供 单点登录、社交登录 有关的服务
gmall-passport-web 用户认证中心8096 20890 passport.gmall.com
#gmall-user-service 用户服务层

#提供 订单 有关的服务
gmall-order-service 订单服务8090 20891
gmall-order-web 订单8097 20892 order.gmall.com

#提供 支付 有关的服务
gmall-payment 8098 20893 payment.gmall.com

gmall-redisson-test 8181 20899

#提供 库存管理 有关的服务
gware-manage  8182

#提供 秒杀 有关的服务
gmall-seckill 8099 20894 seckill.gmall.com

#后台管理
gmall-admin 8100 20900 admin.gmall.com

#项目准备
安装

#开启fastdfs分布式文件存储系统
搭建请看记一次用docker搭建fastdfs,项目运行结束时不能直接关闭电脑，不然docker的storage容器启动不了
要先停止容器，再关闭docker

#启动前台vue框架
在gmall-admin按shift+右键，打开powershell，输入npm run dev
项目启动gmall-manage-service、gmall-manage-web、gmall-user-service

#负载均衡 多进程开启，用Apache2.4压测 ab -c 200 -n 1000 http:localhost/testRedisson
gmall-redisson-test redisson服务层8180
gmall-redisson-test redisson服务层8181
gmall-redisson-test redisson服务层8182

#使用elasticsearch
1、到elasticsearch集群的bin目录下启动各节点的elasticsearch.bat
2、到elasticsearch-head-master的目录下，按shift+鼠标右键，在powershell输入npm run start命令
4、在浏览器输入http://localhost:9100/
5、启动kibana:到kibana的bin目录下双击kibana.bat
6、在浏览器输入http://localhost:5601/

#库存系统
localhost:9100

#rabbitMQ
http://127.0.0.1:15672 gust guest

#activeMQ
http://127.0.0.1:8161/ admin admin
=======
# seckill
>>>>>>> e49bb9b0f990e88b0c0aacbee93354a68b43a2ae
git pull origin master --allow-unrelated-histories 在git命令行提交解决push rejected