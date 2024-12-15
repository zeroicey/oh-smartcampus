
import { LengthMetrics } from '@kit.ArkUI';
import { pushImagePreview } from 'ets/pages/ImgPreview'
@Component
export struct EditNote_imgArr {
  @Link imageItems:Array<string>
  //@Link AIPictureUrl:string

  build() {
    Column({space:10}) {
      Row(){
        List(){
          // if(this.AIPictureUrl != ''){
          //   ListItem() {
          //     Image(this.AIPictureUrl)
          //       .width(100)
          //       .height(100)
          //       .margin({ top: 10, bottom: 10, left: 10, right: 10 })
          //       .borderRadius(20)
          //       .onClick(() => {
          //         //
          //       })
          //   }
          // }
          ForEach(this.imageItems, (item:string,index:number) => {
            ListItem() {
              Image(item)
                .width(100)
                .height(100)
                .margin({ top: 10, bottom: 10, left: 10, right: 10 })
                .borderRadius(20)
                .sharedTransition(JSON.stringify(item))//
                .onClick(() => {
                  pushImagePreview({images:this.imageItems,index:index})//
                })

            }
          })
          ListItem(){
            Column(){
              Image($rawfile('icon/addImg.png'))
                .width(50)
                .height(50)
                .margin({top:25})
            }
            .width(100)
            .height(100)
            .backgroundColor('#c4c4c4')
            .margin({ top: 10, bottom: 10, left: 10, right: 10 })
            .borderRadius(20)
            .onClick(() => {
              //TODO
            })
          }
        }
        .listDirection(Axis.Horizontal)
        .width('100%')
      }
    }
    .height(120)
  }
}