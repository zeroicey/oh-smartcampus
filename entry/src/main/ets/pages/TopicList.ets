import { auth, httpReq, logger } from '../commons/utils';
import { promptAction, router } from '@kit.ArkUI';
import { TopicAiList } from '../models';
import { BusinessError } from '@kit.BasicServicesKit';
interface ICircleIdParams {
  circleId: string
}

export interface IRouterParamsAIChat {
  topicId: number,
  circleId: string
}

@Entry
@Component
struct TopicList {
  @StorageProp('topHeight')
  topHeight: number = 0
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @State TopicArray: TopicAiList[] = []
  @State params : ICircleIdParams = { circleId: '' }
  // 获取话题AI数据
  async getTopicArray(params: ICircleIdParams) {
    try {
      this.TopicArray = await httpReq.request<TopicAiList[]>({
        url: '/topic/findAi',
        params
      })
    } catch (error) {
      //logger.info(err)
      console.log('GOT_请求失败:')
      promptAction.showToast({message:'请求失败'})
    }
  }

  aboutToAppear(): void {
    this.params  = router.getParams() as ICircleIdParams
    this.getTopicArray(this.params)
  }

  build() {
    Column({ space: 10 }) {
      Text('AI对话')
        .fontSize(36)
        .fontColor(Color.White)
        .fontWeight(700)
      Image($rawfile('icon/point.png'))
        .height(10)
      List({ space: 15 }) {
        ForEach(this.TopicArray, (item: TopicAiList, index: number) => {
          ListItem() {
            Row({ space: 14 }) {
              Row() {
                Text(index.toString())
                  .fontSize(36)
                  .fontWeight(700)
              }
              .justifyContent(FlexAlign.Center)
              .backgroundColor('rgb(223, 218, 255)')
              .width(55)
              .height(55)
              .borderRadius(30)

              Column({ space: 10 }) {
                Text(item.name)
                  .fontSize(18)
                  .fontColor(Color.White)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(item.name)
                  .fontSize(14)
                  .fontColor(Color.White)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .height(80)
            .backgroundColor('rgb(49, 48, 53)')
            .borderRadius(30)
            .padding({
              left: 20,
              right: 20,
              bottom: 13,
              top: 13
            })
            .onClick(() => {
              auth.CheckAuth({
                url: 'pages/AIChat',
                params: {
                  topicId: item.id,
                  circleId: this.params.circleId
                } as IRouterParamsAIChat
              })
            })
          }
        })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .height('100%')
    .width('100%')
    .backgroundColor('rgb(22, 21, 26)')
    .padding({
      bottom: this.bottomHeight,
      top: this.topHeight,
      left: 30,
      right: 30
    })
  }
}