
import { router } from '@kit.ArkUI'
import axios, { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import { Message } from '../models/tempModel/DataModel/Message';





@Entry
@Component
export struct ChatHistory {
  @State HistoryArray: Array<Message> = []
  private menu: string[] = ['删除'];
  aboutToAppear(): void {

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
              //TODO
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
          ForEach(this.HistoryArray, (item: string, index: number) => {
            ListItem() {
              Row() {
                Row({ space: 15 }) {
                  Blank().width(10)
                  Image($rawfile('other/Mock/Enpty.png'))
                    .width(60)
                    .height(60)
                    .borderRadius(30)
                  Column({ space: 15 }) {
                    Text(item)//debug//name
                      .fontSize(25)
                      .fontColor(Color.White)
                      .width('100%')
                      .textAlign(TextAlign.Start)
                      .margin({ left: 5 })

                    Text(item)//debug//type or time
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
                router.pushUrl({
                  url: 'pages/AIChat',
                  params: {
                    item: item //对话历史记录列表
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

  axios_GotHistoryArray(): void {
    axios({
      method: 'GET',
      url: "http://127.0.0.1:4523/m1/4414785-4059781-27bdace1/findList",
      headers: {
        'Authorization': 'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINyahBVN2u5kz',
        'Content-Type': 'application/json'
      }
    })
      .then((response: AxiosResponse<string>) => {

      })
      .catch((error: BusinessError) => {
        console.error('Request failed:', error);
      })
  }
}
  // MockData(): void {
  //   let mockObj:TopicAI = {
  //     id:1,
  //     title:'AI对话',
  //     introduce: 'aaa',
  //     avatar: '',
  //     circleId: '1',
  //     aiKey: '1',
  //     chapter:'1',
  //     weight:1
  //   } as TopicAI
  //   this.TopicArray.push(mockObj)
  // }
