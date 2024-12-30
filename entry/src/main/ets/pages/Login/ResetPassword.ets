import { promptAction, router } from '@kit.ArkUI'
import { CustomNavBar, HcLoadingDialog, InputComponent } from '../../commons/components'
import { httpReq } from '../../commons/utils'
import { ITextType } from '../../models'

interface INewPasswordParam {
  email: string
  newPassword: string
}

interface IRouterParam {
  email: string
}

@Entry
@Component
struct ResetPassword {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @StorageProp('topHeight')
  topHeight: number = 0
  @State password: string = ''
  @State repeatPassword: string = ''
  regPassword: RegExp = new RegExp('^\\S*(?=\\S{6,})(?=\\S*\\d)(?=\\S*[A-Z])(?=\\S*[a-z])(?=\\S*[!@#$%^&*? ])\\S*$')
  dialog: CustomDialogController = new CustomDialogController({
    builder: HcLoadingDialog({ message: '请稍后...' }),
    customStyle: true
  })
  email: string = ''

  async submit() {
    if (this.password == '' || !this.regPassword.test(this.password)) {
      promptAction.showToast({
        message: this.password == '' ? '密码不能为空' : '密码不符合要求，请确保至少包含6个字符，且包括数字、大写字母、小写字母和特殊字符'
      })
      return
    }
    if (this.repeatPassword == '' || this.password != this.repeatPassword) {
      promptAction.showToast({ message: this.repeatPassword == '' ? '密码不能为空' : '与输入密码不一致' })
      return
    }
    this.dialog.open()
    await httpReq.request<null, INewPasswordParam>({
      url: '/user/forgotPassword',
      method: 'post',
      data: {
        email: this.email,
        newPassword: this.repeatPassword
      }
    })
    this.dialog.close()
    promptAction.showToast({ message: '修改成功！' })
    router.back(2)
  }

  aboutToAppear(): void {
    const params = router.getParams() as IRouterParam
    this.email = params.email
  }

  build() {
    Column() {
      CustomNavBar({ leftIcon: $rawfile('icon/encryptedBack.png'), showRightIcon: false, title: '更换密码' })
        .margin({ bottom: 50 })

      Column({ space: 30 }) {
        Text('请输入您的新密码')
          .fontColor(Color.White)
          .fontSize(24)
          .fontWeight(700)
          .width('100%')
        InputComponent({ title: '请输入新密码', type: ITextType.password, value: this.password })
        InputComponent({ title: '请确认新密码', type: ITextType.password, value: this.repeatPassword })
      }
      .padding({
        left: 30,
        right: 30
      })

      Blank()

      Row() {
        Button('完成')
          .width('80%')
          .backgroundColor('rgb(141, 135, 242)')
          .fontSize(20)
          .fontWeight(900)
          .onClick(() => {
            this.submit()
          })
      }
      .width('100%')
      .padding({ left: 15, right: 15 })
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#16151A')
    .padding({
      bottom: this.bottomHeight,
    })
  }
}