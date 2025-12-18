#!/bin/bash

# 部署脚本 - 快速推送到 GitHub 并触发部署

echo "🚀 开始部署流程..."

# 检查是否有未提交的更改
if [[ -n $(git status -s) ]]; then
    echo "📝 发现未提交的更改"
    
    # 显示更改
    git status -s
    
    # 添加所有更改
    echo "➕ 添加所有更改..."
    git add .
    
    # 提交
    echo "💾 提交更改..."
    read -p "请输入提交信息 (默认: Update application): " commit_msg
    commit_msg=${commit_msg:-"Update application"}
    git commit -m "$commit_msg"
else
    echo "✅ 没有未提交的更改"
fi

# 推送到 GitHub
echo "📤 推送到 GitHub..."
git push origin main

if [ $? -eq 0 ]; then
    echo "✅ 推送成功!"
    echo ""
    echo "🔗 查看部署状态:"
    echo "   https://github.com/Orpheuscn/ImageViewer/actions"
    echo ""
    echo "🌐 部署完成后访问:"
    echo "   https://orpheuscn.github.io/ImageViewer/"
else
    echo "❌ 推送失败,请检查错误信息"
    exit 1
fi

