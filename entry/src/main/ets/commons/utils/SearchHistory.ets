import { storage } from './storage'
import { logger } from './logger'
import { SEARCH_HISTORY_LIMIT, STORAGE_KEY_SEARCH_HISTORY, STORAGE_NAME_SEARCH } from '../constants'

/** 一条搜索历史 */
export interface SearchHistoryItem {
  /** 搜索关键词 */
  keyword: string
  /** 最近一次搜索时间戳 */
  timestamp: number
  /** 命中次数，用于排序权重 */
  count: number
}

/**
 * 搜索历史管理
 *
 * 基于首选项（preferences）落盘，提供去重、置顶、限长与清空能力。
 * 与 UI 解耦，可在搜索页 / 首页共用。
 */
class SearchHistory {
  /** 读取全部历史，按最近使用时间倒序 */
  getAll(): SearchHistoryItem[] {
    const list = storage.getObject<SearchHistoryItem[]>(STORAGE_NAME_SEARCH, STORAGE_KEY_SEARCH_HISTORY, [])
    if (!Array.isArray(list)) {
      return []
    }
    return list
      .filter((item: SearchHistoryItem) => !!item && !!item.keyword)
      .sort((a: SearchHistoryItem, b: SearchHistoryItem) => b.timestamp - a.timestamp)
  }

  /** 读取最近 n 条关键词 */
  keywords(limit: number = SEARCH_HISTORY_LIMIT): string[] {
    return this.getAll()
      .slice(0, limit)
      .map((item: SearchHistoryItem) => item.keyword)
  }

  /**
   * 记录一次搜索
   *
   * 已存在的关键词会被移到最前并累加计数，超出上限时丢弃最旧记录。
   */
  add(keyword: string): SearchHistoryItem[] {
    const trimmed = (keyword ?? '').trim()
    if (trimmed.length === 0) {
      return this.getAll()
    }
    const list = this.getAll()
    const existing = list.find((item: SearchHistoryItem) => item.keyword === trimmed)
    const rest = list.filter((item: SearchHistoryItem) => item.keyword !== trimmed)
    const merged: SearchHistoryItem = {
      keyword: trimmed,
      timestamp: Date.now(),
      count: existing ? existing.count + 1 : 1
    }
    rest.unshift(merged)
    const limited = rest.slice(0, SEARCH_HISTORY_LIMIT)
    storage.putObject(STORAGE_NAME_SEARCH, STORAGE_KEY_SEARCH_HISTORY, limited)
    logger.debug('SearchHistory: 已记录关键词', trimmed)
    return limited
  }

  /** 批量写入（例如从云端同步） */
  replaceAll(items: SearchHistoryItem[]): void {
    const limited = (items ?? []).slice(0, SEARCH_HISTORY_LIMIT)
    storage.putObject(STORAGE_NAME_SEARCH, STORAGE_KEY_SEARCH_HISTORY, limited)
  }

  /** 删除单个关键词 */
  remove(keyword: string): SearchHistoryItem[] {
    const list = this.getAll().filter((item: SearchHistoryItem) => item.keyword !== keyword)
    storage.putObject(STORAGE_NAME_SEARCH, STORAGE_KEY_SEARCH_HISTORY, list)
    return list
  }

  /** 清空全部历史 */
  clear(): void {
    storage.remove(STORAGE_NAME_SEARCH, STORAGE_KEY_SEARCH_HISTORY)
    logger.info('SearchHistory: 已清空搜索历史')
  }

  /** 当前历史条数 */
  size(): number {
    return this.getAll().length
  }

  /** 按命中次数取热门关键词 */
  hotKeywords(limit: number = 5): string[] {
    return this.getAll()
      .sort((a: SearchHistoryItem, b: SearchHistoryItem) => b.count - a.count)
      .slice(0, limit)
      .map((item: SearchHistoryItem) => item.keyword)
  }
}

export const searchHistory = new SearchHistory()
