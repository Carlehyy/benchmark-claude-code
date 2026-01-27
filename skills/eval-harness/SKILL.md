---
name: eval-harness
description: 实现基于评估驱动开发（EDD）原则的 Claude Code 会话的正式评估框架
tools: Read, Write, Edit, Bash, Grep, Glob
---

# 评估框架技能

一个针对 Claude Code 会话的正式评估框架，实现了评估驱动开发（EDD）原则。

## 原则

评估驱动开发将评估视为“AI 开发的单元测试”：
- 在实现之前定义预期行为
- 在开发过程中持续运行评估
- 随每次变更跟踪回归
- 使用 pass@k 指标衡量可靠性

## 评估类型

### 能力评估
测试 Claude 是否能完成之前无法完成的任务：
```markdown
[CAPABILITY EVAL: feature-name]
Task: Claude 应完成的任务描述
Success Criteria:
  - [ ] 标准 1
  - [ ] 标准 2
  - [ ] 标准 3
Expected Output: 预期结果描述
```

### 回归评估
确保变更不会破坏现有功能：
```markdown
[REGRESSION EVAL: feature-name]
Baseline: SHA 或检查点名称
Tests:
  - existing-test-1: PASS/FAIL
  - existing-test-2: PASS/FAIL
  - existing-test-3: PASS/FAIL
Result: X/Y 通过（之前为 Y/Y）
```

## 评分器类型

### 1. 基于代码的评分器
使用代码进行确定性检查：
```bash
# 检查文件是否包含预期模式
grep -q "export function handleAuth" src/auth.ts && echo "PASS" || echo "FAIL"

# 检查测试是否通过
npm test -- --testPathPattern="auth" && echo "PASS" || echo "FAIL"

# 检查构建是否成功
npm run build && echo "PASS" || echo "FAIL"
```

### 2. 基于模型的评分器
使用 Claude 评估开放式输出：
```markdown
[MODEL GRADER PROMPT]
评估以下代码变更：
1. 是否解决了声明的问题？
2. 结构是否合理？
3. 是否处理了边界情况？
4. 错误处理是否恰当？

评分：1-5（1=差，5=优）
理由：[解释]
```

### 3. 人工评分器
标记为人工复审：
```markdown
[HUMAN REVIEW REQUIRED]
变更：变更内容描述
原因：需要人工复审的原因
风险等级：低/中/高
```

## 指标

### pass@k
“k 次尝试中至少一次成功”
- pass@1：首次尝试成功率
- pass@3：3 次尝试内成功率
- 典型目标：pass@3 > 90%

### pass^k
“k 次尝试全部成功”
- 更高的可靠性标准
- pass^3：连续 3 次成功
- 用于关键路径

## 评估工作流程

### 1. 定义（编码前）
```markdown
## EVAL DEFINITION: feature-xyz

### 能力评估
1. 能创建新用户账户
2. 能验证邮箱格式
3. 能安全地哈希密码

### 回归评估
1. 现有登录功能仍然有效
2. 会话管理未被修改
3. 登出流程保持完整

### 成功指标
- 能力评估 pass@3 > 90%
- 回归评估 pass^3 = 100%
```

### 2. 实现
编写代码以通过定义的评估。

### 3. 评估
```bash
# 运行能力评估
[运行每个能力评估，记录 PASS/FAIL]

# 运行回归评估
npm test -- --testPathPattern="existing"

# 生成报告
```

### 4. 报告
```markdown
EVAL REPORT: feature-xyz
========================

能力评估：
  create-user:     PASS (pass@1)
  validate-email:  PASS (pass@2)
  hash-password:   PASS (pass@1)
  总体：          3/3 通过

回归评估：
  login-flow:      PASS
  session-mgmt:    PASS
  logout-flow:     PASS
  总体：          3/3 通过

指标：
  pass@1: 67% (2/3)
  pass@3: 100% (3/3)

状态：准备复审
```

## 集成模式

### 实现前
```
/eval define feature-name
```
在 `.claude/evals/feature-name.md` 创建评估定义文件

### 实现中
```
/eval check feature-name
```
运行当前评估并报告状态

### 实现后
```
/eval report feature-name
```
生成完整评估报告

## 评估存储

将评估存储在项目中：
```
.claude/
  evals/
    feature-xyz.md      # 评估定义
    feature-xyz.log     # 评估运行历史
    baseline.json       # 回归基线
```

## 最佳实践

1. **编码前定义评估** - 强制明确成功标准
2. **频繁运行评估** - 及早捕捉回归
3. **跟踪 pass@k 趋势** - 监控可靠性变化
4. **优先使用代码评分器** - 确定性优于概率性
5. **安全相关需人工复审** - 安全检查不可完全自动化
6. **保持评估快速** - 慢速评估难以执行
7. **与代码同步版本管理评估** - 评估是一级工件

## 示例：添加认证功能

```markdown
## EVAL: add-authentication

### 阶段 1：定义（10 分钟）
能力评估：
- [ ] 用户可通过邮箱/密码注册
- [ ] 用户可使用有效凭证登录
- [ ] 无效凭证应返回正确错误
- [ ] 会话在页面刷新后保持
- [ ] 登出清除会话

回归评估：
- [ ] 公开路由仍可访问
- [ ] API 响应未变
- [ ] 数据库模式兼容

### 阶段 2：实现（时间不定）
[编写代码]

### 阶段 3：评估
运行：/eval check add-authentication

### 阶段 4：报告
EVAL REPORT: add-authentication
==============================
能力评估：5/5 通过（pass@3：100%）
回归评估：3/3 通过（pass^3：100%）
状态：准备发布
```
