import RecordPO from '../common/table/RecordPO';
import DBUtil from '../utils/DBUtil';
import { ColumnInfo, ColumnType } from '../viewmodel/ColumnInfo';
import relationalStore from '@ohos.data.relationalStore';

const CREATE_TABLE_SQL: string = `
CREATE TABLE IF NOT EXISTS record
(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  keep_id INTEGER NOT NULL,
  amount INTEGER NOT NULL,
  create_time INTEGER NOT NULL,
  success_amount INTEGER NOT NULL
)`

/*
数据库列信息
 */
const COLUMNS: ColumnInfo[] = [
  { name: 'id', columnName: 'id', type: ColumnType.LONG },
  { name: 'keepId', columnName: 'keep_id', type: ColumnType.LONG },
  { name: 'amount', columnName: 'amount', type: ColumnType.DOUBLE },
  { name: 'createTime', columnName: 'create_time', type: ColumnType.LONG },
  { name: 'successAmount', columnName: 'success_amount', type: ColumnType.DOUBLE }
]

/*
表明，ID列名，时间列名 常量
 */
const TABLE_NAME = 'record';
const ID_COLUMN = 'id';
const DATE_COLUMN = 'create_time';

class RecordModel {
  getCreateTableSql(): string {
    return CREATE_TABLE_SQL
  }

  /*
  增
   */
  insert(record: RecordPO) {
    return DBUtil.insert(TABLE_NAME, record, COLUMNS)
  }

  /*
  删
   */
  delete(id: number) {
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo(ID_COLUMN, id)
    return DBUtil.delete(predicates)
  }

  /*
  改
   */
  update(record: RecordPO, id: number) {
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo(ID_COLUMN, id)

    return DBUtil.update(record, COLUMNS, predicates)
  }

  /*
  查所有
   */
  queryAll(): Promise<RecordPO[]> {
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME)

    return DBUtil.queryForList(predicates, COLUMNS)
  }

  /*
  根据日期查
   */
  queryByDate(date: number): Promise<RecordPO[]> {
    let predicates = new relationalStore.RdbPredicates(TABLE_NAME)
    predicates.equalTo(DATE_COLUMN, date)

    return DBUtil.queryForList(predicates, COLUMNS)
  }
}

let recordModel = new RecordModel();

export default recordModel as RecordModel