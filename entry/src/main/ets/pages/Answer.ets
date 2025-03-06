import { CustomNavBar, HcLoadingDialog } from '../commons/components'
import { promptAction, router } from '@kit.ArkUI'
import { httpReq, logger, tracking } from '../commons/utils'
import { ISubject } from '../models'

interface IRouterParam {
  chapterId?: number
  name?: string
  topicContext?: string
}

@Entry
@Component
struct Answer {
  @StorageProp('topHeight')
  topHeight: number = 0
  tabController: TabsController = new TabsController()
  tabBarList: string[] = ['答案解析', 'AI解析', '我的笔记']
  // 控制半模态框
  @State isShow: boolean = false
  // 题库名
  @State title: string | null = ''
  // 选中的答案
  @State activeNum: number = -1
  // 用户选择的答案
  @State userChoose: string = ''
  // 所有题目
  @State subjectList: ISubject[] = []
  // 单个题目的选项
  @State item: ISubject = {} as ISubject
  @State subjectIndex: number = 0
  // 开始的时间戳
  startTime: number = 0
  dialog: CustomDialogController = new CustomDialogController({
    builder: HcLoadingDialog(),
    customStyle: true
  })

  // 根据字段或去对应题目
  async getTextSubjectData(params: IRouterParam) {
    this.dialog.open()
    this.subjectList = await httpReq.request<ISubject[]>({
      url: '/question/getQuestionByCircleContext',
      params: {
        topicContext: params.topicContext
      }
    })
    this.item = this.subjectList[0]
    this.dialog.close()
  }

  // 根据章节获取题目数据
  async getChapterSubjectData(params: IRouterParam) {
    this.dialog.open()
    this.subjectList = await httpReq.request<ISubject[]>({
      //${params.topicContext}
      url: `/question/getQuestionByChapterId/${params.chapterId}`,
    })
    this.item = this.subjectList[0]
    promptAction.showToast({ message: '请求成功' })
    logger.info(JSON.stringify(this.subjectList))
    this.dialog.close()
  }

  // 切换题目
  changeSubject(step: number) {
    const index = this.subjectIndex + step
    if (index < 0) {
      return promptAction.showToast({ message: '已经是最前面啦~' })
    }
    if (index > this.subjectList.length - 1) {
      return promptAction.showToast({ message: '已经到底了哦~' })
    }
    this.subjectIndex = index
    this.item = this.subjectList[this.subjectIndex]
    this.activeNum = -1
    logger.info(this.item.id.toString(), this.userChoose)
    // 记录当前题目的结束时间
    tracking.record(Number(this.item.chapterId), this.startTime, Date.now(), this.item.id, this.userChoose)
    // 让刚做完题目的结束时间等于下一题的开始时间
    this.startTime = Date.now()
  }

  aboutToAppear(): void {
    // 获取跳转页面传过来的章节id或者对话页面跳转过来的字段
    const params = router.getParams() as IRouterParam
    promptAction.showToast({ message: JSON.stringify(params) })
    if (params.name) {
      this.title = params.name
    }
    // 判断是章节题目还是字段查询题目
    if (params.name) {
      this.getChapterSubjectData(params)
    } else {
      this.getTextSubjectData(params)
    }
  }

  onPageShow(): void {
    // 用户一进入答题页获取开始时间戳
    this.startTime = Date.now()
  }

  onPageHide(): void {
    // 1.用户点进去之后又出来的埋点信息
    tracking.record(Number(this.item.chapterId), this.startTime, Date.now(), this.item.id, this.userChoose)
    // 提交埋点数据
    tracking.report()
  }

