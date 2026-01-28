---
name: continuous-learning-v2
description: 基于本能的学习系统，通过钩子观察会话，创建带有置信度评分的原子本能，并将其演化为技能/命令/代理。
version: 2.0.0
---

# 持续学习 v2 - 基于本能的架构

一套先进的学习系统，将您的 Claude Code 会话转化为可复用的知识，通过原子级的“本能”——带有置信度评分的小型学习行为。

## v2 新特性

| 功能 | v1 | v2 |
|---------|----|----|
| 观察方式 | 停止钩子（会话结束） | PreToolUse/PostToolUse（100% 可靠） |
| 分析方式 | 主上下文 | 后台代理（Haiku） |
| 颗粒度 | 完整技能 | 原子级“本能” |
| 置信度 | 无 | 0.3-0.9 加权 |
| 演化路径 | 直接到技能 | 本能 → 聚类 → 技能/命令/代理 |
| 共享方式 | 无 | 导出/导入本能 |

## 本能模型

本能是一种小型学习行为：

```yaml
---
id: prefer-functional-style
trigger: "when writing new functions"
confidence: 0.7
domain: "code-style"
source: "session-observation"
---

# Prefer Functional Style

## Action
Use functional patterns over classes when appropriate.

## Evidence
- Observed 5 instances of functional pattern preference
- User corrected class-based approach to functional on 2025-01-15
```

**属性：**
- **原子性** — 一个触发条件，一个动作
- **置信度加权** — 0.3 表示暂定，0.9 表示近乎确定
- **领域标签** — 代码风格、测试、Git、调试、工作流等
- **证据支持** — 追踪创建本能的观察记录

## 工作原理

```
Session Activity
      │
      │ 钩子捕获提示 + 工具使用（100% 可靠）
      ▼
┌─────────────────────────────────────────┐
│         observations.jsonl              │
│   （提示、工具调用、结果）               │
└─────────────────────────────────────────┘
      │
      │ 观察者代理读取（后台，Haiku）
      ▼
┌─────────────────────────────────────────┐
│          模式检测                      │
│   • 用户纠正 → 本能                    │
│   • 错误解决 → 本能                    │
│   • 重复工作流 → 本能                  │
└─────────────────────────────────────────┘
      │
      │ 创建/更新
      ▼
┌─────────────────────────────────────────┐
│         instincts/personal/             │
│   • prefer-functional.md (0.7)          │
│   • always-test-first.md (0.9)          │
│   • use-zod-validation.md (0.6)         │
└─────────────────────────────────────────┘
      │
      │ /演化 聚类
      ▼
┌─────────────────────────────────────────┐
│              evolved/                   │
│   • commands/new-feature.md             │
│   • skills/testing-workflow.md          │
│   • agents/refactor-specialist.md       │
└─────────────────────────────────────────┘
```

## 快速开始

### 1. 启用观察钩子

添加到您的 `~/.claude/settings.json`：

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "~/.claude/skills/continuous-learning-v2/hooks/observe.sh pre"
      }]
    }],
    "PostToolUse": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "~/.claude/skills/continuous-learning-v2/hooks/observe.sh post"
      }]
    }]
  }
}
```

### 2. 初始化目录结构

```bash
mkdir -p ~/.claude/homunculus/{instincts/{personal,inherited},evolved/{agents,skills,commands}}
touch ~/.claude/homunculus/observations.jsonl
```

### 3. 运行观察者代理（可选）

观察者可以在后台运行，分析观察记录：

```bash
# 启动后台观察者
~/.claude/skills/continuous-learning-v2/agents/start-observer.sh
```

## 命令

| 命令 | 描述 |
|---------|-------------|
| `/instinct-status` | 显示所有学习到的本能及其置信度 |
| `/evolve` | 将相关本能聚类为技能/命令 |
| `/instinct-export` | 导出本能以便共享 |
| `/instinct-import <file>` | 从他人导入本能 |

## 配置

编辑 `config.json`：

```json
{
  "version": "2.0",
  "observation": {
    "enabled": true,
    "store_path": "~/.claude/homunculus/observations.jsonl",
    "max_file_size_mb": 10,
    "archive_after_days": 7
  },
  "instincts": {
    "personal_path": "~/.claude/homunculus/instincts/personal/",
    "inherited_path": "~/.claude/homunculus/instincts/inherited/",
    "min_confidence": 0.3,
    "auto_approve_threshold": 0.7,
    "confidence_decay_rate": 0.05
  },
  "observer": {
    "enabled": true,
    "model": "haiku",
    "run_interval_minutes": 5,
    "patterns_to_detect": [
      "user_corrections",
      "error_resolutions",
      "repeated_workflows",
      "tool_preferences"
    ]
  },
  "evolution": {
    "cluster_threshold": 3,
    "evolved_path": "~/.claude/homunculus/evolved/"
  }
}
```

## 文件结构

```
~/.claude/homunculus/
├── identity.json           # 您的个人资料，技术水平
├── observations.jsonl      # 当前会话观察记录
├── observations.archive/   # 已处理的观察记录
├── instincts/
│   ├── personal/           # 自动学习的本能
│   └── inherited/          # 从他人导入的本能
└── evolved/
    ├── agents/             # 生成的专用代理
    ├── skills/             # 生成的技能
    └── commands/           # 生成的命令
```

## 与技能创建器的集成

当您使用 [Skill Creator GitHub 应用](https://skill-creator.app) 时，它现在会同时生成：
- 传统的 SKILL.md 文件（兼容旧版）
- 本能集合（用于 v2 学习系统）

来自仓库分析的本能带有 `source: "repo-analysis"`，并包含源仓库 URL。

## 置信度评分

置信度随时间演变：

| 分数 | 含义 | 行为 |
|-------|---------|----------|
| 0.3 | 暂定 | 建议但不强制执行 |
| 0.5 | 中等 | 相关时应用 |
| 0.7 | 强烈 | 自动批准应用 |
| 0.9 | 近乎确定 | 核心行为 |

**置信度提升条件：**
- 模式被反复观察到
- 用户未纠正建议行为
- 来自其他来源的类似本能一致

**置信度降低条件：**
- 用户明确纠正该行为
- 长时间未观察到该模式
- 出现相反证据

## 为什么用钩子而不是技能来观察？

> “v1 依赖技能进行观察。技能是概率性的——根据 Claude 的判断，触发概率约为 50-80%。”

钩子则是**100% 触发**，确定性强。这意味着：
- 每次工具调用都会被观察
- 不会遗漏任何模式
- 学习更全面

## 向后兼容性

v2 完全兼容 v1：
- 现有的 `~/.claude/skills/learned/` 技能仍可使用
- 停止钩子仍然运行（同时也为 v2 提供数据）
- 逐步迁移路径：两者可并行运行

## 隐私

- 观察记录保留在您的本地机器
- 仅可导出**本能**（模式）
- 不会共享任何实际代码或对话内容
- 您可控制导出内容

## 相关资源

- [Skill Creator](https://skill-creator.app) - 从仓库历史生成本能
- [Homunculus](https://github.com/humanplane/homunculus) - v2 架构灵感来源
- [长文指南](https://x.com/affaanmustafa/status/2014040193557471352) - 持续学习章节

---

*基于本能的学习：一次观察，教会 Claude 您的模式。*