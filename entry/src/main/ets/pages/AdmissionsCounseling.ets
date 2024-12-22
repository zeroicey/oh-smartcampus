import router from '@ohos.router';
import axios ,{AxiosResponse}from '@ohos/axios';
import { GotPointLine } from '../models/tempModel/Interface/GotPointLine';
import { pickProvinceDialog } from '../views/AdmissionsCounseling/pickProvinceDialog';
import { BusinessError } from '@kit.BasicServicesKit';
import { InputComponent } from '../commons/components';
import { SearchSchoolData, SearchSchoolResponseData,
  SearchSchool_ByName } from '../models/tempModel/Interface/SchoolSearch';

@Entry
@Component
struct AdmissionsCounseling {


  @State uniName: string = 'TheName'
  @State NetErrorFlag:boolean = true
  @State region: string = '广东省'; // 地区
  @State secondaryMajor: string = ''; // 二级专业
  @State tertiaryMajor: string = ''; // 三级专业
  @State universityLevel: string = ''; // 院校级别
  @State responseSchoolData: Array<SearchSchoolData> = []//获取的学校列表
  @Builder inputComponent(text:string, placeholder:string,inputText:string) {
    Column({ space: 10 }) {
      Text(text)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bolder)
        .fontSize(20)
        .width('100%')
        .textAlign(TextAlign.Start)
      Row({ space: 50 }) {
        TextInput({ placeholder:placeholder, text: inputText })
          .backgroundColor('#c4c4c4')
          .width('70%')
          .height(30)
          .borderRadius(15)
        Image($rawfile('icon/search.png'))
          .height(30)
      }
    }
  }
  @Builder TextItem(text:string){
    Text(text)
      .height(30)
      .width('17%')
      .backgroundColor('#fff18c')
      .fontSize(15)
      .fontColor('#8d87f0')
      .textAlign(TextAlign.Center)
      .fontWeight(FontWeight.Bolder)
      .borderRadius(10)
      .onClick((event: ClickEvent) => {

      })
  }
  controller:CustomDialogController = new CustomDialogController({
    builder: pickProvinceDialog({
      selectedItem:$region
    })
  })



  build() {
    Column() {
      Row({space: 20}){//lv1
        Blank().width(10)
        Image($rawfile('icon/backIcon.png'))
          .width(30)
          .height(40)
          .onClick(()=>{
            router.back()
          })
        Text('录取咨讯')
          .fontColor(Color.White)
          .fontSize(30)
          .fontWeight(FontWeight.Bolder)
        Blank().height(30)
        Image($rawfile('icon/DealAIChat.png'))
          .width(30)
          .height(30)
          .margin({ left: 140 })
          .onClick(()=>{

          })
        Blank().width(30)
      }
      .width('100%')
      .height('10%')
      Scroll() {
        Column() {
          Column({ space: 20 }) { //lv2
            Text(this.region)
              .width('90%')
              .height(30)
              .borderRadius(15)
              .backgroundColor(Color.White)
              .fontSize(20)
              .fontWeight(FontWeight.Bolder)
              .textAlign(TextAlign.Center)
              .onClick(()=>{
                this.controller.open()
              })
            this.inputComponent('地区','请输入地区',this.region)
            this.inputComponent('二级专业','请输入二级专业',this.secondaryMajor)
            this.inputComponent('三级专业','请输入三级专业',this.tertiaryMajor)
            this.inputComponent('院校级别','请输入院校级别',this.universityLevel)
          }
          .height('40%')
          .width('90%')

          Blank().height(20)
          Column() { //lv3
            Stack() {
              Image($rawfile('other/card/selectUniCard.png'))
                .height('100%')
                .width('100%')
              Column() {
                Row() {
                  Text(this.uniName)
                    .fontColor(Color.White)
                    .fontSize(40)
                    .fontWeight(FontWeight.Bolder)
                    .width('66%')
                    .textAlign(TextAlign.Center)
                  Blank().width('1%')
                  Column({space: 10}){
                    Image($rawfile('icon/searchUni.png'))
                      .height(50)
                    Text('搜索')
                      .fontColor('#ff9996')
                      .width('100%')
                      .textAlign(TextAlign.Center)
                      .fontWeight(FontWeight.Bold)
                  }
                  .width('33%')

                }
                .height('10%')

                Row({space: 10}) {
                  this.TextItem('年份')
                  this.TextItem('人数')
                  this.TextItem('最低分')
                  this.TextItem('最高分')
                  this.TextItem('平均分')
                }
                .height('10%')
                .width('90%')
                Column() {
                  if(this.NetErrorFlag){
                    Column(){
                      Image($rawfile('icon/reload.png'))
                        .height(100)
                        .width(100)
                    }
                    .width('100%')
                    .height('20%')
                    .align(Alignment.Top)
                  } else {
                    //TODO
                    //具体实现相应的图表设计
                  }
                }
                .height('80%')
              }
            }
          }
          .width('100%')
          .height('130%')
        }
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#353242')
  }
  httpSearchBackByRegion_axios(page:number,size:number,token:string){
    axios({
      method: 'POST',
      url: 'http://127.0.0.1:8081'+'/university/findRangeSearch',
      data:{
        page:page,
        size:size,
        region:this.region,
        secondaryMajor:this.secondaryMajor,
        tertiaryMajor:this.tertiaryMajor,
        universityLevel:this.universityLevel,
      } as SearchSchoolData,
      headers:{
        "Authorization":"Bearer"+token
      }
    })
      .then((response: AxiosResponse<SearchSchoolResponseData>)=>{
        this.responseSchoolData = response.data.data
      })
      .catch((error:BusinessError)=>{
        console.log(error.message)
      })
  }
  httpSearchBackByName_axios(page:number,size:number,school:string,token:string){
    axios({
      method: 'POST',
      url: 'http://127.0.0.1:8081'+'/university/findSchool',
      data:{
        page:page,
        size:size,
        school:school
      } as SearchSchool_ByName,
      headers:{
        "Authorization":"Bearer"+token
      }
    })
      .then((response: AxiosResponse<SearchSchoolResponseData>)=>{
        this.responseSchoolData = response.data.data
      })
      .catch((error:BusinessError)=>{
        console.log(error.message)
      })
  }
  httpGetSchoolData_axios(){
    //TODO 获取详细学校信息，等待接口完善
  }
}