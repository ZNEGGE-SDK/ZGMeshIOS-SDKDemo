//
//  main.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/10/31.
//  Copyright © 2019 文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        if (@available(iOS 10.0, *)) {
            appDelegateClassName = NSStringFromClass([AppDelegate class]);
        } else {
            // Fallback on earlier versions
        }
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
