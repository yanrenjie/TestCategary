//
//  JieMultiContentView.h
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/27.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JieMultiContentView;

@protocol JieMultiContentViewDelegate <NSObject>

- (void)multiContentView:(JieMultiContentView *)contentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;

@end

@interface JieMultiContentView : UIView

@property(nonatomic, weak)id<JieMultiContentViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSMutableArray<UIViewController *> *)childVCs parentVC:(UIViewController *)parentVC;

- (void)setCurrentIndex:(NSInteger)currentIndex;

@end

NS_ASSUME_NONNULL_END
