# 微信小程序自动化脚本

本目录包含用于 Claude 自动化预览和测试微信小程序的脚本工具。

## 📁 文件说明

| 文件 | 说明 |
|------|------|
| `auto-preview.js` | 自动预览脚本，连接开发者工具并截图 |
| `start-automation.sh` | 启动脚本，自动查找并启动开发者工具 |
| `package.json.example` | npm 配置示例文件 |
| `README.md` | 本说明文档 |

## 🚀 快速开始

### 1. 安装依赖

将 `package.json.example` 复制到您的小程序项目根目录并重命名为 `package.json`：

```bash
# 进入您的小程序项目目录
cd /path/to/your/miniapp

# 复制配置文件
cp /path/to/automation-scripts/package.json.example ./package.json

# 安装依赖
npm install
```

### 2. 复制脚本文件

```bash
# 在项目根目录创建 scripts 目录
mkdir -p scripts

# 复制脚本文件
cp /path/to/automation-scripts/auto-preview.js ./scripts/
cp /path/to/automation-scripts/start-automation.sh ./scripts/

# 添加执行权限
chmod +x ./scripts/start-automation.sh
```

### 3. 启动自动化

```bash
# 方式一：使用启动脚本（推荐）
bash scripts/start-automation.sh /path/to/your/miniapp 9420

# 方式二：手动启动开发者工具
# macOS
/Applications/wechatwebdevtools.app/Contents/MacOS/cli \
  --auto /path/to/your/miniapp \
  --auto-port 9420

# Windows
"C:\Program Files (x86)\Tencent\微信web开发者工具\cli.bat" ^
  --auto C:\path\to\your\miniapp ^
  --auto-port 9420
```

### 4. 预览页面

```bash
# 预览单个页面
node scripts/auto-preview.js /pages/index/index

# 指定输出目录
node scripts/auto-preview.js /pages/index/index ./screenshots

# 指定端口
node scripts/auto-preview.js /pages/index/index ./screenshots 9420

# 批量预览多个页面
node scripts/auto-preview.js /pages/index/index,/pages/list/list,/pages/detail/detail
```

## 📖 详细使用说明

### auto-preview.js

自动预览脚本，用于连接开发者工具、截图和获取页面信息。

#### 功能特性

- ✅ 连接到微信开发者工具
- ✅ 导航到指定页面
- ✅ 自动截图并保存
- ✅ 获取页面数据（data）
- ✅ 统计页面元素数量
- ✅ 生成 JSON 格式的页面报告
- ✅ 支持批量预览多个页面
- ✅ 详细的错误提示和诊断

#### 命令格式

```bash
node auto-preview.js <页面路径> [输出目录] [WebSocket端口]
```

#### 参数说明

| 参数 | 必填 | 默认值 | 说明 |
|------|------|--------|------|
| 页面路径 | 是 | - | 小程序页面路径，如 `/pages/index/index` |
| 输出目录 | 否 | `./screenshots` | 截图和数据保存目录 |
| WebSocket端口 | 否 | `9420` | 开发者工具自动化端口 |

#### 使用示例

```bash
# 1. 预览首页
node auto-preview.js /pages/index/index

# 2. 预览题库列表页
node auto-preview.js /pages/question-list/question-list ./output

# 3. 批量预览所有主要页面
node auto-preview.js /pages/index/index,/pages/question-list/question-list,/pages/question-detail/question-detail

# 4. 使用自定义端口
node auto-preview.js /pages/index/index ./screenshots 9421
```

#### 输出文件

每次预览会生成两个文件：

1. **截图文件**：`<页面路径>_<时间戳>.png`
   - 完整的页面截图
   - PNG 格式，高清质量

2. **数据文件**：`<页面路径>_<时间戳>.json`
   - 页面数据（data）
   - 元素统计信息
   - 时间戳和路径信息

示例输出：

```
screenshots/
├── _pages_index_index_1706345678901.png
├── _pages_index_index_1706345678901.json
├── _pages_list_list_1706345679123.png
└── _pages_list_list_1706345679123.json
```

