//
//  Macro.h
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/25.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define JieWeak(type)       __weak typeof(type) weak##type = type
#define JieStrong(type)     __strong typeof(type) strong##type = type


// 是否是空对象
#define IsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

// 不同屏幕尺寸字体适配
#define kScreenWidthRatio       (UIScreen.mainScreen.bounds.size.width / 375.0)
#define kScreenHeightRatio      (UIScreen.mainScreen.bounds.size.height / 667.0)
#define AdaptedWidth(x)         ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x)        ceilf((x) * kScreenHeightRatio)
#define AdaptedFontSize(R)      [UIFont systemFontOfSize:AdaptedWidth(R)]


// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告。
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

// RGB颜色
#define RGBColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#endif /* Macro_h */
