# 安全指南

## 强制安全检查

在任何提交之前：
- [ ] 不得有硬编码的密钥（API 密钥、密码、令牌）
- [ ] 所有用户输入均已验证
- [ ] 防止 SQL 注入（参数化查询）
- [ ] 防止 XSS（清理后的 HTML）
- [ ] 启用 CSRF 保护
- [ ] 验证身份认证/授权
- [ ] 所有端点均有限流措施
- [ ] 错误信息不泄露敏感数据

## 密钥管理

```typescript
// 绝不可：硬编码密钥
const apiKey = "sk-proj-xxxxx"

// 必须：环境变量
const apiKey = process.env.OPENAI_API_KEY

if (!apiKey) {
  throw new Error('OPENAI_API_KEY 未配置')
}
```

## 安全响应流程

发现安全问题时：
1. 立即停止
2. 使用 **security-reviewer** 代理
3. 先修复关键问题后再继续
4. 轮换任何暴露的密钥
5. 审查整个代码库是否存在类似问题