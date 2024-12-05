import { IPublisher } from '../../models'

@Component
export struct SNInput {
  @Link isSend: boolean
  @State value: string = ''
  @StorageProp('bottomHeight')
  bottomHeight: number = 0

  build() {
    Row({ space: 12 }) {
      TextInput({ placeholder: '请输入', text: $$this.value })
        .placeholderColor(Color.Gray)
        .layoutWeight(1)
      Image($rawfile('icon/send.png'))
        .width(30)
        .onClick(() => {
          this.isSend = false
        })
    }
    .width('100%')
    .padding({
      left: 20,
      right: 20,
      top: 20,
      bottom: this.bottomHeight
    })
    .borderRadius(40)
    .backgroundColor('rgb(59, 59, 59)')
  }
}