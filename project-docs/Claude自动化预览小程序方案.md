# Claude 自动化预览微信小程序效果方案

## 问题背景

在使用 Claude Code 开发微信小程序时，传统的开发流程是 Claude 一次性生成代码，然后由开发者手动启动项目查看效果。这种方式存在以下问题：

**效率低下**：Claude 无法实时看到代码效果，可能需要多次迭代才能达到预期。

**反馈延迟**：开发者需要手动检查每次修改的效果，增加了沟通成本。

**质量风险**：Claude 无法自动验证 UI 是否符合设计要求，容易出现偏差。

## 解决方案概述

本文档提供四种可行方案，让 Claude 能够在开发过程中自动化地预览小程序效果、截图对比、并根据反馈实时调整代码。

## 方案对比

| 方案 | 实现难度 | 实时性 | 功能完整度 | 推荐度 |
|------|---------|--------|-----------|--------|
| 方案一：命令行 + 自动化 SDK | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 方案二：Web 预览 + 截图 | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| 方案三：模拟器 + 截图对比 | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| 方案四：持续预览模式 | ⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |

---

## 方案一：命令行 + 微信开发者工具自动化 SDK（推荐）

### 方案概述

使用微信开发者工具的命令行工具（CLI）和自动化 SDK（Automator），让 Claude 能够通过脚本控制开发者工具，实现自动预览、截图、元素检查等功能。

### 技术原理

微信开发者工具提供了完整的自动化能力：

**命令行工具（CLI）**：可以启动工具、打开项目、开启自动化端口。

**Automator SDK**：基于 WebSocket 协议，提供类似 Puppeteer 的 API，可以控制小程序页面、获取元素、截图等。

**实时通信**：通过 WebSocket 连接，Claude 可以实时获取页面状态和截图。

### 实施步骤

#### 1. 环境准备

```bash
# 安装 Node.js（如果还没有）
# 微信开发者工具已安装

# 安装 miniprogram-automator（可选，用于 Node.js 脚本）
npm install miniprogram-automator --save-dev
```

#### 2. 开启开发者工具的自动化功能

在微信开发者工具中：
1. 打开 **设置 -> 安全设置**
2. 开启 **服务端口**
3. 记住端口号（默认通常是随机的）

#### 3. 使用命令行启动项目并开启自动化

```bash
# macOS
/Applications/wechatwebdevtools.app/Contents/MacOS/cli \
  --auto /path/to/your/project \
  --auto-port 9420

# Windows
"C:\Program Files (x86)\Tencent\微信web开发者工具\cli.bat" ^
  --auto C:\path\to\your\project ^
  --auto-port 9420
```

#### 4. 创建自动化脚本

创建文件 `scripts/auto-preview.js`：

```javascript
const automator = require('miniprogram-automator');
const fs = require('fs');
const path = require('path');

async function previewAndCapture(pagePath, outputDir) {
  // 连接到开发者工具
  const miniProgram = await automator.connect({
    wsEndpoint: 'ws://localhost:9420'
  });

  try {
    // 导航到指定页面
    console.log(`正在打开页面: ${pagePath}`);
    const page = await miniProgram.navigateTo(pagePath);
    
    // 等待页面加载完成
    await page.waitFor(1000);
    
    // 截图
    const screenshotPath = path.join(outputDir, `${pagePath.replace(/\//g, '_')}.png`);
    await miniProgram.screenshot({
      path: screenshotPath
    });
    console.log(`截图已保存: ${screenshotPath}`);
    
    // 获取页面数据
    const pageData = await page.data();
    console.log('页面数据:', JSON.stringify(pageData, null, 2));
    
    // 获取页面元素信息
    const elements = await page.$$('view');
    console.log(`页面包含 ${elements.length} 个 view 元素`);
    
    // 返回结果
    return {
      success: true,
      screenshotPath,
      pageData,
      elementCount: elements.length
    };
    
  } catch (error) {
    console.error('预览失败:', error);
    return {
      success: false,
      error: error.message
    };
  } finally {
    await miniProgram.close();
  }
}

