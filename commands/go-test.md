---
description: 强制执行 Go 的测试驱动开发（TDD）工作流程。先编写表驱动测试，再实现代码。使用 go test -cover 验证覆盖率达到 80% 以上。
---

# Go TDD 命令

此命令通过惯用的 Go 测试模式，强制执行 Go 代码的测试驱动开发方法论。

## 此命令的功能

1. **定义类型/接口**：先搭建函数签名框架
2. **编写表驱动测试**：创建全面的测试用例（RED 阶段）
3. **运行测试**：验证测试因正确原因失败
4. **实现代码**：编写最少代码使测试通过（GREEN 阶段）
5. **重构**：在保持测试通过的前提下优化代码
6. **检查覆盖率**：确保覆盖率达到 80% 以上

## 何时使用

在以下场景使用 `/go-test`：
- 实现新的 Go 函数
- 为现有代码添加测试覆盖
- 修复缺陷（先编写失败的测试）
- 构建关键业务逻辑
- 学习 Go 的 TDD 工作流程

## TDD 循环

```
RED     → 编写失败的表驱动测试
GREEN   → 实现最少代码使测试通过
REFACTOR → 优化代码，测试保持通过
REPEAT  → 进行下一个测试用例
```

## 示例会话

```text
User: /go-test I need a function to validate email addresses

Agent:
# TDD 会话：邮箱验证器

## 第 1 步：定义接口

```go
// validator/email.go
package validator

// ValidateEmail 检查给定字符串是否为有效邮箱地址。
// 如果有效返回 nil，否则返回描述问题的错误。
func ValidateEmail(email string) error {
    panic("not implemented")
}
```

## 第 2 步：编写表驱动测试（RED 阶段）

```go
// validator/email_test.go
package validator

import (
    "testing"
)

func TestValidateEmail(t *testing.T) {
    tests := []struct {
        name    string
        email   string
        wantErr bool
    }{
        // 有效邮箱
        {"simple email", "user@example.com", false},
        {"with subdomain", "user@mail.example.com", false},
        {"with plus", "user+tag@example.com", false},
        {"with dots", "first.last@example.com", false},

        // 无效邮箱
        {"empty string", "", true},
        {"no at sign", "userexample.com", true},
        {"no domain", "user@", true},
        {"no local part", "@example.com", true},
        {"double at", "user@@example.com", true},
        {"spaces", "user @example.com", true},
        {"no tld", "user@example", true},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            err := ValidateEmail(tt.email)
            if tt.wantErr && err == nil {
                t.Errorf("ValidateEmail(%q) = nil; want error", tt.email)
            }
            if !tt.wantErr && err != nil {
                t.Errorf("ValidateEmail(%q) = %v; want nil", tt.email, err)
            }
        })
    }
}
```

## 第 3 步：运行测试 - 验证失败

```bash
$ go test ./validator/...

--- FAIL: TestValidateEmail (0.00s)
    --- FAIL: TestValidateEmail/simple_email (0.00s)
        panic: not implemented

FAIL
```

✓ 测试如预期失败（panic）。

## 第 4 步：实现最少代码（GREEN 阶段）

```go
// validator/email.go
package validator

import (
    "errors"
    "regexp"
)

var emailRegex = regexp.MustCompile(`^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`)

var (
    ErrEmailEmpty   = errors.New("email cannot be empty")
    ErrEmailInvalid = errors.New("email format is invalid")
)

func ValidateEmail(email string) error {
    if email == "" {
        return ErrEmailEmpty
    }
    if !emailRegex.MatchString(email) {
        return ErrEmailInvalid
    }
    return nil
}
```

## 第 5 步：运行测试 - 验证通过

```bash
$ go test ./validator/...

PASS
ok      project/validator    0.003s
```

✓ 所有测试通过！

## 第 6 步：检查覆盖率

```bash
$ go test -cover ./validator/...

PASS
coverage: 100.0% of statements
ok      project/validator    0.003s
```

✓ 覆盖率：100%

## TDD 完成！
```

## 测试模式

### 表驱动测试
```go
tests := []struct {
    name     string
    input    InputType
    want     OutputType
    wantErr  bool
}{
    {"case 1", input1, want1, false},
    {"case 2", input2, want2, true},
}

for _, tt := range tests {
    t.Run(tt.name, func(t *testing.T) {
        got, err := Function(tt.input)
        // 断言
    })
}
```

### 并行测试
```go
for _, tt := range tests {
    tt := tt // 捕获变量
    t.Run(tt.name, func(t *testing.T) {
        t.Parallel()
        // 测试主体
    })
}
```

### 测试辅助函数
```go
func setupTestDB(t *testing.T) *sql.DB {
    t.Helper()
    db := createDB()
    t.Cleanup(func() { db.Close() })
    return db
}
```

## 覆盖率命令

```bash
# 基础覆盖率
go test -cover ./...

# 覆盖率配置文件
go test -coverprofile=coverage.out ./...

# 浏览器查看覆盖率报告
go tool cover -html=coverage.out

# 按函数查看覆盖率
go tool cover -func=coverage.out

# 启用竞态检测的覆盖率
go test -race -cover ./...
```

## 覆盖率目标

| 代码类型       | 目标     |
|--------------|---------|
| 关键业务逻辑    | 100%    |
| 公共 API      | 90% 以上 |
| 一般代码       | 80% 以上 |
| 生成代码       | 排除     |

## TDD 最佳实践

**建议：**
- 先写测试，再实现功能
- 每次修改后运行测试
- 使用表驱动测试保证覆盖全面
- 测试行为而非实现细节
- 包含边界情况（空值、nil、最大值）

**避免：**
- 先写实现再写测试
- 跳过 RED 阶段
- 直接测试私有函数
- 测试中使用 `time.Sleep`
- 忽视不稳定的测试

## 相关命令

- `/go-build` - 修复构建错误
- `/go-review` - 实现后代码审查
- `/verify` - 运行完整验证流程

## 相关内容

- 技能：`skills/golang-testing/`
- 技能：`skills/tdd-workflow/`