// 封装hilog函数
import { hilog } from '@kit.PerformanceAnalysisKit'

const Tag = '区的logger'

// HiLog 中定义了 DEBUG、INFO、WARN、ERROR、FATAL 五种日志级别
class Logger {
  private domain: number //十六进制数组
  private tag: string //用于指定日志标识，可以为任意字符串
  private format: string = '%{public}s, %{public}s' //用于日志的格式化输出。%{public}s 为字符串 %{public}d 为数字

  constructor(domain: number, tag: string) {
    this.domain = domain
    this.tag = tag
  }

  // 封装方法
  // 优化format显示
  formatArr(arr: string[]): void {
    arr.length > 1 ? this.format = '%{public}s, %{public}s' : this.format = '%{public}s'
  }

  debug(...arr: string[]): void {
    this.formatArr(arr)
    hilog.debug(this.domain, this.tag, this.format, arr)
  }

  info(...arr: string[]) {
    this.formatArr(arr)
    hilog.info(this.domain, this.tag, this.format, arr)
  }

  warn(...arr: string[]) {
    this.formatArr(arr)
    hilog.warn(this.domain, this.tag, this.format, arr)
  }

  error(...arr: string[]) {
    this.formatArr(arr)
    hilog.error(this.domain, this.tag, this.format, arr)
  }
}

// 由于是类所以要进行实例化
export const logger = new Logger(0x1234, Tag)