// 导出函数供 Claude 调用
module.exports = { previewAndCapture };

// 如果直接运行脚本
if (require.main === module) {
  const pagePath = process.argv[2] || '/pages/index/index';
  const outputDir = process.argv[3] || './screenshots';
  
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }
  
  previewAndCapture(pagePath, outputDir)
    .then(result => {
      console.log('预览结果:', result);
      process.exit(result.success ? 0 : 1);
    })
    .catch(error => {
      console.error('执行失败:', error);
      process.exit(1);
    });
}
```

#### 5. Claude 使用方式

在 Claude Code 中，可以这样使用：

```
/tdd

功能需求：实现首页布局

开发步骤：
1. 编写页面代码
2. 保存文件
3. 运行预览脚本：node scripts/auto-preview.js /pages/index/index ./screenshots
4. 查看截图和输出，验证效果
5. 如果不符合预期，调整代码并重复步骤 2-4

请开始实施。
```

Claude 会：
1. 生成代码
2. 保存文件
3. 执行预览脚本
4. 查看截图（通过 `file view` 工具）
5. 分析效果是否符合要求
6. 如果不符合，自动调整代码并重新预览

### 优势

**完全自动化**：Claude 可以完全控制整个流程，无需人工干预。

**实时反馈**：通过 WebSocket 连接，可以实时获取页面状态。

**功能强大**：可以获取元素、执行操作、检查数据、截图等。

**官方支持**：使用微信官方提供的工具，稳定可靠。

### 劣势

**需要开发者工具运行**：必须保持微信开发者工具运行。

**环境依赖**：需要正确配置命令行工具路径。

**学习成本**：需要了解 Automator API。

### 适用场景

- 需要精确验证 UI 效果
- 需要检查交互逻辑
- 需要自动化测试
- 开发环境稳定

---

## 方案二：Web 预览 + 浏览器截图（简化版）

### 方案概述

利用小程序的 Web 预览功能，在浏览器中预览小程序效果，Claude 可以直接使用浏览器工具查看和截图。

### 技术原理

微信开发者工具支持在浏览器中预览小程序（虽然有些 API 不可用），Claude 可以使用内置的浏览器工具访问预览页面并截图。

### 实施步骤

#### 1. 启动开发服务器

在 `project.config.json` 中配置：

```json
{
  "setting": {
    "urlCheck": false,
    "es6": true,
    "enhance": true,
    "postcss": true,
    "preloadBackgroundData": false,
    "minified": true,
    "newFeature": false,
    "coverView": true,
    "nodeModules": true,
    "autoAudits": false,
    "showShadowRootInWxmlPanel": true,
    "scopeDataCheck": false,
    "uglifyFileName": false,
    "checkInvalidKey": true,
    "checkSiteMap": true,
    "uploadWithSourceMap": true,
    "compileHotReLoad": true,
    "useMultiFrameRuntime": true,
    "useApiHook": true,
    "useApiHostProcess": true,
    "babelSetting": {
      "ignore": [],
      "disablePlugins": [],
      "outputPath": ""
    },
    "enableEngineNative": false,
    "bundle": false,
    "useIsolateContext": true,
    "useCompilerModule": true,
    "userConfirmedUseCompilerModuleSwitch": false,
    "userConfirmedBundleSwitch": false,
    "packNpmManually": false,
    "packNpmRelationList": [],
    "minifyWXSS": true
  }
}
```

#### 2. 使用命令行启动项目

```bash
# 启动开发者工具并打开项目
cli open --project /path/to/project
```

#### 3. 获取预览地址

开发者工具会在本地启动一个 HTTP 服务，通常地址类似：
```
http://127.0.0.1:端口号/
```

#### 4. Claude 使用浏览器工具访问

```
使用 browser_navigate 访问预览地址
使用 browser_view 查看页面效果
使用 browser 工具截图保存
对比截图与设计稿
```

### 优势

**实现简单**：不需要额外的脚本，直接使用 Claude 的浏览器工具。

**直观可见**：可以直接看到页面效果。

**快速迭代**：修改代码后刷新即可查看。

### 劣势

**功能受限**：部分小程序 API 在浏览器中不可用。

**样式差异**：浏览器渲染可能与真实小程序有差异。

**无法测试交互**：复杂的小程序交互可能无法在浏览器中正常工作。

### 适用场景

- 快速验证静态布局
- 开发初期的原型验证
- 不涉及复杂 API 的页面

---

## 方案三：模拟器 + 定时截图对比

### 方案概述

使用微信开发者工具的模拟器，配合定时截图脚本，让 Claude 定期检查页面效果。

### 实施步骤

#### 1. 创建截图脚本

```bash
#!/bin/bash
# scripts/capture-simulator.sh

