//
//  ViewController.m
//  HBPushNoticeDemo
//
//  Created by Mac on 2020/12/26.
//  Copyright © 2020 yanruyu. All rights reserved.
//

#import "ViewController.h"
#import "HBOpenPushNoticeView.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#define WEAKSELF typeof(self) __weak weakSelf = self
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf
@interface ViewController ()

@end

@implementation ViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //判断是否推送权限
    [self seeCurrentNotificationStatus];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推送权限Demo";
}
#pragma mark ==========YES有权限  NO无权限==========
-(void)seeCurrentNotificationStatus{
    if (@available(iOS 10 , *)){
        WEAKSELF;
         [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
             STRONGSELF;
            if (settings.authorizationStatus == UNAuthorizationStatusDenied){
                // 没权限
                NSLog(@"无推送权限，弹窗处理");
                [strongSelf pushNotifcationView];
            }
        }];
    }else if (@available(iOS 8 , *)){
        UIUserNotificationSettings * setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (setting.types == UIUserNotificationTypeNone) {
            // 没权限
            NSLog(@"无推送权限，弹窗处理");
            [self pushNotifcationView];
        }
    }else{
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (type == UIUserNotificationTypeNone){
            // 没权限
            NSLog(@"无推送权限，弹窗处理");
            [self pushNotifcationView];
        }
    }
}
#pragma mark ==========弹窗出推送权限==========
-(void)pushNotifcationView{
    //一天之内只提示一次
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //拿到当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //当前时间
    NSDate *nowDate = [NSDate date];
    NSString *nowDateStr= [dateFormatter stringFromDate:nowDate];
    //之前时间
    NSString *agoDateStr = [userDefault objectForKey:@"saveNowDate"];
    //判断时间差
    if ([agoDateStr isEqualToString:nowDateStr]) {
        //是当天时间
    }else{
        //弹窗
        //主线程使用
        dispatch_async(dispatch_get_main_queue(), ^{
            [[HBOpenPushNoticeView new] show];
        });
        //保存当前时间
        [userDefault setObject:nowDateStr forKey:@"saveNowDate"];
        [userDefault synchronize];
    }

}

@end
