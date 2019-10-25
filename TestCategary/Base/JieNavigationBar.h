//
//  JieNavigationBar.h
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/25.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JieNavigationBar;
// 主要处理导航条
@protocol JieNavigationBarDataSource<NSObject>

@optional

/**头部标题*/
- (NSMutableAttributedString *)jieNavigationBarTitle:(JieNavigationBar *)navigationBar;

/** 背景图片 */
- (UIImage *)jieNavigationBarBackgroundImage:(JieNavigationBar *)navigationBar;

 /** 背景色 */
- (UIColor *)jieNavigationBackgroundColor:(JieNavigationBar *)navigationBar;

/** 是否显示底部黑线 */
- (BOOL)jieNavigationIsHideBottomLine:(JieNavigationBar *)navigationBar;

/** 导航条的高度 */
- (CGFloat)jieNavigationHeight:(JieNavigationBar *)navigationBar;

/** 导航条的左边的 view */
- (UIView *)jieNavigationBarLeftView:(JieNavigationBar *)navigationBar;

/** 导航条右边的 view */
- (UIView *)jieNavigationBarRightView:(JieNavigationBar *)navigationBar;

/** 导航条中间的 View */
- (UIView *)jieNavigationBarTitleView:(JieNavigationBar *)navigationBar;

/** 导航条左边的按钮 */
- (UIImage *)jieNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(JieNavigationBar *)navigationBar;

/** 导航条右边的按钮 */
- (UIImage *)jieNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(JieNavigationBar *)navigationBar;

@end


@protocol JieNavigationBarDelegate <NSObject>

@optional
/** 左边的按钮的点击 */
- (void)leftButtonEvent:(UIButton *)sender navigationBar:(JieNavigationBar *)navigationBar;

/** 右边的按钮的点击 */
- (void)rightButtonEvent:(UIButton *)sender navigationBar:(JieNavigationBar *)navigationBar;

/** 中间如果是 label 就会有点击 */
- (void)titleClickEvent:(UILabel *)sender navigationBar:(JieNavigationBar *)navigationBar;

@end

@interface JieNavigationBar : UIView

/** 底部的黑线 */
@property (weak, nonatomic) UIView *bottomBlackLineView;

/** <#digest#> */
@property (weak, nonatomic) UIView *titleView;

/** <#digest#> */
@property (weak, nonatomic) UIView *leftView;

/** <#digest#> */
@property (weak, nonatomic) UIView *rightView;

/** <#digest#> */
@property (nonatomic, copy) NSMutableAttributedString *title;

/** <#digest#> */
@property (weak, nonatomic) id<JieNavigationBarDataSource> dataSource;

/** <#digest#> */
@property (weak, nonatomic) id<JieNavigationBarDelegate> jieDelegate;

/** <#digest#> */
@property (weak, nonatomic) UIImage *backgroundImage;

@end

NS_ASSUME_NONNULL_END
