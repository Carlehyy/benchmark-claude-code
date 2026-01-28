# 使用 Claude Code 开发微信小程序 - 完整指南

## 前置准备

### 1. 安装中文化的 Claude Code 配置

您已经有了中文化的配置仓库，现在需要将其安装到本地：

```bash
# 克隆您的中文化仓库
git clone https://github.com/Carlehyy/benchmark-claude-code.git

# 安装到 Claude Code 配置目录
cd benchmark-claude-code

# 方式一：用户级安装（推荐，适用于所有项目）
cp -r agents/* ~/.claude/agents/
cp -r commands/* ~/.claude/commands/
cp -r skills/* ~/.claude/skills/
cp -r rules/* ~/.claude/rules/
cp -r contexts/* ~/.claude/contexts/

# 方式二：项目级安装（仅适用于当前项目）
mkdir -p /path/to/your/project/.claude
cp -r agents /path/to/your/project/.claude/
cp -r commands /path/to/your/project/.claude/
cp -r skills /path/to/your/project/.claude/
cp -r rules /path/to/your/project/.claude/
```

### 2. 验证安装

在 Claude Code 中运行以下命令验证：

```
/help
```

您应该能看到所有中文化的命令。

### 3. 配置项目级规则

为您的微信小程序项目创建专属配置：

```bash
cd /path/to/your/miniapp-project
mkdir -p .claude
```

## 开发流程：从 0 到 1

### 阶段一：项目规划（Day 1）

#### 1.1 创建项目目录

```bash
mkdir logic-expression-miniapp
cd logic-expression-miniapp
git init
```

#### 1.2 使用 /plan 命令创建实施计划

在 Claude Code 中输入：

```
/plan

我要开发一个提升逻辑表达力的微信小程序，核心功能包括：
1. 逻辑题库和练习
2. 表达训练模块
3. 学习进度追踪
4. 简单的数据分析

请帮我创建详细的实施计划，包括技术栈选择、架构设计、开发步骤。
```

**planner 代理会为您生成**：
- 详细的实施步骤
- 技术架构建议
- 文件结构规划
- 风险评估和缓解措施

#### 1.3 使用 architect 代理设计架构

```
@architect

请为这个微信小程序设计系统架构，包括：
1. 前端架构（页面结构、组件设计、状态管理）
2. 后端架构（如果需要）
3. 数据模型设计
4. API 接口设计
```

**architect 代理会提供**：
- 系统架构图建议
- 技术选型理由
- 模块划分方案
- 数据流设计

### 阶段二：项目初始化（Day 1-2）

#### 2.1 创建微信小程序项目

```bash
# 使用微信开发者工具创建项目
# 或使用命令行工具
npx create-miniapp logic-expression-miniapp
```

#### 2.2 配置项目级 Claude Code 规则

创建 `.claude/CLAUDE.md`：

```markdown
# 逻辑表达力小程序 - 项目配置

## 项目信息
- 项目名称：逻辑表达力训练小程序
- 技术栈：微信小程序原生开发
- 开发模式：TDD（测试驱动开发）

## 代码规范
- 使用 TypeScript
- 遵循微信小程序最佳实践
- 组件化开发
- 所有函数必须有 JSDoc 注释

## 测试要求
- 单元测试覆盖率 > 80%
- 关键功能必须有 E2E 测试
- 每次提交前运行测试

## 使用的 Skills
- tdd-workflow：强制 TDD 开发
- coding-standards：代码规范
- security-review：安全检查

## 使用的 Agents
- planner：功能规划
- architect：架构设计
- code-reviewer：代码审查
- tdd-guide：TDD 指导
```

#### 2.3 初始化项目结构

在 Claude Code 中：

```
请帮我创建微信小程序的标准项目结构，包括：
- pages/：页面目录
- components/：组件目录
- utils/：工具函数
- services/：API 服务
- models/：数据模型
- config/：配置文件
- tests/：测试文件

使用 TypeScript，并为每个目录创建 README.md 说明其用途。
```

### 阶段三：核心功能开发（Day 3-14）

#### 3.1 使用 TDD 开发第一个功能

**示例：开发题库列表页面**

```
/tdd

我要开发题库列表页面，功能需求：
1. 显示题目列表（题目标题、难度、分类）
2. 支持按难度筛选
3. 支持按分类筛选
4. 点击题目进入详情页

请按照 TDD 流程指导我开发。
```

**TDD 流程**：

1. **RED（写失败的测试）**
```typescript
// tests/pages/question-list.test.ts
describe('题库列表页面', () => {
  it('应该显示题目列表', () => {
    // 测试代码
  });
  
  it('应该支持按难度筛选', () => {
    // 测试代码
  });
});
```

2. **GREEN（实现最小代码使测试通过）**
```typescript
// pages/question-list/question-list.ts
Page({
  data: {
    questions: []
  },
  
  onLoad() {
    // 实现代码
  }
});
```

3. **REFACTOR（重构优化）**
```typescript
// 提取可复用组件
// 优化性能
// 改进代码结构
```

#### 3.2 定期代码审查

每完成一个功能模块后：

