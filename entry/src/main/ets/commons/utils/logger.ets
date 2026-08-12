// 封装 hilog 函数
import { hilog } from '@kit.PerformanceAnalysisKit'

const DEFAULT_DOMAIN = 0x1234
const DEFAULT_TAG = '区的logger'

/** 日志级别，数值越大越严重；低于当前级别的日志不会被输出 */
export enum LogLevel {
  DEBUG = 0,
  INFO = 1,
  WARN = 2,
  ERROR = 3,
  FATAL = 4
}

/**
 * 把任意类型的安全地转为字符串
 *
 * hilog 只接受 string 作为参数，直接传入对象会被框架转成 `[object Object]`，
 * 这里统一做一次序列化，避免排查问题时看不到内容。
 */
function stringify(value: ESObject): string {
  if (value === null || value === undefined) {
    return String(value)
  }
  const type = typeof value
  if (type === 'string') {
    return value as string
  }
  if (type === 'number' || type === 'boolean' || type === 'bigint' || type === 'symbol') {
    return String(value)
  }
  if (type === 'function') {
    return '[Function]'
  }
  try {
    return JSON.stringify(value)
  } catch (err) {
    // 循环引用等异常场景，退化为 String()
    return String(value)
  }
}

/**
 * HiLog 中定义了 DEBUG、INFO、WARN、ERROR、FATAL 五种日志级别。
 *
 * 与旧版相比：
 * 1. 支持全局级别过滤（发布包可将级别设为 WARN 以上，减少日志量）；
 * 2. format 按实际参数个数动态生成，修复了 3 个以上参数时格式化错位的问题；
 * 3. 非字符串参数自动序列化，不再出现 `[object Object]`；
 * 4. 统一补充调用时间，便于与埋点时间戳对齐排查。
 */
class Logger {
  /** 十六进制域号 */
  private domain: number
  /** 用于指定日志标识，可以为任意字符串 */
  private tag: string
  /** 当前生效的日志级别 */
  private level: LogLevel = LogLevel.DEBUG
  /** 是否在日志前缀追加时间 */
  private withTimestamp: boolean = true

  constructor(domain: number = DEFAULT_DOMAIN, tag: string = DEFAULT_TAG) {
    this.domain = domain
    this.tag = tag
  }

  /** 设置全局日志级别 */
  setLevel(level: LogLevel): void {
    this.level = level
  }

  getLevel(): LogLevel {
    return this.level
  }

  /** 是否输出时间前缀 */
  enableTimestamp(enable: boolean): void {
    this.withTimestamp = enable
  }

  /**
   * 根据参数个数生成 hilog 的格式化模板
   * %{public}s 为字符串，避免参数内容被打码
   */
  private buildFormat(size: number): string {
    if (size <= 0) {
      return '%{public}s'
    }
    const placeholders: string[] = []
    for (let i = 0; i < size; i++) {
      placeholders.push('%{public}s')
    }
    return placeholders.join(', ')
  }

  /** 构造可读的日志前缀 */
  private prefix(): string {
    if (!this.withTimestamp) {
      return ''
    }
    const now = new Date()
    const hh = String(now.getHours()).padStart(2, '0')
    const mm = String(now.getMinutes()).padStart(2, '0')
    const ss = String(now.getSeconds()).padStart(2, '0')
    const ms = String(now.getMilliseconds()).padStart(3, '0')
    return `[${hh}:${mm}:${ss}.${ms}] `
  }

  /** 统一输出 */
  private print(level: LogLevel, printer: (domain: number, tag: string, format: string, args: string[]) => void,
    arr: ESObject[]): void {
    if (level < this.level) {
      return
    }
    const args: string[] = arr.map((item: ESObject) => stringify(item))
    if (this.withTimestamp) {
      args.unshift(this.prefix())
    }
    printer(this.domain, this.tag, this.buildFormat(args.length), args)
  }

  debug(...arr: ESObject[]): void {
    this.print(LogLevel.DEBUG, (domain, tag, format, args) => hilog.debug(domain, tag, format, ...args), arr)
  }

  info(...arr: ESObject[]): void {
    this.print(LogLevel.INFO, (domain, tag, format, args) => hilog.info(domain, tag, format, ...args), arr)
  }

  warn(...arr: ESObject[]): void {
    this.print(LogLevel.WARN, (domain, tag, format, args) => hilog.warn(domain, tag, format, ...args), arr)
  }

  error(...arr: ESObject[]): void {
    this.print(LogLevel.ERROR, (domain, tag, format, args) => hilog.error(domain, tag, format, ...args), arr)
  }

  fatal(...arr: ESObject[]): void {
    this.print(LogLevel.FATAL, (domain, tag, format, args) => hilog.fatal(domain, tag, format, ...args), arr)
  }
}

// 由于是类所以要进行实例化
export const logger = new Logger(DEFAULT_DOMAIN, DEFAULT_TAG)
