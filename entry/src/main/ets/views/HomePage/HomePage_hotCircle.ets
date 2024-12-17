import axios, { AxiosResponse } from "@ohos/axios"
import { BusinessError } from '@kit.BasicServicesKit';
import { circleItem, GotCircle } from "../../models/tempModel/Interface/GotCircle";
import { router } from "@kit.ArkUI";

@Component
export struct HomePage_hotCircle {
  @Link circle: number[]
  @State CircleArr: circleItem[] = []
  build() {
    Column({ space: 5 }) { //hot circle
      Text('热门圈子')
        .fontColor(Color.White)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width('90%')

      Row() {
        Blank().width(10)
        ForEach(this.CircleArr, (item: circleItem, index: number) => {
          Column() {
            Image(item.avatar)
              .height(50)
              .width(50)
              .borderRadius(50)
              .onClick(()=>{
                router.pushUrl({
                  url: 'pages/InCircleContent',
                  params: {
                    circledId: item.circledId
                  }
                })
              })
          }

          Blank().width(30)
        })
      }
      .width('90%')
    }
    .borderRadius(25)
    .width('100%')
    .height('13%')
    .backgroundColor('#ffc1c1')
  }

  httpGetCircle_axios(){
    axios({
      method: 'GET',
      url: 'http://localhost:3/findAll',//reeor here
    }).then((response:AxiosResponse<GotCircle>) => {
      for(let i=0;i<4;i++) {
        this.CircleArr[i] = response.data.data[i]
      }
    }).catch((error:BusinessError) => {
      console.log(error.message)
    })
  }
}