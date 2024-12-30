import { auth, logger, tracking, UserInfo } from '../commons/utils';
import { User } from '../models';
import {HomePage_GoToAI,HomePage_head,HomePage_hotCircle,HomePage_InfFastLook,HomePage_sign} from '../views/HomePage';
import { router } from '@kit.ArkUI';
import { circleItem, GotCircle } from '../models/tempModel/Interface/GotCircle';
import { NoteEditPropmtType } from '../models/tempModel/Interface/PropmtInterfaces';
import axios, { AxiosResponse } from '@ohos/axios';
import { BusinessError } from '@kit.BasicServicesKit';


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
  @StorageProp(UserInfo) user: User = {} as User
  @State isShowSideBar: boolean = false
  @State sideBarWidth: number = 0
  @State opcityAll: number = 1
  @State userName: string = '签名空空'
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
  @State CircleArr: circleItem[] = []
  @Builder SideBarButton(text:string){
    Text('    '+text)
      .width('80%')
      .fontColor('#9b9b9b')
      .height(45)
      .backgroundColor('#5e5e5e')
      .borderRadius(20)
      .margin({right:30})

  }
  @Builder ButtonNotice(text:string,Img:string){
    Blank().height(5)
    Row(){
      Text(' '+text)
        .fontColor('#9b9b9b')
        .width('60%')

      Blank().width('30%')
      Image($rawfile(Img))
        .width('10%')
    }
    .width('80%')
    .margin({right:30})
  }
  @Builder Head(){
    Row({ space: 5 }) { //头栏
      Image(this.user.avatar)//头像
        .height(45)
        .width(45)
        .borderRadius(15)
        .borderWidth(1)
        .borderColor(Color.White)
        .onClick(() => {
          this.isShowSideBar = !this.isShowSideBar
          this.sidebar_Animation()
        })
      Column({ space: 5}) {
        Text('Hello,' + this.user.name )
          .fontSize(20)
          .fontWeight(FontWeight.Bolder)
          .fontColor(Color.White)
          .textAlign(TextAlign.Start)
          .width('100%')
        Text(this.user.introduction)
          .fontSize(12)
          .fontWeight(FontWeight.Bolder)
          .fontColor(Color.White)
          .textAlign(TextAlign.Start)
          .width('100%')
      }
      .width('64%')
    }
  }
  mineIndex:number|null = null
  // 刷题业
  changIndexBrush=(index:number) => {
  }
  // 个人中心页
  changIndexMine=(index:number) => {
  }
  aboutToAppear(): void {
    this.httpGetCircle_axios(this.user.token)
    // 被动上报埋点数据
    tracking.report(true)
    this.week[new Date().getDay()].isToday = true
    colorDraw(this.week)
  }

  sidebar_Animation(): void {
    let aimNumBar=0
    let aimNumOpa=1
    if(this.sideBarWidth==0){
      aimNumBar=250
      aimNumOpa=0
    } else {
      aimNumOpa=1
    }
    animateTo({ duration: 200, curve: Curve.Smooth }, () => {
      this.sideBarWidth = aimNumBar
      this.opcityAll = aimNumOpa
    })
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
              userName: this.user.name,
              userText: this.user.introduction,
              opcityAll: $opcityAll,
              IconStr: this.user.avatar
            })

            HomePage_sign({
              week: $week
            })

            HomePage_GoToAI()
              .margin({ top: 20 })
              .onClick(()=>{
                this.changIndexBrush(1)
              })

            HomePage_hotCircle({
              circle: $circle,
              token: this.user.token
            })

            HomePage_InfFastLook({
              provinceCountLine: $provinceCountLine,
              circle: $circle,
              token: this.user.token
            })

          }
          .width('90%')
        }
        .width('100%')
      }
      .height('100%')
      .opacity(this.opcityAll)
      .scrollBar(BarState.Off)

        Row() {
          Column({space:10}) {//sidBar位置
            Blank().height('10%')
            this.Head()
            this.ButtonNotice('AI对话记录','icon/ChatHistory.png')
            Row(){
              this.SideBarButton('点击进入对话记录')
            }.onClick(() => {
              auth.CheckAuth(()=>{
                router.pushUrl({
                  url: 'pages/ChatHistory',
                  params: {
                    subjectId: 2//debug
                  }
                })
              })
            })
            this.ButtonNotice('笔记编辑', 'icon/NoteEdit.png')
            Row(){
              this.SideBarButton('点击进入笔记编辑')
            }.onClick(() => {
              auth.CheckAuth(()=>{
                router.pushUrl({
                  url: 'pages/EditNote',
                  params: {
                    topicId:54,
                    topicName:'EMPTY',
                    url:''
                  } as NoteEditPropmtType
                })
              })
            })
            this.ButtonNotice('每日一练','icon/EverydayTask.png')
            List({space:10}){//获取的列表
              ForEach(this.CircleArr, (item: circleItem, index: number) => {
                ListItem() {
                  this.SideBarButton(item.name.toString())// text & url
                }.width('90%').onClick(()=>{
                  auth.CheckAuth(()=> {
                    router.pushUrl({
                      url: 'pages/BrushProblem',
                      params: {
                        subjectId: item.circleId
                      }
                    })
                  })
                })
              })
            }
            Blank().height(0)
            Stack() {
              Image($rawfile('icon/GotoUserCenter.png'))
                .width('50%')
                .height(30)
                .margin({ right: 90 })
              Text('      个人中心')
                .fontSize(20)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bolder)
                .textAlign(TextAlign.Start)
                .height(30)
                .width('100%')
            }
            .onClick(()=>{
              this.changIndexMine(3)
            })
          }
          .height('100%')
          .width(this.sideBarWidth)
          .backgroundImage($rawfile('other/card/SideBar.png'))
          .backgroundImageSize(ImageSize.Contain)
          .backgroundImagePosition(Alignment.Start)
          Column(){}//空白位置
          .width('30%')
          .height('100%')
          .onClick(()=>{
            if(this.isShowSideBar){
              this.sidebar_Animation()
              this.isShowSideBar = false
            }
          })
        }
        .height('100%')
        .width('100%')
        .visibility(this.isShowSideBar?Visibility.Visible:Visibility.Hidden)
      }
    }
  httpGetCircle_axios(token:string) {
    axios({
      method: 'GET',
      url: 'https://1fd33097.r5.cpolar.cn'+'/circle/findAll',
      headers: {
        'Authorization': 'Bearer '+token
      }
    }).then((response:AxiosResponse<GotCircle>) => {
      for(let i=0;i<4;i++) {
        this.CircleArr[i] = response.data.data[i]
      }
    }).catch((error:BusinessError) => {
      console.log(error.message)
    })
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