// 发布的所有笔记布局组件
import { promptAction, router } from '@kit.ArkUI';
import { IAllPublisherNotes, Rows, WaterFlowType } from '../../models';
import { MyDataSource } from '../../models/LazyForeachResource/MyDataSource';
import { httpReq, logger } from '../utils';
import { HcSkeleton } from './HcSkeleton';
import { NotesWaterFlowItem } from './NotesWaterFlowItem';

// 请求参数类型
interface IInCircleContentRes {
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
  data: MyDataSource<Rows> = new MyDataSource()
  @State list: Rows[] = [
    {
      creatorAvatar: 'https://tse2-mm.cn.bing.net/th/id/OIP-C.yp-D-KHI3e2nN4eMBJcEVAAAAA?rs=1&pid=ImgDetMain',
      creatorId: '1',
      creatorName: '黑夜',
      id: 'note1',
      picture: 'https://pic3.zhimg.com/v2-b173b089c839b82b923260d8acf1688f_r.jpg?source=1940ef5c',
      title: '探索宇宙的奥秘',
      likeTotal: 10
    },
    {
      creatorAvatar: 'https://tse3-mm.cn.bing.net/th/id/OIP-C.sdNN1iFf5WEp1Xnml5qOBgAAAA?rs=1&pid=ImgDetMain',
      creatorId: '2',
      creatorName: '晨曦',
      id: 'note2',
      picture: 'https://tse3-mm.cn.bing.net/th/id/OIP-C.sdNN1iFf5WEp1Xnml5qOBgAAAA?rs=1&pid=ImgDetMain',
      title: '深海世界的奇观',
      likeTotal: 10
    },
    {
      creatorAvatar: 'https://tse3-mm.cn.bing.net/th/id/OIP-C.Erum9yreLBLbYTOMWWzGIwAAAA?rs=1&pid=ImgDetMain',
      creatorId: '3',
      creatorName: '夕阳',
      id: 'note3',
      picture: 'https://img.keaitupian.cn/newupload/02/1675677268420959.jpg',
      title: '古代文明的遗迹',
      likeTotal: 10
    },
    {
      creatorAvatar: 'https://tse2-mm.cn.bing.net/th/id/OIP-C.0nTEIoAl_Bc1AeIEozQXEQAAAA?rs=1&pid=ImgDetMain',
      creatorId: '4',
      creatorName: '星空',
      id: 'note4',
      picture: 'https://pic1.zhimg.com/v2-5bc1f1dfd6b29a08e521b531cae39fe7_r.jpg?source=1940ef5c',
      title: '未来科技的展望一窥未来科技的发展趋势',
      likeTotal: 10
    },
    {
      creatorAvatar: 'https://tse1-mm.cn.bing.net/th/id/OIP-C.qkn-u2DXXEJ6L2KxAWHZ9wAAAA?rs=1&pid=ImgDetMain',
      creatorId: '5',
      creatorName: '迷雾',
      id: 'note5',
      picture: 'https://c-ssl.duitang.com/uploads/item/202008/14/20200814195015_ofoic.jpg',
      title: '自然生态的保护',
      likeTotal: 10
    },
    {
      creatorAvatar: 'https://ts1.cn.mm.bing.net/th/id/R-C.fc02279502a5f170713f466d727c7e34?rik=z83T0O334o0kpw&riu=http%3a%2f%2fwww.gx8899.com%2fuploads%2fallimg%2f2018011510%2fcbn05xbnii1.jpg&ehk=RE8FctNNDvxeQ%2fGZrUbIIdLx5HBi5a4QtdkIy2CB9rY%3d&risl=&pid=ImgRaw&r=0&sres=1&sresct=1',
      creatorId: '6',
      creatorName: '清风',
      id: 'note6',
      picture: 'https://pic.nximg.cn/file/20230219/1344586_133139393109_2.jpg',
      title: '艺术创作的灵感',
      likeTotal: 10
    },
    {
      creatorAvatar: 'https://tse1-mm.cn.bing.net/th/id/OIP-C.ZtrvDWpDrJNiyRQj6DwPvwAAAA?rs=1&pid=ImgDetMain',
      creatorId: '7',
      creatorName: '细雨',
      id: 'note7',
      picture: 'https://pic4.zhimg.com/v2-68c750d8993665feca72cc58438ca066_r.jpg',
      title: '美食文化的传播',
      likeTotal: 10
    },
    {
      creatorAvatar: 'https://tse4-mm.cn.bing.net/th/id/OIP-C.hsnwZAr2R2xUr97ScoSjrgAAAA?rs=1&pid=ImgDetMain',
      creatorId: '8',
      creatorName: '烈日',
      id: 'note8',
      picture: 'https://c-ssl.duitang.com/uploads/item/202005/23/20200523112253_fulke.png',
      title: '健康生活的重要性',
      likeTotal: 10
    },
    {
      creatorAvatar: 'https://tse3-mm.cn.bing.net/th/id/OIP-C.Uoz1-5uTFTJ7s8fymTUhYgAAAA?rs=1&pid=ImgDetMain',
      creatorId: '9',
      creatorName: '暮色',
      id: 'note9',
      picture: 'https://c-ssl.duitang.com/uploads/item/202005/17/20200517212053_rwgtl.jpg',
      title: '教育的力量',
      likeTotal: 10
    },
    {
      creatorAvatar: 'https://tse3-mm.cn.bing.net/th/id/OIP-C.Uoz1-5uTFTJ7s8fymTUhYgAAAA?rs=1&pid=ImgDetMain',
      creatorId: '9',
      creatorName: '暮色',
      id: 'note10',
      picture: 'https://c-ssl.dtstatic.com/uploads/item/202003/04/20200304111526_xuqjq.thumb.400_0.jpg',
      title: '旅行的意义',
      likeTotal: 10
    }
  ]
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
      // TODO header请求头更改
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
      logger.info(JSON.stringify(this.res))
    } else {
      promptAction.showToast({ message: flowType.toString() })
      logger.info(this.page.toString())
      this.res = await this.getUserPublished(flowType)
      logger.info(this.res.pageSize.toString())
    }
    // 将获取到的数组内容放入新数组当中
    this.list.push(...this.res.rows)
    this.list.forEach((item: Rows) => {
      this.data.pushData(item)
    })
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
    this.list.forEach((item: Rows) => {
      this.data.pushData(item)
    })
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
          LazyForEach(this.data, (item: Rows, index: number) => {
            FlowItem() {
              NotesWaterFlowItem({ item: item })
                .onClick(() => {
                  if (this.flowType == WaterFlowType.draft) {
                    // TODO 跳转到笔记编辑页

                  } else {
                    router.pushUrl({
                      url: 'pages/ShareNotes',
                      params: {
                        noteId: item.id,
                      } as ICircleIdParams
                    })
                  }
                })
            }
            .onDisAppear(() => {
              logger.info('销毁了：', index.toString())
            })
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