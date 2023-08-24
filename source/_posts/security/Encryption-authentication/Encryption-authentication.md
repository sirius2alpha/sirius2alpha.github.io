---
title: 加密与认证
catalog: true
date: 2023-04-12
subtitle: 使用OpenSSL作为工具进行实验
lang: cn
header-img: /img/header_img/lml_bg2.jpg
tags:
- information security 
- OpenSSL

---


## **任务**

采用Java/Python语言编写一个较为完整的加密与认证程序，要求具有：

1. 具有较完整的图形化界面；
2. 使用MD5、SHA系列算法，实现消息摘要，确保消息的完整性；
3. 使用DES、AES等算法实现对称加密，确保消息的机密性；
4. 使用RSA算法，实现公钥加密，且用私钥解密，比较不对称加密和对称加密的性能；
5. **实现基于数字证书的数字签名和验证（含证书的生成和创建）；**

## **消息摘要**

### 消息摘要的作用

在网络安全目标中，要求信息在生成、存储或传输过程中保证不被偶然或蓄意地删除、修改、伪造、乱序、重放、插入等破坏和丢失，因此需要一个较为安全的标准和算法，以保证数据的完整性。

**常见的消息摘要算法有：**
Ron Rivest设计的**MD（Standard For Message Digest，消息摘要标准）算法**
NIST设计的**SHA（Secure Hash Algorithm，安全散列算法）**



### 单向散列函数

#### 特点

1. 不定长的输入和定长的输出；

2. 对于及其微小的变化，如1bit的变化，器哈希函数所产生的值也差异巨大；

3. 对于不同的原像都有不同的映像，从散列值不可能推导出消息M ，也很难通过伪造消息M’来生成相同的散列值。

   <img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/03/upgit_20230324_1679662315.png" alt="image-20230324205152690" style="zoom: 50%;" />



**Hash函数的值**称为作为自变量的消息的“**散列值”或“消息摘要”、“数字指纹**”



#### **哈希函数的分类**

##### **根据安全水平**

1. 弱无碰撞
2. 强无碰撞

​	注：强无碰撞自然含弱无碰撞！

##### **根据是否使用密钥**

1. 带秘密密钥的Hash函数：消息的散列值由只有通信双方知道的秘密密钥K来控制，此时散列值称作MAC(Message Authentication Code)
2. 不带秘密密钥的Hash函数：消息的散列值的产生无需使用密钥，此时散列值称作MDC(Message Detection Code)



#### 哈希函数的应用

1. 由Hash函数产生消息的散列值
2. 以消息的散列值来判别消息的完整性
3. 用加密消息的散列值来产生数字签名
4. 用口令的散列值来安全存储口令（认证系统中的口令列表中仅存储口令的Hash函数值，以避免口令被窃取。认证时用输入口令的Hash函数值与其比较）



#### 安全哈希函数的实现

1. 输入数据分成L个长度固定为r的分组：M=(M1,M2,…,ML)
2. 末组附加消息的长度值并通过填充凑足r位
3. 压缩函数 f使用n位的链接变量Hi ,其初值H0=IV可任意指定
4. 压缩函数 f的最后n位输出HL取作散列值

<img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/03/upgit_20230324_1679663071.png" alt="image-20230324210431151" style="zoom:50%;" />

#### 哈希函数：生日攻击

**当哈希函数的输入位数太短的时候，就容易产生哈希碰撞，即出现两个原像对应用一个映像的问题。**



**生日问题**
一个教室中至少有几个学生才能使有两个学生生日相同的概率不小于1/2；
**等价于“球匣问题”**
设J个球随机扔进N个匣子，存在一个匣子中至少有两个球的概率为p，则可以推导出: J2≈-2Nln(1-p)或 p≈ 1-e-J2/2/N
**答案**
将365个生日看作N=365个匣子，将学生看作球，p=0.5，则由上式可算出J≈23，即23个学生中有两个学生生日相同的概率不小于1/2；



**生日攻击实例：**

