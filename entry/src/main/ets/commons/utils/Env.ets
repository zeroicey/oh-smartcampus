import { logger } from './logger'

/**
 * 运行环境枚举
 *
 * dev   —— 本地联调，指向本机后端
 * test  —— 测试环境
 * prod  —— 生产 / 演示环境
 */
export enum EnvMode {
  DEV = 'dev',
  TEST = 'test',
  PROD = 'prod'
}

interface EnvConfig {
  mode: EnvMode
  /** 业务后端地址 */
  baseURL: string
  /** AI 服务地址 */
  aiBaseURL: string
  /** 是否输出详细日志 */
  verboseLog: boolean
}

const CONFIGS: Record<EnvMode, EnvConfig> = {
  [EnvMode.DEV]: {
    mode: EnvMode.DEV,
    baseURL: 'http://127.0.0.1:8080',
    aiBaseURL: 'http://127.0.0.1:8081',
    verboseLog: true
  },
  [EnvMode.TEST]: {
    mode: EnvMode.TEST,
    baseURL: 'http://hellooracle.free.idcfengye.com',
    aiBaseURL: 'https://1fd33097.r5.cpolar.cn',
    verboseLog: true
  },
  [EnvMode.PROD]: {
    mode: EnvMode.PROD,
    baseURL: 'http://hellooracle.free.idcfengye.com',
    aiBaseURL: 'https://1fd33097.r5.cpolar.cn',
    verboseLog: false
  }
}

/**
 * 环境配置
 *
 * 历史代码把 baseURL 直接写死在 Http.ets / 各页面的 axios 调用里，
 * 切换环境需要全局搜索替换。这里集中维护，页面只依赖 Env.baseURL。
 */
class Env {
  private current: EnvMode = EnvMode.TEST

  /** 当前环境 */
  get mode(): EnvMode {
    return this.current
  }

  /** 切换环境（调试面板或构建脚本调用） */
  setMode(mode: EnvMode): void {
    this.current = mode
    logger.warn('环境已切换为', mode)
  }

  /** 业务后端基地址 */
  get baseURL(): string {
    return CONFIGS[this.current].baseURL
  }

  /** AI 服务基地址 */
  get aiBaseURL(): string {
    return CONFIGS[this.current].aiBaseURL
  }

  /** 是否输出详细日志 */
  get verboseLog(): boolean {
    return CONFIGS[this.current].verboseLog
  }

  /** 拼接业务后端完整地址 */
  url(path: string): string {
    return `${this.baseURL}${path}`
  }

  /** 拼接 AI 服务完整地址 */
  aiUrl(path: string): string {
    return `${this.aiBaseURL}${path}`
  }
}

export const env = new Env()

/**
 * 服务端业务错误码
 *
 * 与后端约定保持一致，禁止在业务代码中直接写魔法数字。
 */
export enum BizCode {
  /** 成功 */
  SUCCESS = 0,
  /** 参数校验失败 */
  INVALID_PARAM = 1,
  /** 未登录 / token 失效 */
  UNAUTHORIZED = 50,
  /** 权限不足 */
  FORBIDDEN = 51,
  /** 资源不存在 */
  NOT_FOUND = 404,
  /** 服务端异常 */
  SERVER_ERROR = 500
}
