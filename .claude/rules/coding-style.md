# 编码规范

## 不可变性（关键）

始终创建新对象，绝不修改已有对象：

```javascript
// 错误示例：修改对象
function updateUser(user, name) {
  user.name = name  // 修改！
  return user
}

// 正确示例：不可变性
function updateUser(user, name) {
  return {
    ...user,
    name
  }
}
```

## 文件组织

多个小文件 > 少量大文件：
- 高内聚，低耦合
- 通常 200-400 行，最大 800 行
- 从大型组件中提取工具函数
- 按功能/领域组织，而非按类型

## 错误处理

始终全面处理错误：

```typescript
try {
  const result = await riskyOperation()
  return result
} catch (error) {
  console.error('操作失败:', error)
  throw new Error('详细且用户友好的错误信息')
}
```

## 输入验证

始终验证用户输入：

```typescript
import { z } from 'zod'

const schema = z.object({
  email: z.string().email(),
  age: z.number().int().min(0).max(150)
})

const validated = schema.parse(input)
```

## 代码质量检查清单

在标记工作完成前：
- [ ] 代码可读且命名合理
- [ ] 函数简洁（<50 行）
- [ ] 文件聚焦（<800 行）
- [ ] 无过深嵌套（>4 层）
- [ ] 正确的错误处理
- [ ] 无 console.log 语句
- [ ] 无硬编码值
- [ ] 无修改（使用不可变模式）