# 图片查看器

一个基于 Vue 3 + Vite + DaisyUI + OpenSeadragon 的现代化图片查看器应用。

## 功能特性

- 🖼️ **拖拽上传**: 支持拖拽单张图片或整个文件夹
- 🔍 **高级查看**: 使用 OpenSeadragon 实现图片缩放、平移
- ⬅️➡️ **图片翻页**: 支持左右翻页浏览多张图片
- ⌨️ **键盘快捷键**:
  - `←` / `→` 切换上一张/下一张图片
  - `Esc` 关闭查看器
- 🌓 **主题切换**: 支持亮色/暗色主题
- 📱 **响应式设计**: 适配桌面和移动设备
- 🖥️ **全屏模式**: 支持全屏查看图片

## 技术栈

- **Vue 3** - 渐进式 JavaScript 框架
- **Vite** - 下一代前端构建工具
- **DaisyUI** - Tailwind CSS 组件库
- **OpenSeadragon** - 高性能图片查看库

## 本地开发

```bash
# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 构建生产版本
npm run build

# 预览生产构建
npm run preview
```

## 部署到 GitHub Pages

1. 在 GitHub 仓库设置中启用 GitHub Pages
2. 选择 "GitHub Actions" 作为部署源
3. 推送代码到 `main` 分支，GitHub Actions 会自动构建和部署

## 使用方法

1. 打开应用
2. 将图片或包含图片的文件夹拖拽到页面中
3. 使用控制按钮或键盘快捷键浏览图片
4. 点击全屏按钮进入全屏模式

## License

MIT
