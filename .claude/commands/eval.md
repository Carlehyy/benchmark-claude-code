# Eval 命令

管理基于评估的开发工作流程。

## 用法

`/eval [define|check|report|list] [feature-name]`

## 定义评估

`/eval define feature-name`

创建新的评估定义：

1. 创建 `.claude/evals/feature-name.md` 文件，内容模板如下：

```markdown
## EVAL: feature-name
Created: $(date)

### Capability Evals
- [ ] [能力 1 的描述]
- [ ] [能力 2 的描述]

### Regression Evals
- [ ] [现有行为 1 仍然有效]
- [ ] [现有行为 2 仍然有效]

### Success Criteria
- pass@3 > 90% 用于能力评估
- pass^3 = 100% 用于回归评估
```

2. 提示用户填写具体的评估标准

## 检查评估

`/eval check feature-name`

运行某个功能的评估：

1. 从 `.claude/evals/feature-name.md` 读取评估定义
2. 对每个能力评估：
   - 尝试验证评估标准
   - 记录通过/失败
   - 在 `.claude/evals/feature-name.log` 中记录尝试日志
3. 对每个回归评估：
   - 运行相关测试
   - 与基线进行比较
   - 记录通过/失败
4. 报告当前状态：

```
EVAL CHECK: feature-name
========================
Capability: X/Y 通过
Regression: X/Y 通过
状态: 进行中 / 准备就绪
```

## 报告评估

`/eval report feature-name`

生成全面的评估报告：

```
EVAL REPORT: feature-name
=========================
生成时间: $(date)

能力评估
--------
[eval-1]: 通过 (pass@1)
[eval-2]: 通过 (pass@2) - 需要重试
[eval-3]: 失败 - 详见备注

回归评估
--------
[test-1]: 通过
[test-2]: 通过
[test-3]: 通过

指标
----
能力 pass@1: 67%
能力 pass@3: 100%
回归 pass^3: 100%

备注
----
[任何问题、边缘情况或观察]

建议
----
[发布 / 需要改进 / 阻塞]
```

## 列出评估

`/eval list`

显示所有评估定义：

```
EVAL DEFINITIONS
================
feature-auth      [3/5 通过] 进行中
feature-search    [5/5 通过] 准备就绪
feature-export    [0/4 通过] 未开始
```

## 参数

$ARGUMENTS:
- `define <name>` - 创建新的评估定义
- `check <name>` - 运行并检查评估
- `report <name>` - 生成完整报告
- `list` - 显示所有评估
- `clean` - 删除旧的评估日志（保留最近 10 次运行）