//
//  AppDelegate.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/10/31.
//  Copyright © 2019 文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

API_AVAILABLE(ios(10.0))
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

