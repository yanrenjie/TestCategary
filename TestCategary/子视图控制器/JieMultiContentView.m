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


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isForbidScrollDelegate = NO;
    self.startOffsetX = scrollView.contentOffset.x;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 判断是否是点击事件
    if (self.isForbidScrollDelegate) {
        return;
    }
    
    // 定义需要获取的数据
    CGFloat progress = 0;
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
    
    // 判断是左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.jie_width;
    
    // 左滑动
    if (currentOffsetX > self.startOffsetX) {
        // 计算progress
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        
        // 计算sourceIndex
        sourceIndex = (NSInteger)(currentOffsetX / scrollViewW);
        
        // 计算targetIndex
        targetIndex = sourceIndex + 1;
        if (targetIndex >= self.childVCs.count) {
            targetIndex = self.childVCs.count - 1;
        }
        
        // 如果完全滑过去
        if (currentOffsetX - self.startOffsetX == scrollViewW) {
            progress = 1;
            targetIndex = sourceIndex;
        }
    } else { // 右滑动
        // 计算progress
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        
        // 计算targetIndex
        targetIndex = (NSInteger)(currentOffsetX / scrollViewW);
        
        // 计算sourceIndex
        sourceIndex = targetIndex + 1;
        if (sourceIndex >= self.childVCs.count) {
            sourceIndex = self.childVCs.count - 1;
        }
        
        // 将progress， sourceIndex，targetIndex和titleView进行联动绑定
        if ([self.delegate respondsToSelector:@selector(multiContentView:progress:sourceIndex:targetIndex:)]) {
            [self.delegate multiContentView:self progress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
        }
    }
}


- (void)setCurrentIndex:(NSInteger)currentIndex {
    // 记录需要进制执行代理方法
    self.isForbidScrollDelegate = YES;
    
    // 滚动正确的位置
    CGFloat offsetX = currentIndex * self.vcCollectionView.jie_width;
    [self.vcCollectionView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
}

@end