# 使用系统截图工具截取模拟器区域
# macOS
screencapture -R x,y,width,height screenshots/simulator_$(date +%s).png

# 或使用 ImageMagick
import -window "微信开发者工具" screenshots/simulator_$(date +%s).png
```

#### 2. 创建监控脚本

```javascript
// scripts/watch-and-capture.js
const chokidar = require('chokidar');
const { exec } = require('child_process');
const path = require('path');

const watcher = chokidar.watch('pages/**/*.{wxml,wxss,js,json}', {
  ignored: /(^|[\/\\])\../,
  persistent: true
});

watcher.on('change', (filePath) => {
  console.log(`文件变更: ${filePath}`);
  
  // 等待编译完成
  setTimeout(() => {
    exec('bash scripts/capture-simulator.sh', (error, stdout, stderr) => {
      if (error) {
        console.error(`截图失败: ${error}`);
        return;
      }
      console.log('截图已保存');
    });
  }, 2000);
});

console.log('开始监控文件变更...');
```

#### 3. Claude 工作流程

1. 修改代码
2. 保存文件
3. 等待自动截图
4. 查看截图
5. 分析效果
6. 继续调整

### 优势

**真实环境**：在真实的模拟器中运行。

**自动化程度高**：文件变更自动触发截图。

**无需额外配置**：利用现有的开发者工具。

### 劣势

**依赖截图工具**：需要系统级的截图工具。

**精确度问题**：需要准确定位模拟器窗口位置。

**平台差异**：不同操作系统的实现方式不同。

### 适用场景

- 需要在真实模拟器中验证
- 不需要频繁交互
- 主要关注视觉效果

---

## 方案四：持续预览模式（最简单）

### 方案概述

保持开发者工具打开，启用热重载功能，Claude 修改代码后立即生效，开发者可以实时查看效果并反馈给 Claude。

### 实施步骤

#### 1. 开启热重载

在微信开发者工具中：
- 打开 **设置 -> 编辑设置**
- 开启 **保存时自动编译**
- 开启 **修改文件时自动刷新模拟器**

#### 2. Claude 工作流程

```
1. Claude 生成代码
2. 保存文件
3. 开发者工具自动编译和刷新
4. 开发者查看效果
5. 开发者向 Claude 反馈："首页标题颜色不对，应该是 #333"
6. Claude 调整代码
7. 重复步骤 2-6
```

### 优势

**极简实现**：无需任何额外脚本。

**实时生效**：修改立即可见。

**零配置**：开发者工具自带功能。

### 劣势

**需要人工反馈**：Claude 无法自动查看效果。

**效率较低**：需要人工沟通。

**无法自动化**：不适合批量验证。

### 适用场景

- 快速原型开发
- 简单页面调整
- 不需要完全自动化

---

## 推荐实施方案

### 阶段一：快速启动（方案四）

在项目初期，使用持续预览模式快速迭代：

1. 开启热重载
2. Claude 生成代码
3. 开发者查看并反馈
4. 快速调整

### 阶段二：自动化验证（方案一）

当页面较多时，使用自动化 SDK：

1. 配置自动化脚本
2. Claude 自动预览和截图
3. 自动对比和调整
4. 提高开发效率

### 阶段三：持续集成（方案一 + 方案三）

在 CI/CD 流程中集成自动化测试：

1. 代码提交触发测试
2. 自动化脚本运行
3. 截图对比
4. 生成测试报告

---

## 完整示例：方案一的实施

### 1. 项目结构

```
your-miniapp/
├── pages/
│   └── index/
│       ├── index.wxml
│       ├── index.wxss
│       ├── index.js
│       └── index.json
├── scripts/
│   ├── auto-preview.js          # 自动预览脚本
│   ├── compare-screenshots.js   # 截图对比脚本
│   └── start-automation.sh      # 启动脚本
├── screenshots/
│   ├── reference/               # 参考截图
│   └── current/                 # 当前截图
├── package.json
└── project.config.json
```

### 2. package.json 配置

```json
{
  "name": "logic-expression-miniapp",
  "version": "1.0.0",
  "scripts": {
    "auto:start": "bash scripts/start-automation.sh",
    "auto:preview": "node scripts/auto-preview.js",
    "auto:compare": "node scripts/compare-screenshots.js"
  },
  "devDependencies": {
    "miniprogram-automator": "^0.10.0",
    "pixelmatch": "^5.3.0",
    "pngjs": "^7.0.0"
  }
}
```

### 3. 启动脚本

```bash
#!/bin/bash
# scripts/start-automation.sh

