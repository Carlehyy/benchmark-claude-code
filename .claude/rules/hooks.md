# Hooks 系统

## 钩子类型

- **PreToolUse**：工具执行前（验证、参数修改）
- **PostToolUse**：工具执行后（自动格式化、检查）
- **Stop**：会话结束时（最终验证）

## 当前钩子（位于 ~/.claude/settings.json）

### PreToolUse
- **tmux 提醒**：针对长时间运行的命令（npm、pnpm、yarn、cargo 等）建议使用 tmux
- **git push 审核**：在推送前打开 Zed 进行审核
- **文档阻止器**：阻止创建不必要的 .md/.txt 文件

### PostToolUse
- **PR 创建**：记录 PR URL 和 GitHub Actions 状态
- **Prettier**：编辑后自动格式化 JS/TS 文件
- **TypeScript 检查**：编辑 .ts/.tsx 文件后运行 tsc
- **console.log 警告**：警告编辑文件中存在的 console.log

### Stop
- **console.log 审计**：会话结束前检查所有修改文件中的 console.log

## 自动接受权限

谨慎使用：
- 对可信且定义明确的计划启用
- 探索性工作时禁用
- 切勿使用 dangerously-skip-permissions 标志
- 通过配置 `~/.claude.json` 中的 `allowedTools` 来管理权限

## TodoWrite 最佳实践

使用 TodoWrite 工具来：
- 跟踪多步骤任务的进度
- 验证对指令的理解
- 实现实时引导
- 展示细化的实施步骤

待办列表可揭示：
- 步骤顺序错误
- 缺失项
- 多余不必要的项
- 颗粒度错误
- 需求误解