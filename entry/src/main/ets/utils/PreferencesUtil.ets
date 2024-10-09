import preferences from '@ohos.data.preferences';
import Logger from './Logger';

/**
 * 首选项工具类
 */
class PreferenceUtil{
  private pref: preferences.Preferences

  //加载首选项
  async loadPreference(context){
    try {
      //异步处理，获取名为BaiZhanKeepStore的首选项值
      this.pref = await preferences.getPreferences(context, 'BaiZhanKeepStore')
      Logger.debug(`加载Preferences[BaiZhanKeepStore]成功`)
    } catch (e) {
      Logger.debug(`加载Preferences[BaiZhanKeepStore]失败`, JSON.stringify(e))
    }
  }

  //写入首选项值
  async putPreferenceValue(key: string, value: preferences.ValueType){
    if (!this.pref) {
      Logger.debug(`Preferences[BaiZhanKeepStore]尚未初始化！`)
      return
    }
    try {
      // 写入数据
      await this.pref.put(key, value)
      // 刷盘
      await this.pref.flush()
      Logger.debug(`保存Preferences[${key} = ${value}]成功`)
    } catch (e) {
      Logger.debug(`保存Preferences[${key} = ${value}]失败`, JSON.stringify(e))
    }
  }

  //获取首选项值
  async getPreferenceValue(key: string, defaultValue: preferences.ValueType){
    if (!this.pref) {
      Logger.debug(`Preferences[BaiZhanKeepStore]尚未初始化！`)
      return
    }
    try {
      // 读数据
      let value = await this.pref.get(key, defaultValue)
      Logger.debug(`读取Preferences[${key} = ${value}]成功`)
      return value
    } catch (e) {
      Logger.debug(`读取Preferences[${key}]失败`, JSON.stringify(e))
    }
  }
}

const preferenceUtil = new PreferenceUtil()

export default preferenceUtil as PreferenceUtil