---
name: coding-standards
description: 适用于 TypeScript、JavaScript、React 和 Node.js 开发的通用编码标准、最佳实践和设计模式。
---

# 编码标准与最佳实践

适用于所有项目的通用编码标准。

## 代码质量原则

### 1. 可读性优先
- 代码被阅读的次数远多于被编写
- 清晰的变量和函数命名
- 倾向于自解释代码而非注释
- 格式统一一致

### 2. KISS（保持简单，愚蠢点）
- 采用最简单可行的解决方案
- 避免过度设计
- 不做过早优化
- 易于理解优于巧妙代码

### 3. DRY（不要重复自己）
- 将公共逻辑抽取为函数
- 创建可复用组件
- 在模块间共享工具函数
- 避免复制粘贴编程

### 4. YAGNI（你不会需要它）
- 不要在需求出现前构建功能
- 避免推测性泛化
- 仅在必要时增加复杂度
- 从简单开始，按需重构

## TypeScript/JavaScript 标准

### 变量命名

```typescript
// ✅ 好示例：描述性命名
const marketSearchQuery = 'election'
const isUserAuthenticated = true
const totalRevenue = 1000

// ❌ 差示例：命名不清晰
const q = 'election'
const flag = true
const x = 1000
```

### 函数命名

```typescript
// ✅ 好示例：动词-名词模式
async function fetchMarketData(marketId: string) { }
function calculateSimilarity(a: number[], b: number[]) { }
function isValidEmail(email: string): boolean { }

// ❌ 差示例：命名不清晰或仅用名词
async function market(id: string) { }
function similarity(a, b) { }
function email(e) { }
```

### 不可变模式（关键）

```typescript
// ✅ 始终使用扩展运算符
const updatedUser = {
  ...user,
  name: 'New Name'
}

const updatedArray = [...items, newItem]

// ❌ 切勿直接修改
user.name = 'New Name'  // 错误
items.push(newItem)     // 错误
```

### 错误处理

```typescript
// ✅ 好示例：全面的错误处理
async function fetchData(url: string) {
  try {
    const response = await fetch(url)

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`)
    }

    return await response.json()
  } catch (error) {
    console.error('Fetch failed:', error)
    throw new Error('Failed to fetch data')
  }
}

// ❌ 差示例：无错误处理
async function fetchData(url) {
  const response = await fetch(url)
  return response.json()
}
```

### Async/Await 最佳实践

```typescript
// ✅ 好示例：可并行执行时并行
const [users, markets, stats] = await Promise.all([
  fetchUsers(),
  fetchMarkets(),
  fetchStats()
])

// ❌ 差示例：不必要的顺序执行
const users = await fetchUsers()
const markets = await fetchMarkets()
const stats = await fetchStats()
```

### 类型安全

```typescript
// ✅ 好示例：正确使用类型
interface Market {
  id: string
  name: string
  status: 'active' | 'resolved' | 'closed'
  created_at: Date
}

function getMarket(id: string): Promise<Market> {
  // 实现
}

// ❌ 差示例：使用 any
function getMarket(id: any): Promise<any> {
  // 实现
}
```

## React 最佳实践

### 组件结构

```typescript
// ✅ 好示例：带类型的函数组件
interface ButtonProps {
  children: React.ReactNode
  onClick: () => void
  disabled?: boolean
  variant?: 'primary' | 'secondary'
}

export function Button({
  children,
  onClick,
  disabled = false,
  variant = 'primary'
}: ButtonProps) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`btn btn-${variant}`}
    >
      {children}
    </button>
  )
}

// ❌ 差示例：无类型，结构不清晰
export function Button(props) {
  return <button onClick={props.onClick}>{props.children}</button>
}
```

### 自定义 Hooks

```typescript
// ✅ 好示例：可复用自定义 Hook
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value)

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value)
    }, delay)

    return () => clearTimeout(handler)
  }, [value, delay])

  return debouncedValue
}

// 使用示例
const debouncedQuery = useDebounce(searchQuery, 500)
```

### 状态管理

```typescript
// ✅ 好示例：正确更新状态
const [count, setCount] = useState(0)

// 基于前一个状态的函数式更新
setCount(prev => prev + 1)

// ❌ 差示例：直接引用状态
setCount(count + 1)  // 在异步场景下可能出现过时状态
```

### 条件渲染

```typescript
// ✅ 好示例：清晰的条件渲染
{isLoading && <Spinner />}
{error && <ErrorMessage error={error} />}
{data && <DataDisplay data={data} />}

// ❌ 差示例：三元表达式地狱
{isLoading ? <Spinner /> : error ? <ErrorMessage error={error} /> : data ? <DataDisplay data={data} /> : null}
```

## API 设计标准

### REST API 约定

```
GET    /api/markets              # 列出所有市场
GET    /api/markets/:id          # 获取特定市场
POST   /api/markets              # 创建新市场
PUT    /api/markets/:id          # 更新市场（全部字段）
PATCH  /api/markets/:id          # 更新市场（部分字段）
DELETE /api/markets/:id          # 删除市场

# 过滤查询参数
GET /api/markets?status=active&limit=10&offset=0
```

### 响应格式

```typescript
// ✅ 好示例：统一响应结构
interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
  meta?: {
    total: number
    page: number
    limit: number
  }
}

// 成功响应
return NextResponse.json({
  success: true,
  data: markets,
  meta: { total: 100, page: 1, limit: 10 }
})

// 错误响应
return NextResponse.json({
  success: false,
  error: 'Invalid request'
}, { status: 400 })
```

### 输入校验

```typescript
import { z } from 'zod'

