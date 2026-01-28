/**
 * 微信小程序自动预览脚本
 * 
 * 功能：
 * - 连接到微信开发者工具
 * - 导航到指定页面
 * - 截图保存
 * - 获取页面数据和元素信息
 * 
 * 使用方法：
 * node auto-preview.js <页面路径> <输出目录> [WebSocket端口]
 * 
 * 示例：
 * node auto-preview.js /pages/index/index ./screenshots 9420
 */

const automator = require('miniprogram-automator');
const fs = require('fs');
const path = require('path');

/**
 * 预览并截图
 * @param {string} pagePath - 页面路径，如 /pages/index/index
 * @param {string} outputDir - 输出目录
 * @param {number} wsPort - WebSocket 端口号
 * @returns {Promise<Object>} 预览结果
 */
async function previewAndCapture(pagePath, outputDir, wsPort = 9420) {
  console.log('='.repeat(60));
  console.log('微信小程序自动预览工具');
  console.log('='.repeat(60));
  console.log(`页面路径: ${pagePath}`);
  console.log(`输出目录: ${outputDir}`);
  console.log(`WebSocket 端口: ${wsPort}`);
  console.log('='.repeat(60));

  let miniProgram = null;
  
  try {
    // 连接到开发者工具
    console.log('\n[1/5] 正在连接微信开发者工具...');
    miniProgram = await automator.connect({
      wsEndpoint: `ws://localhost:${wsPort}`
    });
    console.log('✓ 连接成功');

    // 导航到指定页面
    console.log(`\n[2/5] 正在打开页面: ${pagePath}`);
    const page = await miniProgram.navigateTo(pagePath);
    console.log('✓ 页面已打开');
    
    // 等待页面加载完成
    console.log('\n[3/5] 等待页面渲染...');
    await page.waitFor(1500); // 等待 1.5 秒确保页面完全渲染
    console.log('✓ 页面渲染完成');
    
    // 截图
    console.log('\n[4/5] 正在截图...');
    const screenshotFilename = `${pagePath.replace(/\//g, '_')}_${Date.now()}.png`;
    const screenshotPath = path.join(outputDir, screenshotFilename);
    
    // 确保输出目录存在
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }
    
    await miniProgram.screenshot({
      path: screenshotPath
    });
    console.log(`✓ 截图已保存: ${screenshotPath}`);
    
    // 获取页面信息
    console.log('\n[5/5] 正在获取页面信息...');
    
    // 获取页面数据
    const pageData = await page.data();
    
    // 获取页面元素统计
    const viewElements = await page.$$('view');
    const textElements = await page.$$('text');
    const buttonElements = await page.$$('button');
    const imageElements = await page.$$('image');
    
    const elementStats = {
      view: viewElements.length,
      text: textElements.length,
      button: buttonElements.length,
      image: imageElements.length,
      total: viewElements.length + textElements.length + buttonElements.length + imageElements.length
    };
    
    console.log('✓ 页面信息获取完成');
    
    // 输出统计信息
    console.log('\n' + '='.repeat(60));
    console.log('页面统计信息');
    console.log('='.repeat(60));
    console.log(`View 元素: ${elementStats.view}`);
    console.log(`Text 元素: ${elementStats.text}`);
    console.log(`Button 元素: ${elementStats.button}`);
    console.log(`Image 元素: ${elementStats.image}`);
    console.log(`总元素数: ${elementStats.total}`);
    console.log('='.repeat(60));
    
    // 保存页面数据到 JSON 文件
    const dataFilename = `${pagePath.replace(/\//g, '_')}_${Date.now()}.json`;
    const dataPath = path.join(outputDir, dataFilename);
    const reportData = {
      timestamp: new Date().toISOString(),
      pagePath,
      screenshotPath,
      pageData,
      elementStats
    };
    
    fs.writeFileSync(dataPath, JSON.stringify(reportData, null, 2), 'utf-8');
    console.log(`\n页面数据已保存: ${dataPath}`);
    
    // 返回结果
    return {
      success: true,
      pagePath,
      screenshotPath,
      dataPath,
      elementStats,
      pageData
    };
    
  } catch (error) {
    console.error('\n✗ 预览失败:', error.message);
    console.error('\n错误详情:', error);
    
    // 常见错误提示
    if (error.message.includes('ECONNREFUSED')) {
      console.error('\n可能的原因：');
      console.error('1. 微信开发者工具未运行');
      console.error('2. 未开启自动化端口');
      console.error('3. 端口号不正确');
      console.error('\n解决方法：');
      console.error('1. 打开微信开发者工具');
      console.error('2. 设置 -> 安全设置 -> 开启服务端口');
      console.error('3. 使用命令行启动: cli --auto <项目路径> --auto-port 9420');
    }
    
    return {
      success: false,
      error: error.message,
      stack: error.stack
    };
  } finally {
    // 关闭连接
    if (miniProgram) {
      try {
        await miniProgram.close();
        console.log('\n连接已关闭');
      } catch (e) {
        // 忽略关闭错误
      }
    }
  }
}

