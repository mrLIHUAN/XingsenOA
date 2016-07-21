//
//  PingNetTool.swift
//  OA
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

var RequestSuccessAction : [String : (resultString:String)->Void] = [:]

class PingNetTool: NSObject {
    
    
    init(PingNet : (resultString:String)->Void){
    
        super.init()
        RequestSuccessAction[String(self.hashValue)] = PingNet
    
        SimplePingHelper.ping("www.baidu.com", target: self, sel: "checkNetworkWithPinghelper:")

    }
    
    
    func checkNetworkWithPinghelper(sender : NSNumber){

        print(sender)
        if (sender.boolValue){
            
            
            RequestSuccessAction[String(self.hashValue)]!(resultString: "1")
            
            
        }else{
            
            RequestSuccessAction[String(self.hashValue)]!(resultString: "0")
            
            
       }
        
        
    }
    
    
    
    

}
