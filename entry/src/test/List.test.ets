import localUnitTest from './LocalUnit.test';
import validatorTest from './Validator.test';
import dateUtilTest from './DateUtil.test';
import statisticsTest from './Statistics.test';

export default function testsuite() {
  localUnitTest();
  validatorTest();
  dateUtilTest();
  statisticsTest();
}
