---
title: Redis常用指令
catalog: true
date: 2023-08-03
subtitle: 还有一些redis常见概述（废话凑字数）
lang: cn
header-img: /img/header_img/lml_bg2.jpg
tags:
- 开发
- Redis
- MySQL
- DB
- 字节青训营
---
## 快速了解Redis

Redis是什么？为什么要使用Redis？他有什么好处和优势？他的弊端又有哪些呢？他的基本模型和技术有哪些？

### Redis是什么？

Redis（Remote Dictionary Server）是一种开源的内存数据存储系统，它可以**用作数据库、缓存和消息代理**。它被设计用于快速访问、存储和分析数据，以及支持各种数据结构，如字符串、哈希表、列表、集合、有序集合等。Redis支持持久化，可以将数据保存在磁盘上，以便在重启后恢复数据。

### 为什么要使用Redis？

Redis有许多优点，使其成为广泛使用的数据存储和缓存解决方案：

#### 优势

1. **快速访问：** Redis数据存储在内存中，因此具有非常快速的读写性能，适合用作缓存层，加速数据访问。
2. **丰富的数据结构：** Redis不仅支持简单的键值存储，还支持多种数据结构，如列表、集合、有序集合等，这使得它适用于更多不同类型的应用场景。
3. **持久化：** Redis支持数据的持久化，可以将数据保存在磁盘上，以便在服务器重启后恢复数据。
4. **分布式架构：** Redis支持分布式集群，可以将数据分散在多个节点上，提高数据的可用性和性能。
5. **发布/订阅：** Redis具有消息代理功能，可以用于发布和订阅消息，支持实时数据推送和通知。
6. **事务支持：** Redis支持事务，允许一系列操作以原子方式执行，保证数据的一致性。

#### 弊端

1. **内存消耗：** Redis的数据存储在内存中，因此对于大规模数据集可能会占用大量内存。尽管有持久化选项，但内存仍然是其主要的存储介质。
2. **单线程：** Redis在单个进程中使用单线程处理所有的命令请求。这在某些高并发情况下可能成为性能瓶颈。

### 基本模型和技术

1. **键值存储：** Redis的基本模型是键值存储，您可以使用键来检索存储在Redis中的数据。
2. **数据结构：** Redis支持字符串、哈希表、列表、集合、有序集合等多种数据结构，使其非常灵活。
3. **持久化：** Redis支持两种持久化方式，分别是快照（snapshotting）和日志（append-only file）。
4. **发布/订阅：** Redis支持发布/订阅模式，允许客户端订阅特定的频道并接收实时消息。
5. **分布式：** Redis可以通过分片或复制来构建分布式架构，提高可用性和扩展性。



## Redis vs. MySQL 

### **性能比较**

1. **读写性能：** Redis在内存中存储数据，因此具有非常快速的读写性能，尤其适合高并发读取和写入场景。与此相比，MySQL可能受到磁盘IO和索引的影响，其读写性能相对较低。
2. **数据结构：** Redis支持多种数据结构，使其适合用于更复杂的数据模型，如实时计数、排行榜、分布式锁等。MySQL虽然也支持多种数据类型，但通常用于结构化数据的存储。
3. **缓存：** Redis非常适合用作缓存层，可以减轻数据库的负载，提高数据访问速度。MySQL也可以用作缓存，但Redis的读取速度更快。
4. **事务和持久化：** Redis支持事务，但它的事务模型不如MySQL严格。MySQL提供强大的事务支持和多种持久化选项。



### 适用领域和场景

#### Redis适合场景

- 实时数据：例如实时计数、统计信息和分析。
- 缓存：用作高速缓存，提高数据访问速度。
- 实时消息：发布/订阅模式用于实时消息传递。
- 会话存储：存储用户会话数据，适用于分布式系统。
- 分布式锁：实现分布式锁以协调多个系统的并发操作。

#### MySQL适合场景

- 结构化数据：适用于关系型、事务性的结构化数据。
- 复杂查询：支持复杂的查询和连接操作。
- 大规模数据存储：适合大规模数据存储和管理。
- 强大事务：需要强大的事务支持和ACID特性。



Redis和MySQL有各自独特的优势和用途，它们并不是直接替代关系。Redis可以在某些情况下用来增强项目性能，或者作为辅助数据库来存储特定类型的数据，例如缓存、会话、排行榜等。然而，对于需要复杂查询、关联性和事务的应用，Redis并不是MySQL的替代品。对于大部分应用，两者可以共同使用，以发挥各自的优势，构建更高效的系统。



## Redis基本命令

现在很多大公司的后端服务都是基础存储服务+Redis缓存的形式，使用Redis进行缓存很大程度上提高了服务的效率，当然也存在缓存穿透、缓存雪崩的问题，但是在此之前还是要从Redis的基础命令开始学习掌握，所以在这里整理了Redis常用的命令。

### 字符串

在Redis中，字符串可以存储以下3中类型的值：字节串（byte string），整数，浮点数。

#### 自增自减命令

`INCR key-name`：将键存储的值加上1

`DECR key-name`：将键存储的值减去1

`INCRBY key-name amount`：将键存储的值加上整数amount

`DECRBY key-name amount`：将键存储的值减去整数amount

`INCRBYFLOAT key-name amount`：将键存储的值价上浮点数amount，版本2.6以上可用

#### 处理子串命令

`APPEND key-name value`：将value追加到key-name末尾

`GETRANGE key-name start end`：获取一个从start到end（包括）的子串

