//
//  ConfigManage.swift
//  OA
//
//  Created by apple on 16/6/8.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
//                正式：http://183.62.9.226:2001
//                测试：http://183.62.9.226:2002

//"http://192.168.1.39:1000"
let GLOBAL_IPADDRESS_API = "http://183.62.9.226:2001"


//这是正式库的检测更新   ["shortcut":"H01U","_api_key":"168f7331368cfabd37b093cbb3103db1"]
//这是测试库的检测更新   ["shortcut":"UYGx","_api_key":"8c0b4fed91adff6b4192a3801436ecc7"]

let GLOBAL_CheckUp_Parameters = ["shortcut":"H01U","_api_key":"168f7331368cfabd37b093cbb3103db1"]
let GLOBAL_Api_Key            = "168f7331368cfabd37b093cbb3103db1"
//===============================================================================================
/*
高德地图APPKEY,高德webapikey
*/
//测试：55807fb165970e1d37da7429fce4dec5
//正式：7b380a54dbc5bad9df10c7d101d59ed7
let GAODE_MAP_APPKEY = "7b380a54dbc5bad9df10c7d101d59ed7"

//http://www.pgyer.com/apiv1/app/getAppKeyByShortcut
/*
蒲公英检查更新
*/
let PUGongYingAPI = "http://www.pgyer.com/apiv1/app/getAppKeyByShortcut"

//===============================================================================================

/*
判断是否需要JS交互 1：有交互 0：没有交互
*/
let isCallJS = "1"
/*
是否需要检查更新 true 
*/
let isCheckUpIsNew = true


//(此处必须写成这样因为我不想改里面😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊)
/*
JS调用原生时使用 callWithDict（参数是Json类型的字符串）

JSON 字符串 参数：type = 0（定位）1（拍照）3（打电话）4（记住密码）5（获取设备的广告标识符、设备信息）

callWithDict(params : String)
*/




//(此处写的可以更改因为很强壮😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄😄)
/*
原生调用JS方法给JS传递参数
*/

//调用JS方法传递定位信息
let getlocationInfo   = "getUserGroundInfo"

//拍照完成后上传图片->上传成功后返回图片的URL->然后上传URL到H5
let getUserImgUrl     = "getUserImgUrl"

//获得设备的类型（adID 、设备型号）
let getDevicetype     = "getappimei"

//此处写的是用于系统级别的存储
let BundleID          = "com.dzkj.hanxs.xinsen1"








