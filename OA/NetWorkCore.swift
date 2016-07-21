//
//  NetWorkCore.swift
//  OA
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

import Alamofire

class NetWorkCore: NSObject {
    
    
    class func checkUPWithURL(url : String,parameters : [String:AnyObject],Success : (response1 : NSDictionary) ->(),fail:(str: String)->()) {
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: ParameterEncoding.URL, headers: nil).responseJSON { response -> Void in
            
            if let JSON = response.result.value {
                Success(response1: JSON as! NSDictionary)
            }else{
                fail(str: "获取app信息失败")
            }
        }
    }
    
    class func upLoadWithURL(url : String, data : NSData ,success : (respones : NSDictionary)->(),fail:(str:String)->()) {
        
        Alamofire.upload(.POST, url, multipartFormData: { (data1 :MultipartFormData) -> Void in
            
            data1 .appendBodyPart(data: data, name: "file", fileName: "fileName.png", mimeType:"image/png")
            
            }) { (result) -> Void in
                
                switch result {
                    
                case .Success(let upload, _, _):
                    upload.responseJSON(completionHandler: { (Response) -> Void in
                        
                        if let rush = Response.result.value as? NSDictionary {
                        
                            print(rush)
                            success(respones: rush)
                            
                        }else {
                            fail(str: "网络通讯异常，请重试。")
                            
                            return
                        
                        }
                        
                       
                        
//                        if let rush = Response.result.value as? [String:String] {
//                            //这里的rush信息必然不是NIL，如果为NIL 则提示应该有的错误信息
//                            for eachItem in rush {
//                                print(eachItem)
//                            }
//                        }else{
//                            
//                        }
//                        
                    })
//
                    break
                case .Failure(let err):
                    
                    print(err)
                    
                    break
                default:
                    break
                
                }
        }
    }
    
 
    /**JSON字符串转字典*/
    class func parseJSONStringToNSDictionary(JSONString : String)->NSDictionary{
        
        let JSONData = JSONString .dataUsingEncoding(NSUTF8StringEncoding)
        
        let responseJSON = try! NSJSONSerialization .JSONObjectWithData(JSONData!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary
        
        return responseJSON
    }
    
    
    /**字典转JSON字符串*/
    class func dictionaryToJson(dic : NSDictionary)->String {
        let JSONdata = try! NSJSONSerialization .dataWithJSONObject(dic, options: NSJSONWritingOptions.PrettyPrinted)
        
        return String(data: JSONdata, encoding: NSUTF8StringEncoding)!
    }
}
