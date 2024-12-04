

@Component
export struct HomePage_sidebar{
  @Link isShowSideBar: boolean
  @Link sideBarWidth: number
  @Link userName: string
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
    Row() {
      Column({space:20}) {
        Blank().height('10%')
        Image($rawfile('other/Mock/me.png'))
          .width(100)
          .height(100)
          .borderRadius(100)

        Text(this.userName)
          .fontColor(Color.White)
          .fontSize(30)
          .fontWeight(FontWeight.Bolder)

        Row(){}
        .width('70%')
        .height(40)
        .backgroundColor('#c4c4c4')
        .borderRadius(20)
        Row(){}
        .width('70%')
        .height(40)
        .backgroundColor('#c4c4c4')
        .borderRadius(20)
        Row(){}
        .width('70%')
        .height(40)
        .backgroundColor('#c4c4c4')
        .borderRadius(20)
        Row(){}
        .width('70%')
        .height(40)
        .backgroundColor('#c4c4c4')
        .borderRadius(20)
        Row(){}
        .width('70%')
        .height(40)
        .backgroundColor('#c4c4c4')
        .borderRadius(20)
        Blank().height('5%')
        Row(){}
        .width('70%')
        .height(50)
        .backgroundColor('#c4c4c4')
        .borderRadius(30)
        .margin({right:30})
      }
      .height('100%')
      .width(this.sideBarWidth)
      .backgroundImage($rawfile('other/card/SideBar.png'))
      .backgroundImageSize(ImageSize.Contain)
      .backgroundImagePosition(Alignment.Start)
      //.backgroundColor(Color.Blue)
      .margin({ left: 0 })
      Column(){}
      .width('30%')
      .height('100%')
      .onClick(()=>{
        if(this.isShowSideBar){

          this.sidebar_Animation()
          this.isShowSideBar = false
        }
      })
    }
    .height('100%')
    .width('100%')
    //.margin({right:250})
    .visibility(this.isShowSideBar?Visibility.Visible:Visibility.Hidden)
  }
}