import { pushImagePreview } from 'ets/pages/ImgPreview'
import { lvMarkdownIn } from '@luvi/lv-markdown-in';
import router from '@ohos.router';
import {SpinKit,SpinType} from '@pura/spinkit'
@Component
export struct AINote_content {
  @Link isLoading:boolean
  @Link Text:string
  @Link TargetAI_topic:string
  @Link ImageUrl:string
  @Link finishFlag:boolean
  @Link imageItems:Array<string>
  //@Link imageItems:Array<string>
  // animation_Tail_appear(): void {
  //   animateTo({ duration: 500, curve: Curve.Smooth }, () => {
  //     this.isLoading = false
  //   })
  // }
  // aboutToAppear(): void {
  //     this.ImageUrl = extractUrlFromJsonString(this.ImageUrl)
  //     console.log('GOT_ImageUrl:'+this.ImageUrl)
  // }

    build() {
      Scroll() {
        Column() {
          Column() {
            if (!this.isLoading) {
              if(this.ImageUrl!=null||this.ImageUrl!=undefined){
                Image(this.ImageUrl)
                  .borderRadius(25)
                  .height('100%')
                  .width('100%')
                  .backgroundColor(Color.Pink)
                  .sharedTransition('PrewiewImg',{ duration:500 })
                  .onClick(() => {
                    pushImagePreview({images:this.imageItems,index:0})//
                  })
                  .onAppear(()=>{
                    this.finishFlag = true
                  })
              } else {
                Column() {
                  Blank().height('45%')
                  Text('不知道什么原因，\n生成图片的ai罢工了(ó﹏ò｡)')
                    .fontColor(Color.White)
                    .fontSize(20)
                    .width('100%')
                }
              }
              } else {
              Column() {
                Blank().height('45%')
                SpinKit({
                  spinType: SpinType.spinG,
                  spinColor: '#36e2cc',
                  spinSize: 100,
                })
              }
            }
          }
          .width('100%')
          .height(360)
          .backgroundColor(Color.Gray)
          .borderRadius(25)


          Blank().height(50)
          Text('AI笔记')
            .fontSize(30)
            .width('100%')
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
          lvMarkdownIn({ text: this.Text})
          Blank().height(25)
          Row() {
            Image($rawfile('icon/JumpToAI.png'))
              .height(30)
              .width(30)
            Text('点击跳转话题' + this.TargetAI_topic)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#98f4e9')
              .onClick(()=>{
                router.pushUrl({
                  url: 'pages/AI_chatPage',
                  params: {

                  }
                })
              })
          }
          .width('100%')
          Blank().height(200)
        }
        .width('90%')
      }
      .height('75%')
      .width('100%')
    }

}





