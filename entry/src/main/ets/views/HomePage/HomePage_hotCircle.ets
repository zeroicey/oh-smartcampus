import axios, { AxiosResponse } from "@ohos/axios"
import { BusinessError } from '@kit.BasicServicesKit';
import { circleItem, GotCircle } from "../../models/tempModel/Interface/GotCircle";
import { router } from "@kit.ArkUI";
import { auth, logger } from "../../commons/utils";

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
      Image($rawfile('icon/hotCircleBox_L.png'))
        .width('100%')
        .margin({ top: 15})

      Column({ space: 5 }) { //hot circle
        Text('热门圈子')
          .fontColor('#985e1f')//font color
          .fontSize(20)
          .fontWeight(FontWeight.Bolder)
          .width('100%')
        Blank().height(20)
        Row() {
          if (this.CircleArr.length == 0) {Text('热门圈子出问题了？是不是没网?( \'ㅅ\' )').fontColor('#985e1f')}
          Blank().width(10)
          ForEach(this.CircleArr, (item: circleItem) => {
            Column() {
              Image(item.avatar)
                .height(50)
                .width(50)
                .borderRadius(50)
            }
            .onClick(()=>{
              auth.CheckAuth(()=>{
                router.pushUrl({
                  url: 'pages/InCircleContent',
                  params: {
                    circleId: item.circleId
                  }
                })
              })
            })
            Blank().width(35)
          })
        }
        .width('90%')
        .margin({ bottom: 20 })
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
      url: 'http://hellooracle.free.idcfengye.com'+'/circle/findAll',//reeor here
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