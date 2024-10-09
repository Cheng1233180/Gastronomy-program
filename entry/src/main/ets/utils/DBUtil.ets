import relationalStore from '@ohos.data.relationalStore'
import common from '@ohos.app.ability.common';
import Logger from './Logger';
import { ColumnInfo, ColumnType } from '../viewmodel/ColumnInfo';
const DB_FILENAME: string = 'BaiZhanKeep.db'

class DBUtil {
  rdbStore: relationalStore.RdbStore;

  //初始化数据库
  initDB(context: common.UIAbilityContext): Promise<void> {
    let config: relationalStore.StoreConfig = {
      name: DB_FILENAME,
      //安全等级
      securityLevel: relationalStore.SecurityLevel.S1
    }
    return new Promise<void>((resolve, reject) => {
      relationalStore.getRdbStore(context, config)
        .then(rdbStore => {
          this.rdbStore = rdbStore
          Logger.debug('rdbStore 初始化完成')
          resolve()
        })
        .catch(reason => {
          Logger.debug('rdbStore 初始化异常', JSON.stringify(reason))
          reject(reason)
        })
    })
  }
  /*
  创建数据库表
   */
  createTable(createSQL: string): Promise<void> {
    return new Promise((resolve, reject) => {
      this.rdbStore.executeSql(createSQL)
        .then(() => {
          Logger.debug('成功创建表', createSQL)
          resolve()
        }).catch((err) => {
        Logger.error('创建表失败，' + err.message, JSON.stringify(err))
        reject(err)
      })
    })
  }

  /*
  增
   */
  insert(tableName: string, obj: any, columns: ColumnInfo[]) {
    return new Promise((resolve, reject) => {
      //构建新增数据
      let value = this.buildValueBucket(obj, columns)
      //实现新增
      this.rdbStore.insert(tableName, value, (err, id) => {
        if(err) {
          Logger.error('新增失败', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('新增成功，新增数据ID：' + id.toString())
          resolve(id)
        }
      })
    })
  }

  /*
  删
   */
  delete(predicates: relationalStore.RdbPredicates) {
    return new Promise((resolve, reject) => {
      this.rdbStore.delete(predicates, (err, rows) => {
        if(err) {
          Logger.error('删除失败', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('删除成功，删除第' + rows.toString() + '行数据')
          resolve(rows)
        }
      })
    })
  }

  /*
  查
   */
  queryForList<T> (predicates: relationalStore.RdbPredicates, columns: ColumnInfo[]): Promise<T[]> {
    return new Promise((resolve, reject) => {
      this.rdbStore.query(predicates, columns.map(info => info.columnName), (err, result) => {
        if(err) {
          Logger.error('查询失败', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('查询成功，查询到 ' + result.rowCount.toString() + ' 行')
          resolve(this.parseResulSet(result, columns))
        }
      })
    })
  }

  /*
  改
   */
  update(obj: any, columns: ColumnInfo[], predicates: relationalStore.RdbPredicates) {
    return new Promise((resolve, reject) => {
      let value = this.buildValueBucket(obj, columns)
      this.rdbStore.update(value, predicates, (err, id) => {
        if(err) {
          Logger.error('修改失败', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('修改成功，修改数据ID为：' + id)
          resolve(id)
        }
      })
    })
  }
  /*
  处理查询方法返回的Promise类型数据
   */
  parseResulSet<T> (result: relationalStore.ResultSet, columns: ColumnInfo[]): T[] {
    let arr = []

    if(result.rowCount <= 0) {
      return arr
    }

    //循环处理结果,循环条件：当所在行不是最后一行
    while (!result.isAtLastRow) {
      //去往下一行
      result.goToNextRow()
      //解析数据，转换成对象
      let obj = {}
      columns.forEach(info => {
        let val = null
        switch (info.type) {
          case ColumnType.LONG:
            val = result.getLong(result.getColumnIndex(info.columnName))
            break;
          case ColumnType.DOUBLE:
            val = result.getDouble(result.getColumnIndex(info.columnName))
            break;
          case ColumnType.STRING:
            val = result.getString(result.getColumnIndex(info.columnName))
            break;
          case ColumnType.BLOB:
            val = result.getBlob(result.getColumnIndex(info.columnName))
            break;
        }
        obj[info.name] = val
      })
      //将对象填入结果数组
      arr.push(obj)
      Logger.debug('查询到的数据：' + JSON.stringify(obj))
    }
    return arr
  }

  /*
  转换表中列的数据类型
   */
  buildValueBucket(obj: any, columns: ColumnInfo[]): relationalStore.ValuesBucket {
    let value = {}
    columns.forEach(info => {
      let val = obj[info.name]
      if(typeof val !== 'undefined') {
        value[info.columnName] = val
      }
    })
    return value
  }

}

let dbUtil: DBUtil = new DBUtil()
export default dbUtil as DBUtil