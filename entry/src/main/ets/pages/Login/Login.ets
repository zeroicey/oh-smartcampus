import { InputComponent } from '../../commons/components';
import { ITextType, User } from '../../models';
import { promptAction, router } from '@kit.ArkUI';
import { auth, httpReq, logger } from '../../commons/utils';
import { emitter } from '@kit.BasicServicesKit';
import { LOGIN_EVENT } from '../../commons/constants';

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
  @State email: string = ''
  @State password: string = ''
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
    this.isLoading = true
    try {
      this.isLoading = true
      const user = await httpReq.request<User, ILoginParams>({
        url: '/user/login',
        method: 'post',
        data: {
          email: this.email,
          password: this.password,
          type: 1
        }
      })
      this.isLoading = false
      // 存储用户数据
      auth.setUser(user)
      // 通知个人中心触发下拉刷新
      emitter.emit(LOGIN_EVENT)
      promptAction.showToast({ message: '登陆成功' })
      // 根据当前业务逻辑选择性跳转到某个页面
      const params = router.getParams() as Record<string, string> //是为了将跳转前的参数传递下去
      // 实在看不懂就来这里看传过来了啥参数
      logger.info(JSON.stringify(params))
      if (params?.return_url) {
        // 回到用户想去的页面,同时replace是为了防止用户点击返回又重新回到登录页面
        router.replaceUrl({
          url: params.return_url,
          params
        })
      } else {
        router.back()
      }
    } catch (err) {
      promptAction.showToast({ message: err.errorMsg })
    } finally {
      this.isLoading = false
    }
  }

  build() {
    Column() {
      Image($rawfile('icon/Mock_icon.png'))
        .width(180)
        .aspectRatio(1)
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

      Row() {
        Text('注册账户')
          .fontColor('rgb(55, 226, 204)')
          .fontWeight(600)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Login/Registration'
            })
          })

        Text('忘记密码？')
          .fontWeight(600)
          .fontColor('rgb(55, 226, 204)')
          .textAlign(TextAlign.End)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Login/Encrypted'
            })
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

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
      .backgroundColor('#985e1f')
      .width('90%')
      .height(50)
      .margin({ bottom: 5 })
      .onClick(() => {
        this.login()
      })
      .margin({ bottom: 25 })

      // 隐私协议
      Row({ space: 5 }) {
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
        Text('已阅读并同意隐私协议和隐私政策')
          .fontWeight(600)
          .fontColor('#985e1f')
          .fontSize(14)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fffcf3')
    .padding({
      left: 45,
      right: 45,
      bottom: this.bottomHeight,
      top: this.topHeight
    })
  }
}