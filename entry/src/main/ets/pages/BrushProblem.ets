import { CustomNavBar, FilterSheet, HcLoadingDialog } from '../commons/components'
import { promptAction, router } from '@kit.ArkUI'
import { httpReq } from '../commons/utils'
import { IChapter } from '../models'

@Entry
@Component
struct BrushProblem {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  // 是否显示半模态框
  @State isShow: boolean = false
  @State chapterList: IChapter[] = []
  // 加载弹窗
  dialog: CustomDialogController = new CustomDialogController({
    builder: HcLoadingDialog(),
    customStyle: true
  })

  // 获取章节数据
  async getChapterData() {
    try {
      this.dialog.open()
      this.chapterList = await httpReq.request<IChapter[]>({
        url: '/question/getChapterBySubjectId',
        params: {
          // TODO
          uid: '10008',
          id: '1'
        }
      })
      promptAction.showToast({ message: '请求成功' })
      this.dialog.close()
    } catch (err) {
      promptAction.showToast({ message: '请求失败' })
      this.dialog.close()
    }
  }

  aboutToAppear(): void {
    this.getChapterData()
  }

  build() {
    Column({ space: 25 }) {
      // 导航栏
      CustomNavBar({
        title: '考点选择', rightIcon: $rawfile('icon/more.png'),
        onclick: () => {
          this.isShow = true
        }
      })
      Scroll() {
        Column({ space: 20 }) {
          // 试卷以及试题按钮
          Row({ space: 30 }) {
            Button('考前冲刺试题')
              .TsetBtnStyle()
            Button('专题试卷')
              .TsetBtnStyle()
          }
          .width('100%')

          // 章节列表
          List({ space: 10 }) {
            ForEach(this.chapterList, (item: IChapter) => {
              ListItem() {
                this.ChapterBuilder(item)
              }
            })
          }
          .bindSheet($$this.isShow, this.FilterSheetBuilder)
        }
        .width('100%')
      }
      .layoutWeight(1)
      .width('100%')
      .align(Alignment.Top)
      .padding({ bottom: this.bottomHeight, left: 30, right: 30 })

    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgb(53, 50, 66)')

  }

  // 每个章节的数据
  @Builder
  ChapterBuilder(item: IChapter) {
    Column({ space: 6 }) {
      Text(item.name)
        .fontSize(24)
        .fontColor(Color.White)
        .fontWeight(700)

      Row({ space: 8 }) {
        Text(`共${item.questionNum}题`)
          .fontSize(11)
          .fontColor(Color.White)
        Divider()
          .vertical(true)
          .width(2)
          .height(11)
          .borderRadius(5)
          .backgroundColor('rgb(55, 238, 183)')
        Text(`已用1min`)
          .fontSize(11)
          .fontColor(Color.White)
        Divider()
          .vertical(true)
          .width(2)
          .height(11)
          .borderRadius(5)
          .backgroundColor('rgb(55, 238, 183)')
        Text(`练习时间 10-17 23:31`)
          .fontSize(11)
          .fontColor(Color.White)
        Blank()
        Text('未完成')
          .fontWeight(900)
          .fontSize(11)
          .fontColor(Color.White)
          .width(54)
          .height(25)
          .borderRadius(7)
          .backgroundColor('rgb(160, 163, 175)')
          .textAlign(TextAlign.Center)
      }
      .width('100%')
    }
    .width('100%')
    .padding({
      right: 12,
      top: 16,
      left: 16,
      bottom: 15
    })
    .borderRadius(30)
    .backgroundColor('rgb(145, 135, 202)')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
    .onClick(() => {
      router.pushUrl({
        url: 'pages/Answer',
        params: {
          chapterId: item.id,
          name: item.name
        }
      })
    })
  }

  // 半模态框
  @Builder
  FilterSheetBuilder() {
    FilterSheet({
      onclick: () => {
        router.pushUrl({
          url: 'pages/Answer'
        })
      }
    })
  }
}

@Extend(Button)
function TsetBtnStyle() {
  .fontSize(18)
  .fontWeight(700)
  .fontColor(Color.White)
  .width(150)
  .height(50)
  .backgroundColor('rgb(251, 166, 163)')
}
