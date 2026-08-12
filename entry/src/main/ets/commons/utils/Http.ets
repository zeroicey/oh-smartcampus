import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { auth, BizCode, env, logger } from '.'
import { promptAction, router } from '@kit.ArkUI'
import { User } from '../../models'

/** 请求超时时间，统一在环境配置中收口前的过渡值 */
const REQUEST_TIMEOUT = 10000

export const instance = axios.create({
  // 设置基地址（由 Env 统一维护，禁止在此处写死环境地址）
  baseURL: env.baseURL,
  // 设置反应时间如果超过该时间进行报错
  timeout: REQUEST_TIMEOUT,
})

/** 标记「登录失效」是否已经提示过，避免并发请求触发多次跳转与 toast */
let hasNotifiedUnauthorized = false

/** 重置登录失效标记（登录成功后调用） */
export function resetUnauthorizedFlag(): void {
  hasNotifiedUnauthorized = false
}

// 请求拦截器
// 作用：统一携带数据比如token
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  const user = auth.getUser()
  if (user && user.token) {
    config.headers.Authorization = `Bearer ${user.token}`
    config.headers["uid"] = user.uid
  }
  logger.debug('→', config.method?.toUpperCase() ?? '', config.url ?? '')
  return config
}, (err: AxiosError) => {
  logger.error('请求拦截器异常', err.message)
  return Promise.reject(err)
})

/**
 * 处理登录失效
 *
 * 由于页面渲染出来的时候会发送多个请求，若不做去重会跳转多次相同页面，
 * 因此这里加了一个一次性标记；同时使用 router.RouterMode.Single 兜底。
 */
function handleUnauthorized(): void {
  auth.setUser({} as User)
  if (hasNotifiedUnauthorized) {
    return
  }
  hasNotifiedUnauthorized = true
  router.pushUrl({
    url: 'pages/Login/Login'
  }, router.RouterMode.Single).catch((err: Error) => {
    logger.error('跳转登录页失败', err.message)
  })
  promptAction.showToast({ message: '登录失效' })
}

// 响应拦截器
instance.interceptors.response.use((response: AxiosResponse) => {
  // 请求成功的话
  // 拦截之后执行一些逻辑再返回给客户端
  if (response.data.success == true) {
    return response.data.data
  }

  if (response.data.errorCode == BizCode.UNAUTHORIZED) {
    handleUnauthorized()
  } else {
    logger.warn('业务失败', response.config?.url ?? '', response.data.errorMsg ?? '')
  }

  // 对响应错误做点什么
  return Promise.reject(response.data)
}, (error: AxiosError) => {
  // 处理token失效或者登录失败的逻辑
  // 区分「网络不可达」「超时」「HTTP 状态码异常」，便于上层给出不同提示
  if (error.code === 'ECONNABORTED') {
    logger.error('请求超时', error.message)
  } else if (error.response) {
    logger.error('HTTP 状态异常', String(error.response.status ?? ''), error.message)
  } else {
    logger.error('网络异常', error.message)
  }
  // 对响应错误做点什么
  return Promise.reject(error)
})

class Http {
  // res是响应数据类型
  // req是请求数据类型--get不需要传
  request<res, req = object>(config: AxiosRequestConfig<req>) {
    return instance<null, res, req>(config)
  }

  /** GET 语义化封装 */
  get<res>(url: string, params?: ESObject): Promise<res> {
    return this.request<res>({
      url,
      method: 'get',
      params
    })
  }

  /** POST 语义化封装 */
  post<res, req = object>(url: string, data?: req): Promise<res> {
    return this.request<res, req>({
      url,
      method: 'post',
      data
    })
  }
}

export const httpReq = new Http()

// http.request<响数据类型,请求体数据类型>({
//
// })
