import { TopicAI } from 'ets/models/tempModel/DataModel/TopicAI';
import { router } from '@kit.ArkUI';
import axios, { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import { GotTopicAll, TopicAll } from '../models/tempModel/Interface/GetTopicAll';

@Entry
@Component
export struct TopicListPage {
  @State TopicArray: Array<TopicAll> = []
  @State selectedTopicAI: TopicAI = new TopicAI(1, 'Error', '好像是网络出错了，检查一下网络再试试看吧', '', '1', '1', '', 1)

  aboutToAppear(): void {
    this.GotTopicArray_axios()
  }

  build() {
    Column({ space: 15 }) {
      Text('AI对话')
        .fontSize(40)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bolder)
      Image($rawfile('icon/point.png'))
        .height(10)
      Column() {
        List({ space: 15 }) {
          ForEach(this.TopicArray, ( item: TopicAll ) => { //debug TopicAI -> number
            ListItem() {
              Row() {
                Row({ space: 15 }) {
                  Blank().width(10)
                  Image($rawfile('other/Mock/Enpty.png'))
                    .width(60)
                    .height(60)
                    .borderRadius(30)
                  Column({ space: 15 }) {
                    Text(item.name)
                      .fontSize(25)
                      .fontColor(Color.White)
                      .width('100%')
                      .textAlign(TextAlign.Start)
                      .margin({ left: 5 })
                    Text(truncateString(item.introduce, 12))
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
              .onClick( /*async*/ () => {
                // await this.getTopicDetail_axios(item.id)
                router.pushUrl({
                  url: 'pages/AIChat',
                  params: {
                    //item: this.selectedTopicAI//debug
                    item: item.name
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

  GotTopicArray_axios(): void {
    axios({
      method: 'GET',
      url: "",
      headers: {
        'Authorization': 'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINyahBVN2u5kz',
        'Content-Type': 'application/json'
      }
    }).then((response: AxiosResponse<GotTopicAll>) => {
        this.TopicArray = response.data.data
      })
      .catch((error: BusinessError) => {
        console.error('Request failed:', error);
        this.getTopicArray()
      })
  }
  // async getTopicDetail_axios(id: number){
  //   axios({
  //     method: 'GET',
  //     url: "",
  //     headers: {
  //       'Authorization': 'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINy'
  //     },
  //     params: {
  //       id: id
  //     }
  //   }).then((response: AxiosResponse)=>{
  //       this.selectedTopicAI = response.data
  //     }).catch((error: BusinessError)=>{
  //       console.error('Request failed:', error);
  //   })
  // }
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
  getTopicArray(): void {
      this.TopicArray = [
        { id:1, name:'Error', introduce:'好像是网络出错了，检查一下网络再试试看吧',isSelected:false },
        { id:2, name:'Error', introduce:'好像是网络出错了，检查一下网络再试试看吧',isSelected:false },
        { id:3, name:'Error', introduce:'好像是网络出错了，检查一下网络再试试看吧',isSelected:false }
      ]
    }
}

function truncateString(str: string, num: number): string {
  // 如果字符串长度小于等于指定的num，则返回原字符串
  if (str.length <= num) {
    return str;
  }
  // 截取字符串并加上省略号
  return str.slice(0, num) + '...';
}