//
//  CNHUD.h
//  XXXWeibo
//
//  Created by Mac on 15/8/4.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CNHUD : NSObject

/**
 * 不限时间的
 */
+(void)showHUD:(NSString*)title;
+(void)hidHUD;

/**
 * 限时间的
 */
+(void)showHUD:(NSString *)title duration:(NSTimeInterval)duration;


//分享
+(void)showNewHUD;
+(void)hidNewHUD;

@end
