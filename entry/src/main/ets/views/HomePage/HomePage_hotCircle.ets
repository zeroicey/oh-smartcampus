import axios, { AxiosResponse } from "@ohos/axios"
import { BusinessError } from '@kit.BasicServicesKit';
import { circleItem, GotCircle } from "../../models/tempModel/Interface/GotCircle";
import { router } from "@kit.ArkUI";
import { logger } from "../../commons/utils";

@Component
export struct HomePage_hotCircle {
  @Link circle: number[]
  @Prop token: string = ''
  @State CircleArr: circleItem[] = []


  aboutToAppear(): void {
    this.httpGetCircle_axios(this.token)
  }

  build() {
    Stack() {
      Image($rawfile('icon/hotCircleBox.png'))
        .width('100%')

      Column({ space: 5 }) { //hot circle
        Text('热门圈子')
          .fontColor(Color.White)
          .fontSize(20)
          .fontWeight(FontWeight.Bolder)
          .width('100%')
        Blank().height(20)
        Row() {
          if (this.CircleArr.length == 0) {Text('热门圈子出问题了？是不是没网?( \'ㅅ\' )').fontColor(Color.White)}
          Blank().width(10)
          ForEach(this.CircleArr, (item: circleItem, index: number) => {
            Column() {
              Image(item.avatar)
                .height(50)
                .width(50)
                .borderRadius(50)
            }
            .onClick(()=>{
              router.pushUrl({
                url: 'pages/InCircleContent',
                params: {
                  circleId: item.circleId
                }
              })
            })
            Blank().width(30)
          })
        }
        .width('90%')
      }
      .borderRadius(25)
      .width('100%')
      .height('13%')
      .margin({bottom:50})
    }
  }

  httpGetCircle_axios(token:string){
    axios({
      method: 'GET',
      url: 'https://1fd33097.r5.cpolar.cn'+'/circle/findAll',//reeor here
      headers: {
        'Authorization': 'Bearer '+token
      }
    }).then((response:AxiosResponse<GotCircle>) => {
      for(let i=0;i<4;i++) {
        this.CircleArr[i] = response.data.data[i]
        logger.info('GOT_SUCCESS_CIRCLE：'+ JSON.stringify(this.CircleArr))
      }
    }).catch((error:BusinessError) => {
      console.log(error.message)
    })
  }
}