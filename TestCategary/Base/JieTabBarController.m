//
//  JieTabBarController.m
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/28.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import "JieTabBarController.h"
#import "JieNavigationController.h"

@implementation JieTabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray *vcNameArrary = @[@"GitHubViewController", @"TwitterViewController", @"VideoViewController", @"SinaViewController", @"GoogleViewController"];
        NSMutableArray *vcArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < vcNameArrary.count; i++) {
            UIViewController *vc = [NSClassFromString(vcNameArrary[i]) new];
            JieNavigationController *naVC = [[JieNavigationController alloc] initWithRootViewController:vc];
            naVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:[vcNameArrary[i] substringToIndex:[vcNameArrary[i] length] - 14] image:[UIImage imageNamed:[NSString stringWithFormat:@"%ld_n", i]] tag:1000 + i];
            naVC.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%ld_p", i]];
            [vcArray addObject:naVC];
        }
        self.viewControllers = [vcArray copy];
    }
    return self;
}

@end
