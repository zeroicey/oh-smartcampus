
import router from '@ohos.router';
@Component
export struct EditNote_edit{
  @Link Topic: string
  @Link Text: string
  @Link TargetAI_topic: string
  @Link DATE:string
  @Link UserName:string
  //@Link AIPictureUrl:string
  build() {
    Column() {
      Divider()
        .width('90%')
        .borderColor(Color.White)
        .borderWidth(0.3)
        .opacity(0.5)

      TextInput({ placeholder: '输入你的标题>', text: $$this.Topic })//topic
        .width('100%')
        .height('auto')
        .fontSize(25)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bolder)
        .backgroundColor(Color.Transparent)
        .placeholderColor(Color.White)

      TextArea({ placeholder: '输入你的文本笔记>', text: $$this.Text })//text
        .width('100%')
        .height('auto')
        .fontSize(25)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bolder)
        .backgroundColor(Color.Transparent)
        .placeholderColor(Color.White)
      Row() {
        Image($rawfile('icon/JumpToAI.png'))
          .height(30)
          .width(30)

        Text('点击跳转话题' + this.TargetAI_topic)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#98f4e9')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/AI_chatPage',
              params: {
                //TODO
                //topic: this.TargetAI_topic//待修改
              }
            })
          })
      }
      .width('100%')


      Text(this.DATE)//date
        .fontColor(Color.White)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.End)

      Text(this.UserName)//name
        .fontColor(Color.White)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.End)
    }
  }
}