# 微信开发者工具 CLI 路径
if [[ "$OSTYPE" == "darwin"* ]]; then
  CLI_PATH="/Applications/wechatwebdevtools.app/Contents/MacOS/cli"
else
  CLI_PATH="C:/Program Files (x86)/Tencent/微信web开发者工具/cli.bat"
fi

# 项目路径
PROJECT_PATH="$(pwd)"

# 自动化端口
AUTO_PORT=9420

echo "正在启动微信开发者工具..."
"$CLI_PATH" --auto "$PROJECT_PATH" --auto-port $AUTO_PORT

echo "自动化端口: $AUTO_PORT"
echo "WebSocket 地址: ws://localhost:$AUTO_PORT"
```

### 4. Claude 使用示例

```
/tdd

功能需求：实现首页布局，包含标题、副标题和按钮

UI 要求：
- 标题：32rpx，#333，居中
- 副标题：28rpx，#666，居中
- 按钮：宽度 600rpx，高度 80rpx，圆角 40rpx，背景色 #07C160

开发流程：
1. 生成 WXML、WXSS、JS 代码
2. 保存文件
3. 运行: npm run auto:preview /pages/index/index
4. 查看截图: screenshots/current/_pages_index_index.png
5. 验证效果是否符合 UI 要求
6. 如不符合，调整代码并重复步骤 2-5

请开始 TDD 开发。
```

---

## 总结

### 最佳实践建议

1. **开发初期**：使用方案四（持续预览模式），快速迭代
2. **开发中期**：引入方案一（自动化 SDK），提高效率
3. **测试阶段**：结合方案一和方案三，全面验证
4. **持续集成**：将自动化脚本集成到 CI/CD

### 关键要点

**保持工具运行**：确保微信开发者工具始终运行并开启自动化端口。

**截图对比**：将当前截图与参考截图对比，自动发现差异。

**增量开发**：每次只修改一个功能点，立即验证效果。

**文档记录**：记录每次预览的结果，便于追溯问题。

### 下一步

1. 选择适合您的方案
2. 按照实施步骤配置环境
3. 测试自动化脚本
4. 在 Claude Code 中使用
5. 持续优化工作流程

---

**准备好了吗？** 选择一个方案，让我们开始配置！
