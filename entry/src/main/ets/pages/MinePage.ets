import { TextType, Type } from '../models'
import { router } from '@kit.ArkUI'


@Component
export struct MinePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  list: TextType[] = [
    { title: '名字', type: Type.name },
    { title: '电子邮箱', type: Type.name },
    { title: '生日', type: Type.name },
    { title: '性别', type: Type.name },
    { title: '个性签名', type: Type.name },
  ]

  build() {
    Column() {
      Row() {
        Text('我的')
          .fontSize(26)
          .fontWeight(900)
          .fontColor(Color.White)
        Blank()
        Row() {
          Image($rawfile('icon/PieChart.png'))
            .width(25)
          Text('学习分析')
            .fontSize(18)
            .fontWeight(900)
            .fontColor('rgb(255, 153, 150)')
        }
        .padding({
          left: 13,
          right: 13,
          bottom: 9,
          top: 9
        })
        .backgroundColor(Color.White)
        .borderRadius(20)
        .onClick(() => {
          // TODO
        })
      }
      .width('100%')

      Row({ space: 12 }) {
        Image('https://pic1.zhimg.com/v2-e5962333059d0dc857301394d30f396d_r.jpg?source=1940ef5c')
          .width(100)
          .borderRadius(50)
        Column() {
          Text('Hua')
            .width('100%')
            .fontSize(23)
            .fontWeight(900)
            .fontColor(Color.White)
          Text('woyebuzhidao@zhetamashisha.com')
            .width('100%')
            .fontWeight(700)
            .fontColor(Color.White)
        }
        .layoutWeight(1)
      }
      .width('100%')
      .margin({ top: 28, bottom: 40 })
      .padding({ right: 10 })
      .onClick(() => {
        router.pushUrl({
          url: 'pages/loginPage'
        })
      })

      Column() {
        Divider()
          .width('100%')
          .height(2)
          .backgroundColor('rgb(171, 171, 171)')
          .margin({ bottom: 15 })

        List({ space: 15 }) {
          ForEach(this.list, (item: TextType, index: number) => {
            ListItem() {
              Column({ space: 15 }) {
                Text() {
                  Span(item.title)
                    .fontColor(Color.White)
                    .fontWeight(600)
                  Span('*')
                    .fontColor('rgb(242, 111, 56)')
                }
                .width('100%')

                TextInput({ placeholder: item.title })
                  .width('100%')
                  .backgroundColor('rgb(115, 111, 138)')
                  .padding({ left: 24 })
                  .type(item.type == 'email' ? InputType.Email : InputType.Normal)

              }
            }
          })
        }
      }
      .width('100%')
      .padding({ left: 10, right: 10 })
    }
    .width('100%')
    .height('100%')
    .padding({ left: 30, right: 30, top: this.topHeight })
  }
}