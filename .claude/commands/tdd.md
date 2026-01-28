---
description: 强制执行测试驱动开发工作流程。先搭建接口，优先生成测试，然后实现最小代码以通过测试。确保覆盖率达到80%以上。
---

# TDD 命令

该命令调用 **tdd-guide** 代理以强制执行测试驱动开发方法论。

## 该命令的功能

1. **搭建接口** - 先定义类型/接口
2. **先生成测试** - 编写失败的测试（RED）
3. **实现最小代码** - 编写刚好能通过测试的代码（GREEN）
4. **重构** - 在保持测试通过的前提下优化代码（REFACTOR）
5. **验证覆盖率** - 确保测试覆盖率达到80%以上

## 何时使用

在以下情况下使用 `/tdd`：
- 实现新功能
- 添加新函数/组件
- 修复缺陷（先编写复现缺陷的测试）
- 重构现有代码
- 构建关键业务逻辑

## 工作原理

tdd-guide 代理将：

1. **定义输入/输出接口**
2. **编写会失败的测试**（因为代码尚未实现）
3. **运行测试**并验证失败原因正确
4. **编写最小实现**使测试通过
5. **运行测试**并验证通过
6. **重构代码**同时保持测试通过
7. **检查覆盖率**，若低于80%则补充测试

## TDD 循环

```
RED → GREEN → REFACTOR → REPEAT

RED:      编写失败的测试
GREEN:    编写最小代码使测试通过
REFACTOR: 优化代码，保持测试通过
REPEAT:   下一个功能/场景
```

## 示例用法

```
User: /tdd 我需要一个函数来计算市场流动性得分

Agent (tdd-guide):
# TDD 会话：市场流动性得分计算器

## 第一步：定义接口（搭建）

```typescript
// lib/liquidity.ts
export interface MarketData {
  totalVolume: number
  bidAskSpread: number
  activeTraders: number
  lastTradeTime: Date
}

export function calculateLiquidityScore(market: MarketData): number {
  // TODO: 实现
  throw new Error('Not implemented')
}
```

## 第二步：编写失败测试（RED）

```typescript
// lib/liquidity.test.ts
import { calculateLiquidityScore } from './liquidity'

describe('calculateLiquidityScore', () => {
  it('应返回高分表示流动性市场', () => {
    const market = {
      totalVolume: 100000,
      bidAskSpread: 0.01,
      activeTraders: 500,
      lastTradeTime: new Date()
    }

    const score = calculateLiquidityScore(market)

    expect(score).toBeGreaterThan(80)
    expect(score).toBeLessThanOrEqual(100)
  })

  it('应返回低分表示流动性差的市场', () => {
    const market = {
      totalVolume: 100,
      bidAskSpread: 0.5,
      activeTraders: 2,
      lastTradeTime: new Date(Date.now() - 86400000) // 1天前
    }

    const score = calculateLiquidityScore(market)

    expect(score).toBeLessThan(30)
    expect(score).toBeGreaterThanOrEqual(0)
  })

  it('应处理边界情况：零交易量', () => {
    const market = {
      totalVolume: 0,
      bidAskSpread: 0,
      activeTraders: 0,
      lastTradeTime: new Date()
    }

    const score = calculateLiquidityScore(market)

    expect(score).toBe(0)
  })
})
```

## 第三步：运行测试 - 验证失败

```bash
npm test lib/liquidity.test.ts

FAIL lib/liquidity.test.ts
  ✕ 应返回高分表示流动性市场 (2 ms)
    Error: Not implemented

1 个测试失败，0 个通过
```

✅ 测试如预期失败，准备实现代码。

## 第四步：实现最小代码（GREEN）

```typescript
// lib/liquidity.ts
export function calculateLiquidityScore(market: MarketData): number {
  // 处理零交易量边界情况
  if (market.totalVolume === 0) {
    return 0
  }

  // 计算各项得分（0-100 量表）
  const volumeScore = Math.min(market.totalVolume / 1000, 100)
  const spreadScore = Math.max(100 - (market.bidAskSpread * 1000), 0)
  const traderScore = Math.min(market.activeTraders / 10, 100)

  // 最近交易活动加分
  const hoursSinceLastTrade = (Date.now() - market.lastTradeTime.getTime()) / (1000 * 60 * 60)
  const recencyScore = Math.max(100 - (hoursSinceLastTrade * 10), 0)

  // 加权平均
  const score = (
    volumeScore * 0.4 +
    spreadScore * 0.3 +
    traderScore * 0.2 +
    recencyScore * 0.1
  )

  return Math.min(Math.max(score, 0), 100) // 限制在0-100范围内
}
```

## 第五步：运行测试 - 验证通过

```bash
npm test lib/liquidity.test.ts

