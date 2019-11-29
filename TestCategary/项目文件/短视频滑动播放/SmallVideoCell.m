//
//  SmallVideoCell.m
//  TestCategary
//
//  Created by 颜仁浩 on 2019/11/28.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import "SmallVideoCell.h"
#import <AVFoundation/AVFoundation.h>
#import "UIWindow+Extension.h"

@interface SmallVideoCell()<AVPlayerUpdateDelegate>

@property (nonatomic, strong) UIView                   *container;
@property (nonatomic ,strong) CAGradientLayer          *gradientLayer;
@property (nonatomic ,strong) UIImageView              *pauseIcon;
@property (nonatomic, strong) UIView                   *playerStatusBar;
@property (nonatomic, assign) NSTimeInterval           lastTapTime;
@property (nonatomic, assign) CGPoint                  lastTapPoint;
@property (nonatomic, strong) UITapGestureRecognizer   *singleTapGesture;

@end


@implementation SmallVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = RandomColor;
        _lastTapTime = 0;
        _lastTapPoint = CGPointZero;
        [self initSubViews];
    }
    return self;
}


- (void)initSubViews {
    _playerView = [AVPlayerView new];
    _playerView.delegate = self;
    [self.contentView addSubview:_playerView];
    
    //init hover on player view container
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [_container addGestureRecognizer:_singleTapGesture];
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.colors = @[(__bridge id)UIColor.clearColor.CGColor, (__bridge id)[UIColor.blackColor colorWithAlphaComponent:.2].CGColor, (__bridge id)[UIColor.blackColor colorWithAlphaComponent:.4].CGColor];
    _gradientLayer.locations = @[@0.3, @0.6, @1.0];
    _gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    _gradientLayer.endPoint = CGPointMake(0.0f, 1.0f);
    [_container.layer addSublayer:_gradientLayer];
    
    _pauseIcon = [[UIImageView alloc] init];
    _pauseIcon.image = [UIImage imageNamed:@"icon_play_pause"];
    _pauseIcon.contentMode = UIViewContentModeCenter;
    _pauseIcon.layer.zPosition = 3;
    _pauseIcon.hidden = YES;
    [_container addSubview:_pauseIcon];
    
    //init player status bar
    _playerStatusBar = [[UIView alloc] init];
    _playerStatusBar.backgroundColor = UIColor.whiteColor;
    [_playerStatusBar setHidden:YES];
    [_container addSubview:_playerStatusBar];
    
    [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_pauseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(100);
    }];
    
    //make constraintes
    [_playerStatusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).inset(49.5f + (k_Height_SafeBottom));
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _isPlayerReady = NO;
    [_playerView cancelLoading];
    [_pauseIcon setHidden:YES];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _gradientLayer.frame = CGRectMake(0, self.frame.size.height - 500, self.frame.size.width, 500);
    [CATransaction commit];
}

//gesture
- (void)handleGesture:(UITapGestureRecognizer *)sender {
    //获取点击坐标，用于设置爱心显示位置
    CGPoint point = [sender locationInView:_container];
    //获取当前时间
    NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    //判断当前点击时间与上次点击时间的时间间隔
    if(time - _lastTapTime > 0.25f) {
        //推迟0.25秒执行单击方法
        [self performSelector:@selector(singleTapAction) withObject:nil afterDelay:0.25f];
    }else {
        //取消执行单击方法
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction) object: nil];
    }
    //更新上一次点击位置
    _lastTapPoint = point;
    //更新上一次点击时间
    _lastTapTime =  time;
}

- (void)singleTapAction {
    [self showPauseViewAnim:[_playerView rate]];
    [_playerView updatePlayerState];
}


//暂停播放动画
- (void)showPauseViewAnim:(CGFloat)rate {
    if(rate == 0) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             self.pauseIcon.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             [self.pauseIcon setHidden:YES];
                         }];
    }else {
        [_pauseIcon setHidden:NO];
        _pauseIcon.transform = CGAffineTransformMakeScale(1.8f, 1.8f);
        _pauseIcon.alpha = 1.0f;
        [UIView animateWithDuration:0.25f delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.pauseIcon.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                            } completion:^(BOOL finished) {
                            }];
    }
}

//加载动画
-(void)startLoadingPlayItemAnim:(BOOL)isStart {
    if (isStart) {
        _playerStatusBar.backgroundColor = UIColor.whiteColor;
        [_playerStatusBar setHidden:NO];
        [_playerStatusBar.layer removeAllAnimations];
        
        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.duration = 0.5;
        animationGroup.beginTime = CACurrentMediaTime() + 0.5;
        animationGroup.repeatCount = MAXFLOAT;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animation];
        scaleAnimation.keyPath = @"transform.scale.x";
        scaleAnimation.fromValue = @(1.0f);
        scaleAnimation.toValue = @(1.0f * ScreenWidth);
        
        CABasicAnimation * alphaAnimation = [CABasicAnimation animation];
        alphaAnimation.keyPath = @"opacity";
        alphaAnimation.fromValue = @(1.0f);
        alphaAnimation.toValue = @(0.5f);
        [animationGroup setAnimations:@[scaleAnimation, alphaAnimation]];
        [self.playerStatusBar.layer addAnimation:animationGroup forKey:nil];
    } else {
        [self.playerStatusBar.layer removeAllAnimations];
        [self.playerStatusBar setHidden:YES];
    }
    
}


- (void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status {
    switch (status) {
        case AVPlayerItemStatusUnknown:
            [self startLoadingPlayItemAnim:YES];
            break;
        case AVPlayerItemStatusReadyToPlay:
            [self startLoadingPlayItemAnim:NO];
            
            _isPlayerReady = YES;
            
            if(_onPlayerReady) {
                _onPlayerReady();
            }
            break;
        case AVPlayerItemStatusFailed:
            [self startLoadingPlayItemAnim:NO];
            [UIWindow showTips:@"加载失败"];
            break;
        default:
            break;
    }
}

- (void)onProgressUpdate:(CGFloat)current total:(CGFloat)total {
    
}



// update method
- (void)initData:(NSString *)url{
    _url = url;
}

- (void)play {
    [_playerView play];
    [_pauseIcon setHidden:YES];
}

- (void)pause {
    [_playerView pause];
    [_pauseIcon setHidden:NO];
}

- (void)replay {
    [_playerView replay];
    [_pauseIcon setHidden:YES];
}

- (void)startDownloadBackgroundTask {
    [_playerView setPlayerWithUrl:_url];
}

- (void)startDownloadHighPriorityTask {
    [_playerView startDownloadTask:[[NSURL alloc] initWithString:_url] isBackground:NO];
}

@end
