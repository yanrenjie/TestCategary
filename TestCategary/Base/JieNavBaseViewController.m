//
//  JieNavBaseViewController.m
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/25.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import "JieNavBaseViewController.h"

@interface JieNavBaseViewController ()

@end

@implementation JieNavBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.jie_navgationBar.jie_width = self.view.jie_width;
    [self.view bringSubviewToFront:self.jie_navgationBar];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}


#pragma mark - DataSource
- (BOOL)navUIBaseViewControllerIsNeedNavBar:(JieNavBaseViewController *)navUIBaseViewController {
    return YES;
}


/**头部标题*/
- (NSMutableAttributedString *)jieNavigationBarTitle:(JieNavigationBar *)navigationBar {
    return [self changeTitle:self.title ?: self.navigationItem.title];
}


/** 背景图片 */
//- (UIImage *)jieNavigationBarBackgroundImage:(JieNavigationBar *)navigationBar {
//
//}


/** 背景色 */
- (UIColor *)jieNavigationBackgroundColor:(JieNavigationBar *)navigationBar {
    return [UIColor whiteColor];
}


/** 是否显示底部黑线 */
//- (BOOL)jieNavigationIsHideBottomLine:(JieNavigationBar *)navigationBar {
//    return NO;
//}


/** 导航条的高度 */
- (CGFloat)jieNavigationHeight:(JieNavigationBar *)navigationBar {
    if (@available(iOS 13, *)) {
        return UIApplication.sharedApplication.windows[0].windowScene.statusBarManager.statusBarFrame.size.height + 44;
    } else {
        return UIApplication.sharedApplication.statusBarFrame.size.height + 44.0;
    }
}


/** 导航条的左边的 view */
//- (UIView *)jieNavigationBarLeftView:(JieNavigationBar *)navigationBar {
//
//}
/** 导航条右边的 view */
//- (UIView *)jieNavigationBarRightView:(JieNavigationBar *)navigationBar {
//
//}
/** 导航条中间的 View */
//- (UIView *)jieNavigationBarTitleView:(JieNavigationBar *)navigationBar {
//
//}
/** 导航条左边的按钮 */
//- (UIImage *)jieNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(JieNavigationBar *)navigationBar {
//
//}
/** 导航条右边的按钮 */
//- (UIImage *)jieNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(JieNavigationBar *)navigationBar {
//
//}


#pragma mark - Delegate
/** 左边的按钮的点击 */
- (void)leftButtonEvent:(UIButton *)sender navigationBar:(JieNavigationBar *)navigationBar {
    NSLog(@"%s", __func__);
}


/** 右边的按钮的点击 */
- (void)rightButtonEvent:(UIButton *)sender navigationBar:(JieNavigationBar *)navigationBar {
    NSLog(@"%s", __func__);
}


/** 中间如果是 label 就会有点击 */
- (void)titleClickEvent:(UILabel *)sender navigationBar:(JieNavigationBar *)navigationBar {
    NSLog(@"%s", __func__);
}


#pragma mark 自定义代码
- (NSMutableAttributedString *)changeTitle:(NSString *)curTitle {
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, title.length)];
    return title;
}


- (JieNavigationBar *)jie_navgationBar {
    // 父类控制器必须是导航控制器
    if(!_jie_navgationBar && [self.parentViewController isKindOfClass:[UINavigationController class]]) {
        JieNavigationBar *navigationBar = [[JieNavigationBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
        [self.view addSubview:navigationBar];
        _jie_navgationBar = navigationBar;
        
        navigationBar.dataSource = self;
        navigationBar.jieDelegate = self;
        navigationBar.hidden = ![self navUIBaseViewControllerIsNeedNavBar:self];
    }
    return _jie_navgationBar;
}


- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    self.jie_navgationBar.title = [self changeTitle:title];
}

@end
