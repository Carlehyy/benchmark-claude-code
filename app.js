/**
 * 言值（SpeakSmart）小程序入口文件
 * 
 * 本文件定义了小程序的生命周期函数和全局数据
 */

// 引入配置文件
const appConfig = require('./config/app.config.js');

App({
  /**
   * 全局数据
   */
  globalData: {
    userInfo: null,
    hasLogin: false,
    config: appConfig
  },

  /**
   * 小程序初始化完成时触发（全局只触发一次）
   */
  onLaunch(options) {
    console.log('言值小程序启动', options);
    
    // 获取系统信息
    this.getSystemInfo();
    
    // 检查更新
    this.checkUpdate();
    
    // 初始化云开发（如果启用）
    if (appConfig.cloud.enabled) {
      this.initCloud();
    }
  },

  /**
   * 小程序启动，或从后台进入前台显示时触发
   */
  onShow(options) {
    console.log('言值小程序显示', options);
  },

  /**
   * 小程序从前台进入后台时触发
   */
  onHide() {
    console.log('言值小程序隐藏');
  },

  /**
   * 小程序发生脚本错误或 API 调用报错时触发
   */
  onError(msg) {
    console.error('言值小程序错误', msg);
  },

  /**
   * 小程序要打开的页面不存在时触发
   */
  onPageNotFound(res) {
    console.warn('页面不存在', res);
    // 重定向到首页
    wx.redirectTo({
      url: '/pages/index/index'
    });
  },

  /**
   * 获取系统信息
   */
  getSystemInfo() {
    try {
      const systemInfo = wx.getSystemInfoSync();
      this.globalData.systemInfo = systemInfo;
      console.log('系统信息', systemInfo);
    } catch (e) {
      console.error('获取系统信息失败', e);
    }
  },

  /**
   * 检查小程序更新
   */
  checkUpdate() {
    if (wx.canIUse('getUpdateManager')) {
      const updateManager = wx.getUpdateManager();
      
      updateManager.onCheckForUpdate((res) => {
        console.log('检查更新', res.hasUpdate);
      });
      
      updateManager.onUpdateReady(() => {
        wx.showModal({
          title: '更新提示',
          content: '新版本已经准备好，是否重启应用？',
          success: (res) => {
            if (res.confirm) {
              updateManager.applyUpdate();
            }
          }
        });
      });
      
      updateManager.onUpdateFailed(() => {
        console.error('新版本下载失败');
      });
    }
  },

  /**
   * 初始化云开发
   */
  initCloud() {
    if (wx.cloud) {
      wx.cloud.init({
        env: appConfig.cloud.envId,
        traceUser: true
      });
      console.log('云开发初始化成功');
    } else {
      console.warn('当前微信版本不支持云开发');
    }
  },

  /**
   * 获取用户信息
   */
  getUserInfo(callback) {
    if (this.globalData.userInfo) {
      callback && callback(this.globalData.userInfo);
    } else {
      // 调用登录接口
      wx.login({
        success: () => {
          wx.getUserInfo({
            success: (res) => {
              this.globalData.userInfo = res.userInfo;
              this.globalData.hasLogin = true;
              callback && callback(res.userInfo);
            },
            fail: (err) => {
              console.error('获取用户信息失败', err);
            }
          });
        }
      });
    }
  },

  /**
   * 获取当前环境配置
   */
  getEnvConfig() {
    const env = appConfig.currentEnv || 'development';
    return appConfig.env[env];
  }
});
