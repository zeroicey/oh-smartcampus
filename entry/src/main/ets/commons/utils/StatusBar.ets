import { window } from '@kit.ArkUI'

// 设置不同模式下导航栏内容的颜色
class StatusBar {
  // 深色模式
  setDarkBar() {
    this.setBar({
      statusBarContentColor: '#000000'
    })
  }

  // 浅色模式
  setLightBar() {
    this.setBar({
      statusBarContentColor: '#ffffff'
    })
  }

  async setBar(config: window.SystemBarProperties) {
    // 获取上下文对象
    const context = AppStorage.get<Context>('context')
    if (context) {
      // 获取窗口
      const win = await window.getLastWindow(context)
      // 设置导航栏状态
      win.setWindowSystemBarProperties(config)
    }
  }
}

export const statusBar = new StatusBar()