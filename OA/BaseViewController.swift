//
//  BaseViewController.swift
//  FSZCItem
//
//  Created by 东正 on 16/3/10.
//  Copyright © 2016年 Mrshan. All rights reserved.
//

import UIKit

var _globalgodflag = 0

class BaseViewController: UIViewController {
    var conn = Reachability.reachabilityForInternetConnection()
    var netWorkStateInBase = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        autonetwork()
        netWorkStateInBase = checkNetworkStatus()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /**
     注销操作
     */
    deinit {
        conn.stopNotifier()
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    //主动监测网络
    func autonetwork(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "networkStatusChange", name: kReachabilityChangedNotification, object: nil)
        conn.startNotifier()
    }
    
    func networkStatusChange() {
        self.checkNetworkStatus()
    }
    
    func checkNetworkStatus()->Bool {
        var ifuse = 0
        //检测wifi
        let wifi = Reachability.reachabilityForLocalWiFi();
        if wifi.currentReachabilityStatus() == ReachableViaWiFi {
            ifuse = 1
        }else {
        }
        // 检测蜂窝网络
        if wifi.currentReachabilityStatus() == ReachableViaWWAN {
            ifuse = 1
        }else {
            
        }
        
        let connection = Reachability.reachabilityForInternetConnection();
        if connection.currentReachabilityStatus() != NotReachable {
            ifuse = 1
        }
        
        if(ifuse == 1){
            _globalgodflag = 0
            print("net work is ok")
            netstateschanged(true)
            return true
        }else{
            netstateschanged(false)
            if(_globalgodflag == 0){
                _globalgodflag = 1
               print("net work is fail")
            }
            return false
        }
    }
    
    /**
     主动调用这个方法 mrshan 2016.3.30
     
     - parameter usableordisusable: 网络是否可用
     */
    func netstateschanged(usableordisusable:Bool){
        netWorkStateInBase = usableordisusable
    }
    
}
