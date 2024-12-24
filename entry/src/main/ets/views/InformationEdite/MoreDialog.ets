interface Item {
  title: string
  icon: ResourceStr
  width: number
}

@CustomDialog
export struct MoreDialog {
  controller: CustomDialogController
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  iconList: Item[] = [
    { title: '联系客服', icon: $rawfile('icon/customerService.png'), width: 52 },
    { title: '用户协议', icon: $rawfile('icon/agreement.png'), width: 52 },
    { title: '意见反馈', icon: $rawfile('icon/feedback.png'), width: 52 },
    { title: '关于我们', icon: $rawfile('icon/aboutUs.png'), width: 52 },
  ]
  onclick=()=>{

  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {

      }
      .width('100%')
      .height('100%')
      .blur(20)
      .onClick(() => {
        this.controller.close()
      })

      Column({ space: 14 }) {
        Row({ space: 20 }) {
          ForEach(this.iconList, (item: Item) => {
            this.BtnBuilder({ icon: item.icon, title: item.title, width: item.width })
          })
        }

        this.BtnBuilder({ icon: $rawfile('icon/logOut.png'), title: '退出登录', width: 200 })
      }
      .backgroundColor('rgb(184, 171, 239)')
      .borderRadius(30)
      .padding({
        right: 30,
        left: 30,
        top: 26,
        bottom: 13
      })
      .width(330)
      .height(200)
    }
    .padding({ bottom: this.bottomHeight })
  }

  @Builder
  BtnBuilder(item: Item) {
    Column({ space: 5 }) {
      Row() {
        Image(item.icon)
          .width(33)
      }
      .width(item.width)
      .height(52)
      .borderRadius(30)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('rgba(208, 206, 241, 0.8)')

      Text(item.title)
        .fontSize(12)
        .fontColor(Color.White)
    }
  }
}