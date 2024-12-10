import { TopicAI } from 'ets/models/tempModel/DataModel/TopicAI'
import { router } from '@kit.ArkUI'
import axios, { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
@Entry
@Component
export struct TopicListPage {

  @State TopicArray: Array<TopicAI> = [

  ]
  //@State TopicArray: Array<number> = [1,2,3,4,5,6,7,8,9,10]

  aboutToAppear(): void {
    //this.axios_GotTopicArray()
    this.getTopicArray()
  }

  build() {
    Column({space:15}){
      Text('AI对话')
        .fontSize(40)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bolder)
        //.backgroundColor(Color.Pink)
      Image($rawfile('icon/point.png'))
        .height(10)
        // .margin({bottom:40})
      Column(){
        List({space:15}){
          ForEach(this.TopicArray, (item: TopicAI, index: number)=>{//debug TopicAI -> number
            ListItem(){
              Row() {
                Row({space:15}){
                  Blank().width(10)
                  Image($rawfile('other/Mock/Enpty.png'))
                    .width(60)
                    .height(60)
                    .borderRadius(30)
                  Column({space:15}){
                    Text(item.title)//debug
                      .fontSize(25)
                      .fontColor(Color.White)
                      .width('100%')
                      .textAlign(TextAlign.Start)
                      .margin({left:5})
                      //.fontWeight(FontWeight.Bolder)
                    Text(truncateString(item.introduce,12))//debug
                      .fontSize(20)
                      .fontColor(Color.White)
                      //.fontWeight(FontWeight.Bolder)
                  }
                  .width('90%')
                }
                .height(90)
                .width('80%')
                //.backgroundColor(Color.Pink)
              }
              .height(100)
              .width('100%')
              .backgroundColor('#736f8a')
              .borderRadius(25)
              .onClick(()=>{
                router.pushUrl({
                  url: 'pages/AIChat',
                  params: {
                    item: item //debug
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

  axios_GotTopicArray(): void {
    axios({
      method: 'GET',
      url: "http://127.0.0.1:4523/m1/4414785-4059781-27bdace1/findList",
      headers: {
        'Authorization': 'Bearer fastgpt-08KBc24GnU0hWrsb0I6Mpcs918z9fqkIW0Wp1ULuzoGCBKBTrIINyahBVN2u5kz',
        'Content-Type': 'application/json'
      }
    })
      .then((response: AxiosResponse<TopicAI[]>) => {
         this.TopicArray = response.data
      })
      .catch((error: BusinessError) => {
        console.error('Request failed:', error);
      })
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
  getTopicArray():void{
    this.TopicArray = [
      new TopicAI(1,
        'java',
        'Java是一种广泛使用的面向对象的编程语言，以其“编写一次，到处运行”的特性著称，拥有强大的开发工具和库。',
        '','1','1','',1),
      new TopicAI(2,
        'python',
        'Python是一种高级编程语言，以其简洁清晰的语法和强大的功能库著称，广泛应用于Web开发、数据分析、人工智能等领域。',
        '','1','1','',1),
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