# Sirius' Blog

[Hugo](https://gohugo.io/) + [PaperMod](https://github.com/adityatelange/hugo-PaperMod) + GitHub Pages

**URL**: https://sirius2alpha.github.io

---

## 本地开发

```bash
# 克隆
git clone --recursive git@github.com:sirius2alpha/sirius2alpha.github.io.git
cd sirius2alpha.github.io

# 本地预览
hugo server -D
```

---

## 写作流程

文章存放于 `content/posts/Notes`（子模块）

```yaml
---
title: "标题"
date: 2026-04-10
tags: [go, redis]
draft: false   # false 才会发布
---

正文
```

推送后 GitHub Actions 自动构建部署。

---

## 相关仓库

- [Notes](https://github.com/sirius2alpha/Notes) - 笔记源文件（PARA 结构）

---

## 联系

- GitHub: [@sirius2alpha](https://github.com/sirius2alpha)
- Email: sirius1y@outlook.com
