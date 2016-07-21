//
//  TestViewController.swift
//  OA
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class TestViewController: UIViewController,AMapLocationManagerDelegate {

    var locationManagerOne = AMapLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.view.backgroundColor = UIColor.redColor()
        locationManagerOne.delegate = self
        locationManagerOne.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManagerOne.startUpdatingLocation()
        
        
        var button = UIButton()
        button.frame = CGRectMake(0, 0, 150, 200)
        button.backgroundColor = UIColor.yellowColor()
        self.view.addSubview(button)
        button.addTarget(self, action: "press", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func press() {
        _ = PingNetTool { (resultString) -> Void in
            if resultString == "0" {
                
            }else{
                print("shit")
            }
        }
    }
    
    func amapLocationManager(manager: AMapLocationManager!, didUpdateLocation location: CLLocation!) {
        
        print("xixi")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
