import { router } from '@kit.ArkUI'
import { auth } from '../../commons/utils'

@Component
export struct HomePage_head {
  @Link isShowSideBar: boolean
  @Link sideBarWidth: number
  @Prop userName: string = ''
  @Prop userText: string = ''
  @Link opcityAll: number
  @Prop IconStr: string

  sidebar_Animation(): void {
    let aimNumBar = 0
    let aimNumOpa = 1
    if (this.sideBarWidth == 0) {
      aimNumBar = 250
      aimNumOpa = 0.6
    } else {
      aimNumOpa = 1
    }
    animateTo({ duration: 200, curve: Curve.Smooth }, () => {
      this.sideBarWidth = aimNumBar
      this.opcityAll = aimNumOpa
    })
  }

  build() {
    Row({ space: 5 }) { //头栏
      Image(this.IconStr)//头像
        .height(50)
        .width(50)
        .borderRadius(15)
        .borderWidth(1)
        .borderColor('#985e1f')//notice border
        .onClick(() => {
          auth.CheckAuth(() => {
            this.isShowSideBar = !this.isShowSideBar
            this.sidebar_Animation()
          })
        })
      Column() {
        Text('Hello,' + this.userName)
          .fontSize(25)
          .fontWeight(FontWeight.Bolder)
          .fontColor('#c77a28')//font color
          .textAlign(TextAlign.Start)
          .width('100%')
        Text(this.userText)
          .fontSize(15)
          .fontWeight(FontWeight.Bolder)
          .fontColor('#c77a28')
          .textAlign(TextAlign.Start)
          .width('100%')
      }
      .width('64%')

      Column() {
        Image($rawfile('icon/Scan.png'))
          .height(40)
          .width(40)
          .margin({ top: 10 })
          .onClick(() => {
            auth.CheckAuth(() => {
              router.pushUrl({
                url: 'pages/Scan'
              })
            })
          })
      }
      .height(50)
      .width(50)
      .borderRadius(15)

    }
    .height(50)
    .width('100%')
  }
}