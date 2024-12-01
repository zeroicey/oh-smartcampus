import { router } from '@kit.ArkUI'
import { NotesWaterFlow } from '../commons/components'

@Component
export struct KnowledgeSphere {
  @State angleNumber: number = 180
  @State scaleX: number = 10
  @State scaleY: number = 10
  @State isShow: boolean = false
  @State translateY: string = '120%'
  @Prop
  // @Watch('changeIndex')
  activeIndex: number = 0

  // async changeIndex() {
  //   this.angleNumber = 180
  //   this.scaleX = 10
  //   this.scaleY = 10
  //   this.isShow = false
  //   this.translateY = '120%'
  //   await animateTo({
  //     duration: 1500
  //   }, () => {
  //     this.scaleX = 1
  //     this.scaleY = 1
  //     this.angleNumber = 0
  //   })
  //   setTimeout(() => {
  //     this.isShow = true
  //   }, 2000)
  //   animateTo({
  //     duration: 2200
  //   }, () => {
  //     this.translateY = '0'
  //   })
  // }

  aboutToAppear(): void {
    // 设置动画效果
    // this.changeIndex()
    setTimeout(() => {
      this.isShow = true
    }, 1500)
  }

  build() {
    Scroll() {
      Column() {
        Grid() {
          ForEach(Array.from({ length: 4 }), (item: null, index: number) => {
            GridItem() {
              Column() {
                Text(index.toString())
              }
              .width(130)
              .height(130)
              .borderRadius(30)
              .backgroundColor(index == 0 || index == 3 ? 'rgb(202, 193, 255)' : 'rgb(255, 193, 193)')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/IncircleContent'
                })
              })
            }
          })
        }
        .width(280)
        .height(280)
        .columnsTemplate('1fr 1fr')
        .rowsTemplate('1fr 1fr')
        .rowsGap(15)
        .columnsGap(15)
        .margin({ bottom: 40 })
        .rotate({ angle: this.angleNumber })
        .scale({ x: this.scaleX, y: this.scaleY })
        .onAppear(() => {
          animateTo({
            duration: 1500
          }, () => {
            this.scaleX = 1
            this.scaleY = 1
            this.angleNumber = 0
          })
        })

        if (this.isShow) {
          NotesWaterFlow()
            .translate({ y: this.translateY })
            .onAppear(() => {
              animateTo({
                duration: 1000
              }, () => {
                this.translateY = '0'
              })
            })
        }

      }
    }
    .width('100%')
    .height('100%')
    .padding({ left: 30, right: 30 })
  }
}