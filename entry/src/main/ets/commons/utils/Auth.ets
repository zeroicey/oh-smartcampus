import { User } from '../../models'
import { router } from '@kit.ArkUI'

export const UserInfo = 'user'

class Auth {
  // 访问权限
  CheckAuth(options: router.RouterOptions | Function) {
    //根据是否有token来判断权限
    const user = this.getUser()
    if (user.token) {
      //如果传进来的是函数
      if (typeof options == 'function') {
        // 调用函数
        options()
      } else {
        // 正常跳转对应页面
        router.pushUrl(options)
      }
    } else {
      // 如果传进来的是个函数
      if (typeof options == 'function') {
        // 跳转登录页
        router.pushUrl({
          url: 'pages/Login/Login'
        })
      } else {
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
    }
  }

  // 持久化数据
  initUser() {
    PersistentStorage.persistProp<User>(UserInfo, {} as User)
  }

  // 获取本地存储的数据
  getUser() {
    return AppStorage.get<User>(UserInfo) || {} as User
  }

  // 存储用户数据
  setUser(user: User) {
    return AppStorage.setOrCreate(UserInfo, user)
  }
}

export const auth = new Auth()