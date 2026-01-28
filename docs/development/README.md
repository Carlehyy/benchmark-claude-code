# 逻辑表达力小程序 - 完整开发手册

> 基于中文化 Claude Code 配置，从 0 到 1 开发微信小程序的完整指南

## 📖 项目概述

**项目名称**：逻辑表达力训练小程序  
**目标**：帮助用户提升逻辑思维和表达能力  
**技术栈**：微信小程序原生 + TypeScript + 云开发 + Claude Code  
**开发周期**：21 天（MVP）

## 🎯 核心功能

- 📚 **逻辑题库**：推理题、论证题、谬误识别
- ✍️ **表达训练**：结构化表达、论证框架练习
- 📊 **学习进度**：完整的学习追踪和数据分析
- 📈 **数据可视化**：能力雷达图、进步曲线
- 🤖 **AI 评估**：智能评估逻辑表达质量（可选）

## 🚀 快速开始（5 分钟）

### 1. 安装中文化 Claude Code 配置

```bash
# 克隆配置仓库
git clone https://github.com/Carlehyy/benchmark-claude-code.git
cd benchmark-claude-code

# 安装到用户级配置
mkdir -p ~/.claude
cp -r agents ~/.claude/
cp -r commands ~/.claude/
cp -r skills ~/.claude/
cp -r rules ~/.claude/
cp -r contexts ~/.claude/
```

### 2. 创建项目

```bash
# 下载项目模板
cd /path/to/your/workspace

# 运行初始化脚本
bash setup-project.sh

# 安装依赖
npm install
```

### 3. 配置微信小程序

1. 打开微信开发者工具
2. 导入项目
3. 配置 AppID
4. 开通云开发

### 4. 开始开发

在 Claude Code 中运行：

```
/plan

我要开发逻辑表达力小程序，今天是 Day 1。
请按照 21 天开发计划指导我。
```

## 📚 完整文档

### 核心文档

| 文档 | 说明 | 适用阶段 |
|------|------|----------|
| [项目需求分析](docs/项目需求分析.md) | 功能需求、技术方案、风险评估 | 规划阶段 |
| [项目开发计划](docs/项目开发计划.md) | 21 天详细开发计划 | 全程参考 |
| [项目初始化指南](docs/项目初始化指南.md) | 环境搭建、项目配置 | 初始化阶段 |
| [Claude Code 开发指南](docs/Claude-Code-开发指南.md) | Claude Code 使用方法 | 开发阶段 |
| [最佳实践和FAQ](docs/最佳实践和FAQ.md) | 开发技巧、常见问题 | 全程参考 |

### 文档导航

#### 🎯 我想开始项目
→ 阅读 [项目需求分析](docs/项目需求分析.md)  
→ 运行 `bash setup-project.sh`  
→ 阅读 [项目初始化指南](docs/项目初始化指南.md)

#### 📅 我想了解开发计划
→ 阅读 [项目开发计划](docs/项目开发计划.md)  
→ 查看 21 天详细时间线

#### 🛠️ 我想学习 Claude Code
→ 阅读 [Claude Code 开发指南](docs/Claude-Code-开发指南.md)  
→ 学习命令和代理使用

#### 💡 我遇到了问题
→ 查看 [最佳实践和FAQ](docs/最佳实践和FAQ.md)  
→ 搜索常见问题解决方案

## 🏗️ 项目结构

```
logic-expression-miniapp/
├── miniprogram/              # 小程序源码
│   ├── pages/               # 页面
│   │   ├── index/          # 首页
│   │   ├── question-list/  # 题库列表
│   │   ├── question-detail/# 题目详情
│   │   ├── practice/       # 练习页面
│   │   ├── progress/       # 学习进度
│   │   └── profile/        # 个人中心
│   ├── components/         # 组件
│   │   ├── question-card/  # 题目卡片
│   │   ├── progress-chart/ # 进度图表
│   │   ├── answer-input/   # 答案输入
│   │   └── ability-radar/  # 能力雷达图
│   ├── services/           # 服务层
│   │   ├── question.service.ts
│   │   ├── user.service.ts
│   │   └── ai.service.ts
│   ├── models/             # 数据模型
│   │   ├── question.model.ts
│   │   ├── user.model.ts
│   │   └── practice.model.ts
│   ├── utils/              # 工具函数
│   │   ├── request.ts
│   │   ├── storage.ts
│   │   └── validator.ts
│   ├── config/             # 配置
│   │   └── app.config.ts
│   └── app.ts              # 入口文件
├── cloudfunctions/         # 云函数
│   ├── getQuestions/       # 获取题目
│   ├── submitAnswer/       # 提交答案
│   └── evaluateLogic/      # AI 评估
├── tests/                  # 测试
│   ├── unit/              # 单元测试
│   ├── integration/       # 集成测试
│   └── e2e/               # E2E 测试
├── docs/                   # 文档
│   ├── 项目需求分析.md
│   ├── 项目开发计划.md
│   ├── 项目初始化指南.md
│   ├── Claude-Code-开发指南.md
│   └── 最佳实践和FAQ.md
├── .claude/                # Claude Code 配置
│   └── CLAUDE.md
├── setup-project.sh        # 初始化脚本
├── project.config.json     # 小程序配置
├── tsconfig.json          # TypeScript 配置
├── package.json           # 依赖配置
└── README.md              # 本文档
```

