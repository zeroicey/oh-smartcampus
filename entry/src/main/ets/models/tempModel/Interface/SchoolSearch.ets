

export interface SearchSchoolData {
  page?: number | null; // 页码
  size?: number | null; // 条数
  region?: string | null; // 地区
  secondaryMajor?: string | null; // 二级专业
  tertiaryMajor?: string | null; // 三级专业
}


export interface SearchSchool_ByName {
  page?: number | null; // 页码
  size?: number | null; // 条数
  school?: string | null;//学校名称
}


interface UniversityScoreDistributionVO {
  scoreRange: string;
  numberOfStudents: string;
}

export interface ScoreData {
  tertiaryMajor: string;
  year: string;
  school: string;
  img: string;
  faculty: string;
  minScore: string;
  averageScore: string;
  maxScore: string;
  universityScoreDistributionVOS: UniversityScoreDistributionVO[];
}

export interface SearchSchoolResponse {
  success: boolean;
  errorCode: number;
  errorMsg: string;
  data: ScoreData[];
}