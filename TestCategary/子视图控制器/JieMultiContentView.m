//
//  JieMultiContentView.m
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/27.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import "JieMultiContentView.h"

static NSString *viewControllerCellID = @"ViewControllerCellID";

@interface JieMultiContentView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong)NSMutableArray *childVCs;
@property(nonatomic, strong)UIViewController *parentVC;
@property(nonatomic, assign)CGFloat startOffsetX;
@property(nonatomic, assign)BOOL isForbidScrollDelegate;
@property(nonatomic, strong)UICollectionView *vcCollectionView;

@end


@implementation JieMultiContentView

#pragma mark - 懒加载属性
- (UICollectionView *)vcCollectionView {
    if (!_vcCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _vcCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _vcCollectionView.showsHorizontalScrollIndicator = NO;
        _vcCollectionView.pagingEnabled = YES;
        _vcCollectionView.bounces = NO;
        _vcCollectionView.dataSource = self;
        _vcCollectionView.delegate = self;
        _vcCollectionView.scrollsToTop = NO;
        [_vcCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:viewControllerCellID];
    }
    return _vcCollectionView;
}

- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSMutableArray<UIViewController *> *)childVCs parentVC:(UIViewController *)parentVC {
    self = [super initWithFrame:frame];
    if (self) {
        self.childVCs = childVCs;
        self.parentVC = parentVC;
        
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    for (UIViewController *childVC in self.childVCs) {
        [self.parentVC addChildViewController:childVC];
    }
    [self addSubview:self.vcCollectionView];
    self.vcCollectionView.frame = self.bounds;
}


#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childVCs.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:viewControllerCellID forIndexPath:indexPath];
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIViewController *childVC = self.childVCs[indexPath.item];
    childVC.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVC.view];
    return cell;
}



@end
