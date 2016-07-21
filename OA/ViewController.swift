//
//  ViewController.swift
//  OA
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

import Alamofire
import JavaScriptCore
import AVFoundation
import AdSupport
import MBProgressHUD
import Security

class ViewController: BaseViewController,UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,JSAndSwiftModdleDelegate,AMapLocationManagerDelegate,AMapSearchDelegate{

    var webView : UIWebView!
    var imageView1 : UIImageView!
    
    var locationManager = AMapLocationManager()
    
    var jscontext: JSContext?
    
    var _isNetOK : Bool = true
    
    
    var timer : NSTimer!
    
    var locationDic : NSDictionary!
    //大菊花
//    var indicatorView = UIActivityIndicatorView()
    
    var HUD : MBProgressHUD!
    
    var _search : AMapSearchAPI!
    
    var coordinate : CLLocationCoordinate2D!
//    var address : String!
    
    var regeo : AMapReGeocodeSearchRequest!

    var currentCoordinate : CLLocationCoordinate2D!
    
    var pastDate : NSDate!
    
    var CenterAlertView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
                 /**配置定位*/
        configLocationManager()
//        locationManager.delegate = self
        
        /**创建WebView*/
        creatWebView()
        
        //通知--已获得html字符串，并把字符串传过来
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callUNHtml:) name:@"tongzhi" object:nil];
        
        

