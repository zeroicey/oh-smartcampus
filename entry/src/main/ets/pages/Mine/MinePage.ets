import { promptAction, router } from '@kit.ArkUI'
import { NotesWaterFlow, roseChart } from '../../commons/components'
import { BarChart, valueObjects_bar } from '../../commons/components/BarChart'
import { auth, httpReq, logger, UserInfo } from '../../commons/utils'
import { IInformation, User, WaterFlowType } from '../../models'
import { Avatar, NoteInfomation, NoteServe } from '../../views/MinePage'
import { emitter } from '@kit.BasicServicesKit'
import { LOGIN_EVENT } from '../../commons/constants'

@Component
export struct MinePage {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @StorageProp(UserInfo)
  user: User = {} as User
  // 个人中心页上半部分用户数据
  @State infomation: IInformation = {} as IInformation
  // 半模态框显隐
  @State isShow: boolean = false
  // 半模态框标题
  @State sheetTitle: string = ''
  // 半模态框种类
  @State sheetType: WaterFlowType = WaterFlowType.myNotes
  // 防抖id
  @State timeId: number = -1
  // 是否下拉刷新
  @State isRefreshing: boolean = false
  // 线形图数组
  @State BarArr: Array<valueObjects_bar> = [
    { type: 'oxygen', time: '2024-12-01', value: 46 },
    { type: 'silicon', time: '2024-12-02', value: 27 },
    { type: 'aluminum', time: '2024-12-03', value: 8 },
    { type: 'iron', time: '2024-12-04', value: 5 },
    { type: 'calcium', time: '2024-12-05', value: 3 },
  ]

  // 刷新数据
  async getInfomation() {
    this.infomation = await httpReq.request<IInformation>({
      url: '/user/findById',
    })
    try {
    } catch (err) {
      promptAction.showToast({ message: '请求失败' })
    }
  }

  // 开启下拉窗
  noteServe(title: string, flowType: WaterFlowType) {
    this.isShow = true
    this.sheetTitle = title
    this.sheetType = flowType
  }

  aboutToAppear(): void {
    this.getInfomation()
    // 触发 LOGIN_EVENT 更新数据
    emitter.on(LOGIN_EVENT, () => {
      this.getInfomation()
    })
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing }) {
      Scroll() {
        Column({ space: 36 }) {
          Column({ space: 30 }) {

            // 用户头像区域
            Avatar({ user: this.user, item: this.infomation })

            // 用户笔记类数据
            NoteInfomation({ item: this.infomation })

            // 笔记服务
            Row() {
              NoteServe({ icon: $rawfile('icon/sentNote.png') })
                .onClick(() => {
                  auth.CheckAuth(() => {
                    this.noteServe('已发笔记', WaterFlowType.myNotes)
                  })
                })
              NoteServe({ icon: $rawfile('icon/collection2.png') })
                .onClick(() => {
                  auth.CheckAuth(() => {
                    this.noteServe('我的收藏', WaterFlowType.collection)
                  })
                })
              NoteServe({ icon: $rawfile('icon/draft.png') })
                .onClick(() => {
                  auth.CheckAuth(() => {
                    this.noteServe('保存的笔记', WaterFlowType.draft)
                  })
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('100%')
          .padding({ left: 30, right: 30 })
          .alignItems(HorizontalAlign.End)
          .margin({ bottom: 12 })

          // 学习分析部分
          Stack({ alignContent: Alignment.Top }) {
            Column() {
              roseChart({
                dataValue: [
                  { type: '学习', value: '23' },
                  { type: '休息', value: '50' },
                  { type: '运动', value: '27' },
                ],
                legendPosition: 'bottom'
              })
              // 条形统计图
              BarChart({
                dataValue: this.BarArr
              })
              // Button('清除用户数据')
              //   .onClick(() => {
              //     auth.setUser({} as User)
              //   })
              // Button('模拟token失效')
              //   .onClick(() => {
              //     this.user.token += 'xx'
              //     auth.setUser(this.user)
              //   })
              // Button('跳转刷题章节')
              //   .onClick(() => {
              //     router.pushUrl({
              //       url: 'pages/BrushProblem'
              //     })
              //   })
            }
            .backgroundColor(Color.White)
            .width('100%')
            .padding({ left: 30, right: 30, top: 58 })
            .borderRadius({ topLeft: 50, topRight: 50 })

            Image($rawfile('other/analyzeBg.png'))
              .width(123)
          }

        }
        .bindSheet($$this.isShow, this.BindSheetBuilder(this.sheetTitle), { showClose: false })
      }
      .width('100%')
      .height('100%')
      .padding({ top: 10 })
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
    }
    .onRefreshing(() => {
      if (!this.user.token) {
        this.isRefreshing = false
        return
      }
      this.isRefreshing = true
      clearTimeout(this.timeId)
      this.timeId = setTimeout(async () => {
        await this.getInfomation()
        this.isRefreshing = false
        promptAction.showToast({ message: '刷新成功' })
      }, 500)
    })
  }

  // 收藏/草稿/发布的笔记半模态弹窗
  @Builder
  BindSheetBuilder(title: string) {
    Column({ space: 27 }) {
      Row() {
        Text(title)
          .fontSize(36)
          .fontWeight(700)
          .fontColor(Color.White)
        Blank()
        Text('关闭')
          .fontWeight(500)
          .fontColor(Color.White)
          .onClick(() => {
            this.isShow = false
          })
      }
      .width('100%')

      NotesWaterFlow({ flowType: this.sheetType })
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding({
      left: 30,
      right: 30,
      top: 30,
      bottom: this.bottomHeight
    })
    .backgroundColor('rgb(53, 50, 66)')
  }
}