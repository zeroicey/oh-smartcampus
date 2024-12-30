import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { auth, logger } from '.'
import { promptAction, router } from '@kit.ArkUI'
import { User } from '../../models'

export const instance = axios.create({
  // 设置基地址
  baseURL: 'https://34d68b27.r7.cpolar.cn',
  // 设置反应时间如果超过该时间进行报错
  timeout: 10000,
})

// 请求拦截器
// 作用：统一携带数据比如token
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  const user = auth.getUser()
  if (user.token) {
    config.headers.Authorization = `Bearer ${user.token}`
    config.headers["uid"] = user.uid
  }
  return config
}, (err: AxiosError) => {
  return Promise.reject(err)
})

// 响应拦截器
instance.interceptors.response.use((response: AxiosResponse) => {
  // 请求成功的话
  // 拦截之后执行一些逻辑再返回给客户端
  if (response.data.success == true) {
    // 拦截之后执行一些逻辑再返回给客户端
    return response.data.data
  }
  // logger.info(JSON.stringify(response.data))
  if (response.data.errorCode == 50) {
    auth.setUser({} as User)
    // 由于页面渲染出来的时候会发送多个请求所以会跳转多次相同页面
    // 因此我们要使用router.RouterMode.Single
    router.pushUrl({
      url: 'pages/Login/Login'
    }, router.RouterMode.Single)
    promptAction.showToast({ message: '登录失效' })
  }
  // 对响应错误做点什么
  return Promise.reject(response.data)
}, (error: AxiosError) => {
  // 处理token失效或者登录失败的逻辑
  logger.error('Req Error 2', JSON.stringify(error))
  // 对响应错误做点什么
  return Promise.reject(error)
})

class Http {
  // res是响应数据类型
  // req是请求数据类型--get不需要传
  request<res, req = object>(config: AxiosRequestConfig<req>) {
    return instance<null, res, req>(config)
  }
}

export const httpReq = new Http()

// http.request<响数据类型,请求体数据类型>({
//
// })