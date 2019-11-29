//
//  AVPlayerManager.h
//  TestCategary
//
//  Created by 颜仁浩 on 2019/11/29.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface AVPlayerManager : NSObject

@property (nonatomic, strong) NSMutableArray<AVPlayer *>   *playerArray;  //用于存储AVPlayer的数组

+ (AVPlayerManager *)shareManager;
+ (void)setAudioMode;
- (void)play:(AVPlayer *)player;
- (void)pause:(AVPlayer *)player;
- (void)pauseAll;
- (void)replay:(AVPlayer *)player;
- (void)removeAllPlayers;

@end

NS_ASSUME_NONNULL_END
