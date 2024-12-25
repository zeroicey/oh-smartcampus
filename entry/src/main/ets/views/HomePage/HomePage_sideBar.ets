import { router } from "@kit.ArkUI"
import axios, { AxiosResponse } from "@ohos/axios"
import { courseItem, courseResponse } from "../../models/tempModel/Interface/GetCourse"
import { BusinessError } from "@kit.BasicServicesKit"
import { NoteEditPropmtType } from "../../models/tempModel/Interface/PropmtInterfaces"


@Component
export struct HomePage_sidebar{
  @Link isShowSideBar: boolean
  @Link sideBarWidth: number
  @Prop userName: string = ''
  @Link opcityAll: number
  @Prop Icon: string = ''
  @Prop introduce: string = ''
  @Prop token: string = ''
  @State subjectArr:Array<courseItem> = []//debug获取章节

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
      Image(this.Icon)//头像
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
        Text('Hello,' + this.userName)
          .fontSize(20)
          .fontWeight(FontWeight.Bolder)
          .fontColor(Color.White)
          .textAlign(TextAlign.Start)
          .width('100%')
        Text(this.introduce)
          .fontSize(12)
          .fontWeight(FontWeight.Bolder)
          .fontColor(Color.White)
          .textAlign(TextAlign.Start)
          .width('100%')
      }
      .width('64%')
    }
  }

  aboutToAppear(): void {
    this.httpGotCourse_axios(this.token)
  }
  build() {
    Row() {
      Column({space:10}) {
        Blank().height('10%')
        this.Head()
        this.ButtonNotice('AI对话记录','icon/ChatHistory.png')
        Row(){
          this.SideBarButton('点击进入对话记录')
        }.onClick(() => {
          router.pushUrl({
            url: 'pages/ChatHistory',
            params: {
              subjectId: 2//debug
            }
          })
        })
        this.ButtonNotice('笔记编辑','icon/NoteEdit.png')
        Row(){
          this.SideBarButton('点击进入笔记编辑')
        }.onClick(() => {
          router.pushUrl({
            url: 'pages/EditNote',
            params: {
              topicId:54,
              topicName:'EMPTY',
              url:''
            } as NoteEditPropmtType
          })
        })
        this.ButtonNotice('每日一练','icon/EverydayTask.png')
        List({space:10}){
          ForEach(this.subjectArr, (item: courseItem, index: number) => {
            ListItem() {
              this.SideBarButton(item.name.toString())// text & url
            }.width('90%').onClick(()=>{
              router.pushUrl({
                url: 'pages/BrushProblem',
                params: {
                  subjectId: item.id
                }
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
    //.margin({right:250})
    .visibility(this.isShowSideBar?Visibility.Visible:Visibility.Hidden)
  }

  httpGotCourse_axios(token:string){
    axios({
      method: 'GET',
      url: 'https://1fd33097.r5.cpolar.cn'+'/question/getAllSubject',//get
      headers: {
        'Authorization': 'Bearer '+token
      }
    }).then((response: AxiosResponse<courseResponse>)=>{
      this.subjectArr = response.data.data
      console.log('GOT_SUCCESS_SIDEBAR,LENGTH:'+this.subjectArr.length)
    }).catch((error:BusinessError)=>{
      console.log('GOT_ERROR_SIDEBAR'+error.message)
    })
  }
}