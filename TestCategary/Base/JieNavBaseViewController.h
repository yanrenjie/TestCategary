//
//  JieNavBaseViewController.h
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/25.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JieNavigationBar.h"
#import "JieNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@class JieNavBaseViewController;

@protocol JieNavBaseViewControllerDataSource <NSObject>

@optional

- (BOOL)navUIBaseViewControllerIsNeedNavBar:(JieNavBaseViewController *)navUIBaseViewController;

@end


@interface JieNavBaseViewController : UIViewController<JieNavBaseViewControllerDataSource, JieNavigationBarDelegate, JieNavigationBarDataSource>

/*默认的导航栏字体*/
- (NSMutableAttributedString *)changeTitle:(NSString *)curTitle;
/**  */
@property(weak, nonatomic)JieNavigationBar *jie_navgationBar;

@end

NS_ASSUME_NONNULL_END