​	假设张三承诺支付李四100万，约定由李四负责起草合同，并通过8位的散列码H(M)实施信息认证。聪明而无德的李四先起草一个100万的版本，并通过变化其中3个无关紧要之处以得到23=8个不同的消息明文并计算它们的H(M)，形成集合A；然后再起草一个200万的版本，用同样方法又得到23=8 个不同的消息明文及其H(M)，形成集合B。
​	由生日问题知：24个8位比特串中发生碰撞的概率不小于1/2，故在A和B共24 =16个H(M)中有可能存在相同的一对，并极有可能一个在A中而另一个在B中。假设与它们对应的明文为MA （100万版） 和MB （200万版） 。于是李四用MA让张三签署并公证，而在传送时偷偷地用MB替代MA 。由于H(MA)= H(MB)，故张三确信签署的文件未被篡改。当李四要求张三支付200万时，法院根据MB判李四胜诉，而张三因此损失100万。



### MD5算法

Merkle于1989年提出hash function模型
Ron Rivest于1990年提出MD4
1992年， Ron Rivest提出MD5（RFC 1321）
在最近数年之前，MD5是最主要的hash算法
现行美国标准SHA-1以MD5的前身MD4为基础

输入：任意长度消息
输出：128bit消息摘要（16字节编码，32字符）
处理：以512bit输入数据块为单位



### SHA安全散列算法

1992年NIST制定了SHA（128位）
1993年SHA成为标准（FIPS PUB 180）
1994年修改产生SHA-1（160位）
1995年SHA-1成为新的标准，作为SHA-1（FIPS PUB 180-1/RFC 3174），为兼容AES的安全性，NIST发布FIPS PUB 180-2，标准化SHA-256， SHA-384和SHA-512

输入：消息长度<264
输出：160bit消息摘要
处理：以512bit输入数据块为单位
基础是MD4

#### SHA算法的拓展

**SHA-256**
摘要大小由SHA-1的160位扩大到256位
**SHA-384**
消息大小由SHA-1的264位扩大到2128位
分组大小由SHA-1的512位扩大到1024位
字长由SHA-1的32位（双字）扩大到64位（4字）
摘要大小由SHA-1的160位扩大到384位
**SHA-512**
摘要大小由SHA-384的384位扩大到512位



### 息摘要的安全隐患

**隐患：无法完全阻止数据的修改。**

如果在数据传递过程中，窃取者将数据窃取出来，并且修改数据，再重新生成一次摘要，将改后的数据和重新计算的摘要发送给接收者，接收者利用算法对修改过的数据进行验证时，生成的消息摘要和收到的消息摘要仍然相同，消息被判断为“没有被修改”。

**做法：除了需要知道消息和消息摘要之外，还需要知道发送者身份---消息验证码**。



## **消息认证**

用于对抗信息主动攻击之一：消息伪造或篡改
目的之一：验证信息来源的真实性
目的之二：验证信息的完整性

**消息认证的模型**

<img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/03/upgit_20230324_1679665159.png" alt="image-20230324213919755" style="zoom: 67%;" />

**消息认证的方式**

1. **加密认证**──用消息的密文本身充当认证信息
   	消息加密的认证；私钥加密公钥解密；公钥私钥双重加解密
2. **消息认证码MAC(Message Authentication Code**)──由以消息和密钥作为输入的公开函数产生的认证信息
   	简单MAC认证；基于明文认证；基于密文认证
3. **散列值**──由以消息作为唯一输入的散列函数产生的认证信息（无需密钥）
   	6种常用的方式



**消息验证码的局限性**

消息验证码可以保护信息交换双方不受第三方的攻击，但是它**不能处理通信双方的相互攻击**
信宿方可以伪造消息并称消息发自信源方，信源方产生一条消息，并用和信宿方共享的密钥产生认证码，并将认证码附于消息之后
信源方可以否认曾发送过某消息，因为信宿方可以伪造消息，所以无法证明信源方确实发送过该消息

**在收发双方不能完全信任的情况下，引入数字签名来解决上述问题**



### **基于消息加密的认证**

#### 用**对称密码体制**进行加密认证

