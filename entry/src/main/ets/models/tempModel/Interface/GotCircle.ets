export interface GotCircle {
  success: boolean;
  errorCode: number | null;
  errorMsg: string | null;
  data: circleItem[];
}

export interface circleItem {
  circleId: string;
  avatar: string;
  name: string;
}