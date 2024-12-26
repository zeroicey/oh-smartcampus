
import { router } from '@kit.ArkUI'
import axios, { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import { Message } from '../models/tempModel/DataModel/Message'
import { IRouterParams } from '../models/tempModel/Interface/ParamChatHistory';
import { GotChatHistoryData,GetChatHistory,historyListDataItem } from '../models/tempModel/Interface/GetChatHistory';
import { User } from '../models';
import { UserInfo } from '../commons/utils';
import { ChatHistoryPropmtType } from '../models/tempModel/Interface/PropmtInterfaces';

@Entry
@Component
export struct ChatHistory {
  @StorageProp(UserInfo) user: User = {} as User
  @State getPropmt:ChatHistoryPropmtType = {} as ChatHistoryPropmtType
  //@State ParamObj:IRouterParams=router.getParams() as IRouterParams
  @State HistoryArray: Array<historyListDataItem> = []//等待查询对话记录接口返回
  @State nameColorArr:string[] = ['#ff6666','#ffb266','#ff00ff','#66ff66','#66b2ff']
  private menu: string[] = ['删除'];

  async aboutToAppear(){
    this.getPropmt = router.getParams() as ChatHistoryPropmtType
    console.log('GOT_pramas:'+JSON.stringify(this.getPropmt))
    await this.axios_GotAllHistoryArray(1,10,this.user.uid,this.getPropmt.topicId.toString(),this.user.token)
  }

  @Builder
  MyContextMenu() {
    Column() {
      ForEach(this.menu, (item:string) => {
        Row() {
          Text(item)
            .fontSize(18)
            .textAlign(TextAlign.Center)
            .onClick(()=>{
              //TODO 长按删除事件，等待接口完善
              //delete
            })
        }
        .padding(10)
      })
    }
    .backgroundColor(Color.White)
    .borderRadius(15)
  }

  build() {
    Column({ space: 15 }) {
      Blank().height(30)
      Text('对话记录')
        .fontSize(40)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bolder)

      Image($rawfile('icon/point.png'))
        .height(10)

      Column() {
        List({ space: 15 }) {
          ForEach(this.HistoryArray, (item: historyListDataItem, index: number) => {//debug
            ListItem() {
              Row() {
                Row({ space: 15 }) {
                  Blank().width(10)
                  Text(getFirstCharacter(item.topic.name))//debug
                    .width(60)
                    .height(60)
                    .textAlign(TextAlign.Center)
                    .fontSize(35)
                    .fontColor(this.nameColorArr[index%5])//
                    .fontWeight(FontWeight.Bolder)
                    .borderRadius(30)
                    .backgroundColor(Color.White)
                  Column({ space: 5 }) {
                    Text(item.topic.name)
                      .fontSize(25)
                      .fontWeight(FontWeight.Bolder)
                      .fontColor(Color.White)
                      .width('100%')

                    Text(item.induction)
                      .fontSize(20)
                      .fontColor(Color.White)
                      .textAlign(TextAlign.Start)
                      .maxLines(2)
                      .margin({right:20})
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .width('90%')
                }
                .height(90)
                .width('80%')
              }
              .height(100)
              .width('100%')
              .backgroundColor('#736f8a')
              .borderRadius(25)
              .bindContextMenu(this.MyContextMenu, ResponseType.LongPress)
              .onClick(() => {
                //保留对话
                //切换页面（换掉）
                router.pushUrl({
                  url: 'pages/AIChat',
                  params: {
                    //item: item //对话历史记录列表
                  }
                })
              })
            }
          })
        }
      }
      .width('80%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#353242')
  }

  // axios_GotHistoryArray(): void {
  //   axios({
  //     method: 'GET',
  //     url: "http://127.0.0.1:4523/m1/4414785-4059781-27bdace1/findList",
  //     headers: {
  //       'Content-Type': 'application/json'
  //     }
  //   }).then((response: AxiosResponse<string>) => {
  //     //
  //     //this.HistoryArray = response.data
  //   }).catch((error: BusinessError) => {
  //     console.error('Request failed:', error);
  //   })
  // }

   async axios_GotAllHistoryArray(page:number,size:number,uid:string,topicId:string,token:string): Promise<void> {//获取全部历史
    axios({
      method: 'POST',
      url: "https://1fd33097.r5.cpolar.cn"+"/ai/history_list",
      data: {
        page:page,
        size:size,
        uid:uid,
        topicId:topicId
      } as GotChatHistoryData,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer '+token
      }
    }).then((response: AxiosResponse<GetChatHistory>) => {
      this.HistoryArray = response.data.data
      //console.log(this.HistoryArray)
    }).catch((error: BusinessError)=>{
      console.log('GOT._'+error.name+' : '+error.message)
    })
   }
}
  function MockData():Message[] {
    let a: Message[] = [
      new Message('aaa', 'sbsbsbbsbsbsb'),
      new Message('bbb', 'sbsbsbbsbsbsb'),
      new Message('ccc', 'sbsbsbbsbsbsb'),
      new Message('ddd', 'sbsbsbbsbsbsb'),
      new Message('eee', 'sbsbsbbsbsbsb'),
    ]
    return a
  }
function getFirstCharacter(str: string): string | null {
  if (typeof str !== 'string' || str.length === 0) {
    // 如果输入不是字符串或者字符串为空，则返回null
    return null;
  }
  // 返回字符串的第一个字符
  return str.charAt(0);
}