- 过程──**用同一密钥加密、解密消息** 
- 作用──认证+保密
- 原理──攻击者无法通过改变密文来产生所期望的明文变化
- 特点──接收方需要判别消息本身的逻辑性或合法性。“我请你吃饭”被乱改成“我请你謯斸”

<img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/03/upgit_20230324_1679665571.png" alt="image-20230324214611143" style="zoom:67%;" />

##### **对称加密实现：AES算法**

```python
# AES对称加密

password = b'1234567812345678'  # 秘钥，b就是表示为bytes类型
text = b'abcdefghijklmnhi'  # 需要加密的内容，bytes类型
aes = AES.new(password, AES.MODE_ECB)  # 创建一个aes对象

# AES.MODE_ECB 表示模式是ECB模式
en_text = aes.encrypt(text)  # 加密明文
print("密文：", en_text)  # 加密明文，bytes类型

den_text = aes.decrypt(en_text)  # 解密密文
print("明文：", den_text)
```



#### 私钥加密，公钥解密

- 过程──发送者用自己的私钥加密明文、接收者用发送者的公钥解密密文
- 作用──认证及签名，但不保密
- 原理──**因不知发送者的私钥，故其他人无法产生密文或伪造签名**

​	注意：若用公钥加密、私钥解密，则无法起到认证的作用。因为知道公钥的人都可以通过产生伪造的密文来篡改消息。

​			私钥加密，公钥解密，只有私钥的拥有者才能加密，适用于数字签名，用于验证身份。

​			公钥加密，私钥解密，保证了消息的传送的保密性

​		两者都是不对成加密

​	混合加密是将**共享密钥加密（对称加密）**和**公开密钥加密（不对称加密）**结合起来的加密方式。



##### **公开密钥算法实现：RSA算法**



```

```



#### 用私钥、公钥双重加密、解密

- 过程──发送者先用自己的私钥加密明文，再用接收者的公钥加密一次；接收者先用自己的私钥解密密文，再用发送者的公钥解密一次
- 作用──认证、签名，且保密
- 原理──认证、签名由发送者的私钥加密实现；保密性由接收者的公钥加密保证

<img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/03/upgit_20230324_1679667185.png" alt="image-20230324221305827" style="zoom:67%;" />



### 消息验证码MAC

计算消息验证码的常用算法有HMAC算法

- 产生──发送者以消息M和与接收者共享的密钥K为输入，通过某公开函数C进行加密运算得到MAC
- 传送并接收──M+MAC
- 认证──接收者以接收到的M和共享密钥K为输入，用C（公开函数）重新加密算得MAC’ ，若MAC’=MAC，则可确信M未被篡改
- 作用──认证，但不保密

<img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/03/upgit_20230324_1679664863.png" alt="image-20230324213423372" style="zoom:50%;" /><img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/03/upgit_20230324_1679664897.png" alt="image-20230324213456843" style="zoom:50%;" />



**消息验证码和MD5/SHA1算法不同的地方**

1. 在生成摘要时，发送者和接收者都拥有一个共同的密钥。
2. 该密钥可以是通过对称密码体系生成的，事先被双方共有，在生成消息验证码时，还必须要有密钥的参与。
3. 只有同样的密钥才能生成同样的消息验证码。



### **基于散列值的认证**

1、对附加了散列值的消息实施对称加密，得到并发送Ek(M+H(M))
		认证+保密
2、仅对散列值实施对称加密，得到Ek(H(M))，并与M一起发送
		认证+不保密
3、对散列值实施私钥加密，得到EKRa(H(M))并与M一起发送
		认证+签名，不保密

4、将消息与用私钥加密后的散列值一起再用共享密钥加密，最后得到Ek(M+EKRa(H(M)))并发送
		认证+签名+保密
5、将消息串接一个由通信各方共享的密值S后计算散列值，得到H(M+S)并与M一起发送
		认证，不保密
6、先将消息串接一个由通信各方共享的密值S后计算散列值，再将它与消息M一起用共享密钥加密，最后得到Ek(M+H(M+S))并发送
		认证+保密



## **数字签名**

