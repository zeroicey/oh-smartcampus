import router from '@ohos.router';
import axios ,{AxiosResponse}from '@ohos/axios';
import { GotPointLine } from '../models/tempModel/Interface/GotPointLine';
import { pickProvinceDialog } from '../views/AdmissionsCounseling/pickProvinceDialog';
import { BusinessError } from '@kit.BasicServicesKit';
@Entry
@Component
struct AdmissionsCounseling {

  @State selectedItem:string = '广东省'
  @State uniName: string = 'TheName'
  @State NetErrorFlag:boolean = true
  controller:CustomDialogController=new CustomDialogController({
    builder: pickProvinceDialog({
      selectedItem:$selectedItem
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
            Text(this.selectedItem)
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
            Column({ space: 10 }) {
              Text('搜索学校名称')
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bolder)
                .fontSize(20)
                .width('100%')
                .textAlign(TextAlign.Start)
              Row({ space: 50 }) {
                TextInput()
                  .backgroundColor('#c4c4c4')
                  .width('70%')
                  .height(30)
                  .borderRadius(15)
                Image($rawfile('icon/search.png'))
                  .height(30)
              }
            }

            Column({ space: 10 }) {
              Text('搜索专业类')
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bolder)
                .fontSize(20)
                .width('100%')
                .textAlign(TextAlign.Start)
              Row({ space: 50 }) {
                TextInput()
                  .backgroundColor('#c4c4c4')
                  .width('70%')
                  .height(30)
                  .borderRadius(15)
                Image($rawfile('icon/search.png'))
                  .height(30)
              }
            }

            Column({ space: 10 }) {
              Text('搜索专业名称')
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bolder)
                .fontSize(20)
                .width('100%')
                .textAlign(TextAlign.Start)
              Row({ space: 50 }) {
                TextInput()
                  .backgroundColor('#c4c4c4')
                  .width('70%')
                  .height(30)
                  .borderRadius(15)
                Image($rawfile('icon/search.png'))
                  .height(30)
              }
            }
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
                  Text('年份')
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
                  Text('人数')
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
                  Text('最低分')
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
                  Text('最高分')
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
                  Text('平均分')
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
  httpSearchPointLine_axios(){
    axios({
      method: 'GET',
      url: 'http://localhost:8080/api/getPointLine',
      params: {
        university:this.uniName
      }
    })
      .then((response: AxiosResponse<GotPointLine>)=>{
        //TODO
      })
      .catch((error:BusinessError)=>{
        console.log(error.message)
      })
  }
}