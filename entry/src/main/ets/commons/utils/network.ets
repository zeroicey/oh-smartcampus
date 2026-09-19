import { connection } from '@kit.NetworkKit'
import { logger } from './logger'

/**
 * 网络状态监听
 *
 * 应用在弱网 / 离线场景下直接发请求会得到难以理解的 axios 异常，
 * 这里提供统一的网络可用性判断与状态订阅，页面可据此展示离线占位。
 */

/** 网络状态回调 */
export type NetworkListener = (online: boolean) => void

class Network {
  private netConnection: connection.NetConnection | null = null
  private listeners: Map<string, NetworkListener> = new Map()
  private online: boolean = true
  private seq: number = 0

  /**
   * 同步判断当前是否有可用网络
   *
   * 注意：该 API 在部分设备上可能抛异常，这里统一兜底为「有网」，
   * 由实际请求的超时逻辑兜底，避免误判导致整页不可用。
   */
  hasDefaultNet(): boolean {
    try {
      return connection.hasDefaultNetSync()
    } catch (err) {
      logger.warn('Network: 查询默认网络失败', (err as Error).message)
      return true
    }
  }

  /** 当前是否在线（取最近一次通知结果） */
  isOnline(): boolean {
    return this.online
  }

  /**
   * 注册网络监听
   * @param listener 状态变化回调
   * @returns 取消订阅函数
   */
  observe(listener: NetworkListener): () => void {
    const key = `listener-${this.seq++}`
    this.listeners.set(key, listener)
    this.ensureConnection()
    return () => {
      this.listeners.delete(key)
    }
  }

  /** 主动触发一次状态刷新 */
  refresh(): boolean {
    this.online = this.hasDefaultNet()
    this.notify(this.online)
    return this.online
  }

  private ensureConnection(): void {
    if (this.netConnection) {
      return
    }
    try {
      this.netConnection = connection.createNetConnection()
      this.netConnection.on('netAvailable', () => this.update(true))
      this.netConnection.on('netLost', () => this.update(false))
      this.netConnection.on('netUnavailable', () => this.update(false))
      this.netConnection.register((err) => {
        if (err) {
          logger.error('Network: 注册网络监听失败', JSON.stringify(err))
        }
      })
      this.online = this.hasDefaultNet()
    } catch (err) {
      logger.error('Network: 初始化网络监听异常', (err as Error).message)
    }
  }

  private update(online: boolean): void {
    if (this.online === online) {
      return
    }
    this.online = online
    logger.info('Network: 网络状态变化', online ? 'online' : 'offline')
    this.notify(online)
  }

  private notify(online: boolean): void {
    this.listeners.forEach((listener: NetworkListener) => {
      try {
        listener(online)
      } catch (err) {
        logger.error('Network: 监听回调异常', (err as Error).message)
      }
    })
  }

  /** 释放连接（Ability 销毁时调用） */
  release(): void {
    if (!this.netConnection) {
      return
    }
    try {
      this.netConnection.unregister((err) => {
        if (err) {
          logger.error('Network: 注销网络监听失败', JSON.stringify(err))
        }
      })
    } catch (err) {
      logger.error('Network: 注销网络监听异常', (err as Error).message)
    }
    this.netConnection = null
    this.listeners.clear()
  }
}

export const network = new Network()
