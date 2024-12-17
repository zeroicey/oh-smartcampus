// 发布的所有笔记布局组件
import { promptAction, router } from '@kit.ArkUI';
import { IAllPublisherNotes, Rows, WaterFlowType } from '../../models';
import { httpReq } from '../utils';
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
  // 是否加载全部
  @State isFinished: boolean = false
  // 触底计时器id
  @State endTimeId: number = -1
  // 下拉刷新计时器
  @State refreshId: number = -1

  // 获取用户发布过的/草稿箱/收藏的笔记
  getUserPublished(flowType: WaterFlowType): Promise<IAllPublisherNotes> {
    return httpReq.request<IAllPublisherNotes>({
      url: flowType == WaterFlowType.myNotes ? '/circle/find_note' :
        flowType == WaterFlowType.draft ? '/circle/get_save_note' : '/findUserCollectNote',
      headers: {
        "uid": "1000001"
      },
      params: {
        page: this.page,
        size: 10
      }
    })
  }

  // 知识圈以及资讯上滑加载逻辑
  async Loading(flowType: WaterFlowType) {
    if (flowType == WaterFlowType.message || flowType == WaterFlowType.circle) {
      promptAction.showToast({ message: flowType.toString() })
      this.res = await this.getInCircleContent(flowType)
    } else {
      promptAction.showToast({ message: flowType.toString() })
      this.res = await this.getUserPublished(flowType)
    }
    // 将获取到的数组内容放入新数组当中
    this.list.push(...this.res.rows)
    this.isLoading = false
    if (this.list.length >= this.res.total) {
      this.isFinished = true
    } else {
      this.page++
    }
  }

  // 获取知识圈以及资讯的所有笔记
  getInCircleContent(flowType: WaterFlowType): Promise<IAllPublisherNotes> {
    return httpReq.request<IAllPublisherNotes>({
      url: '/circle/queryBatch',
      params: {
        // TODO
        circleId: flowType == WaterFlowType.circle ? this.circleId : '5',
        page: this.page,
        size: 8,
        topicId: flowType == WaterFlowType.circle ? this.topicId : '0'
      } as IInCircleContentRes
    })
  }

  aboutToAppear() {
    this.Loading(this.flowType)
  }

  build() {
    if (false) {
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