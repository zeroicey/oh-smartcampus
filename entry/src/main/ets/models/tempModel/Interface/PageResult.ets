/**
 * 通用分页结构
 *
 * 服务端列表接口大多数都返回 { page, pageSize, rows, total }，
 * 历史代码在每个 Interface 文件里重复声明了同名字段。这里抽成泛型结构，
 * 新接口直接 `PageResult<NoteItem>` 即可。
 */
export interface PageResult<T> {
  /** 当前页码，从 1 开始 */
  page: number
  /** 每页条数 */
  pageSize: number
  /** 数据行 */
  rows: T[]
  /** 总条数 */
  total: number
}

/** 分页请求参数 */
export interface PageQuery {
  page?: number
  size?: number
}

/** 判断某个分页结果是否为最后一页 */
export function isLastPage<T>(result: PageResult<T> | null | undefined): boolean {
  if (!result || !result.pageSize || result.pageSize <= 0) {
    return true
  }
  return result.page >= Math.ceil((result.total ?? 0) / result.pageSize)
}

/** 统一的总页数计算 */
export function totalPages(total: number, pageSize: number): number {
  if (!pageSize || pageSize <= 0) {
    return 0
  }
  return Math.ceil(total / pageSize)
}