## 🎓 开发流程

### 标准开发流程（使用 TDD）

```
1. 规划功能
   ↓ /plan
2. 编写测试（RED）
   ↓ /tdd
3. 实现代码（GREEN）
   ↓
4. 重构优化（REFACTOR）
   ↓ /refactor-clean
5. 代码审查
   ↓ /code-review
6. 提交代码
   ↓ git commit
```

### Claude Code 命令速查

| 命令 | 用途 | 使用时机 |
|------|------|----------|
| `/plan` | 创建实施计划 | 开始新功能前 |
| `/tdd` | TDD 开发指导 | 开发所有功能 |
| `/code-review` | 代码审查 | 完成功能后 |
| `/refactor-clean` | 重构清理 | 定期清理 |
| `/e2e` | E2E 测试 | 测试用户流程 |
| `/test-coverage` | 测试覆盖率 | 检查测试质量 |
| `/security-review` | 安全审查 | 上线前 |

### 代理使用

| 代理 | 用途 | 调用方式 |
|------|------|----------|
| `planner` | 功能规划 | `@planner` |
| `architect` | 架构设计 | `@architect` |
| `code-reviewer` | 代码审查 | `@code-reviewer` |
| `tdd-guide` | TDD 指导 | `@tdd-guide` |
| `security-reviewer` | 安全审查 | `@security-reviewer` |

## 📅 21 天开发计划

### Week 1：基础搭建（Day 1-7）
- ✅ Day 1：项目规划和设计
- ✅ Day 2：项目初始化
- ✅ Day 3-4：数据模型和基础服务
- ✅ Day 5-6：首页和题库列表
- ✅ Day 7：代码审查和重构

### Week 2：核心功能（Day 8-14）
- ✅ Day 8-9：题目详情和答题
- ✅ Day 10-11：表达训练模块
- ✅ Day 12-13：学习进度和数据分析
- ✅ Day 14：Week 2 总结和优化

### Week 3：高级功能和上线（Day 15-21）
- ✅ Day 15-16：AI 评估功能（可选）
- ✅ Day 17：个人中心和设置
- ✅ Day 18：E2E 测试
- ✅ Day 19：安全检查和性能优化
- ✅ Day 20：准备上线材料
- ✅ Day 21：提交审核和发布

详细计划请查看：[项目开发计划](docs/项目开发计划.md)

## 🎯 质量标准

### 代码质量
- ✅ 测试覆盖率 > 80%
- ✅ 所有功能使用 TDD 开发
- ✅ 通过代码审查
- ✅ 无严重 ESLint 错误

### 性能标准
- ✅ 首屏加载 < 2s
- ✅ 页面切换 < 300ms
- ✅ 包体积 < 2MB
- ✅ 内存使用 < 50MB

### 安全标准
- ✅ 数据传输加密
- ✅ 用户隐私保护
- ✅ API 安全验证
- ✅ 通过安全审查

## 🛠️ 技术栈

### 前端
- **框架**：微信小程序原生开发
- **语言**：TypeScript
- **UI 库**：WeUI / Vant Weapp（可选）
- **状态管理**：MobX（可选）

### 后端
- **BaaS**：微信云开发 / Supabase
- **数据库**：云数据库
- **云函数**：处理业务逻辑
- **存储**：云存储

### 开发工具
- **IDE**：微信开发者工具
- **AI 辅助**：Claude Code（Opus 模型）
- **版本控制**：Git
- **测试**：Jest + Miniprogram Simulate

### AI 能力（可选）
- **LLM API**：OpenAI GPT-4 / Anthropic Claude
- **用途**：智能评估逻辑表达

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

## 📖 学习资源

### 官方文档
- [微信小程序官方文档](https://developers.weixin.qq.com/miniprogram/dev/framework/)
- [云开发文档](https://developers.weixin.qq.com/miniprogram/dev/wxcloud/basis/getting-started.html)
- [TypeScript 文档](https://www.typescriptlang.org/docs/)

### 推荐阅读
- [微信小程序最佳实践](https://developers.weixin.qq.com/community/develop/article/doc/000c4e433707c072c1793e56f5c813)
- [小程序性能优化](https://developers.weixin.qq.com/miniprogram/dev/framework/performance/)
- [TDD 实践指南](https://martinfowler.com/bliki/TestDrivenDevelopment.html)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 License

MIT License

---

## 🎉 开始您的开发之旅

现在您已经拥有了：

1. ✅ 完整的中文化 Claude Code 配置
2. ✅ 详细的 21 天开发计划
3. ✅ 系统化的开发流程
4. ✅ 完善的文档和指南
5. ✅ 最佳实践和常见问题解决方案

**下一步**：

```bash
# 1. 运行初始化脚本
bash setup-project.sh

# 2. 安装依赖
npm install

# 3. 打开微信开发者工具

# 4. 在 Claude Code 中开始
/plan
我要开始开发逻辑表达力小程序
```

**祝您开发顺利！** 🚀

---

**作者**：Carlehyy  
**最后更新**：2026-01-27  
**版本**：1.0.0
