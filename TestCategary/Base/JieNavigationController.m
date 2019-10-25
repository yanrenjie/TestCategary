//
//  JieNavigationController.m
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/25.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import "JieNavigationController.h"

@interface JieNavigationController ()

@end

@implementation JieNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;

    // 不让自控制器控制系统导航条
    self.fd_viewControllerBasedNavigationBarAppearanceEnabled = NO;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count != 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
