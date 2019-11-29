//
//  SmallVideoCell.h
//  TestCategary
//
//  Created by 颜仁浩 on 2019/11/28.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVPlayerView.h"

typedef void (^OnPlayerReady)(void);

NS_ASSUME_NONNULL_BEGIN

@interface SmallVideoCell : UITableViewCell

@property (nonatomic, strong) NSString            *url;

@property (nonatomic, strong) AVPlayerView     *playerView;

@property (nonatomic, strong) OnPlayerReady    onPlayerReady;
@property (nonatomic, assign) BOOL             isPlayerReady;

- (void)initData:(NSString *)url;

- (void)play;

- (void)pause;

- (void)replay;

- (void)startDownloadBackgroundTask;

- (void)startDownloadHighPriorityTask;

@end

NS_ASSUME_NONNULL_END
