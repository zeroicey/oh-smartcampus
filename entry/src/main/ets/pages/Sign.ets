import { promptAction } from '@kit.ArkUI';
import { HmCalendarSelectedDay } from '@ohmos/calendar';
import { CustomNavBar } from '../commons/components';
import axios, { AxiosResponse } from '@ohos/axios';
import { SignData, SignedDay } from '../models/tempModel/Interface/SignData';
import { Sign_button, Sign_calender, Sign_LearningProgress, SignDialog } from '../views/Sign/index';
import { BusinessError } from '@kit.BasicServicesKit';
import { User } from '../models';
import { UserInfo } from '../commons/utils';

interface date { date: string }

@Entry
@Component
struct Sign {
  @StorageProp(UserInfo) user: User = {} as User
  @State DateArray: Array<date> = [] //get from server
  @State signArr: Array<HmCalendarSelectedDay> = this.DateArray
  @State today: HmCalendarSelectedDay = { date: new Date().toLocaleDateString() }
  @State clickFlag: number = 1
  @State aniNum: number = 0
  @State ConsecutiveCheckIn_month: number = 1 //get//连续签到天数
  @State ConsecutiveCheckIn_all: number = 1
  @State signedDay: number = 4 //get//已签到天数
  @State rewardOfToday: string = '0' //get//今日奖励
  @State LearningPercentage: number = 8 //get//今日学习百分比
  controller: CustomDialogController = new CustomDialogController({
    builder: SignDialog({
      ConsecutiveCheckIn_month: $ConsecutiveCheckIn_month,
      ConsecutiveCheckIn_all: $ConsecutiveCheckIn_all,
      signedDay: $signedDay,
      rewardOfToday: $rewardOfToday,
      LearningPercentage: $LearningPercentage
    }),
    maskColor: '#4dcfcccc',
    customStyle: true
  })

  aboutToAppear(): void {
    this.httpSignData_axios(this.user.token, this.user.uid)
    this.httpSignContinuousSignMonthDays_axios()
    this.httpSignContinuousSignAllDays_axios()
  }

  build() {
    Column() {
      CustomNavBar({
        title: '打卡',
        showRightIcon: false,
      }).margin({ bottom: 20 })

      Sign_calender({
        signArr: $signArr,
        today: $today,
      })

      Sign_button({
        signArr: $signArr,
        clickFlag: $clickFlag,
        uid: this.user.uid,
        token: this.user.token
        //
      })

      Sign_LearningProgress({
        aniNum: $aniNum
        //
      })

      if (this.clickFlag == 3) {
        Blank().height(0).onAppear(() => {
          this.controller.open()
        })
      } else if (this.clickFlag == 4) {
        Blank().height(0).onAppear(() => {
          promptAction.showToast({ message: "网络错误，打卡失败", duration: 2000 })
        })
      }
    }
    .height('160%')
    .width('100%')
    .backgroundColor('#16151A')
  }

  httpSignData_axios(uid: string, token: string) { //每日打卡
    axios({
      method: 'GET',
      url: 'https://1fd33097.r5.cpolar.cn' + '/dayLog/find',
      params: {
        'date': time_now()
      },
      headers: {
        'Authorization': 'Bearer ' + token, //token
        'uid': uid
      }
    })
      .then((response: AxiosResponse<SignData>) => {
        console.log('GOT_res_signHistory:'+JSON.stringify(response.data));
        this.rewardOfToday = response.data.data.gotPoints //获得的分数
      }).catch((error: BusinessError) => {
      console.log('GOT_'+error.message)
    })
  }

  httpSignContinuousSignMonthDays_axios() { //获取月连续签到的天数
    axios({
      method: 'GET',
      url: 'https://1fd33097.r5.cpolar.cn' + '/taskList/getMDay', //get
      headers: {
        'Authorization': 'Bearer ' + this.user.token, //token
        'uid': this.user.uid
      }
    }).then((response: AxiosResponse<SignedDay>) => {
      console.log('GOT_res_signMonthDay:'+JSON.stringify(response.data));
      this.ConsecutiveCheckIn_month = response.data.data
      this.ConsecutiveCheckIn_month = 1
    }).catch((error: BusinessError) => {
      console.log('GOT_'+error.message)
    })
  }

  httpSignContinuousSignAllDays_axios() { //获取总连续签到的天数
    axios({
      method: 'GET',
      url: 'https://1fd33097.r5.cpolar.cn' + '/taskList/getDay', //get
      headers: {
        'Authorization': 'Bearer ' + this.user.token, //token
        'uid': this.user.uid
      }
    }).then((response: AxiosResponse<SignedDay>) => {
      console.log('GOT_res_SignAllDay:'+JSON.stringify(response.data));
      this.ConsecutiveCheckIn_all = response.data.data
      this.ConsecutiveCheckIn_all = 1
    }).catch((error: BusinessError) => {
      console.log('GOT_'+error.message)
    })
  }
}

function time_now(): string {
  const now = new Date();
  //YYYY-MM-DD HH:MM:SS
  const formattedDate = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate())
    .padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes())
    .padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`;
  return formattedDate;
}