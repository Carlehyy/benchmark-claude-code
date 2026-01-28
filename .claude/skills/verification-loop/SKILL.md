# 验证循环技能

Claude Code 会话的全面验证系统。

## 何时使用

调用此技能：
- 完成功能或重大代码更改后
- 创建 PR 之前
- 需要确保质量门通过时
- 重构之后

## 验证阶段

### 阶段 1：构建验证
```bash
# 检查项目是否能构建
npm run build 2>&1 | tail -20
# 或者
pnpm build 2>&1 | tail -20
```

如果构建失败，停止并修复后再继续。

### 阶段 2：类型检查
```bash
# TypeScript 项目
npx tsc --noEmit 2>&1 | head -30

# Python 项目
pyright . 2>&1 | head -30
```

报告所有类型错误。修复关键错误后再继续。

### 阶段 3：代码风格检查
```bash
# JavaScript/TypeScript
npm run lint 2>&1 | head -30

# Python
ruff check . 2>&1 | head -30
```

### 阶段 4：测试套件
```bash
# 运行带覆盖率的测试
npm run test -- --coverage 2>&1 | tail -50

# 检查覆盖率阈值
# 目标：最低 80%
```

报告：
- 测试总数：X
- 通过：X
- 失败：X
- 覆盖率：X%

### 阶段 5：安全扫描
```bash
# 检查密钥泄露
grep -rn "sk-" --include="*.ts" --include="*.js" . 2>/dev/null | head -10
grep -rn "api_key" --include="*.ts" --include="*.js" . 2>/dev/null | head -10

# 检查 console.log
grep -rn "console.log" --include="*.ts" --include="*.tsx" src/ 2>/dev/null | head -10
```

### 阶段 6：差异审查
```bash
# 显示变更内容
git diff --stat
git diff HEAD~1 --name-only
```

审查每个变更文件，关注：
- 非预期的更改
- 缺失的错误处理
- 潜在的边界情况

## 输出格式

完成所有阶段后，生成验证报告：

```
验证报告
========

构建：     [通过/失败]
类型：     [通过/失败] (X 个错误)
代码风格： [通过/失败] (X 个警告)
测试：     [通过/失败] (X/Y 通过，Z% 覆盖率)
安全：     [通过/失败] (X 个问题)
差异：     [X 个文件变更]

整体状态： [准备好/未准备好] 进行 PR

待修复问题：
1. ...
2. ...
```

## 持续模式

对于长时间会话，每 15 分钟或重大变更后运行验证：

```markdown
设定心理检查点：
- 完成每个函数后
- 完成组件后
- 进入下一个任务前

运行：/verify
```

## 与钩子集成

此技能可补充 PostToolUse 钩子，但提供更深入的验证。
钩子能立即捕获问题；此技能则提供全面审查。