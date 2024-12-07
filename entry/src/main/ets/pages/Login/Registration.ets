import { CustomNavBar, HcLoadingDialog, InputComponent } from '../../commons/components';
import { ITextType } from '../../models';
import { promptAction, router } from '@kit.ArkUI';
import { IVerifyParams } from './Encrypted';
import { httpReq } from '../../commons/utils';

interface IRegisterParams {
  code: string;
  email: string;
  name: string;
  password: string;
}

@Entry
@Component
struct Registration {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @State name: string = 'Chaos'
  @State password: string = 'P@ssW0rd2024!'
  @State repeatPassword: string = 'P@ssW0rd2024!'
  @State email: string = '2372558841@qq.com'
  @State emailNum: string = '123456'
  // 是否校验成功
  @State isAgree: boolean = false
  regName: RegExp = new RegExp('^[a-zA-Z0-9_]{4,20}$')
  regPassword: RegExp = new RegExp('^\\S*(?=\\S{6,})(?=\\S*\\d)(?=\\S*[A-Z])(?=\\S*[a-z])(?=\\S*[!@#$%^&*? ])\\S*$')
  regEmail: RegExp =
    /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  regEmailNum: RegExp = /^\d{6}$/
  dialog: CustomDialogController = new CustomDialogController({
    builder: HcLoadingDialog({ message: '注册中请稍后...' }),
    customStyle: true
  })

  // 校验验证码
  async verifyEmailNum() {
    try {
      await httpReq.request<null, IVerifyParams>({
        url: '/check/email',
        method: 'post',
        data: {
          email: this.email,
          code: this.emailNum
        }
      })
      this.isAgree = true
    } catch (err) {
      // 校验失败
      // TODO
    }
  }

  async Register() {
    if (this.name == '' || !this.regName.test(this.name)) {
      promptAction.showToast({
        message: this.name == '' ? '用户名不能为空' : '用户名无效。请使用4-20个字符，可以包含字母、数字和下划线。'
      })
      return
    }
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
    if (this.email == '' || !this.regEmail.test(this.email)) {
      promptAction.showToast({ message: this.email == '' ? '邮箱不能为空' : '邮箱格式不对' })
      return
    }
    if (this.emailNum == '' || !this.regEmailNum.test(this.emailNum)) {
      promptAction.showToast({ message: this.emailNum == '' ? '验证码不正确' : '验证码格式不对' })
      return
    }
    this.dialog.open()
    // TODO
    setTimeout(() => {
      this.dialog.close()
      router.back()
      promptAction.showToast({ message: '注册成功！' })
    }, 1000)
    // 先校验验证码
    // this.verifyEmailNum()
    // 校验成功后执行注册逻辑
    if (this.isAgree) {
      await httpReq.request<null, IRegisterParams>({
        url: '/user/register',
        method: 'post',
        data: {
          code: this.emailNum,
          email: this.email,
          name: this.name,
          password: this.password
        }
      })
      this.isAgree = false
      this.dialog.close()
      promptAction.showToast({ message: '注册成功！' })
      router.back()
    }
  }

  build() {
    Column() {
      CustomNavBar({ leftIcon: $rawfile('icon/encryptedBack.png'), showRightIcon: false, title: '注册账户' })
        .margin({ bottom: 50 })

      Column({ space: 30 }) {
        Text('请输入您的信息')
          .fontColor(Color.White)
          .fontSize(24)
          .fontWeight(700)
          .width('100%')
        InputComponent({ title: '请输入用户名', value: this.name, type: ITextType.name })
        InputComponent({ title: '请输入密码', value: this.password, type: ITextType.password })
        InputComponent({ title: '再次输入密码', value: this.repeatPassword, type: ITextType.password })
        InputComponent({ title: '绑定您的邮箱', value: this.email, type: ITextType.email })
        InputComponent({ title: '邮箱验证码', value: this.emailNum, type: ITextType.name })
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
            this.Register()
          })
      }
      .width('100%')
      .padding({ left: 15, right: 15 })
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgb(53, 50, 66)')
    .padding({
      bottom: this.bottomHeight,
    })
  }
}