// 发布的所有笔记布局组件
import { IAllPublisherNotes, Rows, WaterFlowType } from '../../models';
import { MyDataSource } from '../../models/LazyForeachResource/MyDataSource';
import { auth, httpReq } from '../utils';
import { HcSkeleton } from './HcSkeleton';
import { NotesWaterFlowItem } from './NotesWaterFlowItem';
import { router } from '@kit.ArkUI';
import { NoteEditPropmtType } from '../../models/tempModel/Interface/PropmtInterfaces';

// 请求参数类型
interface IInCircleContentRes {
  circleId: string;
  page: number;
  size: number;
  topicId: number
}

// 跳转页面参数类型
export interface INoteIdParams {
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
  // 触底计时器id
  @State endTimeId: number = -1
  // 下拉刷新计时器
  @State refreshId: number = -1

  // 获取用户发布过的/草稿箱/收藏的笔记
  getUserPublished(flowType: WaterFlowType): Promise<IAllPublisherNotes> {
    return httpReq.request<IAllPublisherNotes>({
      url: flowType == WaterFlowType.myNotes ? '/note/find_note' :
        flowType == WaterFlowType.draft ? '/note/get_save_note' : '/note/findUserCollectNote',
      params: {
        page: this.page,
        size: 10
      }
    })
  }

  // 获取知识圈以及资讯的所有笔记
  getInCircleContent(flowType: WaterFlowType): Promise<IAllPublisherNotes> {
    return httpReq.request<IAllPublisherNotes>({
      url: '/note/queryBatch',
      params: {
        circleId: flowType == WaterFlowType.circle ? this.circleId : '5',
        page: this.page,
        size: 10,
        topicId: flowType == WaterFlowType.circle ? this.topicId : '0'
      } as IInCircleContentRes
    })
  }

  // 上滑加载逻辑
  async Loading(flowType: WaterFlowType) {
    if (flowType == WaterFlowType.message || flowType == WaterFlowType.circle) {
      this.res = await this.getInCircleContent(flowType)
    } else {
      this.res = await this.getUserPublished(flowType)
    }
    if (this.res.rows) {
      // 将获取到的数组内容放入新数组当中
      this.res.rows.forEach((item: Rows) => {
        this.data.pushData(item)
      })
      this.isLoading = false
      if (this.page >= Math.ceil(this.res.total / this.res.pageSize)) {
        this.isFinished = true
      } else {
        this.page++
      }
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
    if (this.res.rows.length >= 10) {
      this.page++
    }
    this.data.clearData()
    this.res.rows.forEach((item: Rows) => {
      this.data.pushData(item)
    })
    this.isRefreshing = false
    // 让已加载全部，消失
    this.isFinished = this.data.totalCount() >= this.res.total ? true : false
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
        if (this.data.totalCount() == 0) {
          Text('暂无内容')
            .width('100%')
            .height('100%')
            .fontColor(Color.White)
            .fontSize(18)
            .textAlign(TextAlign.Center)
        } else {
          WaterFlow({ footer: this.LoadMoreBuilder() }) {
            LazyForEach(this.data, (item: Rows) => {
              FlowItem() {
                NotesWaterFlowItem({ item: item, flowType: this.flowType })
                  .onClick(() => {
                    if (this.flowType == WaterFlowType.draft) {
                      router.pushUrl({
                        url: 'pages/EditNotes',
                        params: {
                          //TODO
                        } as NoteEditPropmtType
                      })

                    } else {
                      auth.CheckAuth({
                        url: 'pages/ShareNotes',
                        params: {
                          noteId: item.id,
                        } as INoteIdParams
                      })
                    }
                  })
              }
            })
          }
          .columnsTemplate('1fr 1fr')
          .cachedCount(2)
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
            }, 1000)
          })
        }
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