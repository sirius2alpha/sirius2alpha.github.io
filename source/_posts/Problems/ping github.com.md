---
title: ping github.com
catalog: true
date: 2023-07-30
subtitle: git时遇到的小问题，修改hosts文件解决
lang: cn
header-img: /img/header_img/lml_bg2.jpg
tags:
- 疑难杂症
- Github
- Git

---

### 问题初现

在Windows上，挂了Clash，平时网页版的GitHub还是能正常跑的，因为平时开发主要是在Ubuntu上，所以git工具在Windows上用的不多。这次突发奇想，想把Windows和Ubuntu上的笔记整合到一个GitHub仓库上，并实现更新文件后自动拉取推送的功能，所以我现在Ubuntu上推送了一部分笔记到仓库中，再计划将Windows上的笔记也弄上去。

然后在配置Windows上的笔记文件夹Git环境，发现**git老是报错ssh22端口连接超时**。

我检查了：

- GitHub仓库上的SSH公钥配置，正常
- Git的HTTP和HTTPS代理，正常

```shell
// 查看git有没有代理
git config --global -l

// 配置git代理
git config --global http.proxy 127.0.0.1:7890
git config --global https.proxy 127.0.0.1:7890

// 取消git网络代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```

也想不通为啥，然后我就在博客园中看到了一篇文章：https://www.cnblogs.com/oldboyooxx/p/10387150.html

主要就是说：**1、检查IP配置问题；2、检查防火墙状态**



然后我就去ping github.com，发现ping不通，开代理不开代理都不行，怪！

我想起来可以通过改主机hosts的方式访问，https://www.cnblogs.com/xuexianqi/p/13219719.html，改了之后github.com就能ping通了。

再然后就发现SSH22端口超时的问题也解决了，然后就开始合并笔记了~



### 脚本自动同步

对于笔记自动保存之后每次都要git手动提交未免也太麻烦了，然后我想试试通过一个git脚本来自动完成就好了。

```shell
git pull origin master
git add .
git commit -m "update"
git push origin master
```

脚本的内容很简单啊，就是基础的这几步命令。

现在的问题就是怎么让他在保存文件的时候自动执行呢？而且希望如果同步的时候出错，能够把错误信息打印出来，可以是日志的方式。



人工办法：在写笔记之前进行一次脚本运行，写笔记，写完笔记之后，再运行一次脚本。

稍微聪明一点的办法：在打开和关闭文件夹/Typora的时候运行脚本。