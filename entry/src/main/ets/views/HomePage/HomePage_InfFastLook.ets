import router from '@ohos.router';
import axios, { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';
import { DataItem, TopicAtHome } from '../../models/tempModel/Interface/TopicAtHome';
import { auth } from '../../commons/utils';

interface pointLine {
  province: string
  point: number
  specialized: string
  img: string
}

@Component
export struct HomePage_InfFastLook {
  @Link circle: number[]
  @Link provinceCountLine: Array<string>
  @Prop token: string = ''
  @State MockData: Array<pointLine> = [
    {
      province: '中山大学',
      point: 334,
      specialized: '电子信息',
      img: 'https://bkimg.cdn.bcebos.com/pic/b3119313b07eca8032bb094b9a2397dda04483db?x-bce-process=image/format,f_auto/quality,Q_70/resize,m_lfit,limit_1,w_536'
    },
    {
      province: '暨南大学',
      point: 340,
      specialized: '软件工程',
      img: 'https://bkimg.cdn.bcebos.com/pic/8694a4c27d1ed21b0ef428022a3ecac451da80cb918e?x-bce-process=image/format,f_auto/watermark,image_d2F0ZXIvYmFpa2UyNzI,g_7,xp_5,yp_5,P_20/resize,m_lfit,limit_1,h_1080'
    },
    {
      province: '华南理工大学',
      point: 359,
      specialized: '计算机科学与技术',
      img: 'https://bkimg.cdn.bcebos.com/pic/377adab44aed2e738bd4a4526759b68b87d6277f4c0e?x-bce-process=image/format,f_auto/watermark,image_d2F0ZXIvYmFpa2UyNzI,g_7,xp_5,yp_5,P_20/resize,m_lfit,limit_1,h_1080'
    },
  ]
  @State TopicArr: Array<DataItem> = []

  @Builder
  myText(text: string) {
    Text('  ' + text + '  ')
      .fontSize(10)
      .height(15)
      .width('auto')
      .borderRadius(10)
      .backgroundColor('#c7c4ff')
      .textAlign(TextAlign.Center)
      .align(Alignment.Start)
  }

  aboutToAppear(): void {
    this.httpGetNTopic_axios(8, this.token)
  }

  build() {
    Column({ space: 20 }) {
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
          .onClick(() => {
            router.pushUrl({
              url: 'pages/AdmissionsCounseling'
            })
          })
      }

      Scroll() {
        Row() {
          if (this.TopicArr.length == 0) {
            Text('咨询好像也跑路了( ﾟдﾟ)*').fontColor(Color.Gray)
          }
          List() {
            ForEach(this.TopicArr, (item: DataItem) => {
              ListItem() {
                Row() {
                  Text('  ' + item.name + '  ')
                    .width('auto')
                    .constraintSize({ maxWidth: 150 })
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .height(22)
                    .borderRadius(10)
                    .backgroundColor('#c7c4ff')
                    .fontColor(Color.White)
                    .fontWeight(FontWeight.Bolder)
                    .fontSize(18)
                    .onClick(() => {
                      router.pushUrl({
                        url: 'pages/ShareNotes',
                        params: {
                          topicId: item.id
                        }
                      })
                    })
                  Blank().width(10)
                }
                .onClick(() => {
                  auth.CheckAuth(() => {
                    router.pushUrl({
                      url: 'pages/AdmissionsCounseling',
                      params: {
                        topicId: item.id
                      }
                    })
                  })
                })
              }
            })
          }
          .listDirection(Axis.Horizontal)

        }
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)


      Column() {
        ForEach(this.MockData, (item: pointLine) => {
          Column({ space: 10 }) {
            Row() {
              Blank().width(10)
              Image(item.img)
                .height('90%')
                .borderRadius({
                  topLeft: 30,
                  bottomLeft: 30
                })
              Column() {
                Column({ space: 5 }) {
                  Text(item.province)
                    .fontSize(23)
                    .width('100%')
                    .textAlign(TextAlign.Start)
                  Text('平均分' + ': ' + item.point.toString())
                    .fontSize(15)
                    .width('100%')
                    .fontColor(Color.Gray)
                    .textAlign(TextAlign.Start)
                  Blank().height(20)
                  Row({ space: 5 }) {
                    this.myText('985')
                    this.myText('211')
                    this.myText('B+')
                  }
                  .width('100%')
                }
                .height('80%')
                .width('90%')
                .margin({ top: 15 })
              }
              .height('100%')
              .width('60%')
            }
            .backgroundColor(Color.White)
            .width('100%')
            .height(120)
            .borderRadius(30)
            .onClick(() => {
              auth.CheckAuth(() => {
                router.pushUrl({
                  url: 'pages/AdmissionsCounseling'
                })
              })
            })
          }

          Blank().height(10)
        })
      }
      .width('100%')
    }
    .width('100%')
  }

  httpGetNTopic_axios(size: number, token: string) {
    axios({
      method: 'GET',
      url: 'https://1fd33097.r5.cpolar.cn' + '/topic/findList',
      headers: {
        'Authorization': 'Bearer ' + token
      },
      params: {
        size: size
      }
    }).then((response: AxiosResponse<TopicAtHome>) => {
      this.TopicArr = response.data.data
    })
      .catch((error: BusinessError) => {
        console.log(error.message)
      })
  }
}

