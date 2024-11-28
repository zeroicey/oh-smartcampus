import { CustomNavBar } from '../../commons/components'
import { TextType, Type } from '../../models'

@Entry
@Component
export struct InformationEdite {
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
      .padding({ left: 40, right: 40 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgb(53, 50, 66)')
    .padding({ top: 10 })
  }
}