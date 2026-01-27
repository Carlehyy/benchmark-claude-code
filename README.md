# Claude Code 完全指南

[![Stars](https://img.shields.io/github/stars/affaan-m/everything-claude-code?style=flat)](https://github.com/affaan-m/everything-claude-code/stargazers)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Shell](https://img.shields.io/badge/-Shell-4EAA25?logo=gnu-bash&logoColor=white)
![TypeScript](https://img.shields.io/badge/-TypeScript-3178C6?logo=typescript&logoColor=white)
![Go](https://img.shields.io/badge/-Go-00ADD8?logo=go&logoColor=white)
![Markdown](https://img.shields.io/badge/-Markdown-000000?logo=markdown&logoColor=white)

**Anthropic 黑客松获奖者的完整 Claude Code 配置集合。**

经过 10 个多月的密集日常使用，在构建真实产品过程中不断演进的生产就绪代理、技能、钩子、命令、规则和 MCP 配置。

---

## 使用指南

本仓库仅包含原始代码。完整指南请参阅以下文档。

<table>
<tr>
<td width="50%">
<a href="https://x.com/affaanmustafa/status/2012378465664745795">
<img src="https://github.com/user-attachments/assets/1a471488-59cc-425b-8345-5245c7efbcef" alt="Claude Code 完全指南 - 简明版" />
</a>
</td>
<td width="50%">
<a href="https://x.com/affaanmustafa/status/2014040193557471352">
<img src="https://github.com/user-attachments/assets/c9ca43bc-b149-427f-b551-af6840c368f0" alt="Claude Code 完全指南 - 详细版" />
</a>
</td>
</tr>
<tr>
<td align="center"><b>简明指南</b><br/>设置、基础、理念。<b>请先阅读此文档。</b></td>
<td align="center"><b>详细指南</b><br/>Token 优化、内存持久化、评估、并行化。</td>
</tr>
</table>

| 主题 | 学习内容 |
|-------|-------------------|
| Token 优化 | 模型选择、系统提示精简、后台进程 |
| 内存持久化 | 自动跨会话保存/加载上下文的钩子 |
| 持续学习 | 从会话中自动提取模式并转化为可复用技能 |
| 验证循环 | 检查点 vs 持续评估、评分器类型、pass@k 指标 |
| 并行化 | Git worktrees、级联方法、何时扩展实例 |
| 子代理编排 | 上下文问题、迭代检索模式 |

---

## 跨平台支持

本插件现已完全支持 **Windows、macOS 和 Linux**。所有钩子和脚本已使用 Node.js 重写，以实现最大兼容性。

### 包管理器检测

插件会按以下优先级自动检测您首选的包管理器（npm、pnpm、yarn 或 bun）：

1. **环境变量**：`CLAUDE_PACKAGE_MANAGER`
2. **项目配置**：`.claude/package-manager.json`
3. **package.json**：`packageManager` 字段
4. **锁文件**：从 package-lock.json、yarn.lock、pnpm-lock.yaml 或 bun.lockb 检测
5. **全局配置**：`~/.claude/package-manager.json`
6. **回退方案**：首个可用的包管理器

设置首选包管理器：

```bash
# 通过环境变量
export CLAUDE_PACKAGE_MANAGER=pnpm

# 通过全局配置
node scripts/setup-package-manager.js --global pnpm

# 通过项目配置
node scripts/setup-package-manager.js --project bun

# 检测当前设置
node scripts/setup-package-manager.js --detect
```

或在 Claude Code 中使用 `/setup-pm` 命令。

---

## 内容概览

本仓库是一个 **Claude Code 插件** - 可直接安装或手动复制组件。

```
everything-claude-code/
|-- .claude-plugin/   # 插件和市场清单
|   |-- plugin.json         # 插件元数据和组件路径
|   |-- marketplace.json    # 用于 /plugin marketplace add 的市场目录
|
|-- agents/           # 用于委托的专业化子代理
|   |-- planner.md           # 功能实现规划
|   |-- architect.md         # 系统设计决策
|   |-- tdd-guide.md         # 测试驱动开发
|   |-- code-reviewer.md     # 质量和安全审查
|   |-- security-reviewer.md # 漏洞分析
|   |-- build-error-resolver.md
|   |-- e2e-runner.md        # Playwright E2E 测试
|   |-- refactor-cleaner.md  # 死代码清理
|   |-- doc-updater.md       # 文档同步
|   |-- go-reviewer.md       # Go 代码审查（新增）
|   |-- go-build-resolver.md # Go 构建错误解决（新增）
|
|-- skills/           # 工作流定义和领域知识
|   |-- coding-standards/           # 语言最佳实践
|   |-- backend-patterns/           # API、数据库、缓存模式
|   |-- frontend-patterns/          # React、Next.js 模式
|   |-- continuous-learning/        # 从会话中自动提取模式（详细指南）
|   |-- continuous-learning-v2/     # 基于直觉的学习，带置信度评分
|   |-- iterative-retrieval/        # 子代理的渐进式上下文细化
|   |-- strategic-compact/          # 手动压缩建议（详细指南）
|   |-- tdd-workflow/               # TDD 方法论
|   |-- security-review/            # 安全检查清单
|   |-- eval-harness/               # 验证循环评估（详细指南）
|   |-- verification-loop/          # 持续验证（详细指南）
|   |-- golang-patterns/            # Go 语言习惯用法和最佳实践（新增）
|   |-- golang-testing/             # Go 测试模式、TDD、基准测试（新增）
|
|-- commands/         # 用于快速执行的斜杠命令
|   |-- tdd.md              # /tdd - 测试驱动开发
|   |-- plan.md             # /plan - 实现规划
|   |-- e2e.md              # /e2e - E2E 测试生成
|   |-- code-review.md      # /code-review - 质量审查
|   |-- build-fix.md        # /build-fix - 修复构建错误
|   |-- refactor-clean.md   # /refactor-clean - 死代码移除
|   |-- learn.md            # /learn - 会话中提取模式（详细指南）
|   |-- checkpoint.md       # /checkpoint - 保存验证状态（详细指南）
|   |-- verify.md           # /verify - 运行验证循环（详细指南）
|   |-- setup-pm.md         # /setup-pm - 配置包管理器
|   |-- go-review.md        # /go-review - Go 代码审查（新增）
|   |-- go-test.md          # /go-test - Go TDD 工作流（新增）
|   |-- go-build.md         # /go-build - 修复 Go 构建错误（新增）
|
|-- rules/            # 始终遵循的指导原则（复制到 ~/.claude/rules/）
|   |-- security.md         # 强制性安全检查
|   |-- coding-style.md     # 不可变性、文件组织
|   |-- testing.md          # TDD、80% 覆盖率要求
|   |-- git-workflow.md     # 提交格式、PR 流程
|   |-- agents.md           # 何时委托给子代理
|   |-- performance.md      # 模型选择、上下文管理
|
|-- hooks/            # 基于触发器的自动化
|   |-- hooks.json                # 所有钩子配置（PreToolUse、PostToolUse、Stop 等）
|   |-- memory-persistence/       # 会话生命周期钩子（详细指南）
|   |-- strategic-compact/        # 压缩建议（详细指南）
|
|-- scripts/          # 跨平台 Node.js 脚本（新增）
|   |-- lib/                     # 共享工具
|   |   |-- utils.js             # 跨平台文件/路径/系统工具
|   |   |-- package-manager.js   # 包管理器检测和选择
|   |-- hooks/                   # 钩子实现
|   |   |-- session-start.js     # 会话启动时加载上下文
|   |   |-- session-end.js       # 会话结束时保存状态
|   |   |-- pre-compact.js       # 压缩前状态保存
|   |   |-- suggest-compact.js   # 策略性压缩建议
|   |   |-- evaluate-session.js  # 从会话中提取模式
|   |-- setup-package-manager.js # 交互式包管理器设置
|
|-- tests/            # 测试套件（新增）
|   |-- lib/                     # 库测试
|   |-- hooks/                   # 钩子测试
|   |-- run-all.js               # 运行所有测试
|
|-- contexts/         # 动态系统提示注入上下文（详细指南）
|   |-- dev.md              # 开发模式上下文
|   |-- review.md           # 代码审查模式上下文
|   |-- research.md         # 研究/探索模式上下文
|
|-- examples/         # 示例配置和会话
|   |-- CLAUDE.md           # 示例项目级配置
|   |-- user-CLAUDE.md      # 示例用户级配置
|
|-- mcp-configs/      # MCP 服务器配置
|   |-- mcp-servers.json    # GitHub、Supabase、Vercel、Railway 等
|
|-- marketplace.json  # 自托管市场配置（用于 /plugin marketplace add）
```

---

## 生态系统工具

### ecc.tools - 技能创建器

从您的仓库自动生成 Claude Code 技能。

[安装 GitHub App](https://github.com/apps/skill-creator) | [ecc.tools](https://ecc.tools)

分析您的仓库并创建：
- **SKILL.md 文件** - 可直接用于 Claude Code 的技能
- **直觉集合** - 用于 continuous-learning-v2
- **模式提取** - 从您的提交历史中学习

```bash
# 安装 GitHub App 后，技能会出现在：
~/.claude/skills/generated/
```

与 `continuous-learning-v2` 技能无缝配合，实现继承的直觉。

---

## 安装方式

### 方式一：作为插件安装（推荐）

使用本仓库最简单的方式 - 作为 Claude Code 插件安装：

```bash
# 将此仓库添加为市场
/plugin marketplace add affaan-m/everything-claude-code

# 安装插件
/plugin install everything-claude-code@everything-claude-code
```

或直接添加到您的 `~/.claude/settings.json`：

```json
{
  "extraKnownMarketplaces": {
    "everything-claude-code": {
      "source": {
        "source": "github",
        "repo": "affaan-m/everything-claude-code"
      }
    }
  },
  "enabledPlugins": {
    "everything-claude-code@everything-claude-code": true
  }
}
```

这样您就可以立即访问所有命令、代理、技能和钩子。

> **注意：** Claude Code 插件系统不支持通过插件分发 `rules`（[上游限制](https://code.claude.com/docs/en/plugins-reference)）。您需要手动安装规则：
>
> ```bash
> # 首先克隆仓库
> git clone https://github.com/affaan-m/everything-claude-code.git
>
> # 选项 A：用户级规则（应用于所有项目）
> cp -r everything-claude-code/rules/* ~/.claude/rules/
>
> # 选项 B：项目级规则（仅应用于当前项目）
> mkdir -p .claude/rules
> cp -r everything-claude-code/rules/* .claude/rules/
> ```

---

### 方式二：手动安装

如果您希望手动控制安装的内容：

```bash
# 克隆仓库
git clone https://github.com/affaan-m/everything-claude-code.git

# 复制代理到您的 Claude 配置
cp everything-claude-code/agents/*.md ~/.claude/agents/

# 复制规则
cp everything-claude-code/rules/*.md ~/.claude/rules/

# 复制命令
cp everything-claude-code/commands/*.md ~/.claude/commands/

# 复制技能
cp -r everything-claude-code/skills/* ~/.claude/skills/
```

#### 添加钩子到 settings.json

将 `hooks/hooks.json` 中的钩子复制到您的 `~/.claude/settings.json`。

#### 配置 MCP

将所需的 MCP 服务器从 `mcp-configs/mcp-servers.json` 复制到您的 `~/.claude.json`。

**重要：** 将 `YOUR_*_HERE` 占位符替换为您的实际 API 密钥。

---

## 核心概念

### 代理（Agents）

子代理处理范围有限的委托任务。示例：

```markdown
---
name: code-reviewer
description: 审查代码的质量、安全性和可维护性
tools: ["Read", "Grep", "Glob", "Bash"]
model: opus
---

您是一位资深代码审查员...
```

### 技能（Skills）

技能是由命令或代理调用的工作流定义：

```markdown
# TDD 工作流

1. 首先定义接口
2. 编写失败的测试（RED）
3. 实现最小代码（GREEN）
4. 重构（IMPROVE）
5. 验证 80%+ 覆盖率
```

### 钩子（Hooks）

钩子在工具事件时触发。示例 - 警告 console.log：

```json
{
  "matcher": "tool == \"Edit\" && tool_input.file_path matches \"\\\\.(ts|tsx|js|jsx)$\"",
  "hooks": [{
    "type": "command",
    "command": "#!/bin/bash\ngrep -n 'console\\.log' \"$file_path\" && echo '[Hook] Remove console.log' >&2"
  }]
}
```

### 规则（Rules）

规则是始终遵循的指导原则。保持模块化：

```
~/.claude/rules/
  security.md      # 禁止硬编码密钥
  coding-style.md  # 不可变性、文件限制
  testing.md       # TDD、覆盖率要求
```

---

## 运行测试

插件包含完整的测试套件：

```bash
# 运行所有测试
node tests/run-all.js

# 运行单个测试文件
node tests/lib/utils.test.js
node tests/lib/package-manager.test.js
node tests/hooks/hooks.test.js
```

---

## 贡献指南

**欢迎并鼓励贡献。**

本仓库旨在成为社区资源。如果您有：
- 有用的代理或技能
- 巧妙的钩子
- 更好的 MCP 配置
- 改进的规则

请贡献！查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解指南。

### 贡献想法

- 特定语言的技能（Python、Rust 模式）- 现已包含 Go！
- 特定框架的配置（Django、Rails、Laravel）
- DevOps 代理（Kubernetes、Terraform、AWS）
- 测试策略（不同框架）
- 特定领域知识（机器学习、数据工程、移动开发）

---

## 背景介绍

我从实验性推出阶段就开始使用 Claude Code。在 2025 年 9 月与 [@DRodriguezFX](https://x.com/DRodriguezFX) 一起赢得了 Anthropic x Forum Ventures 黑客松，构建了 [zenith.chat](https://zenith.chat) - 完全使用 Claude Code 开发。

这些配置已在多个生产应用中经过实战检验。

---

## 重要说明

### 上下文窗口管理

**关键：** 不要一次启用所有 MCP。启用太多工具会使您的 200k 上下文窗口缩减到 70k。

经验法则：
- 配置 20-30 个 MCP
- 每个项目启用少于 10 个
- 活动工具少于 80 个

在项目配置中使用 `disabledMcpServers` 禁用未使用的 MCP。

### 自定义

这些配置适用于我的工作流程。您应该：
1. 从共鸣的内容开始
2. 根据您的技术栈修改
3. 删除不使用的内容
4. 添加您自己的模式

---

## Star 历史

[![Star History Chart](https://api.star-history.com/svg?repos=affaan-m/everything-claude-code&type=Date)](https://star-history.com/#affaan-m/everything-claude-code&Date)

---

## 相关链接

- **简明指南（从这里开始）：** [Claude Code 完全指南 - 简明版](https://x.com/affaanmustafa/status/2012378465664745795)
- **详细指南（高级）：** [Claude Code 完全指南 - 详细版](https://x.com/affaanmustafa/status/2014040193557471352)
- **关注：** [@affaanmustafa](https://x.com/affaanmustafa)
- **zenith.chat：** [zenith.chat](https://zenith.chat)

---

## 许可证

MIT - 自由使用、按需修改、尽可能回馈社区。

---

**如果对您有帮助，请为本仓库加星。阅读两份指南。构建伟大的产品。**
