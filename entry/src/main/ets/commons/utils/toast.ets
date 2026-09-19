import { promptAction } from '@kit.ArkUI'

/**
 * 统一提示封装
 *
 * 历史代码在几十处直接调用 promptAction.showToast，参数各不相同，
 * 有的没写 duration，有的把错误对象直接拼进 message。这里统一收口并做长度截断，
 * 避免超长文案把 toast 撑破。
 */

/** 默认提示时长 */
export const TOAST_SHORT = 2000
export const TOAST_LONG = 3500

/** toast 文案长度上限 */
const MAX_MESSAGE_LENGTH = 40

/** 兜底文案，避免传入空字符串时 toast 一闪而过 */
const FALLBACK = '操作失败，请稍后重试'

/** 截断超长文案 */
function normalize(message: string | null | undefined): string {
  if (message === null || message === undefined || message.trim().length === 0) {
    return FALLBACK
  }
  const text = message.trim()
  if (text.length <= MAX_MESSAGE_LENGTH) {
    return text
  }
  return `${text.slice(0, MAX_MESSAGE_LENGTH - 1)}…`
}

/**
 * 提示工具
 *
 * 用法：
 *   toast.success('发布成功')
 *   toast.error(err)
 */
class Toast {
  /** 通用提示 */
  show(message: string | null | undefined, duration: number = TOAST_SHORT): void {
    promptAction.showToast({ message: normalize(message), duration })
  }

  /** 成功提示 */
  success(message: string | null | undefined = '操作成功'): void {
    this.show(message, TOAST_SHORT)
  }

  /** 失败提示 */
  error(message: string | null | undefined = FALLBACK, duration: number = TOAST_LONG): void {
    this.show(message, duration)
  }

  /** 普通信息提示 */
  info(message: string | null | undefined, duration: number = TOAST_SHORT): void {
    this.show(message, duration)
  }

  /** 警告提示 */
  warn(message: string | null | undefined, duration: number = TOAST_LONG): void {
    this.show(message, duration)
  }

  /** 统一的「请求失败」提示，可传入 Error 对象 */
  requestFailed(err: ESObject): void {
    let message = FALLBACK
    if (err instanceof Error) {
      message = err.message
    } else if (typeof err === 'string') {
      message = err
    } else if (err && typeof err === 'object') {
      const maybe = err as Record<string, string>
      message = maybe.errorMsg ?? maybe.message ?? FALLBACK
    }
    this.error(message)
  }
}

export const toast = new Toast()
