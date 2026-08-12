/**
 * 日期时间工具
 *
 * 历史代码在 Sign.ets / BrushProblem.ets / 多个组件里各自实现了一遍格式化，
 * 这里统一收口为纯函数，输出格式与后端约定保持一致。
 */

/** 一天对应的毫秒数 */
export const ONE_DAY_MS = 24 * 60 * 60 * 1000

const WEEK_NAMES: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']

/** 补零 */
function pad(value: number, length: number = 2): string {
  return String(value).padStart(length, '0')
}

/**
 * 格式化时间戳
 * @param time 时间戳或 Date
 * @param pattern 支持 YYYY MM DD HH mm ss SSS 占位符
 */
export function format(time: number | Date, pattern: string = 'YYYY-MM-DD HH:mm:ss'): string {
  const date = time instanceof Date ? time : new Date(time)
  if (Number.isNaN(date.getTime())) {
    return ''
  }
  return pattern
    .replace('YYYY', String(date.getFullYear()))
    .replace('MM', pad(date.getMonth() + 1))
    .replace('DD', pad(date.getDate()))
    .replace('HH', pad(date.getHours()))
    .replace('mm', pad(date.getMinutes()))
    .replace('ss', pad(date.getSeconds()))
    .replace('SSS', pad(date.getMilliseconds(), 3))
}

/** 服务端约定的提交格式：YYYY-MM-DD HH:mm:ss */
export function now(): string {
  return format(new Date(), 'YYYY-MM-DD HH:mm:ss')
}

/** 仅日期：YYYY-MM-DD */
export function today(): string {
  return format(new Date(), 'YYYY-MM-DD')
}

/** 短格式：MM-DD HH:mm，用于列表展示 */
export function shortDateTime(time: number): string {
  return format(time, 'MM-DD HH:mm')
}

/** 获取星期名称 */
export function weekName(time: number | Date): string {
  const date = time instanceof Date ? time : new Date(time)
  if (Number.isNaN(date.getTime())) {
    return ''
  }
  return WEEK_NAMES[date.getDay()]
}

/** 是否为同一天 */
export function isSameDay(a: number | Date, b: number | Date): boolean {
  const da = a instanceof Date ? a : new Date(a)
  const db = b instanceof Date ? b : new Date(b)
  return da.getFullYear() === db.getFullYear()
    && da.getMonth() === db.getMonth()
    && da.getDate() === db.getDate()
}

/** 当天的 00:00:00.000 时间戳 */
export function startOfDay(time: number | Date = new Date()): number {
  const date = time instanceof Date ? time : new Date(time)
  date.setHours(0, 0, 0, 0)
  return date.getTime()
}

/** 当天的 23:59:59.999 时间戳 */
export function endOfDay(time: number | Date = new Date()): number {
  const date = time instanceof Date ? time : new Date(time)
  date.setHours(23, 59, 59, 999)
  return date.getTime()
}

/** 相差天数（按自然日计算，忽略时分秒） */
export function daysBetween(from: number | Date, to: number | Date): number {
  const diff = startOfDay(to) - startOfDay(from)
  return Math.round(diff / ONE_DAY_MS)
}

/** 相对时间描述：刚刚 / n 分钟前 / n 小时前 / n 天前 / 具体日期 */
export function fromNow(time: number, base: number = Date.now()): string {
  const diff = base - time
  if (diff < 0) {
    return format(time, 'MM-DD HH:mm')
  }
  const minute = 60 * 1000
  const hour = 60 * minute
  if (diff < minute) {
    return '刚刚'
  }
  if (diff < hour) {
    return `${Math.floor(diff / minute)}分钟前`
  }
  if (diff < ONE_DAY_MS) {
    return `${Math.floor(diff / hour)}小时前`
  }
  if (diff < 7 * ONE_DAY_MS) {
    return `${Math.floor(diff / ONE_DAY_MS)}天前`
  }
  return format(time, 'YYYY-MM-DD')
}

/**
 * 把毫秒数转成可读时长
 * 例如 3_661_000 → 1小时1分1秒
 */
export function humanizeDuration(millis: number): string {
  if (!Number.isFinite(millis) || millis <= 0) {
    return '0秒'
  }
  const totalSeconds = Math.floor(millis / 1000)
  const hours = Math.floor(totalSeconds / 3600)
  const minutes = Math.floor((totalSeconds % 3600) / 60)
  const seconds = totalSeconds % 60
  const parts: string[] = []
  if (hours > 0) {
    parts.push(`${hours}小时`)
  }
  if (minutes > 0) {
    parts.push(`${minutes}分`)
  }
  if (seconds > 0 || parts.length === 0) {
    parts.push(`${seconds}秒`)
  }
  return parts.join('')
}

/** 分钟数转「n 小时 m 分」，用于学习时长展示 */
export function humanizeMinutes(minutes: number): string {
  if (!Number.isFinite(minutes) || minutes <= 0) {
    return '0分钟'
  }
  const h = Math.floor(minutes / 60)
  const m = Math.round(minutes % 60)
  if (h === 0) {
    return `${m}分钟`
  }
  if (m === 0) {
    return `${h}小时`
  }
  return `${h}小时${m}分`
}

/**
 * 获取某个月的日期区间
 * @returns [start, end] 两个时间戳，闭区间
 */
export function monthRange(year: number, month: number): number[] {
  // month 从 1 开始，与业务侧习惯一致
  const start = new Date(year, month - 1, 1).getTime()
  const end = endOfDay(new Date(year, month, 0))
  return [start, end]
}

/** 最近 n 天的日期数组（YYYY-MM-DD），从旧到新 */
export function recentDays(n: number, base: number = Date.now()): string[] {
  const result: string[] = []
  for (let i = n - 1; i >= 0; i--) {
    result.push(format(base - i * ONE_DAY_MS, 'YYYY-MM-DD'))
  }
  return result
}

/**
 * 计算连续天数
 *
 * 给定一组「已完成的日期」（YYYY-MM-DD），从 today 往前推，
 * 返回连续命中的天数。常用于打卡 / 学习连续天数统计。
 */
export function continuousDays(dayList: string[], todayStr: string = today()): number {
  if (!dayList || dayList.length === 0) {
    return 0
  }
  const set = new Set<string>(dayList)
  let count = 0
  let cursor = new Date(`${todayStr}T00:00:00`).getTime()
  // 最多向前追溯一年，避免脏数据导致死循环
  for (let i = 0; i < 366; i++) {
    if (!set.has(format(cursor, 'YYYY-MM-DD'))) {
      break
    }
    count++
    cursor -= ONE_DAY_MS
  }
  return count
}
