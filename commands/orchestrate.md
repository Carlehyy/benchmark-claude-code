# Orchestrate 命令

用于复杂任务的顺序代理工作流。

## 用法

`/orchestrate [workflow-type] [task-description]`

## 工作流类型

### feature
完整功能实现工作流：
```
planner -> tdd-guide -> code-reviewer -> security-reviewer
```

### bugfix
缺陷调查与修复工作流：
```
explorer -> tdd-guide -> code-reviewer
```

### refactor
安全重构工作流：
```
architect -> code-reviewer -> tdd-guide
```

### security
安全重点审查：
```
security-reviewer -> code-reviewer -> architect
```

## 执行模式

针对工作流中的每个代理：

1. **调用代理**，传入来自前一个代理的上下文
2. **收集输出**，形成结构化的交接文档
3. **传递给下一个代理**进行处理
4. **汇总结果**，生成最终报告

## 交接文档格式

代理之间创建交接文档：

```markdown
## HANDOFF: [previous-agent] -> [next-agent]

### Context
[完成内容摘要]

### Findings
[关键发现或决策]

### Files Modified
[涉及的文件列表]

### Open Questions
[待下一个代理解决的问题]

### Recommendations
[建议的下一步措施]
```

## 示例：功能工作流

```
/orchestrate feature "Add user authentication"
```

执行流程：

1. **Planner 代理**
   - 分析需求
   - 制定实现计划
   - 识别依赖关系
   - 输出：`HANDOFF: planner -> tdd-guide`

2. **TDD Guide 代理**
   - 阅读 planner 的交接文档
   - 先编写测试
   - 实现功能以通过测试
   - 输出：`HANDOFF: tdd-guide -> code-reviewer`

3. **Code Reviewer 代理**
   - 审查实现代码
   - 检查潜在问题
   - 提出改进建议
   - 输出：`HANDOFF: code-reviewer -> security-reviewer`

4. **Security Reviewer 代理**
   - 进行安全审计
   - 检查漏洞
   - 最终批准
   - 输出：最终报告

## 最终报告格式

```
ORCHESTRATION REPORT
====================
Workflow: feature
Task: Add user authentication
Agents: planner -> tdd-guide -> code-reviewer -> security-reviewer

SUMMARY
-------
[一段总结]

AGENT OUTPUTS
-------------
Planner: [总结]
TDD Guide: [总结]
Code Reviewer: [总结]
Security Reviewer: [总结]

FILES CHANGED
-------------
[所有修改的文件列表]

TEST RESULTS
------------
[测试通过/失败总结]

SECURITY STATUS
---------------
[安全发现]

RECOMMENDATION
--------------
[可发布 / 需要改进 / 阻塞]
```

## 并行执行

对于独立检查，可并行运行代理：

```markdown
### 并行阶段
同时运行：
- code-reviewer（质量）
- security-reviewer（安全）
- architect（设计）

### 合并结果
将输出合并为单一报告
```

## 参数

$ARGUMENTS:
- `feature <description>` - 完整功能工作流
- `bugfix <description>` - 缺陷修复工作流
- `refactor <description>` - 重构工作流
- `security <description>` - 安全审查工作流
- `custom <agents> <description>` - 自定义代理序列

## 自定义工作流示例

```
/orchestrate custom "architect,tdd-guide,code-reviewer" "Redesign caching layer"
```

## 提示

1. **复杂功能从 planner 开始**
2. **合并前务必包含 code-reviewer**
3. **认证/支付/个人信息相关使用 security-reviewer**
4. **交接文档保持简洁** - 聚焦下一个代理所需信息
5. **必要时在代理间进行验证**