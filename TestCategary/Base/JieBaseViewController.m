//
//  JieBaseViewController.m
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/25.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import "JieBaseViewController.h"

@interface JieBaseViewController ()

@end

@implementation JieBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 13, *)) {
        self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearanceWhenContainedInInstancesOfClasses:@[[JieBaseViewController class]]] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    });
}


- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title.copy;
    }
    return self;
}


- (void)dealloc {
    NSLog(@"dealloc---%@", self.class);
}

@end
