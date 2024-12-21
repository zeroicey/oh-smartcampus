import { tracking } from '../commons/utils';
import {HomePage_GoToAI,HomePage_head,HomePage_hotCircle,HomePage_InfFastLook,HomePage_sidebar,HomePage_sign} from '../views/HomePage';

export class week {
  day: number
  isToday: boolean
  isSignned: boolean
  color: string

  constructor(day: number, isToday: boolean, isSignned: boolean, color: string) {
    this.day = day;
    this.isToday = isToday;
    this.isSignned = isSignned;
    this.color = color;
  }
}

@Entry
@Component
export struct HomePage {
  @State isShowSideBar: boolean = false
  @State sideBarWidth: number = 0
  @State opcityAll: number = 1
  @State Icon: ResourceStr = $rawfile('other/Mock/Enpty.png')
  @State userName: string = '断网了哦'
  @State userText: string = '没有网哦，不知道座右铭是什么（。。？）~'
  @State week: Array<week> = [
    new week(7, false, false, ''),
    new week(1, false, false, ''),
    new week(2, false, false, ''),
    new week(3, false, false, ''),
    new week(4, false, false, ''),
    new week(5, false, false, ''),
    new week(6, false, false, ''),
  ] //Mock
  @State circle: Array<number> = [1, 2, 3, 4] //debug
  @State provinceCountLine: Array<string> = [] //debug

  aboutToAppear(): void {
    // 被动上报埋点数据
    tracking.report(true)
    //this.Icon = //TODO
    this.week[new Date().getDay()].isToday = true
    colorDraw(this.week)
  }

  build() {
    Stack() {
      //stack1
      Scroll() {
        Column() {
          Column({ space: 20 }) {

            HomePage_head({
              isShowSideBar: $isShowSideBar,
              sideBarWidth: $sideBarWidth,
              userName: $userName,
              userText: $userText,
              opcityAll: $opcityAll
            })

            HomePage_sign({
              week: $week
            })

            HomePage_hotCircle({
              circle: $circle
            })

            HomePage_GoToAI()

            HomePage_InfFastLook({
              provinceCountLine: $provinceCountLine,
              circle: $circle
            })

          }
          .width('90%')
        }
        .width('100%')
      }
      .height('100%')
      .opacity(this.opcityAll)
      .scrollBar(BarState.Off)

      //stack2
      HomePage_sidebar({
        isShowSideBar: $isShowSideBar,
        sideBarWidth: $sideBarWidth,
        userName: $userName,
        opcityAll: $opcityAll,
        Icon: this.Icon
      })
    }
  }
}

function colorDraw(arr: Array<week>) {
  for (let i = 0; i < 7; i++) {
    if (arr[i].isToday) {
      arr[i].color = '#8d87f2'
    } else if (arr[i].isSignned) {
      arr[i].color = '#cac7ff'
    } else {
      arr[i].color = '#ffffff'
    }
  }

}