// ✅ 好示例：模式校验
const CreateMarketSchema = z.object({
  name: z.string().min(1).max(200),
  description: z.string().min(1).max(2000),
  endDate: z.string().datetime(),
  categories: z.array(z.string()).min(1)
})

export async function POST(request: Request) {
  const body = await request.json()

  try {
    const validated = CreateMarketSchema.parse(body)
    // 使用校验后的数据继续处理
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json({
        success: false,
        error: '验证失败',
        details: error.errors
      }, { status: 400 })
    }
  }
}
```

## 文件组织

### 项目结构

```
src/
├── app/                    # Next.js 应用路由
│   ├── api/               # API 路由
│   ├── markets/           # 市场页面
│   └── (auth)/           # 认证页面（路由组）
├── components/            # React 组件
│   ├── ui/               # 通用 UI 组件
│   ├── forms/            # 表单组件
│   └── layouts/          # 布局组件
├── hooks/                # 自定义 React Hooks
├── lib/                  # 工具和配置
│   ├── api/             # API 客户端
│   ├── utils/           # 辅助函数
│   └── constants/       # 常量
├── types/                # TypeScript 类型定义
└── styles/              # 全局样式
```

### 文件命名

```
components/Button.tsx          # 组件使用 PascalCase
hooks/useAuth.ts              # 自定义 Hook 使用 camelCase 且以 use 开头
lib/formatDate.ts             # 工具函数使用 camelCase
types/market.types.ts         # 类型文件使用 camelCase 并带 .types 后缀
```

## 注释与文档

### 何时注释

```typescript
// ✅ 好示例：解释为什么，而非做什么
// 使用指数退避以避免在 API 故障时过度请求
const delay = Math.min(1000 * Math.pow(2, retryCount), 30000)

// 此处故意使用可变操作以提升大数组性能
items.push(newItem)

// ❌ 差示例：陈述显而易见的内容
// 计数器加 1
count++

// 设置名称为用户名称
name = user.name
```

### 公共 API 的 JSDoc

```typescript
/**
 * 使用语义相似度搜索市场。
 *
 * @param query - 自然语言搜索查询
 * @param limit - 最大结果数（默认：10）
 * @returns 按相似度排序的市场数组
 * @throws {Error} 当 OpenAI API 失败或 Redis 不可用时抛出
 *
 * @example
 * ```typescript
 * const results = await searchMarkets('election', 5)
 * console.log(results[0].name) // "Trump vs Biden"
 * ```
 */
export async function searchMarkets(
  query: string,
  limit: number = 10
): Promise<Market[]> {
  // 实现
}
```

## 性能最佳实践

### 记忆化

```typescript
import { useMemo, useCallback } from 'react'

// ✅ 好示例：记忆化开销大的计算
const sortedMarkets = useMemo(() => {
  return markets.sort((a, b) => b.volume - a.volume)
}, [markets])

// ✅ 好示例：记忆化回调函数
const handleSearch = useCallback((query: string) => {
  setSearchQuery(query)
}, [])
```

### 懒加载

```typescript
import { lazy, Suspense } from 'react'

// ✅ 好示例：懒加载重量级组件
const HeavyChart = lazy(() => import('./HeavyChart'))

export function Dashboard() {
  return (
    <Suspense fallback={<Spinner />}>
      <HeavyChart />
    </Suspense>
  )
}
```

### 数据库查询

```typescript
// ✅ 好示例：只选择需要的列
const { data } = await supabase
  .from('markets')
  .select('id, name, status')
  .limit(10)

// ❌ 差示例：选择所有列
const { data } = await supabase
  .from('markets')
  .select('*')
```

## 测试标准

### 测试结构（AAA 模式）

```typescript
test('calculates similarity correctly', () => {
  // Arrange
  const vector1 = [1, 0, 0]
  const vector2 = [0, 1, 0]

  // Act
  const similarity = calculateCosineSimilarity(vector1, vector2)

  // Assert
  expect(similarity).toBe(0)
})
```

### 测试命名

```typescript
// ✅ 好示例：描述性测试名称
test('returns empty array when no markets match query', () => { })
test('throws error when OpenAI API key is missing', () => { })
test('falls back to substring search when Redis unavailable', () => { })

// ❌ 差示例：模糊测试名称
test('works', () => { })
test('test search', () => { })
```

## 代码异味检测

注意以下反模式：

### 1. 函数过长
```typescript
// ❌ 差示例：函数超过 50 行
function processMarketData() {
  // 100 行代码
}

// ✅ 好示例：拆分为更小函数
function processMarketData() {
  const validated = validateData()
  const transformed = transformData(validated)
  return saveData(transformed)
}
```

### 2. 嵌套过深
```typescript
// ❌ 差示例：超过 5 层嵌套
if (user) {
  if (user.isAdmin) {
    if (market) {
      if (market.isActive) {
        if (hasPermission) {
          // 执行操作
        }
      }
    }
  }
}

// ✅ 好示例：提前返回
if (!user) return
if (!user.isAdmin) return
if (!market) return
if (!market.isActive) return
if (!hasPermission) return

// 执行操作
```

### 3. 魔法数字
```typescript
// ❌ 差示例：无解释的数字
if (retryCount > 3) { }
setTimeout(callback, 500)

// ✅ 好示例：命名常量
const MAX_RETRIES = 3
const DEBOUNCE_DELAY_MS = 500

if (retryCount > MAX_RETRIES) { }
setTimeout(callback, DEBOUNCE_DELAY_MS)
```

**牢记**：代码质量不可妥协。清晰、可维护的代码促进快速开发和自信重构。