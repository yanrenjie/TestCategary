//
//  JieMultiVCTitleView.h
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/28.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JieMultiVCTitleView;

@protocol JieMultiVCTitleViewDelegate <NSObject>

- (void)mulitTitleView:(JieMultiVCTitleView *)titleView selectedIndex:(NSInteger)selectedIndex;

@end

@interface JieMultiVCTitleView : UIView

@property(nonatomic, weak)id<JieMultiVCTitleViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles;

@end

NS_ASSUME_NONNULL_END
