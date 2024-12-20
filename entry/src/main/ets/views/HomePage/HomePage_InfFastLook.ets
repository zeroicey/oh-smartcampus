
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
  @Link provinceCountLine:Array<string>
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
          if(this.TopicArr.length==0){Text('咨询好像也跑路了( ﾟдﾟ)').fontColor(Color.Gray)}
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
              Image($rawfile('other/Mock/me.png'))
                .height('100%')
                .width('40%')
                .borderRadius({
                  topLeft: 30,
                  bottomLeft: 30
                })
              Column() {
                Column({space:5}){
                  Text('xuexiao')
                    .fontSize(23)
                    .width('100%')
                    .textAlign(TextAlign.Start)
                  Text('shangfeng'+'--'+'leibie')
                    .fontSize(15)
                    .width('100%')
                    .fontColor(Color.Gray)
                    .textAlign(TextAlign.Start)
                  Blank().height(20)
                  Row({space:5}){
                    Text('  '+'label_1'+'  ')
                      .fontSize(10)
                      .height(15)
                      .width('auto')
                      .borderRadius(10)
                      .backgroundColor('#c7c4ff')
                      .textAlign(TextAlign.Center)
                      .align(Alignment.Start)
                    Text('  '+'label__2'+'  ')
                      .fontSize(10)
                      .height(15)
                      .width('auto')
                      .borderRadius(10)
                      .backgroundColor('#c7c4ff')
                      .textAlign(TextAlign.Center)
                      .align(Alignment.Start)
                    Text('  '+'label___3'+'  ')
                      .fontSize(10)
                      .height(15)
                      .width('auto')
                      .borderRadius(10)
                      .backgroundColor('#c7c4ff')
                      .textAlign(TextAlign.Center)
                      .align(Alignment.Start)
                  }
                  .width('100%')
                }
                .height('80%')
                .width('90%')
                .margin({top:15})
              }
              .height('100%')
              .width('60%')
            }
            .backgroundColor(Color.White)
            .width('100%')
            .height(120)
            .borderRadius(30)
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
      .width('100%')
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

