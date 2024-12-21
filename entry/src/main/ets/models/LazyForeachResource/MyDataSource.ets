import { BasicDataSource } from './BasicDataSource';

export class MyDataSource<T> extends BasicDataSource<T> {
  private dataArray: T[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): T {
    if (index < 0 || index > this.dataArray.length - 1) {
      throw new RangeError('index范围异常');
    }
    // console.info('获取元素, 当前索引为: ', index);
    return this.dataArray[index];
  }

  public addData(index: number, data: T): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: T): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
    // super.notifyDataAdd(this.dataSource.length - 1);
  }
}