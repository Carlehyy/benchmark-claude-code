# Git 工作流程

## 提交信息格式

```
<type>: <description>

<optional body>
```

类型：feat，fix，refactor，docs，test，chore，perf，ci

注意：通过 ~/.claude/settings.json 全局禁用归属信息。

## 拉取请求工作流程

创建 PR 时：
1. 分析完整的提交历史（不仅限于最新提交）
2. 使用 `git diff [base-branch]...HEAD` 查看所有变更
3. 起草详尽的 PR 摘要
4. 包含带有待办事项的测试计划
5. 如果是新分支，使用 `-u` 参数推送

## 功能实现工作流程

1. **先规划**
   - 使用 **planner** 代理创建实现计划
   - 识别依赖和风险
   - 拆分为多个阶段

2. **测试驱动开发（TDD）方法**
   - 使用 **tdd-guide** 代理
   - 先编写测试（RED）
   - 实现功能以通过测试（GREEN）
   - 重构代码（IMPROVE）
   - 确保覆盖率达到 80% 以上

3. **代码审查**
   - 编写代码后立即使用 **code-reviewer** 代理
   - 处理 CRITICAL 和 HIGH 级别的问题
   - 尽可能修复 MEDIUM 级别的问题

4. **提交与推送**
   - 编写详细的提交信息
   - 遵循规范化提交格式