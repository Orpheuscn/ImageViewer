# ImageViewer

一个基于 Vue 3 + Vite + DaisyUI + OpenSeadragon 的现代化图片查看器应用。

## 项目结构

```
ImageViewer/
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions 部署配置
└── image-viewer-new/           # Vue 应用主目录
    ├── src/
    │   ├── components/
    │   │   └── ImageViewer.vue # 主要组件
    │   ├── App.vue
    │   ├── main.js
    │   └── style.css
    ├── public/
    ├── index.html
    ├── package.json
    ├── vite.config.js
    ├── tailwind.config.js
    ├── postcss.config.js
    ├── README.md               # 项目详细说明
    ├── DEPLOYMENT.md           # 部署指南
    └── CHANGELOG.md            # 更新日志
```

## 功能特性

- 🖼️ **拖拽上传**: 支持拖拽单张图片或整个文件夹
- 🔍 **高级查看**: 使用 OpenSeadragon 实现图片缩放、平移
- ⬅️➡️ **图片翻页**: 支持左右翻页浏览多张图片
- ⌨️ **键盘快捷键**: `←` / `→` 切换图片, `Esc` 关闭查看器
- 🌓 **主题切换**: 支持亮色/暗色主题
- 📱 **响应式设计**: 适配桌面和移动设备
- 🖥️ **全屏模式**: 支持全屏查看图片
- 🎨 **格式支持**: 支持 JPEG, PNG, GIF, WebP, HEIC/HEIF 等格式

## 本地开发

```bash
# 进入项目目录
cd image-viewer-new

# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 构建生产版本
npm run build

# 预览生产构建
npm run preview
```

## GitHub Pages 部署

### 自动部署

1. 确保仓库设置中启用了 GitHub Pages
2. 在 Settings > Pages 中选择 "GitHub Actions" 作为部署源
3. 推送代码到 `main` 分支,GitHub Actions 会自动构建和部署

```bash
git add .
git commit -m "Update application"
git push origin main
```

### 手动触发部署

在 GitHub 仓库的 "Actions" 标签页中,选择 "Deploy to GitHub Pages" 工作流,点击 "Run workflow"。

## 访问应用

部署成功后,应用将在以下地址可访问:

```
https://orpheuscn.github.io/ImageViewer/
```

## 技术栈

- **Vue 3** - 渐进式 JavaScript 框架
- **Vite** - 下一代前端构建工具
- **DaisyUI** - Tailwind CSS 组件库
- **TailwindCSS** - 实用优先的 CSS 框架
- **OpenSeadragon** - 高性能图片查看库
- **heic2any** - HEIC 格式转换库

## 支持的图片格式

- ✅ JPEG/JPG
- ✅ PNG
- ✅ GIF
- ✅ WebP
- ✅ BMP
- ✅ SVG
- ✅ HEIC/HEIF (自动转换为 JPEG)

## 使用方法

1. 打开应用
2. 将图片或包含图片的文件夹拖拽到页面中
3. 使用控制按钮或键盘快捷键浏览图片
4. 点击全屏按钮进入全屏模式

## 键盘快捷键

- `←` - 上一张图片
- `→` - 下一张图片
- `Esc` - 关闭查看器

## 更多文档

- [详细 README](./image-viewer-new/README.md)
- [部署指南](./image-viewer-new/DEPLOYMENT.md)
- [更新日志](./image-viewer-new/CHANGELOG.md)

## License

MIT

