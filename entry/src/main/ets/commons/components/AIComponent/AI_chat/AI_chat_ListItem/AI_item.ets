//import { boxLength } from 'ets/components/AI_chat/AI_chat_ListItem/algorithm'
import { Message } from 'ets/models/tempModel/DataModel/Message'
//import { html2md } from '@luvi/html2md'
import { lvMarkdownIn, lvText, lvTitle } from '@luvi/lv-markdown-in'
import { router } from '@kit.ArkUI'

//lvText.setTextColor('#ffffff')
lvText.setTextSize(20)
//lvTitle.setLevelTitleColor('#ffa3e5e5')
lvTitle.setLevel1Title(25)
lvTitle.setLevel2Title(23)


//测试数据，生成一段简单的java代码
//分点说一下
@Component
export struct AI_Item {
  @Link isVisible_CheckBox: boolean
  @Link chatArray: Array<Message>
  @Link checkCount: number
  @Prop item: Message = new Message('', '')
  @Link checkAll: boolean
  @Prop AITopic: string = ''
  @State intervalId: number = -1
  @State inputStepChar: number = 1
  @State currentProgress: number = 0
  @State currentTxt: string = ""
  //@State TextArray: Array<miniChildItem> = []//分割的字符串数组
  @State textHead: string = ""
  @State textTail: string = ""
  @State colorTarget: number = 1
  @State extraMessageflag: number = 0

  // @State BackgroundColorArr: Array<string> = ['#FFCCCC','#FFE5CC','#FFFFCC','#E5FFCC','#CCFFCC','#CCFFE5','#CCFFFF','#CCE5FF','#CCCCFF','#E5CCFF','#FFCCE5']
  // @State FrontColorArr: Array<string> = ['#990000','#994c00','#999900','#4c9900','#009900','#00994c','#009999','#004c99','#000099','#4c0099','#990099']
  build() {
    Row() {
      Image($rawfile('other/Mock/Enpty.png'))
        .backgroundColor(Color.White)
        .objectFit(ImageFit.Fill)
        .width(30)
        .height(30)
        .borderRadius(100)
        .margin({ right: 8 })
        .onAppear(() => {
          this.inputTxt(50, '-' + this.item.content) //debug
          this.extraMessageflag++
        })

      Column() {
        lvMarkdownIn({ text: this.currentTxt }) //this.item.content
        //lvMarkdownIn({ text: this.item.content})//debug
        if (this.extraMessageflag == 1) {
          Column({ space: 5 }) {
            Divider()
              .width('100%')
              .borderWidth(0.3)
              .borderColor('#353341')
            Row() {
              Blank().width(10)
              // Image($rawfile('icon/pdf.png'))
              //   .width(15)
              //   .height(20)
              Text('查看出处')
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .onClick(() => {

                })
            }
            .width('100%')
            .height(25)
            .borderRadius(20)
            .backgroundColor('#9685ff')
            // Divider().width('100%')
            // Row({ space: 5}) {
            //   Text(' 5条上下文 ')
            //     .fontSize(10)
            //     .height(15)
            //     .width('auto')
            //     .backgroundColor('#dfdef7')
            //     .borderColor('#736f8a')
            //     .fontColor('#736f8a')
            //     .borderWidth(1)
            //     .borderRadius(20)
            //   Text(' 6条引用 ')
            //     .fontSize(10)
            //     .height(15)
            //     .width('auto')
            //     .backgroundColor('#e4f1ef')
            //     .borderColor('#45867e')
            //     .fontColor('#45867e')
            //     .borderWidth(1)
            //     .borderRadius(20)
            //   Text(' 12.32s ')
            //     .fontSize(10)
            //     .height(15)
            //     .width('auto')
            //     .backgroundColor('#e8f8fe')
            //     .borderColor('#a4dcf1')
            //     .fontColor('#367d98')
            //     .borderWidth(1)
            //     .borderRadius(20)
            //   Text(' 查看详情 ')
            //     .fontSize(10)
            //     .height(15)
            //     .width('auto')
            //     .backgroundColor(Color.Transparent)
            //     .borderColor('#9b98ae')
            //     .fontColor('#353341')
            //     .borderWidth(1)
            //     .borderRadius(20)
            // }
            .align(Alignment.Start)

            Row() {
              Row() {
                Blank().width(10)
                Image($rawfile('icon/GoAwnser.png'))
                  .height(20)
                  .width(15)
                Blank().width(5)
                Text('关于' + this.AITopic + '的题库，快去作答吧！')
                  .fontSize(13)
                  .fontColor(Color.White)
                  .align(Alignment.Center)
                  .fontWeight(FontWeight.Bold)
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/Answer',
                      params: {
                        topicContext: this.AITopic
                      }
                    })
                  })
              }
              .align(Alignment.Center)
              .width('100%')
            }
            .height(30)
            .backgroundColor('#736f8a')
            .width('100%')
            .borderRadius(20)
          }
        }
      }
      .width('80%')
      .height('auto')
      .backgroundColor('#eae8f6')
      .padding(10)
      .borderRadius(20)
      .animation({ duration: 400, curve: Curve.Smooth })


      if (this.isVisible_CheckBox === false) {
        Checkbox({ name: 'checkbox', group: 'checkboxGroup' })
          .select(this.checkAll)
          .shape(CheckBoxShape.CIRCLE)
          .onChange((value: boolean) => {
            let chat: Message = new Message(this.item.role, this.item.content)
            if (value == true) {
              //填入对象数组
              this.chatArray.push(chat)
              this.checkCount++
              //console.log('GOT_CHECKCOUNT++:'+this.checkCount)
              //console.log('GOT_Array_length:'+this.chatArray.length)
              //console.log('GOT_array0:'+this.chatArray[0].content)

            } else if (value == false) {
              //从数组中移除
              //console.log('GOT_run_here')

              let index: number = this.chatArray.indexOf(chat)
              for (let i = 0; i < this.chatArray.length; i++) {
                if (this.chatArray[i].content == chat.content) {
                  this.chatArray.splice(index, 1)
                  this.checkCount--
                  //console.log('GOT_CHECKCOUNT--:'+this.checkCount)
                  //console.log('GOT_Array_length:'+this.chatArray.length)
                  //console.log('GOT_array0:'+this.chatArray[0].content)
                }
              }
            }
          })

      }

    }
    .width("100%")
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.Start)
  }

  inputTxt(step: number, text: string): void {
    let targetTxtArray = splitAndExtract(text); //分割字符串
    //let targetTxtArray = text.split('')
    if (this.intervalId != -1) {
      clearInterval(this.intervalId)
      this.intervalId = -1
    }
    this.intervalId = setInterval(() => {
      for (let index = 0; index < this.inputStepChar; index++) {
        if (this.currentProgress >= targetTxtArray.length - 1) {
          clearInterval(this.intervalId)
          this.extraMessageflag = 1
          break
        } else {
          this.currentTxt += targetTxtArray[++ this.currentProgress]
        }
      }
    }, step)
  }
}

//分割字符串
function splitAndExtract(input: string): string[] {
  // 定义正则表达式抽取代码块，用于提升响应速度
  const regex = /```(.*?)```|./gs;
  const result: string[] = [];
  let match: RegExpExecArray | null;
  while ((match = regex.exec(input)) !== null) {
    if (match[1]) {
      // 匹配到的是三反引号包裹的字符串
      result.push(`\`\`\`${match[1]}\`\`\``);
    } else {
      // 匹配到的是单个字符
      result.push(match[0]);
    }
  }
  return result;
}



