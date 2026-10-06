// 发布的所有笔记布局组件
import { IAllPublisherNotes, Rows, WaterFlowType } from '../../models';
import { MyDataSource } from '../../models/LazyForeachResource/MyDataSource';
import { auth, httpReq, logger, network, toast } from '../utils';
import { HcEmpty } from './HcEmpty';
import { HcError } from './HcError';
import { HcSkeleton } from './HcSkeleton';
import { NotesWaterFlowItem } from './NotesWaterFlowItem';
import { router } from '@kit.ArkUI';
import { API, DEFAULT_PAGE, DEFAULT_PAGE_SIZE } from '../constants';
import { noteIdParams } from '../../pages/reEdit';

// 请求参数类型
interface IInCircleContentRes {
  circleId: string;
  page: number;
  size: number;
  topicId: number
}

// 跳转页面参数类型
export interface INoteIdParams {
  noteId: string,
  flowType?: WaterFlowType
}

@Component
export struct NotesWaterFlow {
  // 判断请求是属于哪种类型
  @Prop flowType: WaterFlowType
  // 话题id
  @Prop topicId: number
  // 知识圈id
  @Prop circleId: string
  // 请求页码
  @State page: number = DEFAULT_PAGE
  @State res: IAllPublisherNotes = {} as IAllPublisherNotes
  data: MyDataSource<Rows> = new MyDataSource()
  @State list: Rows[] = []
  // 是否处在加载中
  @State isLoading: boolean = false
  // 是否处在刷新中
  @State isRefreshing: boolean = false
  // 是否加载全部
  @State isFinished: boolean = false
  // 用来设置骨架屏效果
  @State isSkeleton: boolean = true
  // 请求是否失败（失败时展示重试占位）
  @State isError: boolean = false
  // 触底计时器id
  @State endTimeId: number = -1
  // 下拉刷新计时器
  @State refreshId: number = -1

  aboutToDisappear(): void {
    // 页面销毁时清理定时器，避免回调操作已卸载的组件
    if (this.endTimeId !== -1) {
      clearTimeout(this.endTimeId)
      this.endTimeId = -1
    }
    if (this.refreshId !== -1) {
      clearTimeout(this.refreshId)
      this.refreshId = -1
    }
  }

  // 获取用户发布过的/草稿箱/收藏的笔记
  getUserPublished(flowType: WaterFlowType): Promise<IAllPublisherNotes> {
    return httpReq.request<IAllPublisherNotes>({
      url: flowType == WaterFlowType.myNotes ? API.NOTE_FIND_NOTE :
        flowType == WaterFlowType.draft ? API.NOTE_SAVE_NOTE : API.NOTE_FIND_COLLECT,
      params: {
        page: this.page,
        size: DEFAULT_PAGE_SIZE
      }
    })
  }

  // 获取知识圈以及资讯的所有笔记
  getInCircleContent(flowType: WaterFlowType): Promise<IAllPublisherNotes> {
    return httpReq.request<IAllPublisherNotes>({
      url: API.NOTE_QUERY_BATCH,
      params: {
        circleId: flowType == WaterFlowType.circle ? this.circleId : '0',
        page: this.page,
        size: DEFAULT_PAGE_SIZE,
        topicId: flowType == WaterFlowType.circle ? this.topicId : '0'
      } as IInCircleContentRes
    })
  }

  /** 统一请求入口，根据 flowType 分发 */
  private fetch(flowType: WaterFlowType): Promise<IAllPublisherNotes> {
    if (flowType == WaterFlowType.message || flowType == WaterFlowType.circle) {
      return this.getInCircleContent(flowType)
    }
    return this.getUserPublished(flowType)
  }

  /** 保证返回结构完整，避免后端字段缺失导致后续崩溃 */
  private normalize(res: IAllPublisherNotes | null | undefined): IAllPublisherNotes {
    if (!res) {
      return {
        page: this.page,
        pageSize: DEFAULT_PAGE_SIZE,
        rows: [],
        total: 0
      } as IAllPublisherNotes
    }
    if (!res.rows) {
      res.rows = []
    }
    if (!res.total) {
      res.total = 0
    }
    if (!res.pageSize) {
      res.pageSize = DEFAULT_PAGE_SIZE
    }
    return res
  }

  // 上滑加载逻辑
  async Loading(flowType: WaterFlowType) {
    try {
      const raw = await this.fetch(flowType)
      this.res = this.normalize(raw)
      // 将获取到的数组内容放入新数组当中
      this.res.rows.forEach((item: Rows) => {
        this.data.pushData(item)
      })
      this.isError = false
      if (this.page >= Math.ceil(this.res.total / this.res.pageSize)) {
        this.isFinished = true
      } else {
        this.page++
      }
    } catch (err) {
      // 失败时保留已有数据，仅在首屏失败时展示错误占位
      this.isError = this.data.totalCount() == 0
      logger.error('NotesWaterFlow: 加载失败', JSON.stringify(err))
    } finally {
      this.isLoading = false
    }
  }

