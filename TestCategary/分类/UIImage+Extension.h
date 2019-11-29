//
//  UIImage+Extension.h
//  TestCategary
//
//  Created by 颜仁浩 on 2019/11/29.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

- (UIImage *)drawRoundedRectImage:(CGFloat)cornerRadius width:(CGFloat)width height:(CGFloat)height;

- (UIImage *)drawCircleImage;

@end

NS_ASSUME_NONNULL_END