### 数字签名的概念和作用

### 数字签名的特点

**数字签名必须具有下述特征**
收方能够确认或证实发方的签名，但不能伪造，简记为**R1-条件（unforgeable）**
发方发出签名的消息给收方后，就不能再否认他所签发的消息，简记为**S-条件(non-repudiation)**
收方对已收到的签名消息不能否认，即有收报认证，简记作**R2-条件**
第三者可以确认收发双方之间的消息传送，但不能伪造这一过程，简记作**T-条件**

<img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/03/upgit_20230325_1679724623.png" alt="image-20230325141023658" style="zoom: 67%;" />

### 数字签名与消息认证的区别

### 数字签名分类与常用算法

**根据签名的内容分**

- 对整体消息的签名
- 对压缩消息的签名

**按明、密文的对应关系划分**

- **确定性(Deterministic)数字签名**，其明文与密文一一对应，它对一特定消息的签名不变化，如RSA、Rabin等签名；
- **随机化的(Randomized)或概率式数字签名**



**数字签名常用算法**

普通数字签名算法

- RSA
- ElGamal /DSS/DSA
- ECDSA

盲签名算法
群签名算法



**RSA算法的签名过程和实现过程**

<img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/03/upgit_20230324_1679670913.png" alt="image-20230324231513082" style="zoom: 67%;" />

## **数字证书**

### 数字证书的作用

​	任何的密码体制都不是坚不可摧的，公开密钥体制也不例外。由于公开密钥体制的公钥是对所有人公开的，从而免去了密钥的传递，简化了密钥的管理。
​	但是这个公开性在给人们带来便利的同时，也给攻击者冒充身份篡改公钥有可乘之机。所以，密钥也需要认证，**在拿到某人的公钥时，需要先辨别一下它的真伪。这时就需要一个认证机构**，将身份证书作为密钥管理的载体，并配套建立各种密钥管理设施。

### 数字证书的定义

数字证书（Digital Certificate）又称为数字标识（Digital ID）。它提供一种在Internet上验证身份的方式，是用来标志和证明网络通信双方身份的数字信息文件。

### 数字证书的内容

**最简单的证书包含一个公开密钥、名称以及证书授权中心的数字签名**。一般情况下证书中还包括密钥的有效时间，发证机关(证书授权中心)的名称，该证书的序列号等信息，证书的格式遵循ITU-T X.509国际标准。

一个标准的X.509数字安全证书包含以下一些内容：
（1）证书的版本号。不同的版本的证书格式也不同，在读取证书时首先需要检查版本号。
（2）证书的序列号。每个证书都有一个唯一的证书序列号。
（3）证书所使用的签名算法标识符。签名算法标识符表明数字签名所采用的算法以及使用的参数。
（4）证书的发行机构名称。创建并签署证书的CA的名称，命名规则一般采用X.500格式。
（5）证书的有效期。证书的有效期由证书有效起始时间和终止时间来定义。
（6）证书所有人的名称。命名规则一般采用X.500格式；
（7）证书所有人的公开密钥及相关参数。相关参数包括加密算法的标识符及参数等
（8）证书发行机构ID。这是版本2中增加的可选字段。
（9）证书所有人ID。这是版本2中增加的可选字段。
（10）扩展域。这是版本3中增加的字段，它是一个包含若干扩展字段的集合。
（11）证书发行机构对证书的签名，即CA对证书内除本签名字段以外的所有字段的数字签名。

### 认证中心

CA（Certificate Authority，认证中心）作为权威的、可信赖的、公正的第三方机构，专门负责发放并管理所有参与网上交易的实体所需的数字证书。

CA作为一个权威机构，对密钥进行有效地管理，颁发证书证明密钥的有效性，并将公开密钥同某一个实体（消费者、商户、银行）联系在一起。



**CA的主要职责**

