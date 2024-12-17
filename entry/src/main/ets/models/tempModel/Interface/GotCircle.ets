export interface GotCircle {
  success: boolean;
  errorCode: number | null;
  errorMsg: string | null;
  data: circleItem[];
}

export interface circleItem {
  circledId: string;
  avatar: string;
  name: string;
}