//
//  UIView+Jie.h
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/24.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Jie)

- (void)printViewInfo;

@property (nonatomic) CGFloat jie_x;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat jie_y;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat jie_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat jie_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat jie_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat jie_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat jie_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat jie_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint jie_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  jie_size;        ///< Shortcut for frame.size.

@end

NS_ASSUME_NONNULL_END