（1）颁发证书：如密钥对的生成、私钥的保护等，并保证证书持有者应有不同的密钥对。
（2）管理证书：记录所有颁发过的证书，以及所有被吊销的证书。
（3）用户管理：对于每一个新提交的申请，都要和列表中现存的标识名相比较，如出现重复，就给予拒绝。
（4）吊销证书：在证书有效期内使其无效，并发表CRL（Certificate Revocation List，被吊销的证书列表）
（5）验证申请者身份：对每一个申请者进行必要的身份认证。
（6）保护证书服务器：证书服务器必须安全的，CA应采取相应措施保证其安全性。
（7）保护CA私钥和用户私钥：CA签发证书所用的私钥要受到严格的保护，不能被毁坏，也不能被非法使用。同时，根据用户密钥对的产生方式，CA在某些情况下有保护用户私钥的责任。
（8）审计和日志检查：为了安全起见，CA对一些重要的操作应记入系统日志。在CA发生事故后，要根据系统日志做善后追踪处理――审计，CA管理员要定期检查日志文件，尽早发现可能的隐患。



**CA的基本组成**

认证中心主要有三个部分组成

- 注册服务器（RS）：面向用户，包括计算机系统和功能接口；
- 注册中心（RA）：负责证书的审批；
- 认证中心（CA）：负责证书的颁发，是被信任的部门

一个完整的安全解决方案除了有认证中心外，一般还包括以下几个方面：

- 密码体制的选择

- 安全协议的选择

  - SSL（Secure Socket Layer 安全套接字层）

  - S-HTTP（Secure HTTP，安全的http协议）

  - SET（Secure Electonic Transaction，安全电子交易协议）



**CA的三层体系结构**

- 第一层为RCA（Root Certificate Authority，根认证中心）。它的职责是负责制定和审批CA的总政策，签发并管理第二层CA的证书，与其它根CA进行交叉认证。
- 第二层为BCA（Brand Certificate Authority，品牌认证中心）。它的职责是根据RCA的规定，制定具体政策、管理制度及运行规范；签发第三层证书并进行证书管理。
- 第三层为ECA（End user CA，终端用户CA）。它为参与电子商务的各实体颁发证书。签发的证书可分为三类：分别是支付网关（Payment Gateway）、持卡人（Cardholder）和商家（Merchant）签发的证书；签发这三种证书的CA对应的可称之为PCA、CCA和MCA。

![image-20230325103341547](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/03/upgit_20230325_1679711621.png)



## 【任务完成】

主要是采用OpenSSL命令行操作完成的，虽然使用python写的代码，不过还是是通过系统调用命令的方式进行的。

