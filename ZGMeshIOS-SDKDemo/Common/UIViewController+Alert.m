//
//  UIViewController+Alert.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import "UIViewController+Alert.h"


@implementation UIViewController (Alert)

-(void)alertWithMessage:(NSString*)message
{
     [self alertWithTitle:@"" andMessage:message ok_Title:NSLocalizedString(@"OK","OK") callBlock:nil];
}
-(void)alertWithMessage:(NSString*)message ok_Title:(NSString*)ok_Title callBlock:(void (^)(void))callblock
{
    [self alertWithTitle:@"" andMessage:message ok_Title:ok_Title callBlock:callblock];
}

-(void)alertWithTitle:(NSString*)title andMessage:(NSString*)message callBlock:(void (^)(void))callblock
{
    [self alertWithTitle:title andMessage:message ok_Title:NSLocalizedString(@"OK","OK")  callBlock:callblock];
}

-(void)alertWithTitle:(NSString*)title andMessage:(NSString*)message ok_Title:(NSString*)ok_Title callBlock:(void (^)(void))callblock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *itm = [UIAlertAction actionWithTitle:ok_Title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (callblock!=nil) {
            callblock();
        }
    }];
    [alertController addAction:itm];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)alertConfirmWithTitle:(NSString*)p_title andMessage:(NSString*) p_message callBlock:(void (^)(BOOL confirm))callblock
{
    [self alertConfirmWithTitle:p_title andMessage:p_message
                     yes_Title:NSLocalizedString(@"str_Yes",@"YES")
                      No_Title:NSLocalizedString(@"Cancel","Cancel")
                     callBlock:callblock];
}

-(void)alertConfirmWithTitle:(NSString*)title andMessage:(NSString*)message yes_Title:(NSString*)yes_Title No_Title:(NSString*)No_Title callBlock:(void (^)(BOOL confirm))callblock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:No_Title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (callblock!=nil) {
            callblock(NO);
        }
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:yes_Title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (callblock!=nil) {
            callblock(YES);
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)alertConfirmWithTitle:(NSString*)title andMessage:(NSString*)message btn1_Title:(NSString*)btn1_Title btn2_Title:(NSString*)btn2_Title  btn3_Title:(NSString*)btn3_Title callBlock:(void (^)(int confirm))callblock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *btn1Action = [UIAlertAction actionWithTitle:btn1_Title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (callblock!=nil) {
            callblock(0);
        }
    }];
    
    UIAlertAction *btn2Action = [UIAlertAction actionWithTitle:btn2_Title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (callblock!=nil) {
            callblock(1);
        }
    }];
    UIAlertAction *btn3Action = [UIAlertAction actionWithTitle:btn3_Title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (callblock!=nil) {
            callblock(2);
        }
    }];
    
    [alertController addAction:btn1Action];
    [alertController addAction:btn2Action];
    [alertController addAction:btn3Action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)alertInputBoxWithTitle:(NSString*)title andMessage:(NSString*)message placeholder:(NSString*)placeholder  defText:(NSString*)defText callBack:(void(^)(NSString *textValue))callBack
{
    // 准备初始化配置参数
    NSString *okButtonTitle = NSLocalizedString(@"OK","OK");
    
    // 初始化
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 创建文本框
    [alertDialog addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = placeholder;
        textField.text = defText;
        textField.secureTextEntry = NO;
        textField.returnKeyType = UIReturnKeyDone;
    }];
    
    // 创建操作
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 读取文本框的值显示出来
        UITextField *txtField = alertDialog.textFields.firstObject;
        
        if (txtField.text == nil || [txtField.text isEqualToString:@""]) {
            [self alertWithMessage:NSLocalizedString(@"EmptyString", nil) ok_Title: NSLocalizedString(@"OK",nil) callBlock:^{
                 [self alertInputBoxWithTitle:title andMessage:message placeholder:placeholder defText:txtField.text callBack:callBack];
            }];
           
            return ;
        }
        
        
        callBack(txtField.text);
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel","Cancel") style:UIAlertActionStyleCancel handler:nil];
    
    
    // 添加操作（顺序就是呈现的上下顺序）
    [alertDialog addAction:cancelAction];
    [alertDialog addAction:okAction];
    
    // 呈现警告视图
    [self presentViewController:alertDialog animated:YES completion:nil];
}

-(void)alertActionSheetWith:(NSString *)title andMessage:(NSString*)message andAlertAction:(NSArray<UIAlertAction *> *)actions
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
       
    for (UIAlertAction *itm in actions)
    {
        [alertController addAction:itm];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    if ((UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)) {
           UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
        popPresenter.sourceView = self.view; // 这就是挂靠的对象
        popPresenter.sourceRect =  self.view.bounds;
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


//-(void)toastSuccessUpMessage:(NSString*)message title:(NSString*)title
//{
//    [TSMessage showNotificationInViewController:self
//                                                  title:title
//                                               subtitle:message
//                                                   type:TSMessageNotificationTypeSuccess
//                                       duration:5];
//}
//
//-(void)toastUpWarningMessage:(NSString*)message title:(NSString*)title
//{
//    [TSMessage showNotificationInViewController:self
//                                          title:title
//                                       subtitle:message
//                                           type:TSMessageNotificationTypeWarning
//                                       duration:5];
//}
//
//-(void)toastUpWarningMessage:(NSString*)message  callback:(void (^)(void))callback
//{
//    [self toastUpWarningMessage:message title:nil callback:callback];
//}
//
//-(void)toastUpWarningMessage:(NSString*)message title:(NSString*)title callback:(void (^)(void))callback
//{
//    [TSMessage showNotificationInViewController:self
//                                     title:title
//                                  subtitle:message
//                                     image:nil
//                                      type:TSMessageNotificationTypeWarning
//                                  duration:TSMessageNotificationDurationEndless
//                                  callback:callback
//                               buttonTitle:nil
//                            buttonCallback:nil
//                                atPosition:TSMessageNotificationPositionTop
//                      canBeDismissedByUser:YES];
//}



@end
