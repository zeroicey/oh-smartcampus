// 发布的所有笔记布局组件
import { promptAction, router } from '@kit.ArkUI';
import { IAllPublisherNotes, Rows, WaterFlowType } from '../../models';
import { httpReq, logger } from '../utils';
import { HcSkeleton } from './HcSkeleton';
import { NotesWaterFlowItem } from './NotesWaterFlowItem';

// 请求参数类型
interface IInCircleContentRes {
  // TODO
  circleId: string;
  page: number;
  size: number;
  topicId: number
}

// 跳转页面参数类型
export interface ICircleIdParams {
  noteId: string
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
  @State page: number = 1
  @State res: IAllPublisherNotes = {} as IAllPublisherNotes
  @State list: Rows[] = []
  // 是否处在加载中
  @State isLoading: boolean = false
  // 是否处在刷新中
  @State isRefreshing: boolean = false
  // 是否加载全部
  @State isFinished: boolean = false
  // 用来设置骨架屏效果
  @State isSkeleton: boolean = true
  // 触底计时器id
  @State endTimeId: number = -1
  // 下拉刷新计时器
  @State refreshId: number = -1

  // 获取用户发布过的/草稿箱/收藏的笔记
  getUserPublished(flowType: WaterFlowType): Promise<IAllPublisherNotes> {
    return httpReq.request<IAllPublisherNotes>({
      url: flowType == WaterFlowType.myNotes ? '/note/find_note' :
        flowType == WaterFlowType.draft ? '/note/get_save_note' : '/note/findUserCollectNote',
      headers: {
        "uid": "1000001"
      },
      params: {
        page: this.page,
        size: 8
      }
    })
  }

  // 获取知识圈以及资讯的所有笔记
  getInCircleContent(flowType: WaterFlowType): Promise<IAllPublisherNotes> {
    return httpReq.request<IAllPublisherNotes>({
      url: '/note/queryBatch',
      params: {
        // TODO
        circleId: flowType == WaterFlowType.circle ? this.circleId : '5',
        page: this.page,
        size: 8,
        topicId: flowType == WaterFlowType.circle ? this.topicId : '0'
      } as IInCircleContentRes
    })
  }

  // 上滑加载逻辑
  async Loading(flowType: WaterFlowType) {
    if (flowType == WaterFlowType.message || flowType == WaterFlowType.circle) {
      promptAction.showToast({ message: flowType.toString() })
      this.res = await this.getInCircleContent(flowType)
    } else {
      promptAction.showToast({ message: flowType.toString() })
      logger.info(this.page.toString())
      this.res = await this.getUserPublished(flowType)
      logger.info(this.res.pageSize.toString())
    }
    // 将获取到的数组内容放入新数组当中
    this.list.push(...this.res.rows)
    this.isLoading = false
    if (this.page >= Math.ceil(this.res.total / this.res.pageSize)) {
      this.isFinished = true
    } else {
      this.page++
    }
  }

  // 知识圈以及资讯下拉刷新逻辑
  async onRefreshing() {
    // 判断page是否为最后一页或者倒数第二页是的话恢复为1否则不初始化
    if (this.page >= Math.ceil(this.res.total / this.res.pageSize)) {
      this.page = 1
    }
    this.res = await this.getInCircleContent(this.flowType)
    // 根据返送返回的请求数据rows来判断是否是最后一页，不是的话page++
    if (this.res.rows.length >= 8) {
      this.page++
    }
    this.list = this.res.rows
    this.isRefreshing = false
    // 让已加载全部，消失
    this.isFinished = this.list.length >= this.res.total ? true : false
  }

  async aboutToAppear() {
    await this.Loading(this.flowType)
    this.isSkeleton = false
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing }) {
      if (this.isSkeleton) {
        HcSkeleton()
      } else {
        WaterFlow({ footer: this.LoadMoreBuilder() }) {
          ForEach(this.list, (item: Rows, index: number) => {
            FlowItem() {
              NotesWaterFlowItem({ item: item })
                .onClick(() => {
                  // TODO
                  router.pushUrl({
                    url: 'pages/ShareNotes',
                    params: {
                      noteId: item.id,
                    } as ICircleIdParams
                  })
                })
            }
          })

        }
        .columnsTemplate('1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .edgeEffect(EdgeEffect.None)
        .onReachEnd(() => {
          // 如果已经到底则不会再加载
          if (this.isFinished) {
            return
          }
          this.isLoading = true
          // 防抖处理
          clearTimeout(this.endTimeId)
          this.endTimeId = setTimeout(() => {
            this.Loading(this.flowType)
          }, 700)
        })
      }
    }
    .onRefreshing(() => {
      logger.info('' + this.isSkeleton)
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
      }, 500)
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