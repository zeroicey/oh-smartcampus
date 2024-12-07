import { CustomNavBar, InputComponent } from '../../commons/components'
import { ITextType } from '../../models'

@Entry
@Component
export struct InformationEdite {
  @StorageProp('topHeight')
  topHeight: number = 0
  // list: TextType[] = [
  //   { title: '名字', type: ITextType.name },
  //   { title: '电子邮箱', type: ITextType.name },
  //   { title: '生日', type: ITextType.name },
  //   { title: '性别', type: ITextType.name },
  //   { title: '个性签名', type: ITextType.name },
  // ]
  @State name: string = ''
  @State birth: string = ''
  @State email: string = ''
  @State gender: string = ''
  @State sign: string = ''

  build() {
    Column() {
      CustomNavBar({ title: '信息编辑' })

      Image('https://pic1.zhimg.com/v2-e5962333059d0dc857301394d30f396d_r.jpg?source=1940ef5c')
        .width(125)
        .borderRadius(50)
        .margin({ bottom: 20, top: 24 })

      Column() {
        Divider()
          .width('100%')
          .height(2)
          .backgroundColor('rgb(171, 171, 171)')
          .margin({ bottom: 15 })

        List({ space: 15 }) {
          ListItem() {
            InputComponent({ title: '名字', value: this.name })
          }

          ListItem() {
            InputComponent({ title: '电子邮箱', value: this.email, type: ITextType.email })
          }

          ListItem() {
            InputComponent({ title: '生日', value: this.birth })
          }

          ListItem() {
            InputComponent({ title: '性别', value: this.gender })
          }

          ListItem() {
            InputComponent({ title: '个性签名', value: this.sign })
          }
        }
      }
      .width('100%')
      .padding({ left: 40, right: 40 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgb(53, 50, 66)')
    .padding({ top: 10 })
  }
}