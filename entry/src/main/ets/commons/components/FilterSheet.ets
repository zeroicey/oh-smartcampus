import { ITopic } from '../../models'

// 筛选半模态框封装组件
@Component
export struct FilterSheet {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  // 标题名称
  @Prop title: string = '专题题库'
  // 选中颜色
  @Prop activeIndex: number = -1
  @Prop list: ITopic[] | null
  onclick = (index: number) => {

  }

  build() {
    Column() {
      Text(this.title)
        .fontSize(24)
        .fontWeight(700)
        .fontColor(Color.White)
        .width('100%')
        .margin({ bottom: 19, top: 40 })
      Scroll() {
        Column() {
          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.list || Array.from({ length: 10 }), (item: ITopic | null, index: number) => {
              Text(item?.name || index.toString())
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .height(40)
                .constraintSize({ minWidth: 60, maxWidth: 150 })
                .borderRadius(20)
                .fontColor(this.activeIndex == index ? Color.White : Color.Black)
                .backgroundColor(this.activeIndex == index ? '#B8ABEF' : Color.White)
                .textAlign(TextAlign.Center)
                .margin({ right: 14, bottom: 15 })
                .padding({ left: 10, right: 10 })
                .onClick(() => {
                  // 自定义逻辑
                  this.onclick(index)
                })
            })
          }
          .margin({ bottom: 64 })

          Row() {
            Text(`点击进入${this.title}`)
              .fontSize(24)
              .fontWeight(700)
              .width('100%')
              .textAlign(TextAlign.Center)
              .fontColor(Color.White)
              .margin({ bottom: this.bottomHeight })
          }
        }
        .width('100%')
        .padding({ bottom: 40 })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgb(53, 50, 66)')
    .padding({
      left: 30,
      right: 30,
      bottom: this.bottomHeight
    })
  }
}