//
//  NSString+helper.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import "NSString+helper.h"

@implementation NSString (helper)

- (NSString *) replaceAll:(NSString*)origin with:(NSString*)replacement {
    return [self stringByReplacingOccurrencesOfString:origin withString:replacement];
}
- (NSString *) trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}



@end
