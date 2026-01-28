# Checkpoint 命令

在您的工作流程中创建或验证一个检查点。

## 用法

`/checkpoint [create|verify|list] [name]`

## 创建检查点

创建检查点时：

1. 运行 `/verify quick` 以确保当前状态干净
2. 使用检查点名称创建 git stash 或提交
3. 将检查点记录写入 `.claude/checkpoints.log`：

```bash
echo "$(date +%Y-%m-%d-%H:%M) | $CHECKPOINT_NAME | $(git rev-parse --short HEAD)" >> .claude/checkpoints.log
```

4. 报告检查点已创建

## 验证检查点

验证检查点时：

1. 从日志中读取检查点
2. 将当前状态与检查点进行比较：
   - 自检查点以来新增的文件
   - 自检查点以来修改的文件
   - 当前测试通过率与之前对比
   - 当前覆盖率与之前对比

3. 报告：
```
检查点对比: $NAME
============================
文件变更: X
测试: +Y 通过 / -Z 失败
覆盖率: +X% / -Y%
构建: [通过/失败]
```

## 列出检查点

显示所有检查点，包括：
- 名称
- 时间戳
- Git SHA
- 状态（当前、落后、领先）

## 工作流程

典型的检查点流程：

```
[开始] --> /checkpoint create "feature-start"
   |
[实现] --> /checkpoint create "core-done"
   |
[测试] --> /checkpoint verify "core-done"
   |
[重构] --> /checkpoint create "refactor-done"
   |
[合并请求] --> /checkpoint verify "feature-start"
```

## 参数

$ARGUMENTS:
- `create <name>` - 创建指定名称的检查点
- `verify <name>` - 验证指定名称的检查点
- `list` - 显示所有检查点
- `clear` - 删除旧检查点（保留最近 5 个）