import { router } from '@kit.ArkUI'
import { UserInfoDialog } from '../../views/ShareNotes/UserInfoDialog'

@Preview
@Component
export struct CustomNavBar {
  @StorageProp('topHeight')
  topHeight: number = 0
  @Prop title: string = '忘记密码'
  @BuilderParam
  default: () => void = this.defaultBuilder
  @BuilderParam
  rightIcon: () => void = this.rightBuilder
  UserInfoDialog = new CustomDialogController({
    builder: UserInfoDialog(),
    customStyle: true,
    maskColor: '#4dc4c4c4',
    // backgroundBlurStyle: BlurStyle.BACKGROUND_THICK
  })

  @Builder
  defaultBuilder() {
    Text(this.title)
      .fontSize(30)
      .fontWeight(900)
      .fontColor(Color.White)
  }

  @Builder
  rightBuilder() {
  }

  build() {
    Row() {
      Image($rawfile('icon/backIcon.png'))
        .width(30)
        .margin({ right: 20 })
        .onClick(() => {
          router.back()
        })
      this.default()
      Blank()
      this.rightIcon()
    }
    .width('100%')
    .padding({ left: 30, right: 30, top: this.topHeight })
  }
}