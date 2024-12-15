
import { VChart } from '@visactor/harmony-vchart';

interface Event {
  item: ItemType
}

interface ItemType {
  addState(str: string): void;
}

export interface valueObjects_bar{
  type: string; //不同的分类名称
  time: string;//时间（注意统一写法）
  value: number; //占比（百分比，精确到小数点后两位）
}


@Entry
@Component
export struct BarChart {
  @State message: string = 'Hello World';
  @Prop title: string = '' //标题内容
  //可视化选择
  @Prop dataValue: Array<valueObjects_bar> = [] //获取父组件传递过来的图标数据
  @Prop legendPosition: string = 'bottom' //图例位置（L，R，T，B）
  @State spec:Record<string, string|ESObject> = {
    'color':['#ff89af','#f0cc18','#f69a18'],
    'type': 'bar',
    'data': {
      values: this.dataValue
    },
    'xField': ['time', 'type'],
    'yField': 'value',
    'seriesField': 'type',
    'bar': {
      'state': ({
        'aaa': ({
          'fill': 'red'
        } as ESObject)
      } as ESObject),
    },
    'legends': {
      "interactive":false,
      "visible": true,
      "position": "start",
      "orient": "top"
    }
  }

  aboutToAppear(): void {
    this.dataValue = getData()
  }

  build() {
    Column(){
      VChart({
        spec: this.spec,
        w: 400,
        h: 300,
        onChartInitCb: (vchart) => {
          return;
        },
        onChartReadyCb: (vchart) => {

        },
        initOption: {
          beforeRender: () => {
          },
          afterRender: () => {
          }
        }
      })

    }
    .width('100%')
    .height(300)
    .backgroundColor(Color.Pink)
  }


}

//数据示例方法
export function getData(): Array<valueObjects_bar> {
  const data: Array<valueObjects_bar> = [
    { type: 'oxygen',time:'2024-12-01', value: 46 },
    { type: 'silicon',time:'2024-12-02', value: 27 },
    { type: 'aluminum',time:'2024-12-03', value: 8 },
    { type: 'iron', time:'2024-12-04', value: 5},
    { type: 'calcium',time:'2024-12-05' , value: 3},
    { type: 'sodium',time:'2024-12-06' , value: 2},

  ]
  return data
}