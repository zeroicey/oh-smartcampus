import { describe, it, expect } from '@ohos/hypium'
import {
  format,
  shortDateTime,
  weekName,
  isSameDay,
  startOfDay,
  endOfDay,
  daysBetween,
  fromNow,
  humanizeDuration,
  humanizeMinutes,
  recentDays,
  continuousDays,
  ONE_DAY_MS
} from '../main/ets/commons/utils/dateUtil'

export default function dateUtilTest() {
  describe('dateUtilTest', () => {
    // 2026-10-06 08:05:07.123 本地时间
    const sample = new Date(2026, 9, 6, 8, 5, 7, 123).getTime()

    it('format_should_support_pattern', 0, () => {
      expect(format(sample, 'YYYY-MM-DD')).assertEqual('2026-10-06')
      expect(format(sample, 'HH:mm:ss')).assertEqual('08:05:07')
      expect(format(sample, 'YYYY-MM-DD HH:mm:ss')).assertEqual('2026-10-06 08:05:07')
      expect(format(sample, 'SSS')).assertEqual('123')
    })

    it('format_should_return_empty_for_invalid_input', 0, () => {
      expect(format(Number.NaN)).assertEqual('')
    })

    it('shortDateTime_should_use_month_day', 0, () => {
      expect(shortDateTime(sample)).assertEqual('10-06 08:05')
    })

    it('weekName_should_map_day_of_week', 0, () => {
      // 2026-10-06 是周二
      expect(weekName(sample)).assertEqual('周二')
    })

    it('isSameDay_should_compare_calendar_day', 0, () => {
      const morning = new Date(2026, 9, 6, 1, 0, 0).getTime()
      const night = new Date(2026, 9, 6, 23, 59, 0).getTime()
      const nextDay = new Date(2026, 9, 7, 0, 0, 1).getTime()
      expect(isSameDay(morning, night)).assertTrue()
      expect(isSameDay(morning, nextDay)).assertFalse()
    })

    it('startOfDay_and_endOfDay_should_cover_full_day', 0, () => {
      const start = startOfDay(sample)
      const end = endOfDay(sample)
      expect(end - start).assertEqual(ONE_DAY_MS - 1)
      expect(new Date(start).getHours()).assertEqual(0)
      expect(new Date(end).getMilliseconds()).assertEqual(999)
    })

    it('daysBetween_should_ignore_time_part', 0, () => {
      const a = new Date(2026, 9, 1, 23, 0, 0).getTime()
      const b = new Date(2026, 9, 2, 1, 0, 0).getTime()
      expect(daysBetween(a, b)).assertEqual(1)
      expect(daysBetween(b, a)).assertEqual(-1)
    })

    it('fromNow_should_describe_relative_time', 0, () => {
      const base = new Date(2026, 9, 6, 12, 0, 0).getTime()
      expect(fromNow(base - 10 * 1000, base)).assertEqual('刚刚')
      expect(fromNow(base - 5 * 60 * 1000, base)).assertEqual('5分钟前')
      expect(fromNow(base - 3 * 60 * 60 * 1000, base)).assertEqual('3小时前')
      expect(fromNow(base - 2 * ONE_DAY_MS, base)).assertEqual('2天前')
      expect(fromNow(base - 30 * ONE_DAY_MS, base)).assertEqual('2026-09-06')
    })

    it('humanizeDuration_should_build_readable_text', 0, () => {
      expect(humanizeDuration(0)).assertEqual('0秒')
      expect(humanizeDuration(3661000)).assertEqual('1小时1分1秒')
      expect(humanizeDuration(60000)).assertEqual('1分')
    })

    it('humanizeMinutes_should_build_readable_text', 0, () => {
      expect(humanizeMinutes(0)).assertEqual('0分钟')
      expect(humanizeMinutes(45)).assertEqual('45分钟')
      expect(humanizeMinutes(60)).assertEqual('1小时')
      expect(humanizeMinutes(95)).assertEqual('1小时35分')
    })

    it('recentDays_should_return_ascending_dates', 0, () => {
      const base = new Date(2026, 9, 6, 12, 0, 0).getTime()
      const days = recentDays(3, base)
      expect(days.length).assertEqual(3)
      expect(days[0]).assertEqual('2026-10-04')
      expect(days[2]).assertEqual('2026-10-06')
    })

    it('continuousDays_should_count_from_today', 0, () => {
      const list = ['2026-10-06', '2026-10-05', '2026-10-04', '2026-10-01']
      expect(continuousDays(list, '2026-10-06')).assertEqual(3)
    })

    it('continuousDays_should_return_zero_when_today_missing', 0, () => {
      const list = ['2026-10-05', '2026-10-04']
      expect(continuousDays(list, '2026-10-06')).assertEqual(0)
      expect(continuousDays([], '2026-10-06')).assertEqual(0)
    })
  })
}
