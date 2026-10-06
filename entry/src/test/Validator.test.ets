import { describe, it, expect } from '@ohos/hypium'
import {
  isBlank,
  isEmail,
  isPhone,
  isVerifyCode,
  isStrongPassword,
  isNickname,
  isUrl,
  lengthBetween,
  numberBetween,
  passwordStrength,
  validateAll,
  validateEmail,
  validatePassword,
  validateNickname
} from '../main/ets/commons/utils/validator'

export default function validatorTest() {
  describe('validatorTest', () => {
    it('isBlank_should_detect_empty_values', 0, () => {
      expect(isBlank('')).assertTrue()
      expect(isBlank('   ')).assertTrue()
      expect(isBlank(null)).assertTrue()
      expect(isBlank(undefined)).assertTrue()
      expect(isBlank('a')).assertFalse()
    })

    it('isEmail_should_accept_common_formats', 0, () => {
      expect(isEmail('student@example.com')).assertTrue()
      expect(isEmail('a.b+c@sub.domain.cn')).assertTrue()
      expect(isEmail('  trimmed@example.com  ')).assertTrue()
    })

    it('isEmail_should_reject_invalid_formats', 0, () => {
      expect(isEmail('student@')).assertFalse()
      expect(isEmail('@example.com')).assertFalse()
      expect(isEmail('student.example.com')).assertFalse()
      expect(isEmail('')).assertFalse()
    })

    it('isPhone_should_validate_mainland_number', 0, () => {
      expect(isPhone('13800138000')).assertTrue()
      expect(isPhone('19912345678')).assertTrue()
      expect(isPhone('12345678901')).assertFalse()
      expect(isPhone('1380013800')).assertFalse()
    })

    it('isVerifyCode_should_require_six_digits', 0, () => {
      expect(isVerifyCode('123456')).assertTrue()
      expect(isVerifyCode('12345')).assertFalse()
      expect(isVerifyCode('12345a')).assertFalse()
    })

    it('isStrongPassword_should_require_letter_and_digit', 0, () => {
      expect(isStrongPassword('abc123')).assertTrue()
      expect(isStrongPassword('abcdef')).assertFalse()
      expect(isStrongPassword('123456')).assertFalse()
      expect(isStrongPassword('a1')).assertFalse()
    })

    it('isNickname_should_allow_chinese_and_underscore', 0, () => {
      expect(isNickname('小明')).assertTrue()
      expect(isNickname('user_01')).assertTrue()
      expect(isNickname('a')).assertFalse()
      expect(isNickname('这个昵称实在是太长了超过十六个字符限制')).assertFalse()
    })

    it('isUrl_should_require_http_scheme', 0, () => {
      expect(isUrl('https://example.com/a')).assertTrue()
      expect(isUrl('http://example.com')).assertTrue()
      expect(isUrl('example.com')).assertFalse()
    })

    it('lengthBetween_should_use_closed_interval', 0, () => {
      expect(lengthBetween('abc', 3, 5)).assertTrue()
      expect(lengthBetween('ab', 3, 5)).assertFalse()
      expect(lengthBetween(null, 0, 5)).assertFalse()
    })

    it('numberBetween_should_reject_nan', 0, () => {
      expect(numberBetween(5, 1, 10)).assertTrue()
      expect(numberBetween(0, 1, 10)).assertFalse()
      expect(numberBetween(Number.NaN, 1, 10)).assertFalse()
    })

    it('passwordStrength_should_return_level', 0, () => {
      expect(passwordStrength('')).assertEqual(0)
      expect(passwordStrength('abc12345')).assertEqual(1)
      expect(passwordStrength('Abc12345!')).assertEqual(2)
    })

    it('validateAll_should_return_first_failure', 0, () => {
      const result = validateAll([
        { valid: true, message: '' },
        { valid: false, message: '密码格式不正确' }
      ])
      expect(result.valid).assertFalse()
      expect(result.message).assertEqual('密码格式不正确')
    })

    it('validateEmail_should_return_message', 0, () => {
      expect(validateEmail('').message).assertEqual('请输入邮箱')
      expect(validateEmail('bad').message).assertEqual('邮箱格式不正确')
      expect(validateEmail('ok@example.com').valid).assertTrue()
    })

    it('validatePassword_should_return_message', 0, () => {
      expect(validatePassword('').message).assertEqual('请输入密码')
      expect(validatePassword('123').message).assertEqual('密码需为 6-20 位且包含字母与数字')
      expect(validatePassword('abc123').valid).assertTrue()
    })

    it('validateNickname_should_return_message', 0, () => {
      expect(validateNickname('').message).assertEqual('请输入昵称')
      expect(validateNickname('a').valid).assertFalse()
      expect(validateNickname('小研').valid).assertTrue()
    })
  })
}
