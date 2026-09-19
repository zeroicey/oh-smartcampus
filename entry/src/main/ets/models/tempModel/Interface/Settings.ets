/**
 * 设置相关数据模型
 *
 * 用于个人中心「设置」分组：消息通知、深色模式、自动播放、缓存清理等。
 */
export interface AppSettings {
  /** 是否接收学习提醒推送 */
  studyNotify: boolean
  /** 是否接收知识圈互动通知 */
  circleNotify: boolean
  /** 是否跟随系统深色模式 */
  followSystemTheme: boolean
  /** 是否启用图片自动加载（弱网下可关闭节省流量） */
  autoLoadImage: boolean
  /** 是否在 WiFi 下自动上传学习记录 */
  autoUploadOnWifi: boolean
  /** 字体缩放比例，取值范围 0.85 ~ 1.5 */
  fontScale: number
}

/** 默认设置 */
export const DEFAULT_SETTINGS: AppSettings = {
  studyNotify: true,
  circleNotify: true,
  followSystemTheme: true,
  autoLoadImage: true,
  autoUploadOnWifi: true,
  fontScale: 1.0
}

/** 缓存统计 */
export interface CacheStat {
  /** 图片缓存大小（字节） */
  imageBytes: number
  /** 埋点缓存大小（字节） */
  trackingBytes: number
  /** 搜索历史条数 */
  searchCount: number
}

/** 学习目标设置 */
export interface StudyGoal {
  /** 每日学习目标时长（分钟） */
  dailyMinutes: number
  /** 每日目标刷题数 */
  dailyQuestions: number
}

/** 默认学习目标 */
export const DEFAULT_STUDY_GOAL: StudyGoal = {
  dailyMinutes: 60,
  dailyQuestions: 10
}
