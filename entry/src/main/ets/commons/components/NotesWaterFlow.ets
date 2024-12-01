// 发布的所有笔记布局组件

import { router } from '@kit.ArkUI';
import { IAllPublisherNotes } from '../../models';
import { httpReq } from '../utils';

// 请求参数类型
interface IIncircleContentRes {
  // TODO
  circleId: string;
  page?: string;
  size?: string;
  topicId: string
}

// 跳转页面参数类型
export interface ICircleIdParams {
  CircleId: string
  ContextId: string
}

@Component
export struct NotesWaterFlow {
  @State flowList: IAllPublisherNotes[] = []

  async getIncircleContent() {
    const res = await httpReq.request<IAllPublisherNotes[]>({
      url: '/circle/queryBatch',
      params: {
        // TODO
        circleId: '',
        page: '1',
        size: '15',
        topicId: ''
      } as IIncircleContentRes
    })
    return res
  }

  aboutToAppear(): void {
    const res = [
      {
        circleId: "c1",
        context: {
          pictures: ['https://pic3.zhimg.com/v2-b173b089c839b82b923260d8acf1688f_r.jpg?source=1940ef5c'],
          title: "探索宇宙的奥秘",
          word: "一起揭开宇宙的神秘面纱"
        },
        createTime: "2024-12-01T12:00:00Z",
        id: "note1",
        topic: {
          attractTitle: "宇宙探索",
          id: 1,
          name: "宇宙"
        }
      },
      {
        circleId: "c2",
        context: {
          pictures: ["https://img.51miz.com/Element/00/81/15/50/c77e727b_E811550_7f9027db.jpg"],
          title: "深海世界的奇观",
          word: "潜入深海，发现未知生物"
        },
        createTime: "2024-12-01T13:00:00Z",
        id: "note2",
        topic: {
          attractTitle: "深海探险",
          id: 2,
          name: "深海"
        }
      },
      {
        circleId: "c3",
        context: {
          pictures: ["https://img.keaitupian.cn/newupload/02/1675677268420959.jpg"],
          title: "古代文明的遗迹",
          word: "探索古代文明的遗迹，揭开历史的秘密"
        },
        createTime: "2024-12-01T14:00:00Z",
        id: "note3",
        topic: {
          attractTitle: "历史遗迹",
          id: 3,
          name: "历史"
        }
      },
      {
        circleId: "c4",
        context: {
          pictures: ["https://pic1.zhimg.com/v2-5bc1f1dfd6b29a08e521b531cae39fe7_r.jpg?source=1940ef5c"],
          title: "未来科技的展望",
          word: "一窥未来科技的发展趋势"
        },
        createTime: "2024-12-01T15:00:00Z",
        id: "note4",
        topic: {
          attractTitle: "科技前沿",
          id: 4,
          name: "科技"
        }
      },
      {
        circleId: "c5",
        context: {
          pictures: ["https://c-ssl.duitang.com/uploads/item/202008/14/20200814195015_ofoic.jpg"],
          title: "自然生态的保护",
          word: "保护自然，维护生态平衡"
        },
        createTime: "2024-12-01T16:00:00Z",
        id: "note5",
        topic: {
          attractTitle: "自然保护",
          id: 5,
          name: "自然"
        }
      },
      {
        circleId: "c6",
        context: {
          pictures: ["https://pic.nximg.cn/file/20230219/1344586_133139393109_2.jpg"],
          title: "艺术创作的灵感",
          word: "艺术创作，灵感的源泉"
        },
        createTime: "2024-12-01T17:00:00Z",
        id: "note6",
        topic: {
          attractTitle: "艺术创作",
          id: 6,
          name: "艺术"
        }
      },
      {
        circleId: "c7",
        context: {
          pictures: ["https://pic4.zhimg.com/v2-68c750d8993665feca72cc58438ca066_r.jpg"],
          title: "美食文化的传播",
          word: "探索世界各地的美食文化"
        },
        createTime: "2024-12-01T18:00:00Z",
        id: "note7",
        topic: {
          attractTitle: "美食之旅",
          id: 7,
          name: "美食"
        }
      },
      {
        circleId: "c8",
        context: {
          pictures: ["https://c-ssl.duitang.com/uploads/item/202005/23/20200523112253_fulke.png"],
          title: "健康生活的重要性",
          word: "健康生活，从我做起"
        },
        createTime: "2024-12-01T19:00:00Z",
        id: "note8",
        topic: {
          attractTitle: "健康生活",
          id: 8,
          name: "健康"
        }
      },
      {
        circleId: "c9",
        context: {
          pictures: ["https://c-ssl.duitang.com/uploads/item/202005/17/20200517212053_rwgtl.jpg"],
          title: "教育的力量",
          word: "教育改变未来"
        },
        createTime: "2024-12-01T20:00:00Z",
        id: "note9",
        topic: {
          attractTitle: "教育影响",
          id: 9,
          name: "教育"
        }
      },
      {
        circleId: "c10",
        context: {
          pictures: ["https://c-ssl.dtstatic.com/uploads/item/202003/04/20200304111526_xuqjq.thumb.400_0.jpg"],
          title: "旅行的意义",
          word: "旅行，发现世界的不同"
        },
        createTime: "2024-12-01T21:00:00Z",
        id: "note10",
        topic: {
          attractTitle: "旅行体验",
          id: 10,
          name: "旅行"
        }
      }
    ] as IAllPublisherNotes[]
    this.flowList = res
  }

  build() {
    WaterFlow() {
      ForEach(this.flowList, (item: IAllPublisherNotes, index: number) => {
        FlowItem() {
          Column() {
            Image(item.context.pictures[0])
              .width('100%')
              .borderRadius({ topLeft: 20, topRight: 20 })
            Column({ space: 6 }) {
              Text(item.context.title)
                .fontSize(14)
                .fontWeight(700)
                .maxLines(1)
                .width('100%')
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Row() {
                Text() {
                  ImageSpan('https://pic3.zhimg.com/v2-b173b089c839b82b923260d8acf1688f_r.jpg?source=1940ef5c')
                    .width(15)
                    .borderRadius(10)
                    .margin({ right: 3 })
                  Span('用户002')
                    .fontSize(10)
                    .fontWeight(700)
                    .fontColor('rgb(127, 127, 127)')
                }

                Blank()

                Text() {
                  ImageSpan($rawfile('icon/userLike.png'))
                    .width(15)
                    .margin({ right: 3 })
                  Span('202')
                    .fontSize(10)
                    .fontWeight(700)
                    .fontColor('rgb(127, 127, 127)')
                }
              }
              .width('100%')
            }
            .height(50)
            .width('100%')
            .backgroundColor('rgba(196, 196, 196, 0.5)')
            .borderRadius({ bottomLeft: 20, bottomRight: 20 })
            .padding(5)
          }
          .borderRadius(20)
          .width('100%')
          .backgroundColor('rgb(255, 255, 255)')
          .onClick(() => {
            // TODO
            router.pushUrl({
              url: 'pages/ShareNotes',
              params: {
                CircleId: item.circleId,
                ContextId: item.id
              } as ICircleIdParams
            })
          })
        }
      })
    }
    .columnsTemplate('1fr 1fr')
    .columnsGap(10)
    .rowsGap(10)
  }
}