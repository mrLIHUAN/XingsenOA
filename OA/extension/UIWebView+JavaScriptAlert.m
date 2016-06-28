//
//  UIWebView+JavaScriptAlert.m
//  OA
//
//  Created by apple on 16/6/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIWebView+JavaScriptAlert.h"


@implementation UIWebView (JavaScriptAlert)

-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame{
    UIAlertView* dialogue = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [dialogue show];
}

static BOOL diagStat = NO;
static BOOL sic = NO;

- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    UIAlertView *confirmDiag;
//    if (message.length != 0 && sic) {
//        confirmDiag = [[UIAlertView alloc] initWithTitle:@"助手提示"
//                                                 message:message
//                                                delegate:self
//                                       cancelButtonTitle:@"取消"
//                                       otherButtonTitles:@"确定",nil];
//        [confirmDiag show];
//    }
//    if (!sic) {
        confirmDiag = [[UIAlertView alloc] initWithTitle:@"助手提示"
                                                 message:message
                                                delegate:self
                                       cancelButtonTitle:@"取消"
                                       otherButtonTitles:@"确定",nil];
         [confirmDiag show];
//    }
    
    return diagStat;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        diagStat = NO;

    }else if(buttonIndex == 1){
        
        
        UIButton *btn = [[UIButton alloc]init];
        
//        diagStat = YES;
//        sic = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tongzhi" object:nil];
    }
}
//-(BOOL)isDiagStat{
//    
//    if (bIdx == 0) {
//        return  NO;
//    }else if (bIdx == 1){
//    
//        return YES;
//    }
//
//    return NO;
//}

@end
