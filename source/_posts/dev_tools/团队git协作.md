---
title: Git正确打开方式
catalog: true
date: 2023-08-01
subtitle: Git工作流程图、Git常用命令
lang: cn
header-img: /img/header_img/lml_bg2.jpg
tags:
- 疑难杂症
- 开发
- Git
- 团队
- 字节青训营
---

# Git正确使用姿势

## Git工作区域和流程

<img src="https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/08/upgit_20230801_1690867445.jpeg" alt="git工作流程图" style="zoom:67%;" />

### 工作区域

- **远程仓库：**就是我们托管在github或者其他代码托管平台上的仓库。

- **本地仓库：**就是在我们本地通过`git init`命令初始化的新建的仓库。

- **工作区：**就是我们写代码、编辑文件的地方。

- **暂存区：**当工作区的内容写好了之后，就会通过add命令，将工作区的内容放到暂存区，等待commit命令提交到本地仓库中。

### 文件状态

- **未跟踪的（untracked）：**表示在工作区新建了某个文件，还没有add。
- **已修改（modofied）：**表示在工作区中修改了某个文件，还没有 add。
- **已暂存（staged）：**表示把已修改的文件已add到暂存区域。
- **已提交（commit）：**表示文件已经commit到本地仓库保存起来了。





## Git常见命令

### 仓库初始化和克隆

~~~shell
# git仓库初始化
git init

# 从远程仓库中进行克隆代码到本地仓库
git clone [远程仓库的HTTP/SSH的URL]

# 查看当前git仓库的状态
git status
~~~



### 远程仓库管理

~~~shell
Git正确使用姿势 Git工作区域和流程 工作区域 远程仓库： 就是我们托管在github或者其他代码托管平台上的仓库。 本地仓库： 就是在我们本地通过git init命令初始化的新建的仓库。 工作区# git remote 是用来管理远程仓库的命令

git remote		# 查看已配置的远程仓库
git remote -v 	# 查看远程仓库的URL
git remote add <远程仓库名称> <远程仓库URL>	# 添加一个新的远程仓库
# e.g git remote add origin <远程仓库URL>，一般采用origin作为远程仓库的名字
git remote remove origin 			# 删除名为origin的远程仓库
git remote rename origin newname 	# 将origin的名字改为newname
~~~



### 从工作区提交代码到远程仓库

~~~shell
# git add 将更改过的代码添加到暂存区
git add .	# 将工作区中所有更改添加到暂存区
git add index.html	# 添加更改的单个文件到暂存区
git add src/		# 添加该目录下的更改到暂存区

# git commit 将暂存区的代码提交大本地仓库
git commit -m "提交说明"	# 最常用的提交方式，一定要写提交说明，不然版本管理会非常痛苦

# git push 用于将本地的代码提交推送到远程仓库，将本地仓库中的提交上传到Git服务器上，使其成为远程仓库的一部分
git push <远程仓库名称> <本地分支名称>:<远程分支名称>
git push -f origin master	# 强制推送到origin的master分支，远程仓库origin的master分支上的之前的代码会被覆盖！非常危险的操作！
~~~

- `<远程仓库名称>`：指定要推送到的远程仓库的名称，通常为"origin"，这是Git默认的远程仓库名称。
- `<本地分支名称>`：指定要推送的本地分支的名称，这是你当前所在的分支，例如"main"、"master"等。
- `<远程分支名称>`：指定远程仓库中要接收提交的分支名称。

默认情况下，`git push`命令会将当前分支的代码推送到与之相对应的远程分支。例如，如果你当前在"main"分支上，并且与远程仓库"origin"关联，那么`git push origin main`命令将把"main"分支的提交推送到"origin"的"main"分支；如果远程分支不存在，则`git push`会自动创建一个新的远程分支。



### 从远程仓库中拉取代码

#### fetch

`git fetch`命令用于从远程仓库获取最新的代码提交和分支信息，但它**不会将获取到的内容应用到你的工作目录或当前分支**，也不会改变你本地仓库的历史记录。相当于是将远程仓库的最新信息下载到你的本地仓库，你可以通过`git merge`或`git rebase`将这些更新合并到你的当前分支。

以下是`git fetch`命令的用法：

```shell
git fetch <远程仓库名称>
```

在执行命令时，Git会连接到指定的远程仓库，并获取远程仓库中最新的分支和提交信息。它会将获取到的内容**保存在本地仓库的"FETCH_HEAD"引用**中。



#### 

关于git merge和git rebase的区别在这里引用了另外一个博主的文章进行介绍。

文章原链接：https://blog.csdn.net/kevinxxw/article/details/123980372



![两个分支](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/08/upgit_20230825_1692964880.png)

#### **merge**

将 master 分支合并到 feature 分支最简单的办法就是用下面这些命令：

```shell
git checkout feature
git merge master
```

也可以把它们压缩在一行里。

```shell
git merge master feature
```

feature 分支中新的合并提交（merge commit）将两个分支的历史连在了一起。你会得到下面这样的分支结构：

![b96eb877e38c4ab55242b7068cd8a8c6](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/08/upgit_20230825_1692965624.png)



#### **rebase**

作为 merge 的替代选择，你可以像下面这样将 feature 分支并入 master 分支：

```shell
git checkout feature
git rebase master
```

它会把整个 feature 分支移动到 master 分支的后面，有效地把所有 master 分支上新的提交并入过来。但是，rebase 为原分支上每一个提交创建一个新的提交，重写了项目历史，并且不会带来合并提交。

