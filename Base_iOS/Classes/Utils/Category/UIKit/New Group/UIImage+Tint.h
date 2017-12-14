//
//  UIImage+Tint.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

//对图片内部进行渲染
- (UIImage *)tintedImageWithColor:(UIColor *)tintColor;
//
- (UIImage *)tintedGradientImageWithColor:(UIColor *)tintColor;


@end
