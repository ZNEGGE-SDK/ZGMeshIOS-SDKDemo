//
//  NSString+helper.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (helper)

- (NSString *) replaceAll:(NSString*)origin with:(NSString*)replacement;
- (NSString *) trim;

@end

NS_ASSUME_NONNULL_END
