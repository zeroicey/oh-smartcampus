

export interface SearchSchoolData {
  page?: number | null; // 页码
  size?: number | null; // 条数
  region?: string | null; // 地区
  secondaryMajor?: string | null; // 二级专业
  tertiaryMajor?: string | null; // 三级专业
  universityLevel?: string | null; // 院校级别
}

export interface SearchSchoolResponseData {
  success?: boolean | null
  errorCode?: number | null
  errMsg?: string | null
  data:Array<SearchSchoolData>
}

export interface SearchSchool_ByName {
  page?: number | null; // 页码
  size?: number | null; // 条数
  school?: string | null;//学校名称
}