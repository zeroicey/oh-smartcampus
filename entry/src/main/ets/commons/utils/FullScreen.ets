// 封装沉浸式模式
import { window } from '@kit.ArkUI'

class FullScreen {
  // 开启全屏
  async enabled() {
    // 首先获取上下文对象
    const context = AppStorage.get<Context>('context')
    // 由于上下文对象在未获取到的时候处于undefined所以我们要判断context是否获取到
    if (context != undefined) {
      // 获取页面用法widow.getLastWindow(上下文对象)
      // 由于widow.getLastWindow(上下文对象)返回的值是promise类型所以我们要使用await修饰符
      const win = await window.getLastWindow(context)
      // 调用内置方法开启沉浸式模式（是/否）
      await win.setWindowLayoutFullScreen(true)
      // 获取每个设备的顶部状态栏高度并进行本地存储
      const topHeight = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      // 由于获取到的高度是px所以我们需要调用一个函数来进行精确的转化px2vp()就可以实现
      // logger.info('顶部状态栏的高度是', px2vp(topHeight.topRect.height).toString())
      AppStorage.setOrCreate('topHeight', px2vp(topHeight.topRect.height))
      // 获取每个设备的底部导航栏高度并进行本地存储
      const bottomArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
      // 优先获取底部指示器导航栏高度，如果没有值得再尝试获取常规导航栏(鸿蒙5.0以下的传统底部三键导航栏)高度，两者显示是互斥的
      if (!px2vp(bottomArea.bottomRect.height)) {
        const bottomArea2 = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
        AppStorage.setOrCreate('bottomHeight', px2vp(bottomArea2.bottomRect.height))
      } else {
        AppStorage.setOrCreate('bottomHeight', px2vp(bottomArea.bottomRect.height))
      }
    }
  }

  async dissabled() {
    // 首先获取上下文对象
    const context = AppStorage.get<Context>('context')
    // 由于上下文对象在未获取到的时候处于undefined所以我们要判断context是否获取到
    if (context != undefined) {
      // 获取页面用法widow.getLastWindow(上下文对象)
      // 由于widow.getLastWindow(上下文对象)返回的值是promise类型所以我们要使用await修饰符
      const win = await window.getLastWindow(context)
      // 调用内置方法开启沉浸式模式（是/否）
      await win.setWindowLayoutFullScreen(false)
      // 获取每个设备的顶部状态栏高度并进行本地存储
      const topHeight = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      // 由于获取到的高度是px所以我们需要调用一个函数来进行精确的转化px2vp()就可以实现
      // logger.info('顶部状态栏的高度是', px2vp(topHeight.topRect.height).toString())
      AppStorage.setOrCreate('topHeight', 0)
      // 获取每个设备的底部导航栏高度并进行本地存储
      const bottomArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
      AppStorage.setOrCreate('bottomHeight', 0)
    }
  }
}

export const fullScreen = new FullScreen()