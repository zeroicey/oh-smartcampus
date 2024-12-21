import { promptAction, router } from '@kit.ArkUI'
import { NotesWaterFlow, roseChart } from '../../commons/components'
import { BarChart, valueObjects_bar } from '../../commons/components/BarChart'
import { auth, httpReq, logger, UserInfo } from '../../commons/utils'
import { IInformation, User, WaterFlowType } from '../../models'
import { Avatar } from '../../views/MinePage/Avatar'
import { MineStudyTime } from '../../views/MinePage/MineStudyTime'

@Component
export struct MinePage {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @StorageProp(UserInfo)
  user: User = {} as User
  @State infomation: IInformation = {} as IInformation
  @State isShow: boolean = false
  @State sheetTitle: string = ''
  // 半模态框种类
  @State sheetType: WaterFlowType = WaterFlowType.myNotes
  @State timeId: number = -1
  @State isRefreshing: boolean = false
  @State BarArr: Array<valueObjects_bar> = [
    { type: 'oxygen', time: '2024-12-01', value: 46 },
    { type: 'silicon', time: '2024-12-02', value: 27 },
    { type: 'aluminum', time: '2024-12-03', value: 8 },
    { type: 'iron', time: '2024-12-04', value: 5 },
    { type: 'calcium', time: '2024-12-05', value: 3 },
  ]

  // 刷新数据
  async getInfomation() {
    try {
      this.infomation = await httpReq.request<IInformation>({
        url: '/user/findById',
        // TODO header请求头
        headers: {
          "uid": '1000001'
        }
      })
      logger.info(JSON.stringify(this.infomation))
    } catch (err) {
      promptAction.showToast({ message: '请求失败' })
    }
  }

  aboutToAppear(): void {
    this.getInfomation()
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing }) {
      Scroll() {
        Column() {
          Column({ space: 15 }) {
            Row() {
              Image($rawfile('icon/Setting.png'))
                .width(15)
            }
            .width(30)
            .height(30)
            .backgroundColor('rgb(184, 171, 239)')
            .justifyContent(FlexAlign.Center)
            .borderRadius(15)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/Mine/InformationEdite'
              })
            })

            // 用户头像区域
            Avatar({ user: this.user })

            // 用户获赞信息
            Grid() {
              ForEach(Array.from({ length: 3 }), (item: null, index: number) => {
                GridItem() {
                  Column() {
                    Text(this.user.token ? index == 0 ? `${this.infomation.likeTotal} ` :
                      index == 1 ? `${this.infomation.brightTotal} ` : `${this.infomation.noteTotal} ` : '--')
                      .fontSize(36)
                      .fontWeight(900)
                      .fontColor('rgb(255, 124, 120)')
                    Text(index == 0 ? '获赞数' : index == 1 ? '获亮数' : '发过笔记')
                      .fontWeight(700)
                      .fontColor('rgb(99, 95, 113)')
                  }
                  .padding(15)
                }
                .border({
                  color: 'rgb(165, 165, 165)',
                  width: { right: index != 2 ? 1 : 0 }
                })
                .onClick(() => {
                  if (index == 2) {
                    this.isShow = true
                    this.sheetTitle = '发布过的笔记'
                    this.sheetType = WaterFlowType.myNotes
                  }
                })
              })
            }
            .width('100%')
            .borderRadius(26)
            .backgroundColor(Color.White)
            .columnsTemplate('1fr 1fr 1fr')
            .rowsTemplate('1fr')
            .height(90)

            // 学习时长
            MineStudyTime({ studyTime: this.infomation.studyTime, attendance: this.infomation.attendance })
          }
          .width('100%')
          .padding({ left: 30, right: 30 })
          .alignItems(HorizontalAlign.End)
          .margin({ bottom: 12 })

          // 学习分析部分
          Column() {
            Row() {
              Column({ space: 10 }) {
                Text('学习分析')
                  .fontSize(14)
                  .fontWeight(700)
                  .fontColor('rgb(255, 153, 150)')
                Image($rawfile('icon/PieChart.png'))
                  .width(78)
              }
              .width(90)
              .padding({ top: 13 })

              // 收藏以及草稿按钮
              Row({ space: 15 }) {
                ForEach(Array.from({ length: 2 }), (item: null, index: number) => {
                  // 收藏
                  Column({ space: 5 }) {
                    Row() {
                      Image(index == 0 ? $rawfile('icon/collection2.png') : $rawfile('icon/draft.png'))
                        .width(40)
                    }
                    .width('100%')
                    .height(50)
                    .backgroundColor('rgb(184, 171, 239)')
                    .borderRadius(30)
                    .justifyContent(FlexAlign.Center)
                    .onClick(() => {
                      this.isShow = true
                      if (index == 0) {
                        this.sheetTitle = '收藏'
                        this.sheetType = WaterFlowType.collection
                      } else {
                        this.sheetTitle = '笔记保存'
                        this.sheetType = WaterFlowType.draft
                      }
                    })

                    Text(index == 0 ? '收藏' : '笔记保存')
                      .fontSize(14)
                      .fontWeight(700)
                      .fontColor(Color.White)
                  }
                  .width(100)
                  .height(70)
                })
              }
              .layoutWeight(1)
              .justifyContent(FlexAlign.End)
              .height(110)
              .alignItems(VerticalAlign.Top)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            Button('清除用户数据')
              .onClick(() => {
                auth.setUser({} as User)
              })
            Button('模拟token失效')
              .onClick(() => {
                this.user.token += 'xx'
                auth.setUser(this.user)
              })
            Button('跳转刷题章节')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/BrushProblem'
                })
              })

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
          }
          .width('100%')
          .padding({ left: 30, right: 30 })
        }
        .bindSheet($$this.isShow, this.BindSheetBuilder(this.sheetTitle), { showClose: false })
      }
      .width('100%')
      .height('100%')
      .padding({ top: 10 })
      .margin({ bottom: 10 })
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