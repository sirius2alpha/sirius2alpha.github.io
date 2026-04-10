# Sirius' Blog

基于 Hugo + PaperMod 构建的个人博客，部署于 GitHub Pages。

🔗 **在线地址**: https://sirius1y.top

---

## 🏗️ 项目结构

```
.
├── archetypes/          # 文章模板
├── assets/              # 资源文件
├── content/             # 网站内容
│   └── posts/
│       └── Notes/       # Git 子模块 - 笔记仓库
├── layouts/             # 自定义布局
├── static/              # 静态文件
│   └── images/          # 图片资源
├── themes/              # 主题
│   └── PaperMod/        # Git 子模块 - PaperMod 主题
├── hugo.toml            # Hugo 配置文件
├── blog-commit.sh       # 发布脚本
└── README.md            # 本文件
```

---

## 🚀 快速开始

### 1. 克隆仓库

```bash
git clone git@github.com:sirius2alpha/sirius2alpha.github.io.git
cd sirius2alpha.github.io
```

### 2. 初始化子模块

```bash
git submodule init
git submodule update
```

### 3. 安装 Hugo

```bash
# macOS
brew install hugo

# 或下载二进制到 ~/bin/
mkdir -p ~/bin
curl -L -o /tmp/hugo.tar.gz \
    "https://github.com/gohugoio/hugo/releases/download/v0.124.1/hugo_extended_0.124.1_darwin-universal.tar.gz"
tar -xzf /tmp/hugo.tar.gz -C ~/bin hugo
```

### 4. 本地预览

```bash
hugo server -D
# 访问 http://localhost:1313
```

---

## 📝 写作与发布

### 文章格式

文章使用 Markdown 格式，必须包含 frontmatter：

```yaml
---
title: "文章标题"
date: 2026-04-10
tags:
  - go
  - redis
draft: false  # false 才会发布
---

正文内容...
```

### 发布流程

#### 方式一：使用脚本（推荐）

1. 配置 `config.sh`：
   ```bash
   echo "BLOG_HOME=/Users/hao/Developer/Projects/sirius2alpha.github.io" > config.sh
   ```

2. 运行发布脚本：
   ```bash
   ./blog-commit.sh
   ```

#### 方式二：手动发布

```bash
# 1. 在 Notes 仓库编辑文章
cd content/posts/Notes
# 编辑后提交到 Notes 仓库

# 2. 更新子模块引用
cd ../..
git add content/posts/Notes
git commit -m "update: 同步笔记更新"

# 3. 编译
git push
~/bin/hugo --gc --minify

# 4. 部署（GitHub Actions 自动部署）
```

---

## 🔗 与 Obsidian 知识库的关联

本博客的文章源来自 Obsidian 知识库：

```
Obsidian Vault (iCloud)
    ↓ 整理维护
Notes Repo (sirius2alpha/Notes) - PARA 结构
    ↓ Git 子模块
Hugo Blog (本仓库)
    ↓ 编译
GitHub Pages
```

### PARA 结构

笔记仓库采用 PARA 方法组织：

- **0-Inbox** - 收件箱
- **1-Projects** - 当前项目
- **2-Areas** - 技术领域
- **3-Resources** - 参考资料
- **4-Archive** - 归档内容
- **5-MOC** - 内容地图

只有 `draft: false` 的文章会被编译到博客中。

---

## ⚙️ 配置说明

### hugo.toml 关键配置

| 配置项 | 说明 |
|--------|------|
| `baseURL` | 网站域名 |
| `title` | 网站标题 |
| `theme` | 使用主题（PaperMod）|
| `paginate` | 每页文章数 |
| `buildDrafts` | 是否编译草稿 |

### 评论系统

使用 Giscus（GitHub Discussions）：

```toml
[params.page.comment.giscus]
enable = true
repo = "sirius2alpha/sirius2alpha.github.io"
```

---

## 🛠️ 常见问题

### 子模块更新失败

```bash
# 强制更新子模块到最新
git submodule update --init --recursive --force
```

### Hugo 编译错误

检查文章 frontmatter 格式是否正确（YAML 语法）。

### 图片不显示

将图片放入 `static/images/` 目录，引用方式：

```markdown
![描述](/images/xxx.png)
```

---

## 📊 站点统计

- **主题**: PaperMod
- **部署**: GitHub Pages
- **评论**: Giscus
- **搜索**: Fuse.js

---

## 🤝 友链交换

如果你想交换友链，欢迎通过以下方式联系我：

- GitHub: [@sirius2alpha](https://github.com/sirius2alpha)
- Email: sirius1y@outlook.com
- Instagram: [@siriustuyeahh](https://www.instagram.com/siriustuyeahh/)

---

## 📄 License

文章内容版权归作者所有，转载请注明出处。

主题 PaperMod 遵循其原许可证。