**关于git rebase的黄金法则就是永远不要在公共分支上使用它。**

![755e949c6c111fae02b4c178545e619a](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/08/upgit_20230825_1692964942.png)

rebase最大的好处是你的项目历史会非常整洁。首先，它不像 `git merge` 那样引入不必要的合并提交。其次，如上图所示，rebase 导致最后的项目历史呈现出完美的线性——你可以从项目终点到起点浏览而不需要任何的 fork。这让你更容易使用 `git log`、`git bisect` 和 `gitk` 来查看项目历史。

不过，这种简单的提交历史会带来两个后果：安全性和可跟踪性。如果你违反了 rebase 黄金法则，重写项目历史可能会给你的协作工作流带来灾难性的影响。此外，rebase 不会有合并提交中附带的信息——你看不到 feature 分支中并入了上游的哪些更改。



#### **交互式rebase**

交互式的 rebase 允许你更改并入新分支的提交。这比自动的 rebase 更加强大，因为它提供了对分支上提交历史完整的控制。一般来说，这被用于将 feature 分支并入 master 分支之前，清理混乱的历史。

把 `-i` 传入 `git rebase` 选项来开始一个交互式的rebase过程：

```shell
git checkout feature
git rebase -i master
```

它会打开一个文本编辑器，显示所有将被移动的提交：

```shell
pick 33d5b7a Message for commit #1
pick 9480b3d Message for commit #2
pick 5c67e61 Message for commit #3
```

这个列表定义了 rebase 将被执行后分支会是什么样的。更改 `pick` 命令或者重新排序，这个分支的历史就能如你所愿了。比如说，如果第二个提交修复了第一个提交中的小问题，你可以用 `fixup` 命令把它们合到一个提交中：

```shell
pick 33d5b7a Message for commit #1
fixup 9480b3d Message for commit #2
pick 5c67e61 Message for commit #3
```

保存后关闭文件，Git 会根据你的指令来执行 rebase，项目历史看上去会是这样：

![755e949c6c111fae02b4c178545e619a](https://raw.githubusercontent.com/sirius2alpha/Typora-pics/master/2023/08/upgit_20230825_1692964942.png)

忽略不重要的提交会让你的 feature 分支的历史更清晰易读。这是 `git merge` 做不到的。



### 分支管理

```shell
# git branch 命令用于查看、创建和管理分支

git branch 					# 查看本地所有分支
git branch -a				# 查看本地和远程的分支
git branch <新分支名称>		# 创建一个新分支
git branch -d <分支名称>	# 删除一个分支
git branch -D <分支名称> 	# 强制删除一个分支

# git checkout 用于在Git中切换分支、查看文件的不同版本或还原文件到之前的状态
关于git rebase的黄金法则就是永远不要在公共分支上使用它。
git checkout <分支名称>						 # 切换到其他分支上
											 # 新版本git中采用git switch <分支名称> 切换分支
git checkout <commit哈希值> <文件名>			# 查看文件的不同版本
git checkout <commit哈希值> -- <文件名>		# 还原文件到之前的状态
```



### 清空暂存区

```shell
git reset # 所有文件的变更撤销
```



# 如何进行团队协作

## 建立仓库

- 在github上建立组织和仓库，看起来也酷酷的；

- 在组织里面新建一个仓库。



## 添加SSH秘钥

最好是使用SSH，所以在仓库里面添加上各位团队成员的SSH秘钥

### SSH秘钥的生成

#### 在Windows上

1. 打开Windows PowerShell或者Git Bash（如果你已经安装了Git）。
2. 输入以下命令来生成SSH密钥对：

```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

- `-t rsa`: 指定生成RSA密钥对。
- `-b 4096`: 指定密钥的位数。4096位提供更高的安全性，但生成时间可能稍长。
- `-C "your_email@example.com"`: 用你的邮箱地址替换这部分内容，这将作为你的密钥的注释。

1. 系统会提示你选择密钥保存的位置，默认会保存在`~/.ssh`目录下，你可以按照提示选择保存位置或直接回车使用默认位置。
2. 然后系统会让你输入一个密码来保护你的私钥。这是可选的，如果你不想设置密码，可以直接回车跳过。

#### 在Ubuntu上

1. 打开终端（Terminal）。
2. 输入以下命令来生成SSH密钥对：

```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

- `-t rsa`: 指定生成RSA密钥对。
- `-b 4096`: 指定密钥的位数。4096位提供更高的安全性，但生成时间可能稍长。
- `-C "your_email@example.com"`: 用你的邮箱地址替换这部分内容，这将作为你的密钥的注释。

1. 系统会提示你选择密钥保存的位置，默认会保存在`~/.ssh`目录下，你可以按照提示选择保存位置或直接回车使用默认位置。
2. 然后系统会让你输入一个密码来保护你的私钥。这是可选的，如果你不想设置密码，可以直接回车跳过。

完成上述步骤后，你会在指定的位置（默认为`~/.ssh`目录）找到生成的SSH密钥对。其中，私钥文件为`id_rsa`，公钥文件为`id_rsa.pub`。将公钥文件（`id_rsa.pub`）的内容复制并粘贴到需要使用该SSH密钥的服务器或Git托管服务中，以便进行身份验证。私钥文件请妥善保管，不要分享给他人，以保障账户的安全性。

## Just do it!

剩下就是团队一起约定项目开发计划是什么呀？

变量命名要遵循什么规则啊？

大家一起加油吧！