#### 错误处理

脚本会自动检测常见错误并提供解决建议：

**连接失败（ECONNREFUSED）**

```
可能的原因：
1. 微信开发者工具未运行
2. 未开启自动化端口
3. 端口号不正确

解决方法：
1. 打开微信开发者工具
2. 设置 -> 安全设置 -> 开启服务端口
3. 使用命令行启动: cli --auto <项目路径> --auto-port 9420
```

### start-automation.sh

自动启动脚本，用于查找并启动微信开发者工具。

#### 功能特性

- ✅ 自动检测操作系统（macOS/Windows/Linux）
- ✅ 自动查找开发者工具 CLI 路径
- ✅ 验证项目路径和配置文件
- ✅ 启动开发者工具并开启自动化端口
- ✅ 彩色输出和详细的状态提示
- ✅ 完善的错误处理和诊断

#### 命令格式

```bash
bash start-automation.sh <项目路径> [自动化端口]
```

#### 参数说明

| 参数 | 必填 | 默认值 | 说明 |
|------|------|--------|------|
| 项目路径 | 是 | - | 小程序项目的绝对路径 |
| 自动化端口 | 否 | `9420` | WebSocket 端口号 |

#### 使用示例

```bash
# 1. 使用默认端口启动
bash start-automation.sh /Users/username/my-miniapp

# 2. 指定端口启动
bash start-automation.sh /Users/username/my-miniapp 9421

# 3. 查看帮助
bash start-automation.sh --help
```

#### 环境变量

如果脚本无法自动找到 CLI 路径，可以手动设置环境变量：

```bash
# macOS
export WECHAT_CLI_PATH="/Applications/wechatwebdevtools.app/Contents/MacOS/cli"

# Windows (Git Bash)
export WECHAT_CLI_PATH="C:/Program Files (x86)/Tencent/微信web开发者工具/cli.bat"

# 然后运行脚本
bash start-automation.sh /path/to/project
```

## 🎯 在 Claude Code 中使用

### 方式一：在提示词中使用

```
/tdd

功能需求：实现首页布局

UI 要求：
- 标题：32rpx，#333，居中
- 按钮：宽度 600rpx，背景色 #07C160

开发流程：
1. 生成 WXML、WXSS、JS 代码
2. 保存文件到对应目录
3. 运行预览：node scripts/auto-preview.js /pages/index/index
4. 查看截图：screenshots/_pages_index_index_*.png
5. 验证效果是否符合 UI 要求
6. 如不符合，调整代码并重复步骤 2-5

请开始 TDD 开发。
```

### 方式二：集成到开发流程

```
/plan

任务：开发首页

步骤：
1. 分析需求和设计稿
2. 编写测试用例
3. 实现页面代码
4. 自动预览验证：
   - 执行：node scripts/auto-preview.js /pages/index/index
   - 查看截图对比设计稿
   - 检查元素统计是否合理
5. 如有问题，返回步骤 3
6. 代码审查和优化

请创建详细计划。
```

### 方式三：批量验证

```
/code-review

请审查以下页面的实现：
- /pages/index/index
- /pages/question-list/question-list
- /pages/question-detail/question-detail

审查流程：
1. 批量预览：node scripts/auto-preview.js <页面列表>
2. 查看所有截图
3. 检查页面数据和元素统计
4. 对比设计稿验证 UI 还原度
5. 提出改进建议

请开始审查。
```

## 🔧 配置说明

### 项目配置

确保 `project.config.json` 中包含以下配置：

```json
{
  "appid": "your-appid",
  "projectname": "your-project-name",
  "setting": {
    "urlCheck": false,
    "es6": true,
    "enhance": true,
    "postcss": true,
    "minified": false,
    "newFeature": true,
    "autoAudits": false
  }
}
```

### 自动化配置

在开发者工具中：

1. 打开 **设置 -> 安全设置**
2. 开启 **服务端口**
3. （可选）开启 **CLI/HTTP 调用**

