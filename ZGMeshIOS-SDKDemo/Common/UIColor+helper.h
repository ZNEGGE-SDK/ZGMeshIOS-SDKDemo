//
//  UIColor+helper.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/5.
//  Copyright © 2019 文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSV.h"

#define SUPPORTS_UNDOCUMENTED_API    0

RGBType rgbWithUIColor(UIColor *color);
HSVType hsvWithUIColor(UIColor *color);

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (helper)

@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property (nonatomic, readonly) BOOL canProvideRGBComponents;
@property (nonatomic, readonly) CGFloat red; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat green; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat blue; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat white; // Only valid if colorSpaceModel == kCGColorSpaceModelMonochrome
@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, readonly) UInt32 rgbHex;
@property (nonatomic, readonly) UInt32 rgbaHex;

- (NSString *)colorSpaceString;

- (NSArray *)arrayFromRGBAComponents;

- (BOOL)red:(CGFloat *)r green:(CGFloat *)g blue:(CGFloat *)b alpha:(CGFloat *)a;

- (UIColor *)colorByLuminanceMapping;

- (UIColor *)colorByMultiplyingByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)       colorByAddingRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *) colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)  colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (UIColor *)colorByMultiplyingBy:(CGFloat)f;
- (UIColor *)       colorByAdding:(CGFloat)f;
- (UIColor *) colorByLighteningTo:(CGFloat)f;
- (UIColor *)  colorByDarkeningTo:(CGFloat)f;

- (UIColor *)colorByMultiplyingByColor:(UIColor *)color;
- (UIColor *)       colorByAddingColor:(UIColor *)color;
- (UIColor *) colorByLighteningToColor:(UIColor *)color;
- (UIColor *)  colorByDarkeningToColor:(UIColor *)color;

//- (NSString *)stringFromColor;
- (NSString *)hexStringFromColorWithOutSharp;

+ (UIColor *)randomColor;
//+ (UIColor *)colorWithString:(NSString *)stringToConvert;
+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithRGBAHex:(UInt32)hex;
+ (UIColor *)colorWithHexStringWithOutSharp:(NSString *)stringToConvert;

+ (UIColor *)colorWithName:(NSString *)cssColorName;

-(UIColor*)colorbyBrightness:(CGFloat)brightness;

-(float)brightness;

+ (UIColor *)colorWithHexStringAndroid:(NSString *)stringToConvert;

- (UIColor *)darkerColor;
- (UIColor *)lighterColor;
- (BOOL)isLighterColor;
- (BOOL)isClearColor;

+ (UIColor*)colorByTemperatureValue:(int)temperature;
@end

#if SUPPORTS_UNDOCUMENTED_API
// UIColor_Undocumented_Expanded
// Methods which rely on undocumented methods of UIColor
@interface UIColor (UIColor_Undocumented_Expanded)
- (NSString *)fetchStyleString;
- (UIColor *)rgbColor; // Via Poltras
@end
#endif // SUPPORTS_UNDOCUMENTED_API

NS_ASSUME_NONNULL_END
