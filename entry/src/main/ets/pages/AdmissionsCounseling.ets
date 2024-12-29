import router from '@ohos.router';
import axios ,{AxiosResponse}from '@ohos/axios';
import { pickDialog } from '../views/AdmissionsCounseling/pickDialog';
import { BusinessError } from '@kit.BasicServicesKit';
import {ScoreData,SearchSchoolData, SearchSchoolResponse,SearchSchool_ByName } from '../models/tempModel/Interface/SchoolSearch';
import { logger, UserInfo } from '../commons/utils';
import { User } from '../models';

@Entry
@Component
export struct AdmissionsCounseling {
  @StorageProp(UserInfo)
  user: User = {} as User
  @State submitItem:SearchSchoolData = {}
  @State schoolName:string = ''
  @State region: string = '';//省份
  @State secondaryMajor: string = ''; // 二级专业
  @State tertiaryMajor: string = ''; // 三级专业
  @State universityLevel: string = ''; // 院校级别
  @State responseSchoolData: Array<ScoreData> = []//获取的学校列表
  @State flag:number = 0
  @State CardNameArr:Array<string> = ['年份', '学校', '学院', '专业', '最低分', '平均分', '最高分']
  controller:CustomDialogController = new CustomDialogController({
    builder: pickDialog({
      submitItem:$submitItem,
      responseSchoolData:$responseSchoolData,
      token:this.user.token,
      flag:$flag
    })
  })

  @Builder
  TextInf(text:string){
    Text(text)
      .fontSize(20)
      .fontWeight(FontWeight.Bolder)
      .width('80%')
      .height(30)
      .textAlign(TextAlign.Start)
      .backgroundColor(Color.Transparent)
      .borderRadius(10)
  }

  @Builder
  label1(text:string){
    Text(text)
      .height(30)
      .width(40)
      .fontColor(Color.White)
      .fontSize(20)
      .fontWeight(FontWeight.Bolder)
      .textAlign(TextAlign.Center)
      .backgroundColor('#817afc')
      .borderRadius(10)
  }

  @Builder
  label2(num:number){
    Row({ space: 15}) {
      Blank().height(0)
      Text(this.CardNameArr[num])
        .height(30)
        .width(70)
        .fontSize(20)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bolder)
        .textAlign(TextAlign.Center)
        .backgroundColor('#817afc')
        .borderRadius(10)
    }
  }

  @Builder
  InfCard(item:ScoreData){
    Row({space:10}){
      Column({ space:10 }){
        Blank().height(0)
        ForEach(this.CardNameArr, (item:string , index: number) => {
          this.label2(index)
        })
        Blank().height(0)
      }
      Column({ space: 10 }){
        this.TextInf(item.year.toString())
        this.TextInf(item.school)
        this.TextInf(item.faculty)
        this.TextInf(item.tertiaryMajor)
        this.TextInf(item.minScore)
        this.TextInf(item.maxScore)
        this.TextInf(item.averageScore)
      }
    }
    .width('90%')
    .borderRadius(30)
    .backgroundColor(Color.White)
    .onClick(() => {
      //目前没接口
    })
  }

  aboutToAppear(): void {
    //this.responseSchoolData = MockData()
  }

  build() {
    Column() {
      Row() { //lv1
        Image($rawfile('icon/backIcon.png'))
          .height(40)
          .onClick(() => {
            router.back()
          })
        Blank().width(15)
        Text('录取咨讯')
          .fontColor(Color.White)
          .fontSize(30)
          .width('75%')
          .fontWeight(FontWeight.Bolder)
        Image($rawfile('icon/hyperSearch.png'))
          .width(30)
          .height(30)
          .onClick(()=>{
            this.controller.open()
            this.flag = 2
        })
      }
      .width('90%')
      .height('10%')

      Scroll() {
        Column({ space: 20}) {
            Row({ space: 20 }) {
              Row(){
                TextInput({ placeholder: '请输入学校名称', text: $$this.schoolName })
                  .width('70%')
                  .height(40)
                  .fontSize(20)
                  .fontColor(Color.White)
                  .backgroundColor(Color.Transparent)
                Blank().width('10%')
                Image($rawfile('icon/search.png'))
                  .height(30)
                  .width(30)
                  .margin(5)
                  .onClick(()=>{
                    this.httpSearchBackByName_axios(1,10,this.schoolName,this.user.token)
                  })
              }
              .height(35)
              .borderRadius(15)
              .backgroundColor('#313035')
              .width('80%')

            }

          // Button('got')
          //   .onClick(()=>{
          //     console.log('got'+JSON.stringify(this.submitItem))
          //   })
            if (this.flag == 1) {
              Row({space:20}){
                Image(this.responseSchoolData[0].img)
                  .height(70)
                  .width(70)
                Column(){
                  Text(this.responseSchoolData[0].school)
                    .fontSize(20)
                    .fontWeight(FontWeight.Bolder)
                    .textAlign(TextAlign.Start)
                    .width('80%')
                  Text(this.responseSchoolData[0].minScore +'--'+this.responseSchoolData[0].maxScore)
                    .fontColor(Color.Gray)
                    .fontSize(20)
                    .fontWeight(FontWeight.Bolder)
                    .textAlign(TextAlign.Start)
                    .width('80%')
                }
              }
              .backgroundColor(Color.White)
              .width('90%')
              .borderRadius(30)
            }
            ForEach(this.responseSchoolData, (item: ScoreData, index: number) => {
                this.InfCard(item)
            })
        }
        .width('90%')
      }
      //.width('90%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#15161a')
  }

  httpSearchBackByName_axios(page:number,size:number,school:string,token:string){
    axios({
      method: 'POST',
      url: 'https://1fd33097.r5.cpolar.cn'+'/university/findSchool',
      data:{
        page:page,
        size:size,
        school:school
      } as SearchSchool_ByName,
      headers:{
        "Authorization":"Bearer "+token
      }
    }).then((response: AxiosResponse<SearchSchoolResponse>)=>{
        console.log('GOT_myDATA:------>'+page.toString()+'|'+size.toString()+'|'+school+'|'+token)
        console.log('GOT_res;------->'+JSON.stringify(response.data))
        this.responseSchoolData = response.data.data
        this.flag=1
      })
      .catch((error:BusinessError)=>{
        console.log(error.message)
        logger.info(error.message)
      })
  }
  httpGetSchoolData_axios(){
    //TODO 获取详细学校信息，等待接口完善(后续开发准备)
  }
}
