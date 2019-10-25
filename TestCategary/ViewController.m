//
//  ViewController.m
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/24.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    redView.backgroundColor = UIColor.redColor;
    [self.view addSubview:redView];
    [redView printViewInfo];
}


@end
