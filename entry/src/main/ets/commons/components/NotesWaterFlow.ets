// 发布的所有笔记布局组件

import { router } from '@kit.ArkUI'

export interface ICircleIdParams {
  CircleId: string
  ContextId: string
}

@Component
export struct NotesWaterFlow {
  build() {
    WaterFlow() {
      ForEach(Array.from({ length: 10 }), (index: number) => {
        FlowItem() {
          Column() {
            Text()
              .height(168)
              .width('100%')
            Row() {

            }
            .height(50)
            .width('100%')
            .backgroundColor('rgba(196, 196, 196, 0.5)')
            .borderRadius({ bottomLeft: 20, bottomRight: 20 })
          }
          .borderRadius(20)
          .width('100%')
          .backgroundColor('rgb(255, 255, 255)')
          .onClick(() => {
            // TODO
            router.pushUrl({
              url: 'pages/ShareNotes',
              params: {
                CircleId: '',
                ContextId: ''
              }
            })
          })
        }

      })
    }
    .columnsTemplate('1fr 1fr')
    .columnsGap(10)
    .rowsGap(10)
  }
}