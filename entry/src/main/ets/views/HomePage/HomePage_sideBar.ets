import { router } from "@kit.ArkUI"
import axios, { AxiosResponse } from "@ohos/axios"
import { courseItem, courseResponse } from "../../models/tempModel/Interface/GetCourse"
import { BusinessError } from "@kit.BasicServicesKit"


@Component
export struct HomePage_sidebar{
  @Link isShowSideBar: boolean
  @Link sideBarWidth: number
  @Link userName: string
  @Link opcityAll: number
  @Prop Icon: ResourceStr = $rawfile('other/Mock/Enpty.png')
  @State subjectArr:Array<courseItem> = []//debug获取章节

  sidebar_Animation(): void {
    let aimNumBar=0
    let aimNumOpa=1
    if(this.sideBarWidth==0){
      aimNumBar=250
      aimNumOpa=0.3
    } else {
      aimNumOpa=1
    }
    animateTo({ duration: 200, curve: Curve.Smooth }, () => {
      this.sideBarWidth = aimNumBar
      this.opcityAll = aimNumOpa
    })
  }

  @Builder SideBarButton(text:string,pageUrl:string,id:number){
    Text('    '+text)
      .width('80%')
      .fontColor('#9b9b9b')
      .height(45)
      .backgroundColor('#5e5e5e')
      .borderRadius(20)
      .margin({right:30})
      .onClick(()=>{
        router.pushUrl({
          url: 'pages/'+pageUrl,
          params: {
            subjectId:id//debug
          }
        })
      })
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
      Image($rawfile('other/Mock/Enpty.png'))//头像
        .height(45)
        .width(45)
        .borderRadius(15)
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
        Text(this.userName)
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
    this.httpGotCourse_axios('')//TODO 这里填token
  }
  build() {
    Row() {
      Column({space:10}) {
        Blank().height('10%')
        this.Head()
        this.ButtonNotice('AI对话记录','icon/ChatHistory.png')
        this.SideBarButton('点击进入对话记录','ChatHistory',2)
        this.ButtonNotice('笔记编辑','icon/NoteEdit.png')
        this.SideBarButton('点击进入笔记编辑','EditNote',0)
        this.ButtonNotice('每日一练','icon/EverydayTask.png')
        List({space:10}){
          ForEach(this.subjectArr, (item: number, index: number) => {
            ListItem() {
              this.SideBarButton(item.toString(), 'BrushProblem',3)// text & url
            }.width('90%')
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
      url: 'http://127.0.0.1:8081'+'/question/getAllSubject',//get
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer '+token
      }
    }).then((response: AxiosResponse<courseResponse>)=>{
      this.subjectArr = response.data.data
    }).catch((error:BusinessError)=>{
      console.log(error.message)
    })
  }
}