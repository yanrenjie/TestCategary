//
//  UIView+Jie.m
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/24.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import "UIView+Jie.h"

#import <UIKit/UIKit.h>

@implementation UIView (Jie)

- (CGFloat)jie_x {
    return self.frame.origin.x;
}

- (void)setJie_x:(CGFloat)jie_x {
    CGRect frame = self.frame;
    frame.origin.x = jie_x;
    self.frame = frame;
}

- (CGFloat)jie_y {
    return self.frame.origin.y;
}

- (void)setJie_y:(CGFloat)jie_y {
    CGRect frame = self.frame;
    frame.origin.y = jie_y;
    self.frame = frame;
}

- (CGFloat)jie_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setJie_right:(CGFloat)jie_right {
    CGRect frame = self.frame;
    frame.origin.x = jie_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)jie_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setJie_bottom:(CGFloat)jie_bottom {
    
    CGRect frame = self.frame;
    
    frame.origin.y = jie_bottom - frame.size.height;
    
    self.frame = frame;
}

- (CGFloat)jie_width {
    return self.frame.size.width;
}

- (void)setJie_width:(CGFloat)jie_width {
    CGRect frame = self.frame;
    frame.size.width = jie_width;
    self.frame = frame;
}

- (CGFloat)jie_height {
    return self.frame.size.height;
}

- (void)setJie_height:(CGFloat)jie_height {
    CGRect frame = self.frame;
    frame.size.height = jie_height;
    self.frame = frame;
}

- (CGFloat)jie_centerX {
    return self.center.x;
}

- (void)setJie_centerX:(CGFloat)jie_centerX {
    self.center = CGPointMake(jie_centerX, self.center.y);
}

- (CGFloat)jie_centerY {
    return self.center.y;
}

- (void)setJie_centerY:(CGFloat)jie_centerY {
    self.center = CGPointMake(self.center.x, jie_centerY);
}

- (CGPoint)jie_origin {
    return self.frame.origin;
}

- (void)setJie_origin:(CGPoint)jie_origin {
    CGRect frame = self.frame;
    frame.origin = jie_origin;
    self.frame = frame;
}

- (CGSize)jie_size {
    return self.frame.size;
}

- (void)setJie_size:(CGSize)jie_size {
    CGRect frame = self.frame;
    frame.size = jie_size;
    self.frame = frame;
}


- (void)printViewInfo {
    NSLog(@"我的相关信息是这样的%@", self);
}

@end