  // 知识圈以及资讯下拉刷新逻辑
  async onRefreshing() {
    try {
      // 判断page是否为最后一页或者倒数第二页是的话恢复为1否则不初始化
      const rowsSize = this.res.rows ? this.res.rows.length : 0
      const totalPages = Math.ceil((this.res.total ?? 0) / (this.res.pageSize ?? DEFAULT_PAGE_SIZE))
      if (rowsSize >= DEFAULT_PAGE_SIZE || this.page >= totalPages) {
        this.page = DEFAULT_PAGE
      }
      const raw = await this.fetch(this.flowType)
      this.res = this.normalize(raw)
      // 根据返送返回的请求数据rows来判断是否是最后一页，不是的话page++
      if (this.res.rows.length >= DEFAULT_PAGE_SIZE) {
        this.page++
      }
      this.data.clearData()
      this.res.rows.forEach((item: Rows) => {
        this.data.pushData(item)
      })
      this.isError = false
      // 让已加载全部，消失
      this.isFinished = this.data.totalCount() >= this.res.total
    } catch (err) {
      this.isError = this.data.totalCount() == 0
      logger.error('NotesWaterFlow: 刷新失败', JSON.stringify(err))
      toast.error('刷新失败，请稍后重试')
    } finally {
      this.isRefreshing = false
    }
  }

  async aboutToAppear() {
    if (!network.isOnline()) {
      this.isSkeleton = false
      this.isError = true
      return
    }
    await this.Loading(this.flowType)
    this.isSkeleton = false
  }

  /** 重试：清空并重新加载首屏 */
  private async retry() {
    this.isError = false
    this.isSkeleton = true
    this.isFinished = false
    this.page = DEFAULT_PAGE
    this.data.clearData()
    await this.Loading(this.flowType)
    this.isSkeleton = false
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing }) {
      if (this.isSkeleton) {
        HcSkeleton()
      } else if (this.isError) {
        HcError({ onretry: () => this.retry() })
      } else if (this.data.totalCount() == 0) {
        HcEmpty({ title: '暂无内容', description: '下拉刷新试试' })
      } else {
        WaterFlow({ footer: this.LoadMoreBuilder() }) {
          LazyForEach(this.data, (item: Rows) => {
            FlowItem() {
              NotesWaterFlowItem({ item: item, flowType: this.flowType })
                .onClick(() => {
                  if (this.flowType == WaterFlowType.draft) {
                    router.pushUrl({
                      url: 'pages/reEdit',
                      params: {
                        noteId: item.id,
                      } as noteIdParams
                    })

                  } else {
                    auth.CheckAuth({
                      url: 'pages/ShareNotes',
                      params: {
                        noteId: item.id,
                        flowType: this.flowType
                      } as INoteIdParams
                    })
                  }
                })
            }
          }, (item: Rows) => item.id)
        }
        .columnsTemplate('1fr 1fr')
        .cachedCount(2)
        .columnsGap(10)
        .rowsGap(10)
        .edgeEffect(EdgeEffect.None)
        .onReachEnd(() => {
          // 如果已经到底则不会再加载
          if (this.isFinished || this.isLoading) {
            return
          }
          this.isLoading = true
          // 防抖处理
          clearTimeout(this.endTimeId)
          this.endTimeId = setTimeout(() => {
            this.Loading(this.flowType)
          }, 1000)
        })
      }
    }
    .onRefreshing(() => {
      if (this.isSkeleton) {
        this.isRefreshing = false
        return
      }
      if (this.flowType != WaterFlowType.message && this.flowType != WaterFlowType.circle) {
        this.isRefreshing = false
        return
      }
      this.isFinished = false
      // 防抖处理
      clearTimeout(this.refreshId)
      this.refreshId = setTimeout(() => {
        this.onRefreshing()
      }, 1000)
    })
  }

  @Builder
  LoadMoreBuilder() {
    if (this.isFinished) {
      // 加载完成的状态
      Text('没有更多内容了~')
        .fontSize(14)
        .fontColor(Color.White)
        .width('100%')
        .height(80)
        .textAlign(TextAlign.Center)
    } else if (this.isLoading) {
      // 正在加载中的状态
      Row() {
        LoadingProgress()
          .width(20)
        Text('加载中...')
          .fontSize(14)
          .fontColor(Color.White)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .height(80)
    }
  }
}
