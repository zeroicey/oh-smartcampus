import { promptAction, router } from '@kit.ArkUI';
import { CustomNavBar, HcLoadingDialog, InputComponent } from '../../commons/components';
import { httpReq } from '../../commons/utils';
import { ITextType } from '../../models';

export interface IVerifyParams {
  code: string;
  email: string;
}

@Entry
@Component
struct Encrypted {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @StorageProp('topHeight')
  topHeight: number = 0
  @State email: string = ''
  @State emailNum: string = ''
  regEmail: RegExp =
    /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  regEmailNum: RegExp = /^\d{6}$/
  dialog: CustomDialogController = new CustomDialogController({
    builder: HcLoadingDialog({ message: '请稍后...' }),
    customStyle: true
  })

  // 校验验证码
  async verify() {
    if (this.email == '' || !this.regEmail.test(this.email)) {
      promptAction.showToast({ message: this.email == '' ? '邮箱不能为空' : '邮箱格式不对' })
      return
    }
    if (this.emailNum == '' || !this.regEmailNum.test(this.emailNum)) {
      promptAction.showToast({ message: this.emailNum == '' ? '验证码不正确' : '验证码格式不对' })
      return
    }
    try {
      this.dialog.open()
      await httpReq.request<null, IVerifyParams>({
        url: '/check/email',
        method: 'post',
        data: {
          email: this.email,
          code: this.emailNum
        }
      })
      promptAction.showToast({ message: '验证成功' })
      this.dialog.close()
      router.pushUrl({
        url: 'pages/Login/ResetPassword',
        params: {
          email: this.email
        }
      })
    } catch (err) {
      // 验证码错误
      promptAction.showToast({ message: err.errorMsg })
    } finally {
      // 无论是否校验成功都关闭加载弹窗
      this.dialog.close()
    }

  }

  build() {
    Column() {
      CustomNavBar({ title: '忘记密码', leftIcon: $rawfile('icon/encryptedBack.png'), showRightIcon: false })
        .margin({ bottom: 50 })

      Column({ space: 30 }) {
        Text('请进行验证')
          .fontColor(Color.White)
          .fontSize(20)
          .fontWeight(700)
          .width('100%')
        InputComponent({ title: '请输入您的邮箱', type: ITextType.email, value: this.email })
        InputComponent({ title: '邮箱验证码', value: this.emailNum })
      }
      .padding({
        left: 30,
        right: 30,
      })

      Blank()

      Row() {
        Button('验证')
          .width('80%')
          .backgroundColor('rgb(141, 135, 242)')
          .fontSize(20)
          .fontWeight(900)
          .onClick(() => {
            this.verify()
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
      bottom: this.bottomHeight
    })
  }
}