import { VChart } from '@visactor/harmony-vchart';

//import { Refresh } from '@arkts/5.0/components';
interface Event {
  item: ItemType
}

interface ItemType {
  addState(str: string): void;
}

export interface ValueObjects_rose {
  type: string; //名称
  value: string; //占比（百分比，精确到小数点后两位）
}

@Component
export struct roseChart {
  @Prop title: string = '' //标题内容
  //可视化选择
  @Prop dataValue: Array<ValueObjects_rose> = [] //获取父组件传递过来的图标数据
  @Prop legendPosition: string = 'bottom' //图例位置（L，R，T，B）
  @State spec: Record<string, string | ESObject> = {
    'color': ['#ff89af', '#f0cc18', '#f69a18'],
    'type': 'rose',
    'data': {
      values: this.dataValue
    },
    "outerRadius": 0.8,
    "innerRadius": 0.2,
    "categoryField": "type",
    "valueField": "value",
    "seriesField": "type",
    'legends': {
      "interactive": false
    },
    'label': {
      'visible': true,
      'layout': ({
        'tangentConstraint': false
      }) as ESObject
    },

  };



  build() {
    Row() {
      Column() {
        VChart({
          spec: this.spec,
          w: 400,
          h: 300,
          onChartInitCb: (vchart) => {
            return;
          },
          onChartReadyCb: (vchart) => {
            vchart.on('touchstart', { level: 'mark', type: 'pie' }, (e: Event) => {
              e.item.addState('aaa')
            })
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
    }
    .height(300)
  }
}

//数据示例方法
export function getData(): Array<ValueObjects_rose> {
  const data: Array<ValueObjects_rose> = [
    { type: 'oxygen', value: '46.60' },
    { type: 'silicon', value: '27.72' },
    { type: 'aluminum', value: '8.13' },
    { type: 'iron', value: '5' },
    { type: 'calcium', value: '3.63' },
    { type: 'sodium', value: '2.83' },
    { type: 'potassium', value: '2.59' },
    { type: 'others', value: '3.5' }
  ]
  return data
}