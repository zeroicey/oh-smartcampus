import { auth, httpReq, logger, UserInfo } from '../commons/utils';
import { promptAction, router } from '@kit.ArkUI';
import { TopicAiList, User } from '../models';
import { BusinessError } from '@kit.BasicServicesKit';
import axios, { AxiosResponse } from '@ohos/axios';
import { TopicItem, TopicListResponse } from '../models/tempModel/Interface/TopicList';
import { TopicAI } from '../models/tempModel/DataModel/TopicAI';

interface ICircleIdParams {
  circleId: string
}

export interface IRouterParamsAIChat {
  topic: string,
  circleId: string
}

@Entry
@Component
struct TopicList {
  @StorageProp('topHeight')
  topHeight: number = 0
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @StorageProp(UserInfo)
  user: User = {} as User
  @State TopicArray: TopicItem[] = []
  @State params : ICircleIdParams = { circleId: '' }
  @State Message:TopicAI = {} as TopicAI
  // 获取话题AI数据
  // async getTopicArray(params: ICircleIdParams) {
  //   try {
  //     this.TopicArray = await httpReq.request<TopicAiList[]>({
  //       url: '/topic/findTopic',
  //       params
  //     })
  //   } catch (error) {
  //     //logger.info(err)
  //     console.log('GOT_请求失败:')
  //     promptAction.showToast({message:'请求失败'})
  //   }
  // }

  aboutToAppear(): void {
    this.params  = router.getParams() as ICircleIdParams
    // this.getTopicArray(this.params)
    this.httpGotTopicArray_axios(this.params.circleId,this.user.token)
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
              //this.getTopicDetail_axios(item.id.toString(),this.user.token).then(() => {
                //console.log('GOT_Message:'+JSON.stringify(this.Message))
                auth.CheckAuth({
                  url: 'pages/AIChat',
                  params: {
                    topic: item.id.toString(),
                    circleId: this.params.circleId
                  } as IRouterParamsAIChat
                })
              })
            //})
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

  httpGotTopicArray_axios(circleId: string,token: string){
    axios({
      url: 'https://1fd33097.r5.cpolar.cn'+'/topic/findTopic',
      headers: {
        'Authorization': 'Bearer '+token
      },
      params: {
        circleId: circleId,
        size:10
      }
    }).then((response:AxiosResponse<TopicListResponse>) => {
      this.TopicArray =response.data.data
    }).catch((err: BusinessError) => {
      console.log('GOT_请求失败:'+err)
      promptAction.showToast({message:'请求失败'})
    })
  }
  // async getTopicDetail_axios(id: string,token: string): Promise<void> {
  //   axios({
  //     method: 'GET',
  //     url: `https://1fd33097.r5.cpolar.cn/`+`topic/findById/${id}`,
  //     headers: {
  //       'Authorization': 'Bearer '+token
  //     },
  //   }).then((response: AxiosResponse<TopicAI>) => {
  //     this.Message = response.data
  //     console.log('GOT_Request successGTDL:'+JSON.stringify(response.data))
  //     console.log('GOT_Request successFSMG:'+JSON.stringify(this.Message))
  //   }).catch((error: BusinessError) => {
  //     console.error('GOT_Request failedGTDL:', error);
  //   })
  // }
}