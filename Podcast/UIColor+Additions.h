//
//  UIColor+Additions.h
//  MyMp3
//
//  Created by Mike Tran on 6/24/13.
//  Copyright (c) 2013 Abcdefghijk Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (UIColor *)colorFromHexCode:(NSString *)hexString;
+ (UIColor *)turquoiseColor;
+ (UIColor *)greenSeaColor;
+ (UIColor *)emerlandColor;
+ (UIColor *)nephritisColor;
+ (UIColor *)peterRiverColor;
+ (UIColor *)belizeHoleColor;
+ (UIColor *)amethystColor;
+ (UIColor *)wisteriaColor;
+ (UIColor *)wetAsphaltColor;
+ (UIColor *)midnightBlueColor;
+ (UIColor *)sunflowerColor;
+ (UIColor *)tangerineColor;
+ (UIColor *)carrotColor;
+ (UIColor *)pumpkinColor;
+ (UIColor *)alizarinColor;
+ (UIColor *)pomegranateColor;
+ (UIColor *)cloudsColor;
+ (UIColor *)silverColor;
+ (UIColor *)concreteColor;
+ (UIColor *)asbestosColor;

+ (UIColor *)blendedColorWithForegroundColor:(UIColor *)foregroundColor
                              backgroundColor:(UIColor *)backgroundColor
                                 percentBlend:(CGFloat) percentBlend;
@end
