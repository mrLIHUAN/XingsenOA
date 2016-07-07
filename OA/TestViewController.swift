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
