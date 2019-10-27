//
//  JieMultiVCTitleView.m
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/28.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import "JieMultiVCTitleView.h"

@interface JieMultiVCTitleView ()

@property(nonatomic, assign)NSInteger currentIndex;
@property(nonatomic, copy)NSArray *titles;
@property(nonatomic, strong)NSMutableArray<UILabel *> *titleLabels;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *scrollLine;

@end

@implementation JieMultiVCTitleView {
    UIColor *kNormalColor;
    UIColor *kSelectedColor;
    CGFloat kScrollLineH;
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}


- (UIView *)scrollLine {
    if (!_scrollLine) {
        _scrollLine = [[UIView alloc] init];
        _scrollLine.backgroundColor = UIColor.orangeColor;
    }
    return _scrollLine;
}


- (NSMutableArray<UILabel *> *)titleLabels {
    if (!_titleLabels) {
        _titleLabels = [[NSMutableArray alloc] init];
    }
    return _titleLabels;
}


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        kScrollLineH = 2;
        kNormalColor = RGBColor(85, 85, 85);
        kSelectedColor = RGBColor(255, 128, 0);
        
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    [self addSubview:self.scrollView];
    
    self.scrollView.frame = self.bounds;
    
    [self setupTitleLabels];
    
    [self setupBottomLineAndScrollLine];
}


- (void)setupTitleLabels {
    CGFloat labelW = self.jie_width / self.titles.count;
    CGFloat labelH = self.jie_height - kScrollLineH;
    CGFloat labelY = 0;
    
    for (int index = 0; index < self.titles.count; index++) {
        UILabel *label = [[UILabel alloc] init];
        
        label.text = self.titles[index];
        label.tag = index;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = kNormalColor;
        label.textAlignment = NSTextAlignmentCenter;
        
        CGFloat labelX = labelW * index;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        [self.scrollView addSubview:label];
        [self.titleLabels addObject:label];
        
        // 给label添加手势
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
        [label addGestureRecognizer:tap];
    }
}


- (void)setupBottomLineAndScrollLine {
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = UIColor.lightGrayColor;
    CGFloat lineH = .5f;
    bottomLine.frame = CGRectMake(0, self.jie_height - lineH, self.jie_width, lineH);
    [self addSubview:bottomLine];
    
    UILabel *firstLabel = self.titleLabels.firstObject;
    firstLabel.textColor = kSelectedColor;
    
    [self.scrollView addSubview:self.scrollLine];
    self.scrollLine.frame = CGRectMake(firstLabel.jie_x, self.jie_height - kScrollLineH, firstLabel.jie_width, kScrollLineH);
}


- (void)titleLabelClick:(UITapGestureRecognizer *)tap {
    UILabel *currentLabel = (UILabel *)tap.view;
    if (currentLabel.tag == self.currentIndex) {
        return;
    }
    
    UILabel *oldLabel = self.titleLabels[self.currentIndex];
    
    currentLabel.textColor = kSelectedColor;
    oldLabel.textColor = kNormalColor;
    self.currentIndex = currentLabel.tag;
    
    CGFloat scrollLineX = self.currentIndex * self.scrollLine.jie_width;
    [UIView animateWithDuration:.15 animations:^{
        self.scrollLine.jie_x = scrollLineX;
    }];
    
    [self.delegate mulitTitleView:self selectedIndex:self.currentIndex];
}

@end
