import { InputComponent } from '../../commons/components'
import { ITextType } from '../../models'
import { promptAction, router } from '@kit.ArkUI'

interface ILoginParams {
  email?: null | string;
  password: string;

  /**
   * 手机号
   */
  phoneNumber?: null | string;

  /**
   * 登录类型：      1：密码登录     2：验证码登录
   */
  type: number;
}


@Entry
@Component
struct Login {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @StorageProp('topHeight')
  topHeight: number = 0
  @State email: string = '2759688992@qq.com'
  @State password: string = 'Aa123456'
  @State isAgree: boolean = false
  @State isLoading: boolean = false

  async login() {
    if (this.isLoading) {
      // 如果处于登录状态不可重复点击
      return
    }
    if (this.email == '') {
      promptAction.showToast({ message: '您未输入账号' })
      return
    }
    if (this.password == '') {
      promptAction.showToast({ message: '您未输入密码' })
      return
    }
    if (this.isAgree == false) {
      promptAction.showToast({ message: '请先勾选协议' })
      return
    }
    // TODO
    this.isLoading = true
    setTimeout(() => {
      this.isLoading = false
      promptAction.showToast({ message: '登陆成功' })
      router.back()
    }, 1000)
    // try {
    //   this.isLoading = true
    //   const user = await httpReq.request<User, ILoginParams>({
    //     url: '/user/login',
    //     method: 'post',
    //     data: {
    //       email: this.email,
    //       password: this.password,
    //       type: 1
    //     }
    //   })
    //   this.isLoading = false
    //   // 存储用户数据
    //   auth.setUser(user)
    //   promptAction.showToast({ message: '登陆成功' })
    //   router.back()
    // } catch (err) {
    //   promptAction.showToast({ message: err.errorMsg })
    // } finally {
    //   this.isLoading = false
    // }
  }

  build() {
    Column() {
      Text('')
        .width(180)
        .height(180)
        .backgroundColor('rgb(196, 196, 196)')
        .margin({ bottom: 12, top: 40 })
      Text('登录您的账户')
        .fontSize(23)
        .fontWeight(900)
        .fontColor(Color.White)
        .margin({ bottom: 24 })
      Column({ space: 20 }) {
        InputComponent({ title: '输入账户', placeholder: '请输入电子邮箱', value: this.email })
        InputComponent({
          title: '输入密码',
          type: ITextType.password,
          placeholder: '请输入密码',
          value: this.password
        })
      }
      .width('100%')
      .margin({ bottom: 20 })

      Row({ space: 5 }) {
        //TODO
        Checkbox()
          .width(16)
          .shape(CheckBoxShape.ROUNDED_SQUARE)
          .unselectedColor('rgb(55, 226, 204)')
          .selectedColor('rgb(55, 226, 204)')
          .mark({
            strokeColor: Color.Black,
            strokeWidth: 3
          })
          .select(this.isAgree)
          .onChange((val) => {
            this.isAgree = val
          })
        Text('记住密码')
          .fontWeight(600)
          .fontColor(Color.White)
          .fontSize(14)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .margin({ bottom: 12 })

      Text('忘记密码？')
        .fontWeight(600)
        .fontColor('rgb(55, 226, 204)')
        .width('100%')
        .textAlign(TextAlign.Center)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/Login/Encrypted'
          })
        })
      Blank()
      Button() {
        Row() {
          if (this.isLoading) {
            LoadingProgress()
              .color($r('app.color.white'))
              .width(24)
              .height(24)
              .margin({ right: 10 })
          }
          Text('登录')
            .fontWeight(900)
            .fontSize(20)
            .fontColor(Color.White)
        }
      }
      .backgroundColor('rgb(141, 135, 242)')
      .width('90%')
      .height(50)
      .margin({ bottom: 5 })
      .onClick(() => {
        this.login()
      })
      .margin({ bottom: 25 })

      Text() {
        Span('没有账户？')
          .fontWeight(700)
          .fontColor(Color.White)
        Span('注册')
          .fontColor('rgb(55, 226, 204)')
          .fontWeight(700)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Login/Registration'
            })
          })
      }
      .textAlign(TextAlign.Center)

    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgb(53, 50, 66)')
    .padding({
      left: 45,
      right: 45,
      bottom: this.bottomHeight,
      top: this.topHeight
    })
  }
}