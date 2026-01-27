# 项目开发手册 - 逻辑表达力小程序

> 基于中文化 Claude Code 配置，从 0 到 1 开发微信小程序的完整指南

## 📚 文档目录

### 核心文档

| 文档 | 说明 | 适用阶段 |
|------|------|----------|
| [快速启动指南](快速启动指南.md) | 5 分钟快速开始 | 初始化 |
| [README - 项目总览](README.md) | 项目概述和功能介绍 | 全程参考 |
| [项目需求分析](项目需求分析.md) | 功能需求、技术方案、风险评估 | 规划阶段 |
| [项目开发计划](项目开发计划.md) | 21 天详细开发计划 | 全程参考 |
| [项目初始化指南](项目初始化指南.md) | 环境搭建、项目配置 | 初始化阶段 |
| [Claude Code 开发指南](Claude-Code-开发指南.md) | Claude Code 使用方法 | 开发阶段 |
| [最佳实践和FAQ](最佳实践和FAQ.md) | 开发技巧、常见问题 | 全程参考 |

### 工具脚本

| 文件 | 说明 |
|------|------|
| [setup-project.sh](setup-project.sh) | 一键初始化项目脚本 |

## 🚀 快速开始

### 1. 安装中文化 Claude Code 配置

```bash
# 克隆本仓库
git clone https://github.com/Carlehyy/benchmark-claude-code.git
cd benchmark-claude-code

# 安装配置
mkdir -p ~/.claude
cp -r agents ~/.claude/
cp -r commands ~/.claude/
cp -r skills ~/.claude/
cp -r rules ~/.claude/
cp -r contexts ~/.claude/
```

### 2. 创建项目

```bash
# 创建项目目录
mkdir logic-expression-miniapp
cd logic-expression-miniapp

# 复制初始化脚本
cp /path/to/benchmark-claude-code/project-docs/setup-project.sh .

# 运行初始化
bash setup-project.sh

# 安装依赖
npm install
```

### 3. 开始开发

在 Claude Code 中运行：

```
/plan

我要开发逻辑表达力小程序，今天是 Day 1。
请按照 21 天开发计划指导我。
```

## 📖 推荐阅读顺序

### 第一次使用

1. **[快速启动指南](快速启动指南.md)** - 5 分钟快速开始
2. **[README - 项目总览](README.md)** - 了解项目全貌
3. **[项目开发计划](项目开发计划.md)** - 了解 21 天计划
4. **[Claude Code 开发指南](Claude-Code-开发指南.md)** - 学习使用方法

### 开发过程中

1. **[项目开发计划](项目开发计划.md)** - 查看每日任务
2. **[Claude Code 开发指南](Claude-Code-开发指南.md)** - 查询命令用法
3. **[最佳实践和FAQ](最佳实践和FAQ.md)** - 解决问题

## 🎯 项目概述

**项目名称**：逻辑表达力训练小程序  
**目标**：帮助用户提升逻辑思维和表达能力  
**技术栈**：微信小程序原生 + TypeScript + 云开发 + Claude Code  
**开发周期**：21 天（MVP）

### 核心功能

- 📚 **逻辑题库**：推理题、论证题、谬误识别
- ✍️ **表达训练**：结构化表达、论证框架练习
- 📊 **学习进度**：完整的学习追踪和数据分析
- 📈 **数据可视化**：能力雷达图、进步曲线
- 🤖 **AI 评估**：智能评估逻辑表达质量（可选）

## 🛠️ 技术栈

- **前端**：微信小程序原生 + TypeScript
- **后端**：微信云开发
- **开发工具**：Claude Code（Opus 模型）
- **开发模式**：TDD（测试驱动开发）

## 📅 21 天开发计划

### Week 1：基础搭建（Day 1-7）
- Day 1：项目规划和设计
- Day 2：项目初始化
- Day 3-4：数据模型和基础服务
- Day 5-6：首页和题库列表
- Day 7：代码审查和重构

### Week 2：核心功能（Day 8-14）
- Day 8-9：题目详情和答题
- Day 10-11：表达训练模块
- Day 12-13：学习进度和数据分析
- Day 14：Week 2 总结和优化

### Week 3：高级功能和上线（Day 15-21）
- Day 15-16：AI 评估功能（可选）
- Day 17：个人中心和设置
- Day 18：E2E 测试
- Day 19：安全检查和性能优化
- Day 20：准备上线材料
- Day 21：提交审核和发布

详细计划请查看：[项目开发计划](项目开发计划.md)

## 💡 核心优势

### 1. 中文化 Claude Code
- ✅ 完全中文的命令和文档
- ✅ 更容易理解和使用
- ✅ 提升开发效率

### 2. TDD 开发模式
- ✅ 高质量代码
- ✅ 减少 bug
- ✅ 安全重构

### 3. 系统化流程
- ✅ 从规划到上线的完整流程
- ✅ 每个阶段都有明确指导
- ✅ 最佳实践内置

### 4. AI 辅助开发
- ✅ 智能代码审查
- ✅ 架构设计建议
- ✅ 自动生成测试

## 🎓 学习资源

### 官方文档
- [微信小程序官方文档](https://developers.weixin.qq.com/miniprogram/dev/framework/)
- [云开发文档](https://developers.weixin.qq.com/miniprogram/dev/wxcloud/basis/getting-started.html)
- [TypeScript 文档](https://www.typescriptlang.org/docs/)

### 推荐阅读
- [微信小程序最佳实践](https://developers.weixin.qq.com/community/develop/article/doc/000c4e433707c072c1793e56f5c813)
- [小程序性能优化](https://developers.weixin.qq.com/miniprogram/dev/framework/performance/)
- [TDD 实践指南](https://martinfowler.com/bliki/TestDrivenDevelopment.html)

## 📞 获取帮助

### 遇到问题时
1. 查看 [最佳实践和FAQ](最佳实践和FAQ.md)
2. 在 Claude Code 中使用 `@code-reviewer` 或 `@architect`
3. 查看微信小程序官方文档

### Claude Code 使用
- `/help` - 查看所有命令
- `/plan` - 规划功能
- `/tdd` - TDD 指导
- `/code-review` - 代码审查

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 License

MIT License

---

**作者**：Carlehyy  
**最后更新**：2026-01-27  
**版本**：1.0.0

**祝您开发顺利！** 🚀
