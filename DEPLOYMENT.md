# 部署指南

## 部署到 GitHub Pages

### 步骤 1: 准备仓库

1. 将 `image-viewer-new` 文件夹的内容移动到仓库根目录,或者创建一个新的 GitHub 仓库
2. 确保 `vite.config.js` 中的 `base` 路径设置正确(应该是你的仓库名)

### 步骤 2: 启用 GitHub Pages

1. 进入 GitHub 仓库的 Settings
2. 在左侧菜单中找到 "Pages"
3. 在 "Build and deployment" 部分:
   - Source: 选择 "GitHub Actions"

### 步骤 3: 推送代码

```bash
git add .
git commit -m "Initial commit: Vue image viewer"
git push origin main
```

### 步骤 4: 等待部署

- GitHub Actions 会自动运行构建和部署流程
- 在 "Actions" 标签页可以查看部署进度
- 部署完成后,应用将在 `https://<username>.github.io/<repository-name>/` 可访问

## 本地测试生产构建

在部署前,建议先在本地测试生产构建:

```bash
# 构建
npm run build

# 预览
npm run preview
```

## 故障排除

### 问题: 部署后页面空白

**解决方案**: 检查 `vite.config.js` 中的 `base` 配置是否与仓库名匹配

```javascript
base: process.env.NODE_ENV === 'production' ? '/your-repo-name/' : '/',
```

### 问题: 资源加载失败

**解决方案**: 确保所有资源路径都是相对路径,不要使用绝对路径

### 问题: GitHub Actions 构建失败

**解决方案**: 
1. 检查 `package.json` 中的依赖是否完整
2. 确保 `.github/workflows/deploy.yml` 配置正确
3. 查看 Actions 日志获取详细错误信息

## 自定义域名(可选)

如果你有自定义域名:

1. 在仓库根目录创建 `public/CNAME` 文件
2. 文件内容为你的域名,例如: `example.com`
3. 在域名提供商处配置 DNS 记录指向 GitHub Pages

