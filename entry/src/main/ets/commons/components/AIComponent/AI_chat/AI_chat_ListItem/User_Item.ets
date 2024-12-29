import { Message } from 'ets/models/tempModel/DataModel/Message'
@Component
export struct UserItem {
  @Link isVisible_CheckBox: boolean
  @Link chatArray: Array<Message>
  @Link checkCount: number
  @Prop item: Message = new Message('','')
  @Prop checkAll: boolean = false
  build() {
    Row() {
      Row() {
        if (this.isVisible_CheckBox === false) {
          Checkbox({ name: 'checkbox', group: 'checkboxGroup' })
            .align(Alignment.End)
            .select(this.checkAll)
            .shape(CheckBoxShape.CIRCLE)
            .onChange((value: boolean) => {
              let chat: Message = new Message(this.item.role, this.item.content)
              if (value == true) {
                this.chatArray.push(chat)
                this.checkCount++
              } else if(value == false){
                let index: number = this.chatArray.indexOf(chat)
                for (let i = 0; i < this.chatArray.length; i++) {
                  if (this.chatArray[i].content == chat.content) {
                    this.chatArray.splice(index, 1)
                    this.checkCount--
                  }
                }
              }
            })
        }
        Text(this.item.content)
          .width(boxLength(this.item.content))
          .height('auto')
          .fontSize(20)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#e1fbf8')
          .padding(15.5)
          .borderRadius(20)
        Blank().width(10)
      }
      .margin({ top: 12 })
      .width("100%")
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.End)
    }
  }
}

function boxLength(str: string):string {
  let visualLength = 0;
  for (const char of str) {
    if (char >= '\u4e00' && char <= '\u9fa5') {
      visualLength += 3;
    } else if (/[a-zA-Z0-9]/.test(char)) {
      visualLength += 2;
    } else {
      visualLength += 1;
    }
  }
  if(visualLength<=34) {
    return 'auto'
  } else {
    return '80%'
  }
}