```py
import os


def input_message():
    text = input("请输入一段文字，用于加密：")
    fh = open("message.txt", 'w', encoding='utf-8')
    fh.write(text)
    fh.close()


# 使用md5生成摘要
def dgst_md5(file):
    '''file表示文件名+后缀，输出：dgst_file.txt'''
    command = "openssl dgst -md5 -out dgst_" + file + ".txt " + file
    os.system(command)


# 生成私钥
def key_generate(name):
    '''name表示私钥名字，私钥长度为2048，输出为name_prikey.pem'''
    command = "openssl genrsa -out " + name + "_prikey.pem"
    os.system(command)


# 生成公钥
def key_public(prikey, name):
    '''prikey表示私钥的名字，输出为name_pubkey.pem
    openssl pkey -in key.pem -pubout -out pubkey.pem
    '''
    command = "openssl pkey -in " + prikey + ".pem -pubout -out " + name + "_pubkey.pem"
    os.system(command)


# 签名
def sign(file, key):
    '''file表示要签名的文件的名字，key表示签名所用到的私钥，输出为file.sig
    openssl pkeyutl -sign -in message.txt -inkey key.pem -out message.sig'''
    command = "openssl pkeyutl -sign -in " + file + ".txt -inkey " + key + ".pem -out " + file + ".sig"
    os.system(command)


# 验证签名
def verify(file, signature, pubkey):
    '''
    signature表示签名文件，key表示公钥,
    openssl pkeyutl -verify -in message.txt -sigfile message.sig -pubin -inkey pubkey.pem
    '''
    command = "openssl pkeyutl -verify -in " + file + " -sigfile " + signature + ".sig -pubin -inkey " + pubkey + ".pem"
    os.system(command)


# 普通公钥请求证书
def req_cert(prikey):
    '''
    prikey表示source的私钥，采用的是source.cnf中的配置信息，输出为source.csr
    openssl req -new -key source_prikey.pem -out source.csr
    '''
    command = " openssl req -new -key " + prikey + ".pem -out source.csr -config source.cnf"
    os.system(command)


# 由CA生成证书
def req_x509(csr_name, ca_pubkey, ca_prikey):
    '''csr_name表示证书请求文件的名称，ca_pubkey表示ca的公钥即自签证书，ca_prikey表示ca的私钥
    使用ca_prikey.pem对证书请求文件csr_name.csr进行签名，生成一个带有签名的证书文件dest.pem
     openssl x509 -req -in source.csr -CA ca_cert.pem -CAkey ca_prikey.pem -CAcreateserial -out source_cert.pem
    '''
    command = " openssl x509 -req -in " + csr_name + ".csr -CA " + ca_pubkey + ".pem -CAkey " + ca_prikey + ".pem -CAcreateserial -out dest.pem"
    os.system(command)


# 生成自签名证书
def req_cacert(prikey):
    '''
    使用 CA 私钥生成自签名的 CA 证书,生成ca_pubkey.pem
    openssl req -new -x509 -key ca_prikey.pem -out ca_cert.pem -days 365 -config ca.cnf'''
    command = "openssl req -new -x509 -key " + prikey + ".pem -out ca_pubkey.pem -days 365 -config ca.cnf"
    os.system(command)


# 从证书中提取公钥
def load_pubkey(cert):
    '''
    从证书中提取源公钥,cert表示需要提取公钥的证书，输出为source_pubkey_extracted.pem
    openssl x509 -in source_cert.pem -pubkey -noout > source_pubkey_extracted.pem
    '''
    command = "openssl x509 -in " + cert + ".pem -pubkey -noout > source_pubkey_extracted.pem"
    os.system(command)


# if __name__ == '__main__':

# 输入内容到message.txt
input_message()
# 生成source的私钥
key_generate("source")
# 生成source的公钥
key_public("source_prikey", "source")
# 生成ca的私钥
key_generate("ca")
# 生成ca的公钥
req_cacert("ca_prikey")

# 1.对message.txt使用md5生成摘要
# 生成文件 dgst_message.txt.txt
dgst_md5("message.txt")

# 2.对摘要dgst_message.txt使用source方的私钥进行签名
# 生成文件 dgst_message.txt.sig
sign("dgst_message.txt", "source_prikey")

# 3.将source方的公钥包含在证书请求文件source.pem中
req_cert("source_prikey")

# 4.CA对csr.pem的证书请求文件进行发布证书
req_x509("source", "ca_pubkey", "ca_prikey")

# 5.对source的签名文件dgst_message.sig文件进行摘要和签名
# 生成文件dgst_dgst_message.txt.sig.txt dgst_dgst_message.txt.sig.sig
dgst_md5("dgst_message.txt.sig")
sign("dgst_dgst_message.txt.sig", "ca_prikey")

# 6.从CA认证的证书dest.pem中提取原公钥
load_pubkey("dest")

# 7.使用由CA认证的证书中提取的公钥对文件进行验证签名
print("使用由CA认证的证书中提取的公钥对文件进行验证签名：")
verify("dgst_message.txt.txt", "dgst_message.txt", "source_pubkey_extracted")

'''
# 使用ca的公钥对于message.sig签名文件进行验证签名，判断是否与message.txt内容相同
print("对CA签名的验证：")
# 这个验证必须要将ca_pubkey.pem通过普通公钥的生成，参考source
verify("dgst_dgst_message.txt.sig.txt", "dgst_dgst_message.txt.sig", "ca_pubkey")

# 使用source的公钥对于dgst_message.sig签名文件进行验证签名，判断是否与dgst_message.txt内容相同
print("使用source的公钥对source签名的验证：")
verify("dgst_message.txt.txt", "dgst_message.txt", "source_pubkey")

'''

```

