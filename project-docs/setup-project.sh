#!/bin/bash

# 逻辑表达力小程序 - 项目初始化脚本
# 作者：Carlehyy
# 使用方法：bash setup-project.sh

set -e

echo "🚀 逻辑表达力小程序 - 项目初始化"
echo "=================================="
echo ""

# 检查是否在正确的目录
if [ -f "setup-project.sh" ]; then
    echo "✅ 当前目录正确"
else
    echo "❌ 请在项目根目录运行此脚本"
    exit 1
fi

# 创建目录结构
echo "📁 创建目录结构..."
mkdir -p miniprogram/pages/{index,question-list,question-detail,practice,progress,profile}
mkdir -p miniprogram/components/{question-card,progress-chart,answer-input,ability-radar}
mkdir -p miniprogram/services
mkdir -p miniprogram/models
mkdir -p miniprogram/utils
mkdir -p miniprogram/config
mkdir -p miniprogram/assets/{images,icons}
mkdir -p cloudfunctions/{getQuestions,submitAnswer,evaluateLogic}
mkdir -p tests/{unit,integration,e2e}
mkdir -p docs
mkdir -p .claude

echo "✅ 目录结构创建完成"

# 创建配置文件
echo ""
echo "📝 创建配置文件..."

# project.config.json
cat > project.config.json << 'EOF'
{
  "description": "逻辑表达力训练小程序",
  "miniprogramRoot": "miniprogram/",
  "cloudfunctionRoot": "cloudfunctions/",
  "setting": {
    "urlCheck": true,
    "es6": true,
    "enhance": true,
    "postcss": true,
    "minified": true,
    "coverView": true
  },
  "compileType": "miniprogram",
  "appid": "your-appid",
  "projectname": "logic-expression-miniapp"
}
EOF

# tsconfig.json
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "CommonJS",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["miniprogram/*"]
    },
    "types": ["miniprogram-api-typings"]
  },
  "include": ["miniprogram/**/*"],
  "exclude": ["node_modules"]
}
EOF

# package.json
cat > package.json << 'EOF'
{
  "name": "logic-expression-miniapp",
  "version": "1.0.0",
  "description": "逻辑表达力训练小程序",
  "scripts": {
    "test": "jest",
    "test:coverage": "jest --coverage",
    "lint": "eslint miniprogram/**/*.ts",
    "lint:fix": "eslint miniprogram/**/*.ts --fix"
  },
  "keywords": ["miniprogram", "logic", "education"],
  "author": "Carlehyy",
  "license": "MIT",
  "devDependencies": {
    "@types/jest": "^29.0.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.0.0",
    "jest": "^29.0.0",
    "miniprogram-api-typings": "^3.0.0",
    "miniprogram-simulate": "^1.0.0",
    "ts-jest": "^29.0.0",
    "typescript": "^5.0.0"
  }
}
EOF

# .gitignore
cat > .gitignore << 'EOF'
# 依赖
node_modules/

# 构建产物
dist/
build/

# 日志
*.log
npm-debug.log*

# 编辑器
.vscode/
.idea/
*.swp
*.swo

# 系统文件
.DS_Store
Thumbs.db

# 微信开发者工具
.miniprogram-cache/

# 测试覆盖率
coverage/

# 环境变量
.env
.env.local

# 临时文件
*.tmp
EOF

# README.md
cat > README.md << 'EOF'
# 逻辑表达力训练小程序

帮助用户提升逻辑思维和表达能力的微信小程序。

## 功能特性

- 📚 逻辑题库（推理题、论证题、谬误识别）
- ✍️ 表达训练（结构化表达、论证框架）
- 📊 学习进度追踪
- 📈 数据分析和可视化
- 🤖 AI 智能评估（可选）

## 技术栈

- 微信小程序原生开发
- TypeScript
- 云开发
- TDD 测试驱动开发

## 快速开始

1. 安装依赖：`npm install`
2. 配置 AppID：编辑 `project.config.json`
3. 打开微信开发者工具
4. 开始开发

## 文档

- [项目开发计划](docs/项目开发计划.md)
- [项目初始化指南](docs/项目初始化指南.md)
- [Claude Code 开发指南](docs/Claude-Code-开发指南.md)
- [最佳实践和 FAQ](docs/最佳实践和FAQ.md)

## License

MIT
EOF

echo "✅ 配置文件创建完成"

# 移动文档到 docs 目录
echo ""
echo "📚 整理文档..."
if [ -f "项目开发计划.md" ]; then
    mv 项目开发计划.md docs/
fi
if [ -f "项目初始化指南.md" ]; then
    mv 项目初始化指南.md docs/
fi
if [ -f "Claude-Code-开发指南.md" ]; then
    mv Claude-Code-开发指南.md docs/
fi
if [ -f "最佳实践和FAQ.md" ]; then
    mv 最佳实践和FAQ.md docs/
fi
if [ -f "项目需求分析.md" ]; then
    mv 项目需求分析.md docs/
fi

echo "✅ 文档整理完成"

# 初始化 Git
echo ""
echo "🔧 初始化 Git..."
if [ ! -d ".git" ]; then
    git init
    git add .
    git commit -m "chore: 项目初始化"
    echo "✅ Git 初始化完成"
else
    echo "⚠️  Git 已初始化，跳过"
fi

# 完成
echo ""
echo "=================================="
echo "✅ 项目初始化完成！"
echo "=================================="
echo ""
echo "下一步："
echo "1. 安装依赖：npm install"
echo "2. 配置 AppID：编辑 project.config.json"
echo "3. 打开微信开发者工具"
echo "4. 在 Claude Code 中运行：/plan"
echo ""
echo "文档位置："
echo "- docs/项目开发计划.md"
echo "- docs/项目初始化指南.md"
echo "- docs/Claude-Code-开发指南.md"
echo "- docs/最佳实践和FAQ.md"
echo ""
echo "祝您开发顺利！🎉"