//        getCurrentTime()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "clickDetermine", name: "tongzhi", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "becomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "becomeDeath", name: UIApplicationWillResignActiveNotification, object: nil)
    }
    /**
     从后台进前台这个问题是解决程序推到后台时间长点击没有反应
     */
    func becomeActive(){
    
        let nowDate = getCurrentTime()
        
        var DurationTime : NSTimeInterval!
        
        if pastDate != nil{
        
            DurationTime = nowDate .timeIntervalSinceDate(pastDate)
            
            print("\(DurationTime)")
            let userName : String!
            let pwd      : String!
            
            if(NSUserDefaults.standardUserDefaults().objectForKey("userName") != nil){
                
                userName =  NSUserDefaults.standardUserDefaults().objectForKey("userName") as! String
                pwd      = NSUserDefaults.standardUserDefaults().objectForKey("pwd") as! String
            }else{
                userName = ""
                pwd      = ""
            }
            if (DurationTime > 10 * 60){
            
                let jsParamFunc = self.jscontext?.objectForKeyedSubscript("getUserlognin")
                let userNameAndpwd  = NSDictionary(dictionary: ["userName" : userName,"pwd" : pwd ])
                let dictString = dictionaryToJson(userNameAndpwd)
                jsParamFunc?.callWithArguments([dictString])
            }
        }
    }
    /**
     从前台进后台
     */
    func becomeDeath(){
        
        pastDate = getCurrentTime()
        
    }
    func getCurrentTime()-> NSDate{
        
        let currentDate = NSDate()
        
        return currentDate
    }
    
   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!_isNetOK){
            
            //没有网的情况下显示
            
            CenterAlertView.hidden = false
        }
    }
    
    override func netstateschanged(usableordisusable: Bool) {
        super.netstateschanged(usableordisusable)
        

        if (usableordisusable){
            
             _isNetOK = true
            
           
        }else{
            _isNetOK = false
            CNHUD.showHUD("网络异常，请检查网络设置！", duration: 1.5)
        }
    }
    
    //创建WebView
    func creatWebView(){
        
        webView = UIWebView(frame: CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.height - 20))
        webView.backgroundColor = UIColor.whiteColor()
        webView.userInteractionEnabled = true
        webView.scalesPageToFit = false
        webView.scrollView.bounces = false
        webView.delegate = self
        self.view .addSubview(webView)
        
         loadingHTML()
        
        
        //加载失败，请连接网络
        CenterAlertView = UIView(frame: CGRectMake(0, (self.view.frame.size.height - 60) / 2 , self.view.frame.size.width, 60))
        CenterAlertView.backgroundColor = UIColor.whiteColor()
        CenterAlertView.hidden = true
        self.view.addSubview(CenterAlertView)
        
        let alertLabel = UILabel(frame: CGRectMake(0, 0 , self.view.frame.size.width, 30))
        alertLabel.textAlignment = NSTextAlignment.Center
        alertLabel.textColor = UIColor.blackColor()
        alertLabel.font = UIFont.systemFontOfSize(16)
        alertLabel.text = "加载失败，请连接网络"
        alertLabel.backgroundColor = UIColor.whiteColor()
        CenterAlertView.addSubview(alertLabel)
        
        let reloadBtn = UIButton()
        reloadBtn.frame = CGRectMake(self.view.frame.size.width / 2 - 70 / 2 , 30, 70, 30)
        reloadBtn.backgroundColor = UIColor.whiteColor()
        reloadBtn.setTitle("重新加载", forState: UIControlState.Normal)
        reloadBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        reloadBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        reloadBtn.addTarget(self, action: "reloadHTML", forControlEvents: UIControlEvents.TouchUpInside)
        reloadBtn.layer.borderWidth = 1
        reloadBtn.layer.cornerRadius = 5
        CenterAlertView.addSubview(reloadBtn)

    }
    

    /**
     重新加载 按钮的点击事件！
     */
    func reloadHTML(){
        
        loadingHTML()
        
        //判断网络是不是成功，成功的话隐藏提示
        if(_isNetOK){
            
            CenterAlertView.hidden = true
            
        }
        
        
    }
    
    
    
    /**
     加载HTML
     */
    func loadingHTML(){

        let url : NSURL!
        //判断用户名是否存在，如果有就拼在URL后面，没有就不用拼
        if(NSUserDefaults.standardUserDefaults().objectForKey("userName") != nil){
            
            let userName =  NSUserDefaults.standardUserDefaults().objectForKey("userName") as! String
            let pwd      = NSUserDefaults.standardUserDefaults().objectForKey("pwd") as! String
            
            url = NSURL(string: String(format: "\(GLOBAL_IPADDRESS_API)/pda/default.aspx?userName=%@&pwd=%@",userName,pwd))
            
        }else{
            
            url = NSURL(string: "\(GLOBAL_IPADDRESS_API)/pda/default.aspx?")
        }
        
        //        let url = NSURL(string: "http://192.168.1.39:1000/pda/default.aspx?userName=admin&pwd=1")
        let urlRequest = NSURLRequest(URL: url)
        
        //        NSURLCache .sharedURLCache().removeAllCachedResponses()
        //        NSURLCache.sharedURLCache().diskCapacity = 0
        //        NSURLCache.sharedURLCache().memoryCapacity = 0
        webView.loadRequest(urlRequest)
    }
    
    /**
     定时器 走的方法
     */
    func timerMethod(){
        
        timer.invalidate()
    
        //判断HUD是不是nil
        if HUD != nil {
            HUD.hide(true)
        }
        HUD = nil
        CNHUD.showHUD("网络异常，请检查网络设置！", duration: 1.5)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        if HUD == nil {
            HUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            HUD.mode = MBProgressHUDMode.Indeterminate
            HUD.labelText = "顾客为先 快速高效"
            HUD.removeFromSuperViewOnHide = true
            timer = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: "timerMethod", userInfo: nil, repeats: false)
        }
        //判断网络是不是👌，如果OK隐藏HUD
        if _isNetOK {
            
            HUD.show(true)
            
        }else{
            
            CNHUD.showHUD("网络异常，请检查网络设置！", duration: 1.5)
        }
    }
    
    
    
    
    
    //MRAK-- UIWebViewdelegate
    func webViewDidFinishLoad(webView: UIWebView) {
        
        
        timer.invalidate()
        if HUD != nil {
            HUD.hide(true)
        }
        HUD = nil
        
//    webView.stringByEvaluatingJavaScriptFromString("document.documentElement.style.webkitUserSelect='none';")
        
       //HUD.hide(true)
        
        if(isCallJS == "1" ){
            // 初始化model
            let model = JSAndSwiftMiddle()
            model.delegate = self
            //        model.controller = self
            //        model.jsContext = context
            model.webView = webView
            self.jscontext = model.jsContext
            self.jscontext?.setObject(model
                , forKeyedSubscript: "OCModel")
            self.jscontext?.exceptionHandler = { (context,exception) in
                print("exception @",exception)
            }
        }
    }
    
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){

        
        timer.invalidate()
        if HUD != nil {
            HUD.hide(true)
        }
        HUD = nil

//        webView.stringByEvaluatingJavaScriptFromString("getUserlognin")
        
    }
    
    //MARK: JSAndSwiftModdleDelegate
    //var pingHelper: PingNetTool?
    func JSCallSwiftWithDict(params : NSString) {
        
//        print(params)
        
        
        //这里的东西一定不要忘记删除....这个方法是有问题的！
//       _ = PingNetTool(PingNet: {[weak self](resultString) -> Void in
//            
//            if resultString == "0"{
//                
//                CNHUD.hidHUD()
//                CNHUD.showHUD("网络异常，请检查网络设置！", duration: 1.5)
//                
//                print("PingTool 走了没有网络+++")
//                
//                return
//            }else{
//
//                print("PingTool 走了有网络---")
//                self!.callJSWith(params)
//            }
//        })
        
        if(checkNetworkStatus()){
        
            callJSWith(params)
        }else{
            
            CNHUD.hidHUD()
            CNHUD.showHUD("网络异常，请检查网络设置！", duration: 1.5)

            return
        
        }
        
        
    }
    
    func callJSWith(params : NSString){
        
    
        let paramsDic = parseJSONStringToNSDictionary(params as String)
        
        let type = paramsDic.objectForKey("type") as! String
        
        if type == "0" {
            
            print("定位")
            action()
        }else if (type == "1"){
            
            print("拍照")
            SystemCamera()
        }else if (type == "3" ){
            
            let number = paramsDic.objectForKey("number") as! String
            
            let tel = "telprompt://" + number
            //从这拨打电话
            UIApplication.sharedApplication().openURL(NSURL(string: tel)!)
            
        }else if (type == "4"){
            
            let userName = paramsDic.objectForKey("userName") as! String
            let pwd      = paramsDic.objectForKey("pwd") as! String
            
            
            NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "userName")
            NSUserDefaults.standardUserDefaults().setObject(pwd, forKey: "pwd")
        }else if (type == "5"){
            SwiftCallJSMarkAndId()
        }
    
    
    }
    
    
    
    
   
    // 定位
    func action(){

       
//        if(!_isNetOK){
//            CNHUD.hidHUD()
//            CNHUD.showHUD("网络异常，请检查网络设置！", duration: 1.5)
//            return
//        }else{
//            
//            
//        
//        }
//
//        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Denied && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Restricted {
//            
//            locationManager.requestLocationWithReGeocode(true) { [weak self](location : CLLocation!,regeocode : AMapLocationReGeocode!, error : NSError!) -> Void in
//                
////                CNHUD.hidHUD()
//                
//                if (error != nil) {
//                    
////                  self!.SwiftCallJSLocation("", longitude: "", positionInfo:"",status: "0")
//
//                    
//                    
//                    CNHUD.showHUD("定位失败，请重新定位！", duration: 1.5)
//                    
//                }else{
//                
//
//                let latitude1 = location.coordinate.latitude as Double
//                let longitude1 = location.coordinate.longitude as Double
//                
//                let latitude = String(format: "%f", latitude1)
//                let longitude = String(format: "%f", longitude1)
//                
//                print("++++++\(regeocode.formattedAddress)")
//                
//                self?.SwiftCallJSLocation(latitude, longitude: longitude, positionInfo: regeocode.formattedAddress,status: "1")
//                }
//            }
//        }else{
//            
//            print("no")
//            
//            
//            CNHUD.showHUD("定位失败，请重新定位！", duration: 1.5)
//            
////            self.SwiftCallJSLocation("", longitude: "", positionInfo:"",status: "0")
//        }
        
//        let latitude = String(format: "%.6f", coordinate.latitude)
//        let longitude = String(format: "%.6f", coordinate.longitude)
//        SwiftCallJSLocation(latitude, longitude: longitude, positionInfo:"ddd",status: "1")
        
        if coordinate != nil {
        
            reGeoSearch(coordinate)
        
//            let latitude = String(format: "%f", coordinate.latitude)
//            let longitude = String(format: "%f", coordinate.longitude)
//            
//            self.SwiftCallJSLocation(latitude, longitude: longitude, positionInfo:address,status: "1")

        }else{
        
             self.SwiftCallJSLocation("", longitude: "", positionInfo:"",status: "0")
            
            locationManager.startUpdatingLocation()
            
    }
    
    }
    
    func reGeoSearch(coordinate1 : CLLocationCoordinate2D){
        
        currentCoordinate = coordinate1
        
        _search = AMapSearchAPI()
        _search.delegate = self
        regeo = AMapReGeocodeSearchRequest()
        regeo.requireExtension = true
        regeo.location = AMapGeoPoint.locationWithLatitude(CGFloat(coordinate1.latitude), longitude: CGFloat(coordinate1.longitude))
        _search.AMapReGoecodeSearch(regeo)
    }
    
    func onReGeocodeSearchDone(request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        
        if(response.regeocode != nil){
            print("+++\(response.regeocode.formattedAddress)")
            print(currentCoordinate)
            
            let latitude = String(format: "%.6f", currentCoordinate.latitude)
            let longitude = String(format: "%.6f", currentCoordinate.longitude)
        
            self.SwiftCallJSLocation(latitude, longitude: longitude, positionInfo:response.regeocode.formattedAddress,status: "1")
            
        }else{
            
            self.SwiftCallJSLocation("", longitude: "", positionInfo:"",status: "0")
        }
    }
    
    //拍照
    func SystemCamera(){
        
        let type = AVMediaTypeVideo
        let status = AVCaptureDevice.authorizationStatusForMediaType(type)
        
        if(status == AVAuthorizationStatus.Restricted || status == AVAuthorizationStatus.Denied){
            
            let Alert = UIAlertController(title: "提示", message: "请在设置里修改本app对照片的使用权", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "设置", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
                UIApplication.sharedApplication().openURL(NSURL(string: "prefs:root=Privacy&path=Photos")!)
            })
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (action:UIAlertAction) -> Void in
            })
            
            Alert.addAction(cancelAction)
            Alert.addAction(okAction)
            
            self.presentViewController(Alert, animated: true, completion: nil)
            print("没有打开相机")
            
            return
            
        }else{
            
            var sourceType = UIImagePickerControllerSourceType.Camera
            if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
                sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            }
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.delegate = self
            picker.sourceType = sourceType
            self.presentViewController(picker, animated: true, completion: nil)
            
        }
    }
    //相册回调方法;
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
//        imageView1.image = image
        
         upLoadImage(image)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func upLoadImage(image : UIImage){
        
        let image1 = imageCut(image, size: CGSizeMake(100, 100))
        
        let data = UIImagePNGRepresentation(image1)
        
        
        NetWorkCore.upLoadWithURL("\(GLOBAL_IPADDRESS_API)/pda/fileupload.ashx", data: data!, success: { [weak self](respones : NSDictionary) -> () in
            
            let s = respones.objectForKey("result") as! String
            
            if s == "success" {
                
                self?.SwiftCallJSCamera(respones.objectForKey("imgUrl") as! String, result:respones.objectForKey("result") as! String )
                
            }else {
                
                self!.SwiftCallJSCamera("", result: "fail")
                
            }
            
            }) { [weak self](str) -> () in
                
                self?.SwiftCallJSCamera("", result: "fail")
                
        }
    }
    
    
    

    /**
     压缩图片的方法，
     
     :param: originalImage 原图
     :param: size          指定图片最后的大小
     
     :returns: 压缩后图片
     */
     func imageCut(originalImage:UIImage,size:CGSize)->UIImage{
        
        UIGraphicsBeginImageContext(size)
        
        originalImage.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        let standardImage1 = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return standardImage1
        
    }

    /**Swift调用JS--定位信息*/
    func SwiftCallJSLocation(latitude : String ,longitude : String,positionInfo : String ,status : String){
        
        let adUUID = getUUID()
        
        let Mark = getDeviceVersion()
        
        var sss = "0"
        
        if((adUUID as NSString).length > 0 && (Mark as NSString).length > 0){
            
            sss = "1"
        }
        
        let jsParamFunc = self.jscontext?.objectForKeyedSubscript("\(getlocationInfo)")
        locationDic = NSDictionary(dictionary: ["latitude" : latitude,"longitude" : longitude,"positionInfo" : positionInfo,"status" : status,"IMEI" : adUUID,"DeviceVersion" : Mark])
        let dictString = dictionaryToJson(locationDic)
        
        jsParamFunc?.callWithArguments([dictString])
//        self.webView.stopLoading()
//        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "www.baidu.com")!))
    }
    /**Swift调用JS--照片连接*/
    func SwiftCallJSCamera(imgUrl : String, result : String){
        
        let jsParamFunc = self.jscontext?.objectForKeyedSubscript("\(getUserImgUrl)")
        let dict = NSDictionary(dictionary: ["imgUrl" : imgUrl,"result" : result])
        let dictSting = dictionaryToJson(dict)
        jsParamFunc?.callWithArguments([dictSting])
    }
    
    /**Swift调用JS--手机唯一标示、手机型号*/
    func SwiftCallJSMarkAndId(){
        
        let adUUID = getUUID()
        let Mark = getDeviceVersion()
        var sss = "0"
        if((adUUID as NSString).length > 0 && (Mark as NSString).length > 0){

            sss = "1"
            
        }
        let jsParamFunc = self.jscontext?.objectForKeyedSubscript("\(getDevicetype)")
        let dict = NSDictionary(dictionary: ["IMEI" : adUUID,"DeviceVersion" : Mark,"status" : sss ])
        let dictSting = dictionaryToJson(dict)
        jsParamFunc?.callWithArguments([dictSting])
    }
    
    /**JSON字符串转字典*/
    func parseJSONStringToNSDictionary(JSONString : String)->NSDictionary{
        
        let JSONData = JSONString .dataUsingEncoding(NSUTF8StringEncoding)
        let responseJSON = try! NSJSONSerialization .JSONObjectWithData(JSONData!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary
        return responseJSON
    }
    
    /**字典转JSON字符串*/
    func dictionaryToJson(dic : NSDictionary)->String {
        let JSONdata = try! NSJSONSerialization .dataWithJSONObject(dic, options: NSJSONWritingOptions.PrettyPrinted)
        return String(data: JSONdata, encoding: NSUTF8StringEncoding)!
    }
    
    /**配置定位信息*/
    func configLocationManager(){

        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false

        locationManager.delegate = self

        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func amapLocationManager(manager: AMapLocationManager!, didUpdateLocation location: CLLocation!) {
        
//        print("\(location.description)")
        
        coordinate = location.coordinate
        
        print(coordinate)
//        var alertInfo = UIAlertView(title: "", message: "", delegate: self, cancelButtonTitle: "OK")
//        alertInfo.show()
        
    }
    
    
    func getUUID()->String{

        let UUIDDate = SSKeychain.passwordDataForService("\(BundleID)", account: "\(BundleID)")
        
        var UUID : NSString!
        
        if UUIDDate != nil{
        
             UUID = NSString(data: UUIDDate, encoding: NSUTF8StringEncoding)
        }
        if(UUID == nil){
            
            UUID = UIDevice.currentDevice().identifierForVendor?.UUIDString
            SSKeychain.setPassword(UUID as String, forService: "\(BundleID)", account: "\(BundleID)")
        }
    
        print("=====\(UUID)")
        
        return UUID as String
    }
    
    /**点击弹出来alert框点击确定时走此方法*/
    func clickDetermine(){
        
        let jsParamFunc = self.jscontext?.objectForKeyedSubscript("getUserGroundInfo2")
        let dictString = dictionaryToJson(locationDic)
        jsParamFunc?.callWithArguments([dictString])
        
    }
    
    deinit{
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "tongzhi", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    func getDeviceVersion()->String{
        
        //deviceType设备类型获取地址https://www.theiphonewiki.com/wiki/Models
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let deviceString = withUnsafePointer(&systemInfo.machine) { (ASCIIChar) -> String in

            return String.fromCString(UnsafePointer<CChar>(ASCIIChar))!
        }
        let deviceType = ["iPhone1,1" :  "iPhone",
            "iPhone1,2" :  "iPhone3G",
            "iPhone2,1" :  "iPhone3GS",
            "iPhone3,1" :  "iPhone4",
            "iPhone3,2" :  "iPhone4",
            "iPhone3,3" :  "iPhone4",
            "iPhone4,1" :  "iPhone4S",
            "iPhone5,1" :  "iPhone5",
            "iPhone5,2" :  "iPhone5",
            "iPhone5,3" :  "iPhone5C",
            "iPhone5,4" :  "iPhone5C",
            "iPhone6,1" :  "iPhone5S",
            "iPhone6,2" :  "iPhone5S",
            "iPhone7,2" :  "iPhone6",
            "iPhone7,1" :  "iPhone6 Plus",
            "iPhone8,1" :  "iPhone6s",
            "iPhone8,2" :  "iPhone6s Plus",
            "iPhone8,4" :  "iPhoneSE",
            "iPod1,1"   :  "iPod touch",
            "iPod2,1"   :  "iPod touch 2G",
            "iPod3,1"   :  "iPod touch 3G",
            "iPod4,1"   :  "iPod touch 4G",
            "iPod5,1"   :  "iPod touch 5G",
            "iPad1,1"   :  "iPad1",
            "iPad2,1"   :  "iPad2",
            "iPad2,2"   :  "iPad2",
            "iPad2,3"   :  "iPad2",
            "iPad2,4"   :  "iPad2",
            "iPad3,1"   :  "iPad3",
            "iPad3,2"   :  "iPad3",
            "iPad3,3"   :  "iPad3",
            "iPad3,4"   :  "iPad4",
            "iPad3,5"   :  "iPad4",
            "iPad3,6"   :  "iPad4",
            "iPad4,1"   :  "iPad Air",
            "iPad4,2"   :  "iPad Air",
            "iPad4,3"   :  "iPad Air",
            "iPad5,3"   :  "iPad Air 2",
            "iPad5,4"   :  "iPad Air 2",
            "iPad2,5"   :  "iPad mini 1G",
            "iPad2,6"   :  "iPad mini 1G",
            "iPad2,7"   :  "iPad mini 1G",
            "iPad4,4"   :  "iPad mini 2",
            "iPad4,5"   :  "iPad mini 2",
            "iPad4,6"   :  "iPad mini 2",
            "iPad4,7"   :  "iPad mini 3",
            "iPad4,8"   :  "iPad mini 3",
            "iPad4,9"   :  "iPad mini 3",
            "iPad6,7"   :  "iPad Pro",
            "iPad6,8"   :  "iPad Pro",
            "iPad6,3"   :  "iPad Pro",
            "iPad6,4"   :  "iPad Pro",]
        
        if let deviceTypeString = deviceType[deviceString]{
            
//            print("===\(deviceTypeString)")
            
            return deviceTypeString
        }
        
        return "新机型"
    
    }


}