```
/code-review

请审查我刚完成的题库列表功能，检查：
1. 代码质量
2. 性能问题
3. 安全隐患
4. 最佳实践
```

#### 3.3 重构和清理

定期清理代码：

```
/refactor-clean

请帮我清理项目中的：
1. 未使用的代码
2. 重复代码
3. 过时的注释
4. 临时文件
```

### 阶段四：集成 AI 功能（可选）

如果需要集成 LLM 进行智能评估：

#### 4.1 设计 AI 评估接口

```
@architect

我想集成 LLM 来评估用户的逻辑表达，请设计：
1. API 接口结构
2. 提示词模板
3. 评估标准
4. 结果展示方案
```

#### 4.2 实现 AI 服务

```typescript
// services/ai-evaluation.service.ts
export class AIEvaluationService {
  async evaluateLogic(userAnswer: string): Promise<EvaluationResult> {
    // 调用 LLM API
    // 解析评估结果
    // 返回结构化数据
  }
}
```

### 阶段五：测试和优化（Day 15-18）

#### 5.1 生成 E2E 测试

```
/e2e

请为以下用户流程生成 E2E 测试：
1. 用户打开小程序 → 浏览题库 → 选择题目 → 答题 → 查看结果
2. 用户查看学习进度 → 查看数据分析
```

#### 5.2 检查测试覆盖率

```
/test-coverage

请检查当前测试覆盖率，并为覆盖不足的模块补充测试。
```

#### 5.3 性能优化

```
请分析小程序性能，优化：
1. 页面加载速度
2. 列表渲染性能
3. 图片加载优化
4. 内存使用
```

### 阶段六：安全检查和上线准备（Day 19-21）

#### 6.1 安全审查

```
/security-review

请全面检查小程序的安全性，包括：
1. 数据传输安全
2. 用户隐私保护
3. API 安全
4. 敏感信息处理
```

#### 6.2 准备上线

```
请帮我准备小程序上线所需的：
1. 隐私政策
2. 用户协议
3. 小程序简介
4. 提审说明
```

## 常用命令速查

### 开发阶段

| 命令 | 用途 | 使用场景 |
|------|------|----------|
| `/plan` | 创建实施计划 | 开始新功能前 |
| `/tdd` | TDD 开发 | 开发所有功能 |
| `/code-review` | 代码审查 | 完成功能后 |
| `/refactor-clean` | 重构清理 | 定期清理 |
| `/e2e` | E2E 测试 | 测试用户流程 |
| `/test-coverage` | 测试覆盖率 | 检查测试质量 |
| `/security-review` | 安全审查 | 上线前 |

### 代理使用

| 代理 | 用途 | 调用方式 |
|------|------|----------|
| `planner` | 功能规划 | `@planner` |
| `architect` | 架构设计 | `@architect` |
| `code-reviewer` | 代码审查 | `@code-reviewer` |
| `security-reviewer` | 安全审查 | `@security-reviewer` |
| `tdd-guide` | TDD 指导 | `@tdd-guide` |

## 最佳实践

### 1. 始终使用 TDD

```
# 每个新功能都从测试开始
/tdd

功能需求：[描述功能]
```

### 2. 定期代码审查

```
# 每天结束前审查当天代码
/code-review

请审查今天的代码变更
```

### 3. 保持代码整洁

```
# 每周运行一次
/refactor-clean
```

### 4. 使用 Git 工作流

```bash
# 功能分支开发
git checkout -b feature/question-list

# 提交前运行测试
npm test

# 提交代码
git add .
git commit -m "feat: 实现题库列表功能"

# 代码审查后合并
git checkout main
git merge feature/question-list
```

### 5. 文档先行

为每个模块创建 README.md：

```markdown
# 题库模块

## 功能说明
...

## API 接口
...

## 数据模型
...

## 使用示例
...
```

## 项目里程碑

### Week 1：基础搭建
- ✅ 项目初始化
- ✅ 架构设计
- ✅ 基础页面框架

### Week 2：核心功能
- ✅ 题库列表
- ✅ 答题功能
- ✅ 结果展示

### Week 3：高级功能
- ✅ 学习进度
- ✅ 数据分析
- ✅ AI 评估（可选）

### Week 4：测试和上线
- ✅ 完整测试
- ✅ 性能优化
- ✅ 安全检查
- ✅ 提交审核

## 遇到问题时

### 构建错误
```
/build-fix

[粘贴错误信息]
```

### 代码问题
```
@code-reviewer

这段代码有问题：
[粘贴代码]

错误信息：
[粘贴错误]
```

### 架构疑问
```
@architect

我在实现 [功能] 时遇到架构问题：
[描述问题]

请给出建议。
```

## 总结

使用 Claude Code 开发的优势：

1. **系统化流程**：从规划到上线的完整流程
2. **高质量代码**：TDD + 代码审查保证质量
3. **快速迭代**：AI 辅助大幅提升效率
4. **最佳实践**：内置的规则和技能确保专业性
5. **中文支持**：完全中文化，理解更清晰

现在，让我们开始开发您的小程序吧！🚀
