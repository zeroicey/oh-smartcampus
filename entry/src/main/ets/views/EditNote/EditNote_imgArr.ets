
import { LengthMetrics } from '@kit.ArkUI';
import { pushImagePreview } from 'ets/pages/ImgPreview'
import { SendNoteData } from '../../models/tempModel/Interface/SendNote';


@Component
export struct EditNote_imgArr {
  //@Link imageItems:Array<string>
  @Link EditData:SendNoteData
  @Prop url:string = ''
  @Prop LocalImg:string = ''
  //@Link AIPictureUrl:string

  build() {
    Column({space:10}) {
      Row(){
        List(){
          ListItem(){
            Column(){
              Image(this.url)
                .width(100)
                .height(100)
                .borderRadius(20)
            }
            .width(100)
            .height(100)
            .backgroundColor('#c4c4c4')
            .margin({ top: 10, bottom: 10, left: 10, right: 10 })
            .borderRadius(20)
          }
          ForEach(this.EditData.pictures, (item:string,index:number) => {
            ListItem() {
              Image(item)
                .width(100)
                .height(100)
                .margin({ top: 10, bottom: 10, left: 10, right: 10 })
                .borderRadius(20)
                .sharedTransition(JSON.stringify(item))//
                .onClick(() => {
                  pushImagePreview({images:this.EditData.pictures,index:index})//
                })

            }
          })
          ListItem(){
            Column(){
              Image($rawfile('icon/addImg.png'))
                .width(50)
                .height(50)
                .margin({top:25})
                .onClick(()=>{
                  this.EditData.pictures.push(this.LocalImg)
                  //TODO 打开图片选择器添加图片(后续开发加入)
                })

            }
            .width(100)
            .height(100)
            .backgroundColor('#c4c4c4')
            .margin({ top: 10, bottom: 10, left: 10, right: 10 })
            .borderRadius(20)
          }
        }
        .listDirection(Axis.Horizontal)
        .width('100%')
      }
    }
    .height(120)
  }
}