## 📊 输出示例

### 控制台输出

```
============================================================
微信小程序自动预览工具
============================================================
页面路径: /pages/index/index
输出目录: ./screenshots
WebSocket 端口: 9420
============================================================

[1/5] 正在连接微信开发者工具...
✓ 连接成功

[2/5] 正在打开页面: /pages/index/index
✓ 页面已打开

[3/5] 等待页面渲染...
✓ 页面渲染完成

[4/5] 正在截图...
✓ 截图已保存: ./screenshots/_pages_index_index_1706345678901.png

[5/5] 正在获取页面信息...
✓ 页面信息获取完成

============================================================
页面统计信息
============================================================
View 元素: 15
Text 元素: 8
Button 元素: 2
Image 元素: 3
总元素数: 28
============================================================

页面数据已保存: ./screenshots/_pages_index_index_1706345678901.json

连接已关闭

✓ 预览成功！
```

### JSON 数据文件

```json
{
  "timestamp": "2026-01-27T12:34:56.789Z",
  "pagePath": "/pages/index/index",
  "screenshotPath": "./screenshots/_pages_index_index_1706345678901.png",
  "pageData": {
    "title": "逻辑表达力训练",
    "subtitle": "提升你的逻辑思维能力",
    "userInfo": null
  },
  "elementStats": {
    "view": 15,
    "text": 8,
    "button": 2,
    "image": 3,
    "total": 28
  }
}
```

## ❓ 常见问题

### Q1: 连接失败怎么办？

**A:** 检查以下几点：

1. 微信开发者工具是否正在运行
2. 是否开启了服务端口（设置 -> 安全设置）
3. 端口号是否正确
4. 是否使用命令行启动了自动化模式

### Q2: 截图是空白的？

**A:** 可能的原因：

1. 页面加载时间不够，增加等待时间
2. 页面路径错误
3. 页面有错误导致渲染失败

解决方法：修改 `auto-preview.js` 中的等待时间：

```javascript
await page.waitFor(3000); // 增加到 3 秒
```

### Q3: 如何在 CI/CD 中使用？

**A:** 可以将脚本集成到 CI/CD 流程：

```yaml
# GitHub Actions 示例
- name: Install dependencies
  run: npm install

- name: Start automation
  run: bash scripts/start-automation.sh $PWD 9420 &

- name: Wait for tool to start
  run: sleep 10

- name: Preview pages
  run: node scripts/auto-preview.js /pages/index/index ./screenshots

- name: Upload screenshots
  uses: actions/upload-artifact@v2
  with:
    name: screenshots
    path: screenshots/
```

### Q4: 支持真机预览吗？

**A:** 当前脚本主要用于模拟器预览。真机预览需要使用微信开发者工具的真机调试功能，可以参考官方文档：
https://developers.weixin.qq.com/miniprogram/dev/devtools/auto/real-device.html

### Q5: 如何对比截图差异？

**A:** 可以使用图像对比工具，如 `pixelmatch`：

```javascript
const pixelmatch = require('pixelmatch');
const { PNG } = require('pngjs');
const fs = require('fs');

const img1 = PNG.sync.read(fs.readFileSync('reference.png'));
const img2 = PNG.sync.read(fs.readFileSync('current.png'));
const { width, height } = img1;
const diff = new PNG({ width, height });

const numDiffPixels = pixelmatch(
  img1.data, img2.data, diff.data, width, height,
  { threshold: 0.1 }
);

console.log(`差异像素数: ${numDiffPixels}`);
```

## 📚 相关文档

- [微信小程序自动化文档](https://developers.weixin.qq.com/miniprogram/dev/devtools/auto/)
- [命令行调用文档](https://developers.weixin.qq.com/miniprogram/dev/devtools/cli.html)
- [Claude 自动化预览方案](../Claude自动化预览小程序方案.md)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 License

MIT License

---

**准备好了吗？** 开始使用自动化脚本，让 Claude 实时查看开发效果！🚀
