

@Component
export struct HomePage_head {
  @Link isShowSideBar: boolean
  @Link sideBarWidth: number
  @Link userName: string
  @Link userText: string
  @Link opcityAll: number
  sidebar_Animation(): void {
    let aimNumBar=0
    let aimNumOpa=1
    if(this.sideBarWidth==0){
      aimNumBar=250
      aimNumOpa=0.6
    } else {
      aimNumOpa=1
    }
    animateTo({ duration: 200, curve: Curve.Smooth }, () => {
      this.sideBarWidth = aimNumBar
      this.opcityAll = aimNumOpa
    })
  }

  build() {
    Row({ space: 5 }) { //头栏
      Image($rawfile('other/Mock/me.png'))//头像
        .height(50)
        .width(50)
        .borderRadius(15)
        .onClick(() => {
          this.isShowSideBar = !this.isShowSideBar
          this.sidebar_Animation()
        })
      Column() {
        Text('Hello,' + this.userName)
          .fontSize(25)
          .fontWeight(FontWeight.Bolder)
          .fontColor(Color.White)
          .textAlign(TextAlign.Start)
          .width('100%')
        Text(this.userText)
          .fontSize(15)
          .fontWeight(FontWeight.Bolder)
          .fontColor(Color.White)
          .textAlign(TextAlign.Start)
          .width('100%')
      }
      .width('64%')

      Column() {
        Image($rawfile('icon/Scan.png'))
          .height(30)
          .width(30)
          .margin({ top: 10 })
      }
      .height(50)
      .width(50)
      .borderRadius(15)
      .backgroundColor(Color.White)

    }
    .height(50)
    .width('100%')
  }
}