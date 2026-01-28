# 言值（SpeakSmart）

> 提升逻辑表达力的微信小程序

一款专注于提升用户逻辑思维和表达能力的微信小程序，通过系统化的题库练习、智能评估和个性化训练，帮助用户提高逻辑表达水平。

## 📱 项目简介

**言值（SpeakSmart）** 是一款创新的逻辑表达力训练小程序，旨在帮助用户：

- 🎯 **提升逻辑思维**：通过结构化的题目训练逻辑推理能力
- 💬 **改善表达能力**：学习清晰、有条理的表达方式
- 📊 **量化进步**：实时追踪学习进度和能力提升
- 🎓 **个性化学习**：根据用户水平定制训练计划

## ✨ 核心功能

### 1. 题库练习
- 多类型题目（逻辑推理、结构化表达、论证分析等）
- 分级难度系统
- 详细的题目解析

### 2. 智能评估
- AI 辅助评分
- 多维度能力分析
- 个性化改进建议

### 3. 学习进度
- 可视化进度追踪
- 能力雷达图
- 学习统计报告

### 4. 个人中心
- 用户信息管理
- 学习记录查看
- 成就系统

## 🛠️ 技术栈

### 前端
- **框架**：微信小程序原生框架
- **语言**：JavaScript
- **样式**：WXSS（支持 CSS3）
- **UI 组件**：WeUI（微信官方 UI 库）

### 后端（待开发）
- **服务**：微信云开发 / 自建后端
- **数据库**：云数据库 / MySQL
- **存储**：云存储 / 腾讯云 COS

### 开发工具
- **IDE**：微信开发者工具
- **AI 辅助**：Claude Code（Opus 模型）
- **版本控制**：Git
- **自动化**：miniprogram-automator

## 🚀 快速开始

### 环境要求

- **Node.js**：>= 14.0.0
- **微信开发者工具**：最新稳定版
- **Claude Code**：已配置 Opus 模型

### 安装步骤

1. **克隆项目**

```bash
git clone -b logic-wechat https://github.com/Carlehyy/benchmark-claude-code.git speaksmart
cd speaksmart
```

2. **安装依赖**

```bash
npm install
```

3. **配置 AppID**

```bash
# 复制配置文件模板
cp config/app.config.example.js config/app.config.js

# 编辑配置文件，填入您的 AppID
# vim config/app.config.js
```

4. **打开项目**

- 启动微信开发者工具
- 导入项目目录
- 选择 `project.config.json` 所在目录

5. **开始开发**

```bash
# 在 Claude Code 中打开项目
# 使用以下命令开始开发

/plan 基于 docs/ui-design/screenshots/ 中的截图，复刻言值小程序
```

### 使用 Claude Code 开发

本项目已完整配置 Claude Code，包含：

- ✅ **12 个专业代理**：规划器、架构师、代码审查员等
- ✅ **18 个快捷命令**：/tdd、/plan、/code-review 等
- ✅ **16 个技能工作流**：TDD、安全审查、持续学习等
- ✅ **8 个编码规范**：代码质量、最佳实践等

#### 常用命令

```bash
# 规划功能
/plan 实现首页布局和交互

# TDD 开发
/tdd 开发题库列表页面

# 代码审查
/code-review pages/index/index.js

# 架构设计
/architect 设计数据模型和API接口

# 自动化预览
node scripts/auto-preview.js /pages/index/index
```

详细使用方法请查看：[Claude-Code-开发指南](./docs/development/Claude-Code-开发指南.md)

## 📁 项目结构

```
speaksmart/
├── .claude/                          # Claude Code 配置
│   ├── agents/                       # 12 个专业代理
│   ├── commands/                     # 18 个快捷命令
│   ├── skills/                       # 16 个技能工作流
│   ├── rules/                        # 8 个编码规范
│   ├── contexts/                     # 动态上下文
│   └── hooks/                        # 生命周期钩子
├── pages/                            # 小程序页面
│   ├── index/                        # 首页
│   ├── question-list/                # 题库列表
│   ├── question-detail/              # 题目详情
│   ├── answer/                       # 答题页面
│   ├── practice/                     # 练习页面
│   └── profile/                      # 个人中心
├── components/                       # 自定义组件
├── utils/                            # 工具函数
├── styles/                           # 全局样式
├── assets/                           # 静态资源
│   └── images/                       # 图片资源
├── config/                           # 配置文件
│   ├── app.config.js                 # 应用配置（需手动创建）
│   └── app.config.example.js         # 配置模板
├── docs/                             # 项目文档
│   ├── development/                  # 开发文档
│   │   ├── README.md                 # 项目总览
│   │   ├── 快速启动指南.md
│   │   ├── 项目需求分析.md
│   │   ├── 项目开发计划.md
│   │   ├── Claude-Code-开发指南.md
│   │   ├── 项目初始化指南.md
│   │   ├── 最佳实践和FAQ.md
│   │   └── Claude自动化预览小程序方案.md
│   ├── ui-design/                    # UI 设计参考
│   │   ├── screenshots/              # 参考截图（待上传）
│   │   ├── 截图分析模板.md
│   │   └── 基于截图的开发指南.md
│   └── README.md                     # 文档导航
├── scripts/                          # 自动化脚本
│   ├── auto-preview.js               # 自动预览脚本
│   ├── start-automation.sh           # 启动脚本
│   └── README.md                     # 脚本文档
├── app.js                            # 小程序入口
├── app.json                          # 全局配置
├── app.wxss                          # 全局样式
├── project.config.json               # 项目配置
├── sitemap.json                      # 站点地图
├── theme.json                        # 主题配置
├── package.json                      # npm 配置
├── .gitignore                        # Git 忽略文件
└── README.md                         # 本文件
```

