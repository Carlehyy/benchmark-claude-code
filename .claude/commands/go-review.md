---
description: 针对惯用模式、并发安全、错误处理和安全性的全面 Go 代码审查。调用 go-reviewer 代理。
---

# Go 代码审查

此命令调用 **go-reviewer** 代理，进行全面的 Go 语言特定代码审查。

## 此命令的功能

1. **识别 Go 变更**：通过 `git diff` 查找修改的 `.go` 文件
2. **运行静态分析**：执行 `go vet`、`staticcheck` 和 `golangci-lint`
3. **安全扫描**：检查 SQL 注入、命令注入、竞态条件
4. **并发审查**：分析 goroutine 安全性、channel 使用、互斥锁模式
5. **惯用 Go 检查**：验证代码是否遵循 Go 约定和最佳实践
6. **生成报告**：按严重程度分类问题

## 何时使用

在以下情况下使用 `/go-review`：
- 编写或修改 Go 代码后
- 提交 Go 代码变更前
- 审查包含 Go 代码的拉取请求时
- 新加入 Go 代码库时
- 学习惯用 Go 模式时

## 审查类别

### CRITICAL（必须修复）
- SQL/命令注入漏洞
- 无同步的竞态条件
- goroutine 泄漏
- 硬编码凭证
- 不安全的指针使用
- 关键路径中忽略错误

### HIGH（应修复）
- 缺少带上下文的错误包装
- 使用 panic 代替返回错误
- 上下文未传递
- 无缓冲 channel 导致死锁
- 接口未满足错误
- 缺少互斥锁保护

### MEDIUM（可考虑）
- 非惯用代码模式
- 导出项缺少 godoc 注释
- 低效的字符串拼接
- 切片未预分配
- 未使用表驱动测试

## 自动运行的检查

```bash
# 静态分析
go vet ./...

# 高级检查（如已安装）
staticcheck ./...
golangci-lint run

# 竞态检测
go build -race ./...

# 安全漏洞检测
govulncheck ./...
```

## 示例用法

```text
User: /go-review

Agent:
# Go 代码审查报告

## 审查文件
- internal/handler/user.go（已修改）
- internal/service/auth.go（已修改）

## 静态分析结果
✓ go vet：无问题
✓ staticcheck：无问题

## 发现的问题

[CRITICAL] 竞态条件
文件：internal/service/auth.go:45
问题：共享 map 未同步访问
```go
var cache = map[string]*Session{}  // 并发访问！

func GetSession(id string) *Session {
    return cache[id]  // 竞态条件
}
```
修复：使用 sync.RWMutex 或 sync.Map
```go
var (
    cache   = map[string]*Session{}
    cacheMu sync.RWMutex
)

func GetSession(id string) *Session {
    cacheMu.RLock()
    defer cacheMu.RUnlock()
    return cache[id]
}
```

[HIGH] 缺少错误上下文
文件：internal/handler/user.go:28
问题：返回错误时无上下文
```go
return err  // 无上下文
```
修复：添加上下文包装
```go
return fmt.Errorf("get user %s: %w", userID, err)
```

## 总结
- CRITICAL：1
- HIGH：1
- MEDIUM：0

建议：❌ 在修复 CRITICAL 问题前阻止合并
```

## 审批标准

| 状态 | 条件 |
|--------|-----------|
| ✅ 通过 | 无 CRITICAL 或 HIGH 问题 |
| ⚠️ 警告 | 仅有 MEDIUM 问题（谨慎合并） |
| ❌ 阻止 | 发现 CRITICAL 或 HIGH 问题 |

## 与其他命令的集成

- 先使用 `/go-test` 确保测试通过
- 出现构建错误时使用 `/go-build`
- 提交前使用 `/go-review`
- 针对非 Go 特定问题使用 `/code-review`

## 相关内容

- 代理：`agents/go-reviewer.md`
- 技能：`skills/golang-patterns/`、`skills/golang-testing/`