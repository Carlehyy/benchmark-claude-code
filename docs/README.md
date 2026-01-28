# 言值（SpeakSmart）项目文档

欢迎查阅言值小程序的完整开发文档。本目录包含所有开发相关的文档和资源。

## 📚 文档导航

### 开发文档（development/）

核心开发文档，包含项目规划、开发指南和最佳实践。

| 文档 | 说明 | 推荐阅读顺序 |
|------|------|-------------|
| [快速启动指南](./development/快速启动指南.md) | 5 分钟快速开始开发 | ⭐ 第一步 |
| [README](./development/README.md) | 项目总览和功能介绍 | ⭐ 第二步 |
| [项目需求分析](./development/项目需求分析.md) | 详细的功能需求和技术方案 | 第三步 |
| [项目开发计划](./development/项目开发计划.md) | 21 天详细开发计划 | 第四步 |
| [Claude-Code-开发指南](./development/Claude-Code-开发指南.md) | 完整的 Claude Code 使用教程 | 第五步 |
| [项目初始化指南](./development/项目初始化指南.md) | 环境搭建和项目配置 | 参考 |
| [最佳实践和FAQ](./development/最佳实践和FAQ.md) | 开发技巧和常见问题 | 参考 |
| [Claude自动化预览小程序方案](./development/Claude自动化预览小程序方案.md) | 自动化预览的完整方案 | 参考 |

### UI 设计参考（ui-design/）

UI 设计相关的截图、分析和开发指南。

| 文档/目录 | 说明 |
|----------|------|
| [README](./ui-design/README.md) | UI 设计目录说明 |
| [screenshots/](./ui-design/screenshots/) | 参考小程序的功能截图 |
| [截图分析模板](./ui-design/截图分析模板.md) | 系统化的截图分析框架 |
| [基于截图的开发指南](./ui-design/基于截图的开发指南.md) | 如何基于截图复刻开发 |

## 🚀 快速开始

### 新手入门

如果您是第一次使用本项目，建议按以下步骤进行：

1. **阅读快速启动指南**（5 分钟）
   ```bash
   cat docs/development/快速启动指南.md
   ```

2. **了解项目概况**（10 分钟）
   ```bash
   cat docs/development/README.md
   ```

3. **查看 UI 截图**（10 分钟）
   ```bash
   ls docs/ui-design/screenshots/
   ```

4. **开始开发**
   - 在 Claude Code 中打开项目
   - 使用命令：`/plan 基于 docs/ui-design/screenshots/ 中的截图，复刻言值小程序`

### 有经验的开发者

如果您已经熟悉微信小程序和 Claude Code：

1. **查看项目需求分析**
   - 了解功能需求和技术栈

2. **查看开发计划**
   - 根据自己的节奏调整计划

3. **直接开始开发**
   - 使用 `/tdd` 命令进行测试驱动开发
   - 使用 `/code-review` 进行代码审查

## 📖 文档使用指南

### 按场景查找文档

#### 场景一：我想快速开始开发

→ [快速启动指南](./development/快速启动指南.md)

#### 场景二：我想了解项目有哪些功能

→ [README](./development/README.md)  
→ [项目需求分析](./development/项目需求分析.md)

#### 场景三：我想学习如何使用 Claude Code

→ [Claude-Code-开发指南](./development/Claude-Code-开发指南.md)

#### 场景四：我想看参考小程序的截图

→ [ui-design/screenshots/](./ui-design/screenshots/)

#### 场景五：我想知道如何基于截图开发

→ [基于截图的开发指南](./ui-design/基于截图的开发指南.md)  
→ [截图分析模板](./ui-design/截图分析模板.md)

#### 场景六：我想使用自动化预览功能

→ [Claude自动化预览小程序方案](./development/Claude自动化预览小程序方案.md)  
→ [scripts/README.md](../scripts/README.md)

#### 场景七：我遇到了问题

→ [最佳实践和FAQ](./development/最佳实践和FAQ.md)

#### 场景八：我想制定开发计划

→ [项目开发计划](./development/项目开发计划.md)

## 🎯 项目特点

### 完整的开发文档

- ✅ 从需求分析到上线的完整流程
- ✅ 21 天详细开发计划
- ✅ Claude Code 完整使用教程
- ✅ 最佳实践和常见问题解答

### 基于截图的复刻开发

- ✅ 真实小程序的功能截图
- ✅ 系统化的截图分析框架
- ✅ 详细的开发指导流程
- ✅ Claude Code 提示词模板

### 自动化预览支持

- ✅ 实时预览小程序效果
- ✅ 自动截图和数据获取
- ✅ 支持批量预览多个页面
- ✅ 完整的自动化脚本工具

### 中文化的 Claude Code 配置

- ✅ 12 个专业化代理
- ✅ 18 个快捷命令
- ✅ 16 个技能工作流
- ✅ 8 个编码规范

## 📊 文档统计

| 类型 | 数量 | 说明 |
|------|------|------|
| 开发文档 | 8 个 | 涵盖需求、计划、指南、FAQ |
| UI 设计文档 | 3 个 | 截图分析和开发指南 |
| 自动化脚本 | 3 个 | 预览、启动、配置脚本 |
| Claude 配置 | 54 个 | agents、commands、skills、rules |

## 🔗 相关链接

### 项目相关

- [项目根目录 README](../README.md)
- [自动化脚本文档](../scripts/README.md)
- [项目配置文件](../project.config.json)

### 外部资源

- [微信小程序官方文档](https://developers.weixin.qq.com/miniprogram/dev/framework/)
- [微信开发者工具](https://developers.weixin.qq.com/miniprogram/dev/devtools/download.html)
- [Claude Code 官方文档](https://docs.claude.ai/)

## 💡 使用建议

### 开发前

1. ✅ 完整阅读快速启动指南
2. ✅ 浏览所有 UI 截图
3. ✅ 配置开发环境
4. ✅ 熟悉 Claude Code 基本命令

### 开发中

1. ✅ 参考开发计划进行增量开发
2. ✅ 使用 TDD 方法保证质量
3. ✅ 利用自动化预览实时验证
4. ✅ 遇到问题查阅 FAQ

### 开发后

1. ✅ 进行完整的代码审查
2. ✅ 测试所有功能
3. ✅ 优化性能和体验
4. ✅ 准备上线材料

## 📞 获取帮助

### 文档问题

如果文档中有不清楚的地方：
1. 查看相关文档的"常见问题"部分
2. 查阅[最佳实践和FAQ](./development/最佳实践和FAQ.md)

### 开发问题

如果开发过程中遇到问题：
1. 在 Claude Code 中使用 `@code-reviewer` 或 `@architect`
2. 查看微信小程序官方文档
3. 查阅项目 FAQ 文档

### Claude Code 使用问题

如果不熟悉 Claude Code：
1. 阅读 [Claude-Code-开发指南](./development/Claude-Code-开发指南.md)
2. 使用 `/help` 命令查看所有可用命令
3. 从简单命令开始练习

---

**准备好了吗？** 开始您的言值小程序开发之旅！🚀

建议从 [快速启动指南](./development/快速启动指南.md) 开始。
