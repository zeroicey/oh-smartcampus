import { preferences } from '@kit.ArkData'
import { logger } from './logger'

/**
 * 首选项（preferences）轻量封装
 *
 * 历史代码在 Tracking.ets 里手写了 getPreferencesSync / getSync / putSync / flush 的流程，
 * 其它模块要落盘时只能再抄一遍。这里统一封装：
 * 1. 按 name 缓存 preferences 实例，避免重复打开；
 * 2. 提供 getString / getNumber / getBoolean / getObject 等类型化读取；
 * 3. 所有写入默认 flush，保证进程被杀后数据不丢。
 */
class Storage {
  private stores: Map<string, preferences.Preferences> = new Map()

  /** 获取（并按需创建）指定名称的首选项实例 */
  getStore(name: string): preferences.Preferences | null {
    const cached = this.stores.get(name)
    if (cached) {
      return cached
    }
    const context = AppStorage.get<Context>('context')
    if (!context) {
      logger.error('Storage: context 未初始化，无法打开首选项', name)
      return null
    }
    try {
      const store = preferences.getPreferencesSync(context, { name })
      this.stores.set(name, store)
      return store
    } catch (err) {
      logger.error('Storage: 打开首选项失败', name, (err as Error).message)
      return null
    }
  }

  /** 读取字符串 */
  getString(name: string, key: string, defValue: string = ''): string {
    const store = this.getStore(name)
    if (!store) {
      return defValue
    }
    try {
      return store.getSync(key, defValue) as string
    } catch (err) {
      logger.error('Storage: 读取字符串失败', key, (err as Error).message)
      return defValue
    }
  }

  /** 写入字符串 */
  putString(name: string, key: string, value: string): boolean {
    return this.put(name, key, value)
  }

  /** 读取数字 */
  getNumber(name: string, key: string, defValue: number = 0): number {
    const store = this.getStore(name)
    if (!store) {
      return defValue
    }
    try {
      return store.getSync(key, defValue) as number
    } catch (err) {
      logger.error('Storage: 读取数字失败', key, (err as Error).message)
      return defValue
    }
  }

  /** 写入数字 */
  putNumber(name: string, key: string, value: number): boolean {
    return this.put(name, key, value)
  }

  /** 读取布尔 */
  getBoolean(name: string, key: string, defValue: boolean = false): boolean {
    const store = this.getStore(name)
    if (!store) {
      return defValue
    }
    try {
      return store.getSync(key, defValue) as boolean
    } catch (err) {
      logger.error('Storage: 读取布尔失败', key, (err as Error).message)
      return defValue
    }
  }

  /** 写入布尔 */
  putBoolean(name: string, key: string, value: boolean): boolean {
    return this.put(name, key, value)
  }

  /**
   * 读取对象（内部以 JSON 字符串存储）
   * @param defValue 解析失败时返回的默认值
   */
  getObject<T>(name: string, key: string, defValue: T): T {
    const raw = this.getString(name, key, '')
    if (!raw) {
      return defValue
    }
    try {
      return JSON.parse(raw) as T
    } catch (err) {
      logger.error('Storage: JSON 解析失败', key, (err as Error).message)
      return defValue
    }
  }

  /** 写入对象 */
  putObject<T>(name: string, key: string, value: T): boolean {
    try {
      return this.put(name, key, JSON.stringify(value))
    } catch (err) {
      logger.error('Storage: JSON 序列化失败', key, (err as Error).message)
      return false
    }
  }

  /** 通用写入 */
  private put(name: string, key: string, value: preferences.ValueType): boolean {
    const store = this.getStore(name)
    if (!store) {
      return false
    }
    try {
      store.putSync(key, value)
      store.flush()
      return true
    } catch (err) {
      logger.error('Storage: 写入失败', key, (err as Error).message)
      return false
    }
  }

  /** 删除单个键 */
  remove(name: string, key: string): boolean {
    const store = this.getStore(name)
    if (!store) {
      return false
    }
    try {
      store.deleteSync(key)
      store.flush()
      return true
    } catch (err) {
      logger.error('Storage: 删除失败', key, (err as Error).message)
      return false
    }
  }

  /** 判断键是否存在 */
  has(name: string, key: string): boolean {
    const store = this.getStore(name)
    if (!store) {
      return false
    }
    try {
      return store.hasSync(key)
    } catch (err) {
      logger.error('Storage: 判断键失败', key, (err as Error).message)
      return false
    }
  }

  /** 清空某个首选项库 */
  clear(name: string): boolean {
    const store = this.getStore(name)
    if (!store) {
      return false
    }
    try {
      store.clearSync()
      store.flush()
      return true
    } catch (err) {
      logger.error('Storage: 清空失败', name, (err as Error).message)
      return false
    }
  }

  /**
   * 向数组型数据追加元素，并做长度截断（保留最新的 limit 条）
   * 常用于搜索历史、浏览记录等「先进先出」场景。
   */
  pushToList<T>(name: string, key: string, item: T, limit: number = 20, compareKey?: (a: T, b: T) => boolean): T[] {
    const list = this.getObject<T[]>(name, key, [])
    // 去重：若存在相同元素先移除，保证最近使用排在最前
    const filtered = compareKey ? list.filter((it: T) => !compareKey(it, item)) : list.filter((it: T) => it !== item)
    filtered.unshift(item)
    const limited = filtered.slice(0, limit)
    this.putObject(name, key, limited)
    return limited
  }
}

export const storage = new Storage()
