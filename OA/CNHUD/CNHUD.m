//
//  CNHUD.m
//  XXXWeibo
//
//  Created by Mac on 15/8/4.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "CNHUD.h"
#import "UIViewExt.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight [[UIScreen mainScreen]bounds].size.height
UIWindow *_myWindow;

UIWindow*_newWindow;


@implementation CNHUD
+(UIWindow*)myWindow:(CGFloat)W{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
    
        
        _myWindow = [[UIWindow alloc]initWithFrame:CGRectMake(kScreenWidth / 2 - W / 2 ,KScreenHeight - 150, W, 35)];
        
        _myWindow.clipsToBounds = YES;
        _myWindow.layer.cornerRadius = 5;
        
        [_myWindow setWindowLevel:UIWindowLevelStatusBar];
        
        [_myWindow setBackgroundColor:[UIColor blackColor]];
        
        UILabel *label = [[UILabel alloc]initWithFrame:_myWindow.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.tag = 100;
        [_myWindow addSubview:label];

//    });
    return _myWindow;
}

/**
 * 不限时间的
 */
+(void)showHUD:(NSString*)title{
    
    //初始化label
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = [UIFont boldSystemFontOfSize:15];
    label1.text = title;
    [label1 sizeToFit];
    CGFloat w = label1.width + 30;
    
    UIWindow *window = [self myWindow:w];
    window.hidden = NO;
    
    UILabel *label = (UILabel*)[window viewWithTag:100];
    [label setText:title];
    

 }
+(void)hidHUD{
    _myWindow.hidden = YES;
    
    [_myWindow removeFromSuperview];
 }

/**
 * 限时间的
 */
+(void)showHUD:(NSString *)title duration:(NSTimeInterval)duration{
    
    [self showHUD:title];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hidHUD];
    });


    
}

#pragma mark-  添加 分享窗口====================
//分享窗口
+(UIWindow*)newWindow{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //创建window
        _newWindow = [[UIWindow alloc]initWithFrame:CGRectMake((kScreenWidth-300)/2.0f, 150,300, 400)];
        [_newWindow setWindowLevel:UIWindowLevelStatusBar];
        [_newWindow setBackgroundColor:[UIColor whiteColor]];
        _newWindow.tag=1001;
        
        
        //分享
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 70)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:0.153 green:0.545 blue:1.000 alpha:1.000];
        label.text=@"    分享";
        label.font=[UIFont boldSystemFontOfSize:23];
        label.tag = 100;
        [_newWindow addSubview:label];
        
        //横线
        UILabel*lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, 300, 3)];
        lineLabel.backgroundColor=[UIColor colorWithRed:0.181 green:0.662 blue:1.000 alpha:1.000];
        [_newWindow addSubview:lineLabel];
        
        //图
        UIView *iView = [[UIView alloc]initWithFrame:CGRectMake(0, 73, 300, 297)];
        iView.backgroundColor=[UIColor whiteColor];
        iView.tag = 200;
        [_newWindow addSubview:iView];

        //循环添加图片
        for (int i=0; i<9; i++) {
        NSArray*arr=@[@"Share_Sina",@"Share_WeChat",@"Share_WeChat_Moments",@"Share_Evernote",@"Share_YoudaoNote",@"Share_QQ",@"Share_Renren",@"Share_Readability",@"Share_Email"];
            // UIImage*image=[UIImage imageNamed:@"Share_Readability"];
            
            float width = (300-30)/3.0f;//宽
            int row = i/3;
            int list = i%3;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(list*(5+width)+5, row*(5+width)+5, width, width);
            [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
//            btn.tag = 2000+i;
            
//            [btn addTarget:self action:@selector(Action:) forControlEvents:UIControlEventTouchUpInside];
            [iView addSubview:btn];
 
        }
    });
    return _newWindow;
}
//-(void)Action:(UIButton*)button{
//    if (button.tag==2000) {
//        
//        
//        
//        NSLog(@"新浪");
//    }
//
//
//
//}
//



//添加
+(void)showNewHUD{
    UIWindow *window = [self newWindow];
    window.hidden = NO;
    
    //newWindow 出现时动画 设置起始坐标－400 添加动画到 150
    window.top = -400;
    [UIView animateWithDuration:0.35 animations:^{
        window.top = 150;
    }];
}

//移除分享页
+(void)hidNewHUD{
    UIWindow *window = [self newWindow];
    //根据tap值 移除
    [UIView animateWithDuration:.7 animations:^{
        window.top = 1200;
    }completion:^(BOOL finished) {
        window.hidden = YES;
    }];
}

@end
