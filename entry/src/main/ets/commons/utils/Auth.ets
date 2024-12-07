import { User } from '../../models'

export const UserInfo = 'user'

class Auth {
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