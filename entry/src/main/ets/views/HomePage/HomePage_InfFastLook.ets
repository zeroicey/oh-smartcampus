
import router from '@ohos.router';
import { it } from '@ohos/hypium';
import axios, { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import { TopicAtHome , DataItem} from '../../models/tempModel/Interface/TopicAtHome';

interface  pointLine{
  province:string
  point:number
  specialized:string
}

@Component
export struct HomePage_InfFastLook{
  @Link circle:number[]
  @Link provinceCountLine:Array<string>//
  @State MockData:Array<pointLine> = [
    {
      province:'广东省',
      point:700,
      specialized:'physics'
    },
    {
      province:'重庆市',
      point:680,
      specialized:'math'
    },
    {
      province:'广西省',
      point:560,
      specialized:'math'
    },
  ]//mock
  @State TopicArr:Array<DataItem> = []

  aboutToAppear(): void {
    this.httpGetNTopic_axios(8)
  }

  build() {
    Column({ space: 20 }) { //zixunsukan
      Row() {
        Text('资讯速看')
          .fontColor(Color.White)
          .fontSize(20)
          .fontWeight(FontWeight.Bolder)
          .width('70%')
        Text('查看全部 >')
          .fontColor(Color.Gray)
          .fontSize(15)
          .width('30%')
          .textAlign(TextAlign.End)
          .onClick(()=>{
            router.pushUrl({
              url: 'pages/AdmissionsCounseling'
            })
          })

      }

      Scroll() {
        Row() {
          List() {
            ForEach(this.TopicArr, (item: DataItem, index: number) => {
              ListItem() {
                Row() {
                  Text(item.name)
                    .width(100)
                    .height(22)
                    .borderRadius(10)
                    .backgroundColor('#c7c4ff')
                    .fontColor(Color.White)
                    .fontWeight(FontWeight.Bolder)
                    .fontSize(18)
                    .onClick(()=>{
                      router.pushUrl({
                        url: 'pages/Note',
                        params: {
                          topicId: item.id
                        }
                      })
                    })
                  Blank().width(10)
                }
              }
            })
          }
          .listDirection(Axis.Horizontal)

        }
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)


      Column() {
        // TODO
        ForEach(this.MockData, (item: pointLine, index: number) => {
          Column({ space: 10 }) {
            Row() {
              Row({space:10}){
                Text(item.province)
                  .fontSize(32)
                  .fontWeight(FontWeight.Bolder)
                  .fontColor(Color.White)
                  .textAlign(TextAlign.Center)
                  .width('45%')
                Text('|')
                  .fontSize(55)
                  .fontWeight(FontWeight.Lighter)
                  .width('10%')
                  .textAlign(TextAlign.Center)
                Column({space:10}) {
                  Text(item.specialized)
                    .fontSize(25)
                    .fontWeight(FontWeight.Bolder)
                    .fontColor(Color.White)
                  Text(item.point.toString())
                    .fontSize(30)
                    .fontWeight(FontWeight.Bolder)
                    .fontColor('#37e2cc')
                }
                .width('45%')
              }
              .width('90%')
              .height('90%')
            }
            .backgroundColor('#8d87f2')
            .width('100%')
            .height(80)
            .borderRadius(20)
            .onClick(()=>{
              router.pushUrl({
                url: 'pages/AIChat'
              })
            })
          }
          Blank().height(10)
        })
      }
      //.backgroundColor(Color.Pink)
      .width('90%')
    }
    .width('100%')
  }

  httpGetNTopic_axios(size:number){
    axios({
      method: 'GET',
      url: 'http://127.0.0.1:8081/topic/findList',
      params: {
        size:size
      }
    })
      .then((response: AxiosResponse<TopicAtHome>)=>{
        this.TopicArr = response.data.data
      })
      .catch((error:BusinessError)=>{
        console.log(error.message)
      })
  }
}

