

export interface courseResponse {
  success: boolean;
  errorCode: null | number; // 可以是 null 或数字
  errorMsg: null | string; // 可以是 null 或字符串
  data: courseItem[];
}

export interface courseItem {
  id: number;
  name: string;
}