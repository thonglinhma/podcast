//
//  UIImage+Additions.h
//  MyMp3
//
//  Created by Mike Tran on 6/24/13.
//  Copyright (c) 2013 Abcdefghijk Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)
+ (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *)buttonImageWithColor:(UIColor *)color
                      cornerRadius:(CGFloat)cornerRadius
                       shadowColor:(UIColor *)shadowColor
                      shadowInsets:(UIEdgeInsets)shadowInsets;

+ (UIImage *)circularImageWithColor:(UIColor *)color
                                size:(CGSize)size;

- (UIImage *)imageWithMinimumSize:(CGSize)size;

+ (UIImage *)stepperPlusImageWithColor:(UIColor *)color;
+ (UIImage *)stepperMinusImageWithColor:(UIColor *)color;

+ (UIImage *)backButtonImageWithColor:(UIColor *)color
                            barMetrics:(UIBarMetrics)metrics
                          cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *)playButtonImageWithColor:(UIColor *)color
                                 size:(CGSize)size;
@end
