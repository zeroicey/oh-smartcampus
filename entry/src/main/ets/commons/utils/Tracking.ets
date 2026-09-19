import { preferences } from '@kit.ArkData'
import { httpReq } from './Http'
import { logger } from './logger'
import { IAnswerRequest } from '../../models'
import {
  API,
  STORAGE_KEY_TRACKING,
  STORAGE_NAME_TRACKING,
  TRACKING_REPORT_THRESHOLD
} from '../constants'

/** 本地最多缓存的埋点条数，防止极端离线场景下无限增长 */
const MAX_LOCAL_RECORDS = 200

class Tracking {
  store: preferences.Preferences | null = null
  dataKey: string = STORAGE_KEY_TRACKING
  /** 是否正在上报，避免并发重复上报 */
  private reporting: boolean = false

  getStore(): preferences.Preferences | null {
    // 只获取一次
    if (!this.store) {
      // 获取上下文对象
      const context = AppStorage.get<Context>('context')
      if (!context) {
        logger.error('Tracking: context 未初始化，埋点数据无法落盘')
        return null
      }
      // 获取首选项实例
      const store = preferences.getPreferencesSync(context, { name: STORAGE_NAME_TRACKING })
      this.store = store
    }
    return this.store
  }

  /** 读取本地缓存，任何解析异常都退化为空对象，避免污染后续流程 */
  private readLocal(): IAnswerRequest {
    const store = this.getStore()
    if (!store) {
      return {} as IAnswerRequest
    }
    const jsonStr = store.getSync(this.dataKey, '{}')
    try {
      return JSON.parse(jsonStr as string) as IAnswerRequest
    } catch (err) {
      logger.error('Tracking: 本地埋点数据损坏，已重置', (err as Error).message)
      store.deleteSync(this.dataKey)
      store.flush()
      return {} as IAnswerRequest
    }
  }

  // 记录埋点数据
  record(chapterId: number, startTimestamp: number, endTimestamp: number, questionId: number,
    userAnswer: string | null) {
    // 非法时间段直接丢弃，避免上报脏数据
    if (!Number.isFinite(startTimestamp) || !Number.isFinite(endTimestamp) || endTimestamp < startTimestamp) {
      logger.warn('Tracking: 忽略非法埋点区间', String(startTimestamp), String(endTimestamp))
      return
    }
    // 获取首选项实例 - 只有第一次执行
    const store = this.getStore()
    if (!store) {
      return
    }
    // 取出store中的key值，json字符串或者[]
    const timeStr = this.readLocal()
    // 再将新获取到的埋点数据推入进去
    timeStr.chapterId = chapterId.toString()
    if (timeStr.answerDetails == undefined) {
      timeStr.answerDetails = []
    }
    timeStr.answerDetails.push({
      endTimestamp,
      questionId,
      startTimestamp,
      userAnswer
    })
    // 超出上限时丢弃最旧的记录（保留最新的 MAX_LOCAL_RECORDS 条）
    if (timeStr.answerDetails.length > MAX_LOCAL_RECORDS) {
      timeStr.answerDetails = timeStr.answerDetails.slice(timeStr.answerDetails.length - MAX_LOCAL_RECORDS)
      logger.warn('Tracking: 本地埋点超出上限，已丢弃最旧数据')
    }
    logger.debug('Tracking record', JSON.stringify(timeStr))
    // 再转化成json字符串传入回store中
    store.putSync(this.dataKey, JSON.stringify(timeStr))
    // 并进行初始化
    store.flush()
  }

  // 上报埋点数据
  // force指的是是否主动上报
  async report(force: boolean = false): Promise<void> {
    if (this.reporting) {
      return
    }
    const store = this.getStore()
    if (!store) {
      return
    }
    const timeStr = this.readLocal()
    // 当获取到的埋点数据为5条时主动上报
    // 如果用户在还没有到达5条时就退出应用那么在下次用户点开应用时
    // 即进入首页或者登录页时自动上报一次
    if (!timeStr.answerDetails || timeStr.answerDetails.length === 0) {
      return
    }
    if (timeStr.answerDetails.length < TRACKING_REPORT_THRESHOLD && !force) {
      return
    }

    this.reporting = true
    try {
      await httpReq.request<null, IAnswerRequest>({
        url: API.QUESTION_ANSWER_UPLOAD,
        headers: {
          'uid': '10008'
        },
        method: 'post',
        data: timeStr
      })
      // 只有上报成功后才清除数据，避免弱网下丢失埋点
      store.deleteSync(this.dataKey)
      store.flush()
      logger.info('Tracking: 埋点上报成功', String(timeStr.answerDetails.length))
    } catch (err) {
      // 上报失败保留本地数据，等待下一次触发
      logger.error('Tracking: 埋点上报失败，数据已保留', JSON.stringify(err))
    } finally {
      this.reporting = false
    }
  }

  /** 清空本地埋点（退出登录时调用） */
  clear(): void {
    const store = this.getStore()
    if (!store) {
      return
    }
    store.deleteSync(this.dataKey)
    store.flush()
  }

  /** 当前待上报条数，供调试面板展示 */
  pendingCount(): number {
    const local = this.readLocal()
    return local.answerDetails ? local.answerDetails.length : 0
  }
}

export const tracking = new Tracking()