  build() {
    Column() {
      Row() {
        CustomNavBar({ title: this.title ? this.title : '类似题目', showRightIcon: false })
          .width('80%')
        Text(`${this.subjectIndex + 1}/${this.subjectList.length}`)
          .layoutWeight(1)
          .margin({ bottom: 5 })
          .fontColor(Color.White)
          .textAlign(TextAlign.End)
      }
      .alignItems(VerticalAlign.Bottom)
      .padding({ right: 30 })
      .margin({ bottom: 38 })

      Column({ space: 30 }) {
        // 题目名称
        Column({ space: 19 }) {
          Text(this.item.content)
            .width('100%')
            .TextStyle()
            .fontSize(20)
          Progress({ value: this.subjectIndex + 1, total: this.subjectList.length })
            .width('100%')
            .color('rgb(255, 153, 150)')
        }

        // 选项
        List({ space: 30 }) {
          ForEach(this.item.optionsList, (items: string, index: number) => {
            ListItem() {
              this.ChoiceItem(items, index)
            }
          })
        }

        // 如果用户做出选择答案就显示出来
        if (this.activeNum != -1) {
          Divider()
            .width('100%')
            .height(1)
            .backgroundColor('#FF9996')

          Text('查看答案')
            .TextStyle()
            .width(200)
            .height(50)
            .borderRadius(30)
            .textAlign(TextAlign.Center)
            .backgroundColor('rgb(76, 206, 167)')
            .onClick(() => {
              this.isShow = true
            })
        }
      }
      .width('100%')
      .padding({ left: 30, right: 30 })
      .layoutWeight(1)

      Row() {
        Text('上一题')
          .textBtn()
          .backgroundColor(this.subjectIndex == 0 ? '#BDBDBD' : '#FF9996')
          .onClick(() => {
            this.changeSubject(-1)
          })
        Text('下一题')
          .textBtn()
          .backgroundColor(this.subjectIndex == this.subjectList.length - 1 ? '#BDBDBD' : '#FF9996')//数组的最后一项：数组长度-1
          .onClick(() => {
            this.changeSubject(1)
          })
      }
      .width('100%')
      .backgroundColor('rgb(59, 59, 59)')
      .borderRadius(30)
      .padding({
        left: 30,
        right: 30,
        top: 20,
        bottom: 20
      })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#fffcf3')
    .bindSheet($$this.isShow, this.AnswerBuilder(this.item.explanation), {
      height: SheetSize.MEDIUM,
      showClose: false,
      maskColor: 'rgba(196, 196, 196, 0.25)'
    })
  }

  // 选项
  @Builder
  ChoiceItem(items: string, index: number) {
    Text(items)
      .TextStyle()
      .width('100%')
      .padding({
        left: 33,
        right: 33,
        top: 15,
        bottom: 15
      })
      .borderRadius(30)
      .backgroundColor(index == this.activeNum ? '#FF9996' : '#313035')
      .onClick(() => {
        this.activeNum = index
        this.userChoose = items.split('.')[0]
      })
  }

  // 答案解析半模态框
  @Builder
  AnswerBuilder(explanation: string) {
    Column() {
      // 答案
      Row({ space: 50 }) {
        Text(`标准答案：${this.item.answer}`)
          .TextStyle()
        Text(`你的答案：${this.userChoose}`)
          .TextStyle()
      }
      .width('100%')
      .margin({ top: 30 })
      .justifyContent(FlexAlign.Center)

      Tabs({ controller: this.tabController }) {
        ForEach(this.tabBarList, (item: string, index: number) => {
          TabContent() {
            Column() {
              Text(explanation)
                .width('100%')
                .fontColor(Color.White)
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Start)
          }.tabBar(
            SubTabBarStyle.of(item.toString())// 直接使用字符串有些限制, 例如不能设置他对应的一些自定义样式.
              .indicator({
                color: 'rgb(55, 238, 183)', // 下划线颜色
                height: 2, // 下划线高度
                width: 40, // 下划线宽度, 100%则和文本宽度一致, 但这个下划线宽度可以超过100%, 可以根据需求自己设置
                borderRadius: 2, // 下划线圆角半径
                marginTop: 9, // 下划线与文字间距
              })
              .selectedMode(SelectedMode.INDICATOR)// 设置下划线, 固定写法
              .labelStyle({
                // 设置字体样式
                font: { size: '17fp', weight: '700' }, // 字体大小, 我们无法控制选中和未选中不同状态下的字体大小
                unselectedColor: Color.White, // 未选中字体颜色
                selectedColor: 'rgb(55, 238, 183)'  // 选中字体颜色
              })
          )
          .padding({
            left: 15,
            right: 15,
            top: 15,
            bottom: 15
          })
        })
      }
      .width('100%')
    }
    .backgroundColor('#fffcf3')

  }
}

@Extend(Text)
function TextStyle() {
  .fontColor(Color.White)
  .fontSize(17)
  .fontWeight(700)
}

@Extend(Text)
function textBtn() {
  .width(132)
  .height(50)
  .borderRadius(30)
  .fontSize(24)
  .fontWeight(900)
  .fontColor(Color.White)
  .textAlign(TextAlign.Center)
}
