import axios, { AxiosError, AxiosRequestConfig, AxiosResponse } from '@ohos/axios'
import webSocket from '@ohos.net.webSocket';
export const AIinstance = axios.create({
  // 设置基地址
  baseURL: '',
  // 设置反应时间如果超过该时间进行报错
  timeout: 10000,
  headers: {
    Authorization: '',
  }
})

// 响应拦截器
AIinstance.interceptors.response.use((response: AxiosResponse) => {
  // 请求成功的话
  // 拦截之后执行一些逻辑再返回给客户端
  if (response.data.success == true) {
    // 拦截之后执行一些逻辑再返回给客户端
    return response.data.data
  }
  // 对响应错误做点什么
  return Promise.reject(response.data)
}, (error: AxiosError) => {
  // 对响应错误做点什么
  return Promise.reject(error)
})

class AIHttp {
  // res是响应数据类型
  // req是请求数据类型--get不需要传
  request<res, req = object>(config: AxiosRequestConfig<req>) {
    return AIinstance<null, res, req>(config)
  }
}

export const AIhttpReq = new AIHttp()

// http.request<响数据类型,请求体数据类型>({
//
// })



