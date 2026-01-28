---
name: continuous-learning
description: 自动从 Claude Code 会话中提取可复用的模式，并将其保存为可供未来使用的学习技能。
---

# 持续学习技能

自动在会话结束时评估 Claude Code 会话，提取可复用的模式，并将其保存为学习技能。

## 工作原理

该技能作为每次会话结束时的**停止钩子**运行：

1. **会话评估**：检查会话消息数量是否足够（默认：10条以上）
2. **模式检测**：识别会话中可提取的模式
3. **技能提取**：将有用的模式保存到 `~/.claude/skills/learned/`

## 配置

编辑 `config.json` 以自定义：

```json
{
  "min_session_length": 10,
  "extraction_threshold": "medium",
  "auto_approve": false,
  "learned_skills_path": "~/.claude/skills/learned/",
  "patterns_to_detect": [
    "error_resolution",
    "user_corrections",
    "workarounds",
    "debugging_techniques",
    "project_specific"
  ],
  "ignore_patterns": [
    "simple_typos",
    "one_time_fixes",
    "external_api_issues"
  ]
}
```

## 模式类型

| 模式 | 描述 |
|---------|-------------|
| `error_resolution` | 具体错误的解决方法 |
| `user_corrections` | 用户更正的模式 |
| `workarounds` | 针对框架/库特殊问题的解决方案 |
| `debugging_techniques` | 有效的调试方法 |
| `project_specific` | 项目特定的约定 |

## 钩子设置

添加到你的 `~/.claude/settings.json`：

```json
{
  "hooks": {
    "Stop": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "~/.claude/skills/continuous-learning/evaluate-session.sh"
      }]
    }]
  }
}
```

## 为什么选择停止钩子？

- **轻量级**：仅在会话结束时运行一次
- **非阻塞**：不会增加每条消息的延迟
- **完整上下文**：可访问完整的会话记录

## 相关内容

- [长篇指南](https://x.com/affaanmustafa/status/2014040193557471352) - 持续学习章节
- `/learn` 命令 - 会话中手动提取模式

---

## 比较说明（调研：2025年1月）

### 与 Homunculus (github.com/humanplane/homunculus) 的对比

Homunculus v2 采用了更复杂的方法：

| 特性 | 我们的方法 | Homunculus v2 |
|---------|--------------|---------------|
| 观察点 | 停止钩子（会话结束） | PreToolUse/PostToolUse 钩子（100%可靠） |
| 分析方式 | 主上下文 | 后台代理（Haiku） |
| 颗粒度 | 完整技能 | 原子级“本能” |
| 置信度 | 无 | 0.3-0.9 加权 |
| 进化路径 | 直接生成技能 | 本能 → 聚类 → 技能/命令/代理 |
| 共享方式 | 无 | 导出/导入本能 |

**来自 Homunculus 的关键见解：**
> “v1 依赖技能进行观察。技能是概率性的——触发率约为50-80%。v2 使用钩子进行观察（100%可靠），并将本能作为学习行为的原子单位。”

### v2 可能的增强方向

1. **基于本能的学习** - 更小的原子行为，带置信度评分
2. **后台观察者** - Haiku 代理并行分析
3. **置信度衰减** - 本能若被反驳则置信度降低
4. **领域标签** - 代码风格、测试、git、调试等
5. **进化路径** - 将相关本能聚类成技能/命令

详见：`/Users/affoon/Documents/tasks/12-continuous-learning-v2.md` 完整规范。