/**
 * 批量预览多个页面
 * @param {Array<string>} pages - 页面路径数组
 * @param {string} outputDir - 输出目录
 * @param {number} wsPort - WebSocket 端口号
 */
async function previewMultiplePages(pages, outputDir, wsPort = 9420) {
  console.log(`\n准备预览 ${pages.length} 个页面...\n`);
  
  const results = [];
  
  for (let i = 0; i < pages.length; i++) {
    const pagePath = pages[i];
    console.log(`\n[${i + 1}/${pages.length}] 预览页面: ${pagePath}`);
    
    const result = await previewAndCapture(pagePath, outputDir, wsPort);
    results.push(result);
    
    // 页面之间间隔 1 秒
    if (i < pages.length - 1) {
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
  }
  
  // 生成汇总报告
  const successCount = results.filter(r => r.success).length;
  const failCount = results.length - successCount;
  
  console.log('\n' + '='.repeat(60));
  console.log('批量预览完成');
  console.log('='.repeat(60));
  console.log(`总页面数: ${results.length}`);
  console.log(`成功: ${successCount}`);
  console.log(`失败: ${failCount}`);
  console.log('='.repeat(60));
  
  return results;
}

// 命令行入口
if (require.main === module) {
  const args = process.argv.slice(2);
  
  if (args.length === 0 || args[0] === '--help' || args[0] === '-h') {
    console.log(`
使用方法:
  node auto-preview.js <页面路径> [输出目录] [WebSocket端口]

参数:
  页面路径      必填。小程序页面路径，如 /pages/index/index
  输出目录      可选。截图和数据保存目录，默认为 ./screenshots
  WebSocket端口 可选。开发者工具自动化端口，默认为 9420

示例:
  # 预览首页
  node auto-preview.js /pages/index/index

  # 预览首页并指定输出目录
  node auto-preview.js /pages/index/index ./output

  # 预览首页并指定端口
  node auto-preview.js /pages/index/index ./output 9420

批量预览:
  # 使用逗号分隔多个页面
  node auto-preview.js /pages/index/index,/pages/list/list,/pages/detail/detail

环境准备:
  1. 安装依赖: npm install miniprogram-automator --save-dev
  2. 打开微信开发者工具
  3. 设置 -> 安全设置 -> 开启服务端口
  4. 使用命令行启动: cli --auto <项目路径> --auto-port 9420
    `);
    process.exit(0);
  }
  
  const pagePathArg = args[0];
  const outputDir = args[1] || './screenshots';
  const wsPort = parseInt(args[2]) || 9420;
  
  // 检查是否是批量预览
  if (pagePathArg.includes(',')) {
    const pages = pagePathArg.split(',').map(p => p.trim());
    previewMultiplePages(pages, outputDir, wsPort)
      .then(results => {
        const allSuccess = results.every(r => r.success);
        process.exit(allSuccess ? 0 : 1);
      })
      .catch(error => {
        console.error('批量预览失败:', error);
        process.exit(1);
      });
  } else {
    // 单页面预览
    previewAndCapture(pagePathArg, outputDir, wsPort)
      .then(result => {
        if (result.success) {
          console.log('\n✓ 预览成功！');
          process.exit(0);
        } else {
          console.log('\n✗ 预览失败！');
          process.exit(1);
        }
      })
      .catch(error => {
        console.error('执行失败:', error);
        process.exit(1);
      });
  }
}

// 导出函数供其他脚本使用
module.exports = {
  previewAndCapture,
  previewMultiplePages
};
