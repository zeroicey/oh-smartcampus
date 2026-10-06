import { describe, it, expect } from '@ohos/hypium'
import {
  sum,
  average,
  max,
  min,
  aggregate,
  round,
  percent,
  percentText,
  completionRate,
  toMinutes,
  averageSecondsPerQuestion,
  fillTrend,
  growthRate,
  topN,
  countBy,
  mapToRecords,
  median,
  standardDeviation,
  NumericRecord
} from '../main/ets/commons/utils/statistics'

export default function statisticsTest() {
  describe('statisticsTest', () => {
    it('sum_should_ignore_non_finite_values', 0, () => {
      expect(sum([1, 2, 3])).assertEqual(6)
      expect(sum([])).assertEqual(0)
      expect(sum([1, Number.NaN, 2])).assertEqual(3)
    })

    it('average_max_min_should_handle_empty', 0, () => {
      expect(average([])).assertEqual(0)
      expect(max([])).assertEqual(0)
      expect(min([])).assertEqual(0)
      expect(average([2, 4, 6])).assertEqual(4)
      expect(max([2, 9, 6])).assertEqual(9)
      expect(min([2, 9, 6])).assertEqual(2)
    })

    it('aggregate_should_return_all_fields', 0, () => {
      const result = aggregate([10, 20, 30])
      expect(result.total).assertEqual(60)
      expect(result.average).assertEqual(20)
      expect(result.max).assertEqual(30)
      expect(result.min).assertEqual(10)
      expect(result.count).assertEqual(3)
    })

    it('round_should_keep_digits', 0, () => {
      expect(round(1.2345, 2)).assertEqual(1.23)
      expect(round(1.2355, 2)).assertEqual(1.24)
      expect(round(Number.NaN)).assertEqual(0)
    })

    it('percent_should_guard_zero_total', 0, () => {
      expect(percent(1, 4)).assertEqual(25)
      expect(percent(1, 0)).assertEqual(0)
      expect(percentText(1, 3)).assertEqual('33.3%')
    })

    it('completionRate_should_delegate_to_percent', 0, () => {
      expect(completionRate(3, 4)).assertEqual(75)
      expect(completionRate(0, 0)).assertEqual(0)
    })

    it('toMinutes_should_convert_millis', 0, () => {
      expect(toMinutes([60000, 120000])).assertEqual(3)
      expect(toMinutes([])).assertEqual(0)
    })

    it('averageSecondsPerQuestion_should_guard_zero_questions', 0, () => {
      expect(averageSecondsPerQuestion(120000, 4)).assertEqual(30)
      expect(averageSecondsPerQuestion(120000, 0)).assertEqual(0)
    })

    it('fillTrend_should_pad_missing_dates', 0, () => {
      const records: NumericRecord[] = [
        { date: '2026-10-01', value: 1 },
        { date: '2026-10-01', value: 2 },
        { date: '2026-10-03', value: 5 }
      ]
      const trend = fillTrend(records, ['2026-10-01', '2026-10-02', '2026-10-03'])
      expect(trend.length).assertEqual(3)
      expect(trend[0].value).assertEqual(3)
      expect(trend[1].value).assertEqual(0)
      expect(trend[2].value).assertEqual(5)
    })

    it('growthRate_should_handle_zero_previous', 0, () => {
      expect(growthRate(150, 100)).assertEqual(50)
      expect(growthRate(50, 100)).assertEqual(-50)
      expect(growthRate(10, 0)).assertEqual(0)
    })

    it('topN_should_sort_descending', 0, () => {
      const records: NumericRecord[] = [
        { date: 'a', value: 1 },
        { date: 'b', value: 9 },
        { date: 'c', value: 5 }
      ]
      const top = topN(records, 2)
      expect(top.length).assertEqual(2)
      expect(top[0].date).assertEqual('b')
      expect(top[1].date).assertEqual('c')
      expect(topN(records, 0).length).assertEqual(0)
    })

    it('countBy_should_group_items', 0, () => {
      const list = [
        { chapter: '第一章' },
        { chapter: '第一章' },
        { chapter: '第二章' }
      ]
      const map = countBy(list, (item: Record<string, string>) => item.chapter)
      expect(map.get('第一章')).assertEqual(2)
      expect(map.get('第二章')).assertEqual(1)
      const records = mapToRecords(map)
      expect(records.length).assertEqual(2)
    })

    it('median_should_handle_even_and_odd', 0, () => {
      expect(median([1, 3, 2])).assertEqual(2)
      expect(median([1, 2, 3, 4])).assertEqual(2.5)
      expect(median([])).assertEqual(0)
    })

    it('standardDeviation_should_be_zero_for_constant', 0, () => {
      expect(standardDeviation([5, 5, 5])).assertEqual(0)
      expect(standardDeviation([])).assertEqual(0)
      expect(standardDeviation([2, 4, 4, 4, 5, 5, 7, 9])).assertEqual(2)
    })
  })
}
