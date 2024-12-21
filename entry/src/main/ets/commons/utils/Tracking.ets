import { preferences } from '@kit.ArkData'
import { httpReq, logger } from '.'
import { IAnswerRequest } from '../../models'

class Tracking {
  store: preferences.Preferences | null = null
  dataKey: string = 'time-list'

  getStore() {
    // 只获取一次
    if (!this.store) {
      // 获取上下文对象
      const context = AppStorage.get<Context>('context')
      const store = preferences.getPreferencesSync(context, { name: 'tracking-store' })
      this.store = store
    }
    return this.store
  }

  // 记录埋点数据
  record(chapterId: number, startTimestamp: number, endTimestamp: number, questionId: number,
    userAnswer: string | null) {
    // 获取首选项实例 - 只有第一次执行
    const store = this.getStore()
    // 取出store中的key值，json字符串或者[]
    const jsonStr = store.getSync(this.dataKey, '{}')
    // 将json字符串转化成对象
    const timeStr = JSON.parse(jsonStr as string) as IAnswerRequest
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
    logger.info(JSON.stringify(timeStr))
    // 再转化成json字符串传入回store中
    store.putSync(this.dataKey, JSON.stringify(timeStr))
    // 并进行初始化
    store.flush()
  }

  // 上报埋点数据
  // force指的是是否主动上报
  report(force: boolean = false) {
    // 获取首选项实例
    const store = this.getStore()
    const jsonStr = store.getSync(this.dataKey, '{}')
    const timeStr = JSON.parse(jsonStr as string) as IAnswerRequest
    logger.info(JSON.stringify(timeStr))
    // 当获取到的埋点数据为5条时主动上报
    // 如果用户在还没有到达5条时就退出应用那么在下次用户点开应用时
    // 即进入首页或者登录页时自动上报一次
    if (timeStr.answerDetails) {
      if (timeStr.answerDetails.length >= 5 || (timeStr.answerDetails.length > 0 && force)) {
        httpReq.request<null, IAnswerRequest>({
          url: '/question/answerUpload',
          headers: {
            "uid": "10008"
          },
          method: 'post',
          data: timeStr
        })
        // 上报完成之后将数据清除以免数据重复
        store.deleteSync(this.dataKey)
        // 并且初始化
        store.flush()
      }
    }
  }
}

export const tracking = new Tracking()