# 插件清单模式说明

本文档记录了 Claude Code 插件清单验证器中**未公开但强制执行的约束**。

这些规则基于实际安装失败、验证器行为以及与已知可用插件的对比。
它们的存在是为了防止隐性故障和反复出现的回归问题。

如果你要编辑 `.claude-plugin/plugin.json`，请先阅读本文。

---

## 概要（请先阅读）

Claude 插件清单验证器是**严格且有明确规范的**。
它强制执行的规则未在公开的模式参考中完全记录。

最常见的失败模式是：

> 清单看起来合理，但验证器以模糊错误拒绝，比如
> `agents: Invalid input`

本文档将解释原因。

---

## 必填字段

### `version`（必填）

即使某些示例中省略了，验证器仍要求必须有 `version` 字段。

缺失时，安装可能在市场安装或 CLI 验证阶段失败。

示例：

```json
{
  "version": "1.1.0"
}
```

---

## 字段格式规则

以下字段**必须始终是数组**：

* `agents`
* `commands`
* `skills`
* `hooks`（如果存在）

即使只有一项，**不接受字符串类型**。

### 无效示例

```json
{
  "agents": "./agents"
}
```

### 有效示例

```json
{
  "agents": ["./agents/planner.md"]
}
```

此规则对所有组件路径字段均适用。

---

## 路径解析规则（关键）

### Agents 必须使用明确的文件路径

验证器**不接受 `agents` 字段使用目录路径**。

即使如下写法也会失败：

```json
{
  "agents": ["./agents/"]
}
```

必须显式列出每个 agent 文件：

```json
{
  "agents": [
    "./agents/planner.md",
    "./agents/architect.md",
    "./agents/code-reviewer.md"
  ]
}
```

这是验证错误最常见的原因。

### Commands 和 Skills

* `commands` 和 `skills` 仅在用数组包裹时接受目录路径
* 显式文件路径是最安全且最具前瞻性的做法

---

## 验证器行为说明

* `claude plugin validate` 比某些市场预览更严格
* 本地验证可能通过，但安装时若路径不明确则失败
* 错误信息通常泛泛（如 `Invalid input`），不指示根本原因
* 跨平台安装（尤其是 Windows）对路径假设更不宽容

请假设验证器是严格且字面意义理解的。

---

## 已知反模式

以下写法看似正确，但会被拒绝：

* 使用字符串而非数组
* `agents` 使用目录数组
* 缺少 `version`
* 依赖推断路径
* 认为市场行为与本地验证一致

避免“聪明”写法，保持明确。

---

## 最小已知有效示例

```json
{
  "version": "1.1.0",
  "agents": [
    "./agents/planner.md",
    "./agents/code-reviewer.md"
  ],
  "commands": ["./commands/"],
  "skills": ["./skills/"]
}
```

此结构已通过 Claude 插件验证器验证。

---

## 对贡献者的建议

在提交涉及 `plugin.json` 的更改前：

1. 对 agents 使用明确的文件路径
2. 确保所有组件字段均为数组
3. 包含 `version`
4. 运行：

```bash
claude plugin validate .claude-plugin/plugin.json
```

如有疑问，宁可冗长明确，也不要图省事。

---

## 本文件存在的原因

本仓库被广泛 Fork 并用作参考实现。

在此记录验证器的特殊规则：

* 防止重复出现问题
* 减少贡献者挫败感
* 随生态发展保障插件稳定性

若验证器发生变化，请优先更新本文档。