//
//  AppDelegate.swift
//  OA
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UIAlertViewDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
//        MAMapServices.sharedServices().apiKey = ""
//        AMapSearchServices.sharedServices().apiKey = ""
        
        AMapLocationServices.sharedServices().apiKey = GAODE_MAP_APPKEY

        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.window?.backgroundColor = UIColor.whiteColor()
        
    
        let vc = ViewController()
        
        
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = vc
        
        
        if isCheckUpIsNew{
            checkUpIsNew()
        }
        
        // Override point for customization after application launch.
        return true
    }
    
    var appKey = ""
    func checkUpIsNew(){
        
        
//    这是正式库的检测更新   ["shortcut":"H01U","_api_key":"168f7331368cfabd37b093cbb3103db1"]
//    这是测试库的检测更新   ["shortcut":"UYGx","_api_key":"8c0b4fed91adff6b4192a3801436ecc7"]
        
        NetWorkCore.checkUPWithURL(PUGongYingAPI, parameters: GLOBAL_CheckUp_Parameters, Success: { [weak self](response) -> () in
            
            
            let newData = response["data"] as! NSDictionary
            self!.appKey = newData["appKey"] as! String
            let version = newData["appVersion"] as! String
            let stateVersion =  NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as!String
            if((version as NSString).isEqual((stateVersion as NSString))){
                
            }else{
                let alertive = UIAlertView(title: "发现新版本,是否前去更新", message: "", delegate: self! , cancelButtonTitle: nil , otherButtonTitles: "前往")
                alertive.show()
            }
            
            }) { (str) -> () in
                
        }
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex == 0){
            UIApplication.sharedApplication().openURL(NSURL(string: "http://www.pgyer.com/apiv1/app/install?_api_key=\(GLOBAL_Api_Key)&aKey=\(appKey)")!)
        }
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    
    func applicationWillEnterForeground(application: UIApplication) {
        
        
        if isCheckUpIsNew{
            checkUpIsNew()
        }

        
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

