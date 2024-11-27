// import { User } from '../../models/Index'
// import { router } from '@kit.ArkUI'
//
// export const UserInfo = 'user'
//
// class Auth {
//   // 访问权限+按钮控制权限控制
//   CheckAuth(options: router.RouterOptions | Function) {
//     // 根据是否有token来判断权限
//     const user = this.getUser()
//     if (user.token) {
//       // 如果传进来的是个函数
//       if (typeof options == 'function') {
//         options()
//       } else {
//         router.pushUrl(options)
//       }
//     } else {
//       // 跳转至登录页面,很显然为了保证用户登录完返回的页面是他点进去的页面我们要传一个包含地址的参数
//       // 如果传进来的是个函数
//       if (typeof options == 'function') {
//         // 先执行登录逻辑在调用方法
//         router.pushUrl({
//           url: 'pages/LoginPage'
//         })
//       } else {
//         const params = options.params as Record<string, string>
//         if (params) {
//           params.return_url = options.url //可以理解为在router中的params:{return_Url:传进来的options.url}
//           router.pushUrl({
//             url: 'pages/LoginPage',
//             // 将传进来的地址和其他数据传出去
//             params// params:params的简写
//           })
//         }
//       }
//     }
//   }
//
//   // 持久化数据
//   initUser() {
//     PersistentStorage.persistProp<User>(UserInfo, {} as User)
//   }
//
//   // 获取本地存储的数据
//   getUser() {
//     return AppStorage.get<User>(UserInfo) || {} as User
//   }
//
//   // 存储用户数据
//   setUser(user: User) {
//     return AppStorage.setOrCreate(UserInfo, user)
//   }
// }
//
// export const auth = new Auth()