---
title: 使用GORM连接MySQL实现数据增删查改
catalog: true
date: 2023-08-25
subtitle: 怎么正确使用GORM？
lang: cn
header-img: /img/header_img/lml_bg2.jpg
tags:
- 开发
- GORM
- MySQL
- ORM
- 字节青训营
---
## 什么是GORM？

GORM 是一个 Go 编程语言中的 ORM（对象关系映射）库，全名为 "Go Object Relational Mapping"。ORM 是一种编程技术，旨在将数据库中的数据与编程语言中的对象进行映射，从而使开发者能够使用面向对象的方式来操作数据库，而不需要直接编写 SQL 查询语句。

GORM 为 Go 语言开发者提供了一个便捷的方式来操作数据库，支持多种数据库系统，包括 MySQL、PostgreSQL、SQLite 等。它提供了许多功能，如数据库连接管理、模型定义、查询构建、事务管理、关联关系映射等。

以下是一些 GORM 提供的功能和特点：

1. **模型定义简单**：你可以定义 Go 结构体来映射数据库表，然后使用 GORM 来处理与数据库的交互。
2. **自动迁移**：GORM 可以自动根据模型定义来创建、修改和删除数据库表结构。
3. **查询构建**：你可以使用链式方法构建复杂的查询语句，进行数据的检索、排序、过滤等操作。
4. **事务管理**：GORM 支持事务，你可以在代码中使用事务来确保数据库操作的原子性。
5. **关联关系**：GORM 支持定义和处理表之间的关联关系，如一对一、一对多、多对多等。
6. **钩子函数**：GORM 允许你在模型的生命周期中定义钩子函数，以便在不同的操作发生时执行特定的逻辑。



## 使用GORM对数据库进行增删查改

### 数据库的设计

使用mysql作为数据库，新建一个表user，其中最主要的列是Username和Email；

因为gorm默认使用id为主键，所以我们也在表user中新建一列id；

另外为了配合grom.Model的使用表中另外新增created_at,updated_at,deleted_at三列。



注意，主键id记得要设置自动递增。

![image-20230824230310726](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/08/upgit_20230824_1692892565.png)

我们可以先使用navicate的随机数据生成少量数据。

![image-20230824231017500](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/08/upgit_20230824_1692892567.png)

### 连接数据库

使用 GORM 建立数据库连接，你需要提供 MySQL 数据库的连接信息。这包括数据库的用户名、密码、主机名、端口号和数据库名称。

```go
dsn := "username:password@tcp(hostname:port)/dbname?charset=utf8mb4&parseTime=True&loc=Local"
db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
if err != nil {
    panic("Failed to connect to the database")
}
```

确保将 `username`、`password`、`hostname`、`port` 和 `dbname` 替换为自己的 MySQL 数据库连接信息。

注意使用err检查错误。

### 增添记录

这里新建了一个User类型的变量newUser，再通过db.Create方法实现增添记录。

```go
// create a user by gorm
	newUser := User{Username: "john_doe", Email: "john@example.com"}
	db.Create(&newUser)
```

### 查询记录

新建了一个新变量user，通过向数据库中查询主键（id）为2的记录，返回给user。

之前在表的设计中不时有一个deleted_at列吗？当这个列不为空的时候，就说明这条数据已经被软删除了，所以对他进行查询是查不到的，同时你也可以看见SQL语句中的条件要求：“seleted_at IS NULL”

```go
// query
	var user User
	db.First(&user, 1) // 查询ID为1的用户
```

### 更新记录

这里就是更新了id为1的username为new_username。

```go
// update user
	db.Model(&user).Where("id = ?", 1).Update("Username", "new_username")
```

### 删除记录

在实际的开发中，删除不一定是真的进行物理删除了，而是进行了软删除，即在deleted_at列中写入软删除的时间，来表示该条数据已经被“删除”了。

```go
// delete
	db.Model(&user).Where("id = ?", 1).Delete(&user)
```

在执行完成上述代码之后，结果如下：

![image-20230824232342141](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/08/upgit_20230824_1692892573.png)

可以看见id为1的user的Username被改为new_username了，更新时间也打上去了，最后也被删除了。