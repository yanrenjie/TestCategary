//
//  VideoViewController.m
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/28.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import "VideoViewController.h"
#import "SmallVideoCell.h"
#import "AVPlayerManager.h"

@interface VideoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign) BOOL                              isCurPlayerPause;

@property(nonatomic, assign)CGFloat cellHeight;

@property(nonatomic, strong)NSMutableArray *urlArray;

@property (nonatomic, assign) NSInteger                         currentIndex;

@end

@implementation VideoViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_tableView.layer removeAllAnimations];
    NSArray<SmallVideoCell *> *cells = [_tableView visibleCells];
    for(SmallVideoCell *cell in cells) {
        [cell.playerView cancelLoading];
    }
    [[AVPlayerManager shareManager] removeAllPlayers];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"currentIndex"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCurPlayerPause = NO;
    self.currentIndex = 0;
    self.cellHeight = ScreenHeight;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTouchBegin) name:@"StatusBarTouchBeginNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    /**
            https://v-cdn.zjol.com.cn/280443.mp4
            https://v-cdn.zjol.com.cn/276998.mp4
            https://v-cdn.zjol.com.cn/276993.mp4
     */
    self.urlArray = [[NSMutableArray alloc] init];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -self.cellHeight, ScreenWidth, self.cellHeight * 3) style:UITableViewStylePlain];
    tableView.contentInset = UIEdgeInsetsMake(self.cellHeight, 0, self.cellHeight, 0);
    tableView.backgroundColor = UIColor.clearColor;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[SmallVideoCell class] forCellReuseIdentifier:@"SmallVideoCell"];
    _tableView = tableView;
    [self loadData];
    
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view addSubview:tableView];
        [tableView reloadData];
        
        NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        [tableView scrollToRowAtIndexPath:curIndexPath atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:NO];
        [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.urlArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SmallVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SmallVideoCell" forIndexPath:indexPath];
    [cell initData:self.urlArray[indexPath.row]];
    [cell startDownloadBackgroundTask];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

#pragma ScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        //UITableView禁止响应其他滑动手势
        scrollView.panGestureRecognizer.enabled = NO;
    
        if(translatedPoint.y < -50 && self.currentIndex < (self.urlArray.count - 1)) {
            self.currentIndex ++;   //向下滑动索引递增
        }
        if(translatedPoint.y > 50 && self.currentIndex > 0) {
            self.currentIndex --;   //向上滑动索引递减
        }
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                //UITableView滑动到指定cell
                                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                            } completion:^(BOOL finished) {
                                //UITableView可以响应其他滑动手势
                                scrollView.panGestureRecognizer.enabled = YES;
                            }];
        
    });
}


#pragma KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //观察currentIndex变化
    if ([keyPath isEqualToString:@"currentIndex"]) {
        //设置用于标记当前视频是否播放的BOOL值为NO
        _isCurPlayerPause = NO;
        //获取当前显示的cell
        SmallVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        __weak typeof (cell) wcell = cell;
        __weak typeof (self) wself = self;
        //判断当前cell的视频源是否已经准备播放
        if(cell.isPlayerReady) {
            //播放视频
            [cell replay];
        }else {
            [[AVPlayerManager shareManager] pauseAll];
            //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等待视频准备好后通知播放
            cell.onPlayerReady = ^{
                NSIndexPath *indexPath = [wself.tableView indexPathForCell:wcell];
                if(!wself.isCurPlayerPause && indexPath && indexPath.row == wself.currentIndex) {
                    [wcell play];
                }
            };
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



- (void)statusBarTouchBegin {
    _currentIndex = 0;
}

- (void)applicationBecomeActive {
    SmallVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    if(!_isCurPlayerPause) {
        [cell.playerView play];
    }
}

- (void)applicationEnterBackground {
    SmallVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    _isCurPlayerPause = ![cell.playerView rate];
    [cell.playerView pause];
}

- (void)dealloc {
    NSLog(@"======== dealloc =======");
}


- (void)loadData {
    for (int i = 0; i < 20; i++) {
        NSString *url;
        if (i % 3 == 0) {
            url = @"https://v-cdn.zjol.com.cn/280443.mp4";
        } else if (i % 3 == 1) {
            url = @"https://v-cdn.zjol.com.cn/276998.mp4";
        } else {
            url = @"https://v-cdn.zjol.com.cn/276993.mp4";
        }
        [self.urlArray addObject:url];
    }
    
    [_tableView reloadData];
}

@end
