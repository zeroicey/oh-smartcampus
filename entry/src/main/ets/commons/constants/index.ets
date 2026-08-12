/**
 * 全局常量出口
 *
 * 约定：
 * 1. 事件名（emitter）统一以 EVENT 结尾；
 * 2. 路由地址统一以 ROUTE_ 开头，值必须与 resources/base/profile/main_pages.json 一致；
 * 3. 本地存储键统一以 STORAGE_KEY_ 开头；
 * 4. 接口路径统一放在 API 对象中集中维护，禁止在页面里散落字符串。
 */

// ---------------------------------------------------------------------------
// 事件
// ---------------------------------------------------------------------------

/** 登录成功后广播，个人中心等页面监听刷新用户数据 */
export const LOGIN_EVENT = 'LOGIN_EVENT'

/** 退出登录后广播 */
export const LOGOUT_EVENT = 'LOGOUT_EVENT'

/** 笔记发布/编辑成功后广播，用于通知列表刷新 */
export const NOTE_CHANGED_EVENT = 'NOTE_CHANGED_EVENT'

/** 打卡成功后广播 */
export const SIGN_SUCCESS_EVENT = 'SIGN_SUCCESS_EVENT'

// ---------------------------------------------------------------------------
// 路由
// ---------------------------------------------------------------------------

export const ROUTE_INDEX = 'pages/Index'
export const ROUTE_LOGIN = 'pages/Login/Login'
export const ROUTE_REGISTRATION = 'pages/Login/Registration'
export const ROUTE_RESET_PASSWORD = 'pages/Login/ResetPassword'
export const ROUTE_ENCRYPTED = 'pages/Login/Encrypted'
export const ROUTE_INFORMATION_EDIT = 'pages/Mine/InformationEdite'
export const ROUTE_IN_CIRCLE_CONTENT = 'pages/InCircleContent'
export const ROUTE_SIGN = 'pages/Sign'
export const ROUTE_AI_NOTE = 'pages/AINote'
export const ROUTE_AI_CHAT = 'pages/AIChat'
export const ROUTE_EDIT_NOTE = 'pages/EditNote'
export const ROUTE_ADMISSIONS_COUNSELING = 'pages/AdmissionsCounseling'
export const ROUTE_IMG_PREVIEW = 'pages/ImgPreview'
export const ROUTE_BRUSH_PROBLEM = 'pages/BrushProblem'
export const ROUTE_ANSWER = 'pages/Answer'
export const ROUTE_CHAT_HISTORY = 'pages/ChatHistory'
export const ROUTE_NOTE = 'pages/Note'
export const ROUTE_TOPIC_LIST = 'pages/TopicList'
export const ROUTE_HISTORY_DETAIL = 'pages/HistoryDetail'
export const ROUTE_RE_EDIT = 'pages/reEdit'
export const ROUTE_HARDWARE_CONTROLLER = 'pages/HardwareControler'
export const ROUTE_DEEPSEEK = 'pages/Deepseek'
export const ROUTE_SHARE_NOTES = 'pages/ShareNotes'
export const ROUTE_ABOUT = 'pages/About'

// ---------------------------------------------------------------------------
// 本地存储
// ---------------------------------------------------------------------------

/** 用户信息（PersistentStorage，见 commons/utils/Auth.ets） */
export const STORAGE_KEY_USER = 'user'
/** 埋点队列 */
export const STORAGE_KEY_TRACKING = 'time-list'
/** preferences 数据库名 */
export const STORAGE_NAME_TRACKING = 'tracking-store'
/** preferences 数据库名：搜索历史 */
export const STORAGE_NAME_SEARCH = 'search-store'
/** 搜索历史键 */
export const STORAGE_KEY_SEARCH_HISTORY = 'search-history'
/** 埋点单次上报阈值 */
export const TRACKING_REPORT_THRESHOLD = 5
/** 搜索历史最大保留条数 */
export const SEARCH_HISTORY_LIMIT = 20

// ---------------------------------------------------------------------------
// 接口路径
// ---------------------------------------------------------------------------

export const API = {
  // 认证
  SEND_EMAIL: '/send/email',
  TOKEN: '/auth/token',
  // 知识圈
  CIRCLE_FIND_ALL: '/circle/findAll',
  TOPIC_FIND: '/topic/findTopic',
  // 笔记
  NOTE_QUERY_BATCH: '/note/queryBatch',
  NOTE_FIND_NOTE: '/note/find_note',
  NOTE_SAVE_NOTE: '/note/get_save_note',
  NOTE_FIND_COLLECT: '/note/findUserCollectNote',
  // 题库
  QUESTION_CHAPTER: '/question/getChapterBySubjectId',
  QUESTION_BY_CHAPTER: '/question/getQuestionByChapterId',
  QUESTION_BY_CONTEXT: '/question/getQuestionByCircleContext',
  QUESTION_ANSWER_UPLOAD: '/question/answerUpload',
  // 打卡
  DAY_LOG_FIND: '/dayLog/find',
  TASK_LIST_MONTH_DAY: '/taskList/getMDay',
  TASK_LIST_ALL_DAY: '/taskList/getDay'
}

// ---------------------------------------------------------------------------
// 业务枚举
// ---------------------------------------------------------------------------

/** 分页默认值 */
export const DEFAULT_PAGE = 1
export const DEFAULT_PAGE_SIZE = 10

/** 验证码倒计时秒数 */
export const EMAIL_COUNTDOWN_SECONDS = 60

/** 首页侧边栏动画时长（毫秒） */
export const SIDEBAR_ANIMATION_DURATION = 200
