/**
 * 表单校验工具
 *
 * 历史代码把邮箱正则写在 InputComponent 内部，其它页面要复用时只能复制粘贴。
 * 这里统一收口，所有校验函数均为纯函数，便于单元测试。
 */

/** 邮箱：允许 a@b.cc / a.b+c@d.co 等常见形态 */
export const EMAIL_REG = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

/** 中国大陆手机号 */
export const PHONE_REG = /^1[3-9]\d{9}$/

/** 6 位数字验证码 */
export const CODE_REG = /^\d{6}$/

/** 密码：6-20 位，至少包含字母与数字 */
export const PASSWORD_REG = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*._-]{6,20}$/

/** 昵称：2-16 位，允许中英文、数字、下划线 */
export const NICKNAME_REG = /^[\u4e00-\u9fa5A-Za-z0-9_]{2,16}$/

/** http/https 链接 */
export const URL_REG = /^https?:\/\/[^\s]+$/

/** 空白字符 */
export function isBlank(value: string | null | undefined): boolean {
  return value === null || value === undefined || value.trim().length === 0
}

/** 邮箱校验 */
export function isEmail(value: string | null | undefined): boolean {
  if (isBlank(value)) {
    return false
  }
  return EMAIL_REG.test((value as string).trim())
}

/** 手机号校验 */
export function isPhone(value: string | null | undefined): boolean {
  if (isBlank(value)) {
    return false
  }
  return PHONE_REG.test((value as string).trim())
}

/** 验证码校验 */
export function isVerifyCode(value: string | null | undefined): boolean {
  if (isBlank(value)) {
    return false
  }
  return CODE_REG.test((value as string).trim())
}

/** 密码强度校验 */
export function isStrongPassword(value: string | null | undefined): boolean {
  if (isBlank(value)) {
    return false
  }
  return PASSWORD_REG.test(value as string)
}

/** 昵称校验 */
export function isNickname(value: string | null | undefined): boolean {
  if (isBlank(value)) {
    return false
  }
  return NICKNAME_REG.test((value as string).trim())
}

/** 链接校验 */
export function isUrl(value: string | null | undefined): boolean {
  if (isBlank(value)) {
    return false
  }
  return URL_REG.test((value as string).trim())
}

/** 字符串长度区间校验（闭区间） */
export function lengthBetween(value: string | null | undefined, min: number, max: number): boolean {
  if (value === null || value === undefined) {
    return false
  }
  const len = value.length
  return len >= min && len <= max
}

/** 数字区间校验（闭区间） */
export function numberBetween(value: number, min: number, max: number): boolean {
  if (Number.isNaN(value) || !Number.isFinite(value)) {
    return false
  }
  return value >= min && value <= max
}

/** 密码强度评级：0 弱 / 1 中 / 2 强 */
export function passwordStrength(value: string): number {
  if (!value) {
    return 0
  }
  let score = 0
  if (value.length >= 8) {
    score++
  }
  if (/[A-Za-z]/.test(value) && /\d/.test(value)) {
    score++
  }
  if (/[^A-Za-z0-9]/.test(value)) {
    score++
  }
  if (score >= 3) {
    return 2
  }
  if (score === 2) {
    return 1
  }
  return 0
}

/** 校验结果，用于统一描述「通过与否 + 失败原因」 */
export interface ValidationResult {
  valid: boolean
  message: string
}

/** 组合校验：全部通过才返回 valid */
export function validateAll(rules: ValidationResult[]): ValidationResult {
  for (const rule of rules) {
    if (!rule.valid) {
      return rule
    }
  }
  return { valid: true, message: '' }
}

/** 生成邮箱校验结果 */
export function validateEmail(value: string): ValidationResult {
  if (isBlank(value)) {
    return { valid: false, message: '请输入邮箱' }
  }
  if (!isEmail(value)) {
    return { valid: false, message: '邮箱格式不正确' }
  }
  return { valid: true, message: '' }
}

/** 生成密码校验结果 */
export function validatePassword(value: string): ValidationResult {
  if (isBlank(value)) {
    return { valid: false, message: '请输入密码' }
  }
  if (!isStrongPassword(value)) {
    return { valid: false, message: '密码需为 6-20 位且包含字母与数字' }
  }
  return { valid: true, message: '' }
}

/** 生成昵称校验结果 */
export function validateNickname(value: string): ValidationResult {
  if (isBlank(value)) {
    return { valid: false, message: '请输入昵称' }
  }
  if (!isNickname(value)) {
    return { valid: false, message: '昵称为 2-16 位中英文、数字或下划线' }
  }
  return { valid: true, message: '' }
}
