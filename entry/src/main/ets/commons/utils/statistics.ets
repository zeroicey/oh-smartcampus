/**
 * 学习数据统计工具
 *
 * 全部为纯函数，不依赖 UI 与网络，可直接被 hypium 单元测试覆盖。
 * 页面只负责取数，统计口径统一由这里定义。
 */

/** 通用数值记录 */
export interface NumericRecord {
  /** 记录日期，YYYY-MM-DD */
  date: string
  /** 数值 */
  value: number
}

/** 聚合结果 */
export interface AggregateResult {
  total: number
  average: number
  max: number
  min: number
  count: number
}

/** 求和 */
export function sum(values: number[]): number {
  if (!values || values.length === 0) {
    return 0
  }
  return values.reduce((acc: number, cur: number) => acc + (Number.isFinite(cur) ? cur : 0), 0)
}

/** 平均值，空数组返回 0 */
export function average(values: number[]): number {
  if (!values || values.length === 0) {
    return 0
  }
  return sum(values) / values.length
}

/** 最大值，空数组返回 0 */
export function max(values: number[]): number {
  if (!values || values.length === 0) {
    return 0
  }
  return values.reduce((acc: number, cur: number) => (cur > acc ? cur : acc), values[0])
}

/** 最小值，空数组返回 0 */
export function min(values: number[]): number {
  if (!values || values.length === 0) {
    return 0
  }
  return values.reduce((acc: number, cur: number) => (cur < acc ? cur : acc), values[0])
}

/** 一次性聚合 */
export function aggregate(values: number[]): AggregateResult {
  return {
    total: sum(values),
    average: average(values),
    max: max(values),
    min: min(values),
    count: values ? values.length : 0
  }
}

/** 保留 n 位小数（四舍五入） */
export function round(value: number, digits: number = 2): number {
  if (!Number.isFinite(value)) {
    return 0
  }
  const factor = Math.pow(10, digits)
  return Math.round(value * factor) / factor
}

/** 百分比，返回保留一位小数的数值 */
export function percent(part: number, total: number): number {
  if (!total || total <= 0) {
    return 0
  }
  return round((part / total) * 100, 1)
}

/** 百分比字符串，例如 "62.5%" */
export function percentText(part: number, total: number): string {
  return `${percent(part, total)}%`
}

/** 完成率，入参为「已完成 / 总数」 */
export function completionRate(completed: number, total: number): number {
  return percent(completed, total)
}

/** 把「毫秒」列表换算为分钟 */
export function toMinutes(millisList: number[]): number {
  return round(sum(millisList) / 60000, 2)
}

/**
 * 计算平均每题耗时（秒）
 * @param totalMillis 总耗时
 * @param questionCount 题目数
 */
export function averageSecondsPerQuestion(totalMillis: number, questionCount: number): number {
  if (!questionCount || questionCount <= 0) {
    return 0
  }
  return round(totalMillis / 1000 / questionCount, 1)
}

/**
 * 按日期补全序列
 *
 * 输入可能缺少某些日期，输出保证包含 dates 中的每一天（缺失补 0），
 * 便于直接喂给柱状图 / 折线图。
 */
export function fillTrend(records: NumericRecord[], dates: string[]): NumericRecord[] {
  const map = new Map<string, number>()
  ;(records || []).forEach((item: NumericRecord) => {
    map.set(item.date, (map.get(item.date) ?? 0) + item.value)
  })
  return dates.map((date: string) => {
    return { date, value: map.get(date) ?? 0 } as NumericRecord
  })
}

/**
 * 计算环比增长率
 * @returns 增长率（百分比），previous 为 0 时返回 0
 */
export function growthRate(current: number, previous: number): number {
  if (!previous || previous === 0) {
    return 0
  }
  return round(((current - previous) / Math.abs(previous)) * 100, 1)
}

/** 取前 N 名（降序） */
export function topN(records: NumericRecord[], n: number): NumericRecord[] {
  if (!records || records.length === 0 || n <= 0) {
    return []
  }
  return [...records].sort((a: NumericRecord, b: NumericRecord) => b.value - a.value).slice(0, n)
}

/** 按值分组计数，例如错题按章节分布 */
export function countBy<T>(list: T[], keyGetter: (item: T) => string): Map<string, number> {
  const result = new Map<string, number>()
  ;(list || []).forEach((item: T) => {
    const key = keyGetter(item)
    result.set(key, (result.get(key) ?? 0) + 1)
  })
  return result
}

/** Map 转成用于图表的记录数组 */
export function mapToRecords(map: Map<string, number>): NumericRecord[] {
  const result: NumericRecord[] = []
  map.forEach((value: number, key: string) => {
    result.push({ date: key, value })
  })
  return result
}

/** 中位数 */
export function median(values: number[]): number {
  if (!values || values.length === 0) {
    return 0
  }
  const sorted = [...values].sort((a: number, b: number) => a - b)
  const mid = Math.floor(sorted.length / 2)
  if (sorted.length % 2 === 0) {
    return round((sorted[mid - 1] + sorted[mid]) / 2, 2)
  }
  return sorted[mid]
}

/** 标准差 */
export function standardDeviation(values: number[]): number {
  if (!values || values.length === 0) {
    return 0
  }
  const avg = average(values)
  const variance = average(values.map((v: number) => Math.pow(v - avg, 2)))
  return round(Math.sqrt(variance), 2)
}