## 📖 开发文档

完整的开发文档位于 `docs/` 目录：

### 快速入门
- [快速启动指南](./docs/development/快速启动指南.md) - 5 分钟快速开始
- [项目总览](./docs/development/README.md) - 了解项目全貌

### 开发指南
- [项目需求分析](./docs/development/项目需求分析.md) - 功能需求和技术方案
- [项目开发计划](./docs/development/项目开发计划.md) - 21 天详细开发计划
- [Claude-Code-开发指南](./docs/development/Claude-Code-开发指南.md) - 完整使用教程

### UI 设计
- [UI 设计参考](./docs/ui-design/README.md) - 截图和设计规范
- [基于截图的开发指南](./docs/ui-design/基于截图的开发指南.md) - 复刻开发流程

### 最佳实践
- [最佳实践和FAQ](./docs/development/最佳实践和FAQ.md) - 开发技巧和常见问题
- [自动化预览方案](./docs/development/Claude自动化预览小程序方案.md) - 实时预览配置

## 🎯 开发流程

### 基于截图的复刻开发

本项目采用**基于真实小程序截图的复刻开发**方式：

1. **上传截图**
   - 将参考小程序的截图上传到 `docs/ui-design/screenshots/`
   - 按功能模块分类存放

2. **分析截图**
   - 使用 Claude Code 分析截图
   - 提取 UI 设计、交互逻辑、功能需求

3. **生成代码**
   - Claude 根据截图生成页面代码
   - 实时预览验证效果

4. **迭代优化**
   - 对比截图调整细节
   - 完善功能和交互

详细流程请查看：[基于截图的开发指南](./docs/ui-design/基于截图的开发指南.md)

### 自动化预览

使用自动化脚本实时查看开发效果：

```bash
# 启动自动化
bash scripts/start-automation.sh $(pwd) 9420

# 预览页面
node scripts/auto-preview.js /pages/index/index

# 批量预览
node scripts/auto-preview.js /pages/index/index,/pages/question-list/question-list
```

详细说明请查看：[自动化脚本文档](./scripts/README.md)

## 🔧 配置说明

### AppID 配置

1. 复制配置模板：
```bash
cp config/app.config.example.js config/app.config.js
```

2. 编辑 `config/app.config.js`，填入您的 AppID：
```javascript
module.exports = {
  appId: 'wx1234567890abcdef',  // 填入您的 AppID
  // ...其他配置
};
```

3. `config/app.config.js` 已添加到 `.gitignore`，不会被提交到 Git

### 开发者工具配置

1. 打开微信开发者工具
2. 进入 **设置 -> 安全设置**
3. 开启 **服务端口**（用于自动化预览）

## 📊 开发计划

项目采用 **21 天开发计划**，分为 5 个阶段：

| 阶段 | 天数 | 内容 | 产出 |
|------|------|------|------|
| **阶段一** | Day 1-3 | 项目初始化和基础搭建 | 项目框架、首页 |
| **阶段二** | Day 4-9 | 核心功能开发 | 题库、答题、评估 |
| **阶段三** | Day 10-15 | 数据和交互完善 | 进度追踪、个人中心 |
| **阶段四** | Day 16-18 | 优化和测试 | 性能优化、Bug 修复 |
| **阶段五** | Day 19-21 | 上线准备 | 审核材料、部署上线 |

详细计划请查看：[项目开发计划](./docs/development/项目开发计划.md)

## 🧪 测试

```bash
# 运行测试（待实现）
npm test

# 自动化预览测试
npm run auto:preview
```

## 📝 待办事项

- [ ] 上传参考小程序截图到 `docs/ui-design/screenshots/`
- [ ] 配置微信小程序 AppID
- [ ] 开发首页布局和交互
- [ ] 实现题库列表页面
- [ ] 开发答题功能
- [ ] 集成 AI 评估
- [ ] 实现学习进度追踪
- [ ] 开发个人中心
- [ ] 性能优化
- [ ] 上线审核

## 🤝 贡献

欢迎贡献代码、提出建议或报告问题！

## 📄 许可证

MIT License

## 🔗 相关链接

### 项目相关
- [GitHub 仓库](https://github.com/Carlehyy/benchmark-claude-code)
- [项目文档](./docs/README.md)
- [开发计划](./docs/development/项目开发计划.md)

### 官方文档
- [微信小程序官方文档](https://developers.weixin.qq.com/miniprogram/dev/framework/)
- [微信开发者工具](https://developers.weixin.qq.com/miniprogram/dev/devtools/download.html)
- [WeUI 组件库](https://developers.weixin.qq.com/miniprogram/dev/extended/weui/)

### 工具和资源
- [Claude Code](https://docs.claude.ai/)
- [miniprogram-automator](https://developers.weixin.qq.com/miniprogram/dev/devtools/auto/)

---

**准备好了吗？** 开始您的言值小程序开发之旅！🚀

建议从 [快速启动指南](./docs/development/快速启动指南.md) 开始。
