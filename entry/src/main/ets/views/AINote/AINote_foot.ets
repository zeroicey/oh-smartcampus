import router from '@ohos.router';
@Component
export struct AINote_foot {
  @Prop url:string = ''
  @Prop finishFlag:boolean = false
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
          if(this.finishFlag){
            router.pushUrl({
              url: 'pages/EditNote',
              params: {
                url: this.url
              }
            })
          } else {
            AlertDialog.show({
              title: 'AI正在生成笔记总结及思维导图', //弹窗标题
              message: '请稍等片刻', //弹窗内容
              autoCancel: true, //点击遮罩层，是否关闭弹窗
              backgroundColor: '#b1ccd4', //背景色
              primaryButton: {
                // 主要按钮，左侧
                value: '确认',
                fontColor: Color.Red,
                action: () => {
                  console.info('Button-clicking callback')
                }
              },
              cancel: () => {
                console.info('showDialog cancel');
              }
            })
          }
        })
    }
    .height('10%')
  }
}