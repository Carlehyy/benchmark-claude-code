---
description: 逐步修复 Go 构建错误、go vet 警告和代码检查问题。调用 go-build-resolver 代理进行最小化、精准的修复。
---

# Go 构建与修复

该命令调用 **go-build-resolver** 代理，以最小改动逐步修复 Go 构建错误。

## 命令功能

1. **运行诊断**：执行 `go build`、`go vet`、`staticcheck`
2. **解析错误**：按文件分组并按严重程度排序
3. **逐步修复**：一次修复一个错误
4. **验证修复**：每次修改后重新构建
5. **报告总结**：展示已修复和未解决的问题

## 适用场景

当出现以下情况时使用 `/go-build`：
- `go build ./...` 构建失败报错
- `go vet ./...` 报告问题
- `golangci-lint run` 显示警告
- 模块依赖损坏
- 拉取代码后导致构建失败

## 运行的诊断命令

```bash
# 主要构建检查
go build ./...

# 静态分析
go vet ./...

# 扩展代码检查（如果可用）
staticcheck ./...
golangci-lint run

# 模块问题检查
go mod verify
go mod tidy -v
```

## 示例会话

```text
用户: /go-build

代理:
# Go 构建解决方案

## 初始诊断

```bash
$ go build ./...
internal/service/user.go:25:15: undefined: UserRepository
internal/handler/api.go:42:9: cannot use x (type string) as type int
internal/handler/api.go:58:2: missing return at end of function
```

发现错误：3 个

## 修复 1：未定义标识符

文件：internal/service/user.go:25
错误：undefined: UserRepository
原因：缺少导入

```go
// 添加导入
import "project/internal/repository"

// 修改
var repo UserRepository
// 为
var repo repository.UserRepository
```

```bash
$ go build ./...
# 剩余 2 个错误
```

## 修复 2：类型不匹配

文件：internal/handler/api.go:42
错误：cannot use x (type string) as type int

```go
// 修改
count := params.Get("count")
// 为
countStr := params.Get("count")
count, _ := strconv.Atoi(countStr)
```

```bash
$ go build ./...
# 剩余 1 个错误
```

## 修复 3：缺少返回值

文件：internal/handler/api.go:58
错误：missing return at end of function

```go
func GetUser(id string) (*User, error) {
    if id == "" {
        return nil, ErrInvalidID
    }
    user := findUser(id)
    // 添加缺失的返回
    return user, nil
}
```

```bash
$ go build ./...
# 构建成功！
```

## 最终验证

```bash
$ go vet ./...
# 无问题

$ go test ./...
ok      project/internal/service   0.015s
ok      project/internal/handler   0.023s
```

## 总结

| 指标 | 数量 |
|--------|-------|
| 修复的构建错误 | 3 |
| 修复的 vet 警告 | 0 |
| 修改的文件数 | 2 |
| 剩余问题数 | 0 |

构建状态：✅ 成功
```

## 常见修复错误

| 错误 | 典型修复方法 |
|-------|-------------|
| `undefined: X` | 添加导入或修正拼写错误 |
| `cannot use X as Y` | 类型转换或修正赋值 |
| `missing return` | 添加返回语句 |
| `X does not implement Y` | 添加缺失的方法 |
| `import cycle` | 重构包结构 |
| `declared but not used` | 删除或使用变量 |
| `cannot find package` | 使用 `go get` 或 `go mod tidy` |

## 修复策略

1. **优先修复构建错误** — 代码必须能编译
2. **其次修复 vet 警告** — 修复可疑代码结构
3. **然后修复代码检查警告** — 代码风格和最佳实践
4. **一次修复一个问题** — 验证每次修改
5. **最小改动原则** — 不重构，仅修复

## 停止条件

代理将在以下情况下停止并报告：
- 同一错误尝试 3 次仍未解决
- 修复导致更多错误
- 需要架构性变更
- 缺少外部依赖

## 相关命令

- `/go-test` - 构建成功后运行测试
- `/go-review` - 代码质量审查
- `/verify` - 完整验证流程

## 相关资源

- 代理：`agents/go-build-resolver.md`
- 技能：`skills/golang-patterns/`