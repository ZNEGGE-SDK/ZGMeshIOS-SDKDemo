//
//  UIViewController+Alert.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Alert)

-(void)alertWithMessage:(NSString*)message;

-(void)alertWithMessage:(NSString*)message ok_Title:(NSString*)ok_Title callBlock:(void (^)(void))callblock;

-(void)alertWithTitle:(NSString*)title andMessage:(NSString*)message callBlock:(void (^)(void))callblock;

-(void)alertWithTitle:(NSString*)title andMessage:(NSString*)message ok_Title:(NSString*)ok_Title callBlock:(void (^)(void))callblock;

-(void)alertConfirmWithTitle:(NSString*)p_title andMessage:(NSString*) p_message callBlock:(void (^)(BOOL confirm))callblock;

-(void)alertConfirmWithTitle:(NSString*)title andMessage:(NSString*)message yes_Title:(NSString*)yes_Title No_Title:(NSString*)No_Title callBlock:(void (^)(BOOL confirm))callblock;

-(void)alertInputBoxWithTitle:(NSString*)title andMessage:(NSString*)message placeholder:(NSString*)placeholder  defText:(NSString*)defText callBack:(void(^)(NSString *textValue))callBack;

-(void)alertConfirmWithTitle:(NSString*)title andMessage:(NSString*)message btn1_Title:(NSString*)btn1_Title btn2_Title:(NSString*)btn2_Title  btn3_Title:(NSString*)btn3_Title callBlock:(void (^)(int confirm))callblock;


-(void)alertActionSheetWith:(nullable NSString *)title andMessage:(nullable NSString*)message andAlertAction:(NSArray<UIAlertAction *> *)actions;


@end

NS_ASSUME_NONNULL_END