PASS lib/liquidity.test.ts
  ✓ 应返回高分表示流动性市场 (3 ms)
  ✓ 应返回低分表示流动性差的市场 (2 ms)
  ✓ 应处理边界情况：零交易量 (1 ms)

3 个测试通过
```

✅ 所有测试通过！

## 第六步：重构（优化）

```typescript
// lib/liquidity.ts - 重构，使用常量提升可读性
const WEIGHTS = {
  VOLUME: 0.4,
  SPREAD: 0.3,
  TRADERS: 0.2,
  RECENCY: 0.1,
} as const

const SCALE_FACTORS = {
  VOLUME: 1000,
  SPREAD: 1000,
  TRADERS: 10,
  RECENCY_PENALTY: 10,
} as const

function clamp(value: number, min: number, max: number): number {
  return Math.min(Math.max(value, min), max)
}

export function calculateLiquidityScore(market: MarketData): number {
  if (market.totalVolume === 0) return 0

  const volumeScore = Math.min(market.totalVolume / SCALE_FACTORS.VOLUME, 100)
  const spreadScore = clamp(100 - (market.bidAskSpread * SCALE_FACTORS.SPREAD), 0, 100)
  const traderScore = Math.min(market.activeTraders / SCALE_FACTORS.TRADERS, 100)

  const hoursSinceLastTrade = (Date.now() - market.lastTradeTime.getTime()) / (1000 * 60 * 60)
  const recencyScore = clamp(100 - (hoursSinceLastTrade * SCALE_FACTORS.RECENCY_PENALTY), 0, 100)

  const weightedScore =
    volumeScore * WEIGHTS.VOLUME +
    spreadScore * WEIGHTS.SPREAD +
    traderScore * WEIGHTS.TRADERS +
    recencyScore * WEIGHTS.RECENCY

  return clamp(weightedScore, 0, 100)
}
```

## 第七步：验证测试仍然通过

```bash
npm test lib/liquidity.test.ts

PASS lib/liquidity.test.ts
  ✓ 应返回高分表示流动性市场 (3 ms)
  ✓ 应返回低分表示流动性差的市场 (2 ms)
  ✓ 应处理边界情况：零交易量 (1 ms)

3 个测试通过
```

✅ 重构完成，测试依旧通过！

## 第八步：检查覆盖率

```bash
npm test -- --coverage lib/liquidity.test.ts

File           | % Stmts | % Branch | % Funcs | % Lines
---------------|---------|----------|---------|--------
liquidity.ts   |   100   |   100    |   100   |   100

覆盖率：100% ✅ （目标：80%）
```

✅ TDD 会话完成！
```

## TDD 最佳实践

**应做：**
- ✅ 先编写测试，再实现代码
- ✅ 运行测试并确认失败后再实现
- ✅ 编写最小代码使测试通过
- ✅ 测试通过后再进行重构
- ✅ 增加边界情况和错误场景测试
- ✅ 目标覆盖率80%以上（关键代码100%）

**不应做：**
- ❌ 先写实现代码再写测试
- ❌ 每次修改后跳过运行测试
- ❌ 一次写太多代码
- ❌ 忽视失败的测试
- ❌ 测试实现细节（应测试行为）
- ❌ 过度模拟，优先集成测试

## 应包含的测试类型

**单元测试**（函数级）：
- 正常路径场景
- 边界情况（空值、null、最大值）
- 错误条件
- 边界值测试

**集成测试**（组件级）：
- API 接口
- 数据库操作
- 外部服务调用
- 带 Hooks 的 React 组件

**端到端测试**（使用 `/e2e` 命令）：
- 关键用户流程
- 多步骤流程
- 全栈集成

## 覆盖率要求

- 所有代码最低80%
- 以下代码需100%覆盖：
  - 财务计算
  - 认证逻辑
  - 安全关键代码
  - 核心业务逻辑

## 重要说明

**强制要求**：必须先写测试再实现。TDD 循环为：

1. **RED** - 编写失败测试
2. **GREEN** - 实现代码使测试通过
3. **REFACTOR** - 优化代码

切勿跳过 RED 阶段，切勿先写代码再写测试。

## 与其他命令的集成

- 先用 `/plan` 理解需求
- 用 `/tdd` 实现并编写测试
- 出现构建错误时用 `/build-and-fix`
- 用 `/code-review` 进行代码审查
- 用 `/test-coverage` 验证覆盖率

## 相关代理

该命令调用位于：
`~/.claude/agents/tdd-guide.md` 的 `tdd-guide` 代理

并可引用技能：
`~/.claude/skills/tdd-workflow/` 的 `tdd-workflow` 技能