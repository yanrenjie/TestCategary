//
//  GitHubViewController.m
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/24.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import "GitHubViewController.h"
#import "WaterFlowLayout.h"
#import "MyCollectionViewCell.h"

static NSString * const reuse_string = @"MyCollectionViewCell";

@interface GitHubViewController ()<UICollectionViewDataSource, WaterFlowLayoutDelegate> {
    UICollectionView *_collectionView;
    NSMutableArray *_data_arr;
    NSInteger column_number;
}

@end

@implementation GitHubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    column_number = 3;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(refresh_action)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]  initWithTitle:@"列数" style:UIBarButtonItemStyleDone target:self action:@selector(change_columen_num)];
    
    _data_arr = [[NSMutableArray alloc] init];
    [self createData];
    
    WaterFlowLayout *layout = [[WaterFlowLayout alloc] init];
    layout.delegate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor = UIColor.whiteColor;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:reuse_string];
    [self.view addSubview:_collectionView];
    
    [self refresh_action];
    
//    if (IPHONE_X) {
//        NSLog(@"iPhoneX列");
//    } else {
//        NSLog(@"三段式");
//    }
}


- (void)change_columen_num {
    column_number++;
    if (column_number == 6) {
        column_number = 2;
    }
    [self refresh_action];
}


- (void)refresh_action {
    [_data_arr removeAllObjects];
    [self createData];
    [_collectionView reloadData];
}


- (void)createData {
    for (int i = 0; i < 60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd.png", arc4random_uniform(9) + 1]];
        [_data_arr addObject:image];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _data_arr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse_string forIndexPath:indexPath];
    cell.myImage = _data_arr[indexPath.item];
    return cell;
}


#pragma mark - water flow layout delegate
- (CGFloat)waterFlowLayout:(WaterFlowLayout *)waterFlowLayout heightForItemAtIndex:(NSInteger)index width:(CGFloat)width {
    UIImage *image = _data_arr[index];
    CGFloat height = width * image.size.height / image.size.width;
    return height;
}


- (NSInteger)waterFlowLayoutColumnCount:(WaterFlowLayout *)waterFlowLayout {
    return column_number;
}


- (CGFloat)waterFlowLayoutColumnSpace:(WaterFlowLayout *)waterFlowLayout {
    return 3;
}


- (CGFloat)waterFlowLayoutRowSpace:(WaterFlowLayout *)waterFlowLayout {
    return 3;
}


- (UIEdgeInsets)waterFlowLayoutEdgeInsets:(WaterFlowLayout *)waterFlowLayout {
    return UIEdgeInsetsMake(3, 3, 3, 3);
}

@end
