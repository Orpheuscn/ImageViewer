# GitHub Pages 部署指南

## 问题修复

如果遇到 GitHub Actions 构建失败,请按照以下步骤操作:

### 1. 确保 GitHub Pages 已启用

1. 进入仓库的 **Settings** (设置)
2. 在左侧菜单找到 **Pages**
3. 在 **Build and deployment** 部分:
   - **Source**: 选择 **GitHub Actions**
   - 不要选择 "Deploy from a branch"

### 2. 检查工作流文件

确保 `.github/workflows/deploy.yml` 文件在仓库根目录,内容如下:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        working-directory: ./image-viewer-new
        run: npm ci

      - name: Build
        working-directory: ./image-viewer-new
        run: npm run build

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: './image-viewer-new/dist'

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### 3. 推送更新

```bash
# 添加所有更改
git add .

# 提交更改
git commit -m "Fix GitHub Actions deployment"

# 推送到 GitHub
git push origin main
```

### 4. 查看部署状态

1. 进入仓库的 **Actions** 标签页
2. 查看最新的工作流运行状态
3. 如果失败,点击查看详细日志

### 5. 常见问题

#### 问题: "Not Found" 错误

**原因**: GitHub Pages 未启用或配置错误

**解决方案**:
1. 确保在 Settings > Pages 中选择了 "GitHub Actions"
2. 等待几分钟让 GitHub 初始化 Pages 环境

#### 问题: "cache dependencies" 错误

**原因**: npm cache 路径配置问题

**解决方案**: 
- 已在新的工作流中移除 cache 配置
- 使用 `working-directory` 指定正确的工作目录

#### 问题: 部署成功但页面空白

**原因**: Vite base 路径配置错误

**解决方案**:
- 确保 `vite.config.js` 中的 base 路径与仓库名匹配
- 当前配置: `base: '/ImageViewer/'`

### 6. 验证部署

部署成功后,访问:

```
https://orpheuscn.github.io/ImageViewer/
```

### 7. 手动触发部署

如果需要手动触发部署:

1. 进入 **Actions** 标签页
2. 选择 "Deploy to GitHub Pages" 工作流
3. 点击 **Run workflow** 按钮
4. 选择 `main` 分支
5. 点击绿色的 **Run workflow** 按钮

## 本地测试生产构建

在推送到 GitHub 之前,建议先在本地测试:

```bash
cd image-viewer-new

# 构建
npm run build

# 预览
npm run preview
```

然后访问 `http://localhost:4173/ImageViewer/` 查看效果。

## 项目结构说明

```
ImageViewer/                    # 仓库根目录
├── .github/
│   └── workflows/
│       └── deploy.yml         # GitHub Actions 配置(必须在根目录)
├── image-viewer-new/          # Vue 应用目录
│   ├── dist/                  # 构建输出目录(自动生成)
│   ├── src/                   # 源代码
│   ├── package.json
│   └── vite.config.js         # Vite 配置
└── README.md
```

## 下一步

部署成功后,你可以:

1. 自定义域名(在 Settings > Pages 中配置)
2. 添加 CNAME 文件到 `image-viewer-new/public/` 目录
3. 继续开发新功能

