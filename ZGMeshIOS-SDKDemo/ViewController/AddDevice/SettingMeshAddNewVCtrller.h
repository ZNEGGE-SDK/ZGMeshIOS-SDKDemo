//
//  SetupIndexVCtrller.h
//  LedWiFiAdvanced
//
//  Created by zhou mingchang on 16/10/11.
//  Copyright © 2016年 Zhengji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingMeshAddNewVCtrller : UIViewController
{
    IBOutlet UIView *_viewContentSpan;
    IBOutlet UIView *_viewLoadFailed;
    IBOutlet UILabel *_lblNoteScanFailed;
    IBOutlet UIView *_viewLoading;
    IBOutlet UILabel *_lblLoadingInfo;
    IBOutlet UIActivityIndicatorView *_indicatorView;
    IBOutlet UILabel *_viewTitle;
    IBOutlet UIButton *_btnTryAgain;
    
      __strong  void (^_callbackAdd)(void);
    
}

-(void)setallbackAdd:(void(^)(void))callBack;

@end