`SETRANGE key-name offset value`：将key-name的第offset位（从左到右，从0开始数）开始，设置成value

#### 二进制位命令

`GETBIT key-name offset`：获取偏移量为offset的二进制位的值

`SETBIT key-name offset value`：将偏移量为offset的二进制位的值设置为value

`BITCOUNT key-name [start end]`：统计二进制串中1的个数，范围可选

`BITOP operation dest-key key-name [key-name ...]`，对key-name进行操作（operation可以为AND,OR,XOR,NOT）,将结果存储在dest-key中



### 列表

#### 常用命令

`RPUSH key-name value [value ...]`：将一个值或多个值推入列表右侧

`LPUSH key-name value [value ...]`：将一个或多个值推入列表左侧

`RPOP key-name`：从列表最右侧移除并返回一个元素

`LPOP key-name`：从列表最左侧移除并返回一个元素

`LINDEX key-name offset`：返回列表中偏移量为offset的元素

`LRANGE key-name start end`：返回列表中从偏移量为start到end的元素，包括start和end

`LTRIM key-name start end`：对列表进行修剪，只保留从偏移量为start到end范围内的元素，包括start和end



### 集合

#### 常用命令

`SADD key-name item [item ...]`：将一个元素或者多个元素添加到集合里面，并返回添加元素当中原本并不存在于集合里面的元素数量

`SREM key-name item [item ...]`：从集合里面移除一个或者多个元素，并返回移除元素的数量

`SISMEMBER key-name item`：检查元素item是否存在于集合key-name里

`SCARD key-name`：返回集合中包含的元素数量

`SMEMBERS key-name`：返回集合包含的所有元素

`SRANDMEMBER key-name [count]`：随机返回一个或多个元素，当count为整数的时候，命令返回的随机元素不会重复，负数时则可能会出现重复

`SPOP key-name`：随机地从集合中一出一个元素，并返回被移除的元素

`SMOVE source-key dest-key item`：如果source-key中包含item，则从source-key中移除元素item，并添加到dest-key中。如果item被成功移除命令返回1，否则返回0



### 散列

#### 常用命令

`HEXISTS key-name key`：检查给定键是否存在于散列中

`HKEYS key-name`：获取散列包含的所有键

`HVALS key-name`：获取散列包含的所有值

`HGETALL key-name`：获取散列包含的所有键值对

`HINCRBY key-name key increment`：将键key存储的值加上整数increment

`HINCRBYFLOAT key-name key increment`：将键key存储的值加上浮点数increment



### 有序集合

#### 常用命令

`ZADD key-name score member [score member ...]`：将带有给定分值的成员添加到有序集合里面

`ZREM key-name member [member ....]`：从有序集合里面移除给定成员，并返回被移除成员的数量

`ZCARD key-name`：返回有序集合包含的成员数量

`ZINCRYBY key-name increment member`：将member成员的分值加上increment

`ZCOUNT key-name min max`：返回分值介于min和max之间的成员数量

`ZRANK key-name member`：返回成员member在有序集合的排名

`ZSCORE key-name member`：返回成员member的分值

`ZRANGE key-name start stop [WITHSCORES]`：返回有序集合中排名介于start和stop之间的成员，如果给定年了可选的WITHSCORES选项，那么命令会将成员的分值一并返回

#### 有序集合的范围性数据

`ZREVRANK key-namemember`：返回有序集合里成员member的排名，成员按照分值 从大到小排列

`ZREVRANGE key-name start stop[WITHSCORES]`：返回有序集合给定排名范围内 的成员，成员按照分值从大到小排列

`ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT offset count]`：返回 有序集合中，分值介于min和max之间的所有成员 获取有序集合中分值介于min和max之间的所有成员，并按照分值从大到小的顺序来返 回它们 

`ZREMRANGEBYRANK key-name start stop` ：移除有序集合中排名介于start和stop 之间的所有成员

`ZREMRANGEBYSCORE key-name min max`：移除有序集合中分值介于min和max之间的所有成员

`ZINTERSTORE dest-key key-count key [key ...] [WEIGHTS weight[weight ...]] [AGGREGATE SUMIMIN|MAX]`：对给定的有序集合执行类似于集合的交集运算

`ZUNIONSTORE dest-key key-count key [key ...] [WEIGHTS weight[weight ...]] [AGGREGATE SUM|MIN|MAX]`：对给定的有序集合执行类似于集合的并集运算



### 其他命令

#### 排序

`SORT source-key [BY pattern] [LIMIT offset count] [GET pattern [GET pattern ...]] [ASCIDESC] [ALPHA] [STORE dest-key]`：根据给定的选项，对输入列表、集合或者有序集合进行排序，然后返回或者存储排序的结果



#### 处理过期时间

`PERSIST key-name`：移除键的过期时间 

`TTLkey-name`：查看给定键距离过期还有多少秒 

`EXPIRE key-nameseconds`：让给定键在指定的秒数之后过期 

`EXPIREAT key-nametimestamp`：将给定键的过期时间设置为给定的UNIX时间戳 

`PTTLkey-name`：查看给定键距离过期时间还有多少毫秒，这个命令在Redis2.6或以上版本可用 

`PEXPIRE key-name milliseconds` ：让给定键在指定的毫秒数之后过期，这个命令在Redis2.6 或以上版本可用 

`PEXPIREAT key-name timestamp-milliseconds`：将一个毫秒级精度的UNIX时间戳设置 为给定键的过期时间，这个命令在Redis2.6或以上版本可用
