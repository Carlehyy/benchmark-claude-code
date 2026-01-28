/**
 * 言值（SpeakSmart）小程序配置文件示例
 * 
 * 使用方法：
 * 1. 复制本文件并重命名为 app.config.js
 * 2. 在 app.config.js 中填入您的真实配置信息
 * 3. app.config.js 已添加到 .gitignore，不会被提交到 Git
 */

module.exports = {
  // 微信小程序 AppID
  appId: 'wx1234567890abcdef',

  // 项目名称
  projectName: '言值',
  projectNameEn: 'SpeakSmart',

  // 项目描述
  description: '提升逻辑表达力的微信小程序',

  // 版本号
  version: '1.0.0',

  // 环境配置
  env: {
    development: {
      apiBaseUrl: 'https://dev-api.speaksmart.com',
      debug: true
    },
    staging: {
      apiBaseUrl: 'https://staging-api.speaksmart.com',
      debug: true
    },
    production: {
      apiBaseUrl: 'https://api.speaksmart.com',
      debug: false
    }
  },

  // 当前环境
  currentEnv: 'development',

  // 云开发配置
  cloud: {
    envId: 'your-cloud-env-id',
    enabled: false
  },

  // 第三方服务配置
  services: {
    cos: {
      enabled: false,
      bucket: 'your-bucket-name',
      region: 'ap-guangzhou'
    }
  }
};
