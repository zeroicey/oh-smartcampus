

export interface GotPointLine {
  success: boolean;
  errorMsg: string | null;
  data: schoolInfItem[];
  total: number | null;
}

interface schoolInfItem {
  id: number;
  academy: string;
  admissions: number;
  averageScore: number;
  highestScore: number;
  major: string;
  minimumScore: number;
  province: string;
  school: string;
  year: number;
}