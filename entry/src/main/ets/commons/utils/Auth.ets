import { User } from '../../models'
import { router } from '@kit.ArkUI'
import { LOGOUT_EVENT, STORAGE_KEY_USER } from '../constants'
import { emitter } from '@kit.BasicServicesKit'
import { logger } from './logger'
import { tracking } from './Tracking'

export const UserInfo = STORAGE_KEY_USER

class Auth {
  /**
   * 访问权限校验
   *
   * 已登录：函数直接执行；路由参数则直接跳转。
   * 未登录：统一跳转登录页，并通过 return_url 记录来源页面，
   * 登录成功后由登录页回跳（历史实现在「传函数」分支漏掉了 return_url，已修复）。
   */
  CheckAuth(options: router.RouterOptions | Function) {
    //根据是否有token来判断权限
    if (this.isLogin()) {
      //如果传进来的是函数
      if (typeof options == 'function') {
        // 调用函数
        options()
      } else {
        // 正常跳转对应页面
        router.pushUrl(options)
      }
      return
    }

    // 未登录：统一跳转登录页
    if (typeof options == 'function') {
      // 传函数时无法得知目标页面，仅跳转登录页
      router.pushUrl({ url: 'pages/Login/Login' })
      return
    }
    // 跳转至登录页面,很显然为了保证用户登录完返回的页面是他点进去的页面我们要传一个包含地址的参数
    const params = options.params as Record<string, string>
    if (params) {
      params.return_url = options.url //可以理解为在router中的params:{return_Url:传进来的options.url}
      router.pushUrl({
        url: 'pages/Login/Login',
        params
      })
    } else {
      router.pushUrl({
        url: 'pages/Login/Login',
        // 将传进来的地址传出去
        params: {
          'return_url': options.url
        }
      })
    }
  }

  /** 是否已登录 */
  isLogin(): boolean {
    const user = this.getUser()
    return !!(user && user.token)
  }

  // 持久化数据
  initUser() {
    PersistentStorage.persistProp<User>(UserInfo, {} as User)
  }

  // 获取本地存储的数据
  getUser(): User {
    return AppStorage.get<User>(UserInfo) || {} as User
  }

  // 存储用户数据
  setUser(user: User) {
    return AppStorage.setOrCreate(UserInfo, user)
  }

  /**
   * 退出登录
   *
   * 清理用户信息与本地埋点缓存，并广播 LOGOUT_EVENT，
   * 由页面自行决定是否回退到首页 / 登录页。
   */
  logout(): void {
    this.setUser({} as User)
    tracking.clear()
    try {
      emitter.emit(LOGOUT_EVENT)
    } catch (err) {
      logger.error('Auth: 广播退出登录事件失败', (err as Error).message)
    }
    logger.info('Auth: 已退出登录')
  }

  /** 退出登录并返回登录页 */
  logoutToLogin(): void {
    this.logout()
    router.pushUrl({ url: 'pages/Login/Login' }, router.RouterMode.Single)
  }
}

export const auth = new Auth()
