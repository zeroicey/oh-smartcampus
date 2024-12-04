import router from '@ohos.router';
@Component
export struct AINote_foot {
  build() {
    Row(){
      Button('进入编辑')
        .width('70%')
        .height(50)
        .margin({top:10})
        .backgroundColor('#9893b1')
        .fontSize(25)
        .fontWeight(FontWeight.Bolder)
        .onClick(()=>{
          router.pushUrl({
            url: 'pages/EditNote'
          })
        })
    }
    .height('10%')
  }
}