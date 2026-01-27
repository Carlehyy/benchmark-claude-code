---
name: iterative-retrieval
description: 逐步优化上下文检索以解决子代理上下文问题的模式
---

# 迭代检索模式

解决多代理工作流中的“上下文问题”，即子代理在开始工作前不知道需要哪些上下文。

## 问题

子代理启动时上下文有限。他们不知道：
- 哪些文件包含相关代码
- 代码库中存在哪些模式
- 项目使用了哪些术语

标准方法失败：
- **发送所有内容**：超出上下文限制
- **不发送任何内容**：代理缺乏关键信息
- **猜测所需内容**：常常错误

## 解决方案：迭代检索

一个包含四个阶段的循环，逐步优化上下文：

```
┌─────────────────────────────────────────────┐
│                                             │
│   ┌──────────┐      ┌──────────┐            │
│   │ DISPATCH │─────▶│ EVALUATE │            │
│   └──────────┘      └──────────┘            │
│        ▲                  │                 │
│        │                  ▼                 │
│   ┌──────────┐      ┌──────────┐            │
│   │   LOOP   │◀─────│  REFINE  │            │
│   └──────────┘      └──────────┘            │
│                                             │
│        最多 3 个循环，然后继续                │
└─────────────────────────────────────────────┘
```

### 阶段 1：DISPATCH（分发）

初步广泛查询以收集候选文件：

```javascript
// 从高层意图开始
const initialQuery = {
  patterns: ['src/**/*.ts', 'lib/**/*.ts'],
  keywords: ['authentication', 'user', 'session'],
  excludes: ['*.test.ts', '*.spec.ts']
};

// 分发给检索代理
const candidates = await retrieveFiles(initialQuery);
```

### 阶段 2：EVALUATE（评估）

评估检索内容的相关性：

```javascript
function evaluateRelevance(files, task) {
  return files.map(file => ({
    path: file.path,
    relevance: scoreRelevance(file.content, task),
    reason: explainRelevance(file.content, task),
    missingContext: identifyGaps(file.content, task)
  }));
}
```

评分标准：
- **高（0.8-1.0）**：直接实现目标功能
- **中（0.5-0.7）**：包含相关模式或类型
- **低（0.2-0.4）**：间接相关
- **无（0-0.2）**：不相关，排除

### 阶段 3：REFINE（优化）

根据评估结果更新搜索条件：

```javascript
function refineQuery(evaluation, previousQuery) {
  return {
    // 添加在高相关文件中发现的新模式
    patterns: [...previousQuery.patterns, ...extractPatterns(evaluation)],

    // 添加代码库中发现的术语
    keywords: [...previousQuery.keywords, ...extractKeywords(evaluation)],

    // 排除已确认无关的路径
    excludes: [...previousQuery.excludes, ...evaluation
      .filter(e => e.relevance < 0.2)
      .map(e => e.path)
    ],

    // 针对特定缺失部分
    focusAreas: evaluation
      .flatMap(e => e.missingContext)
      .filter(unique)
  };
}
```

### 阶段 4：LOOP（循环）

用优化后的条件重复（最多 3 个循环）：

```javascript
async function iterativeRetrieve(task, maxCycles = 3) {
  let query = createInitialQuery(task);
  let bestContext = [];

  for (let cycle = 0; cycle < maxCycles; cycle++) {
    const candidates = await retrieveFiles(query);
    const evaluation = evaluateRelevance(candidates, task);

    // 检查是否已有足够上下文
    const highRelevance = evaluation.filter(e => e.relevance >= 0.7);
    if (highRelevance.length >= 3 && !hasCriticalGaps(evaluation)) {
      return highRelevance;
    }

    // 优化并继续
    query = refineQuery(evaluation, query);
    bestContext = mergeContext(bestContext, highRelevance);
  }

  return bestContext;
}
```

## 实践示例

### 示例 1：修复 Bug 上下文

```
任务: "修复认证令牌过期的 Bug"

循环 1：
  DISPATCH：在 src/** 中搜索 "token", "auth", "expiry"
  EVALUATE：找到 auth.ts (0.9), tokens.ts (0.8), user.ts (0.3)
  REFINE：添加关键词 "refresh", "jwt"；排除 user.ts

循环 2：
  DISPATCH：搜索优化后的关键词
  EVALUATE：找到 session-manager.ts (0.95), jwt-utils.ts (0.85)
  REFINE：上下文充分（2 个高相关文件）

结果：auth.ts, tokens.ts, session-manager.ts, jwt-utils.ts
```

### 示例 2：功能实现

```
任务: "为 API 端点添加速率限制"

循环 1：
  DISPATCH：在 routes/** 中搜索 "rate", "limit", "api"
  EVALUATE：无匹配 - 代码库使用 "throttle" 术语
  REFINE：添加关键词 "throttle", "middleware"

循环 2：
  DISPATCH：搜索优化后的关键词
  EVALUATE：找到 throttle.ts (0.9), middleware/index.ts (0.7)
  REFINE：需要路由器相关模式

循环 3：
  DISPATCH：搜索 "router", "express" 模式
  EVALUATE：找到 router-setup.ts (0.8)
  REFINE：上下文充分

结果：throttle.ts, middleware/index.ts, router-setup.ts
```

## 与代理集成

在代理提示中使用：

```markdown
检索此任务的上下文时：
1. 从广泛的关键词搜索开始
2. 评估每个文件的相关性（0-1 评分）
3. 识别仍缺失的上下文
4. 优化搜索条件并重复（最多 3 个循环）
5. 返回相关性 >= 0.7 的文件
```

## 最佳实践

1. **先广泛，逐步缩小** — 不要过早限定初始查询
2. **学习代码库术语** — 第一轮通常揭示命名规范
3. **跟踪缺失内容** — 明确的缺口识别推动优化
4. **达到“足够好”即停** — 3 个高相关文件胜过 10 个一般文件
5. **自信地排除** — 低相关文件不会变得重要

## 相关内容

- [长篇指南](https://x.com/affaanmustafa/status/2014040193557471352) - 子代理编排章节
- `continuous-learning` 技能 - 用于随时间改进的模式
- 代理定义位于 `~/.claude/agents/`