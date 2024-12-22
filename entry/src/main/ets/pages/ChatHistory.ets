
import { router } from '@kit.ArkUI'
import axios, { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import { Message } from '../models/tempModel/DataModel/Message'
import { IRouterParams } from '../models/tempModel/Interface/ParamChatHistory';
import { GotChatHistoryData } from '../models/tempModel/Interface/GetChatHistory';

@Entry
@Component
export struct ChatHistory {
  @State ParamObj:IRouterParams=router.getParams() as IRouterParams
  @State HistoryArray: Array<Message> = []//等待查询对话记录接口返回
  @State nameColorArr:string[] = ['#ff6666','#ffb266','#ff00ff','#66ff66','#66b2ff']
  private menu: string[] = ['删除'];

  aboutToAppear(): void {
    this.HistoryArray = MockData()
      // if(this.ParamObj.ShowMod == 1){
      //   this.axios_GotHistoryArray()
      // } else if(this.ParamObj.ShowMod == 2){
      //   this.axios_GotAllHistoryArray()
      // }
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
      Text('对话记录')
        .fontSize(40)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bolder)

      Image($rawfile('icon/point.png'))
        .height(10)

      Column() {
        List({ space: 15 }) {
          ForEach(this.HistoryArray, (item: Message, index: number) => {//debug
            ListItem() {
              Row() {
                Row({ space: 15 }) {
                  Blank().width(10)
                  Text(getFirstCharacter(item.role))//debug
                    .width(60)
                    .height(60)
                    .textAlign(TextAlign.Center)
                    .fontSize(35)
                    .fontColor(this.nameColorArr[index%5])//
                    .fontWeight(FontWeight.Bolder)
                    .borderRadius(30)
                    .backgroundColor(Color.White)
                  Column({ space: 15 }) {
                    Text(item.role)//debug//name
                      .fontSize(25)
                      .fontColor(Color.White)
                      .width('100%')
                      .textAlign(TextAlign.Start)
                      .margin({ left: 5 })
                    Text(item.content)//debug//type or time
                      .fontSize(20)
                      .fontColor(Color.White)
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
  //     //TODO  暂时搁置
  //     //this.HistoryArray = response.data
  //   }).catch((error: BusinessError) => {
  //     console.error('Request failed:', error);
  //   })
  // }

  axios_GotAllHistoryArray(page:number,size:number,uid:string,topicId:string,token:string): void {//获取全部历史
    axios({
      method: 'POST',
      url: "http://127.0.0.1:8081/topic"+"/ai/history_list",
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
    }).then((response: AxiosResponse<string>) => {

    }).catch((error: BusinessError)=>{
      console.log(error.name+' : '+error.message)
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
