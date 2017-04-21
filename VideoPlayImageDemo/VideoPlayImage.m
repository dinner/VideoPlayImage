//
//  playImage.m
//  videoPro
//
//  Created by zhanglingxiang on 15/9/30.
//  Copyright (c) 2015年 zhanglingxiang. All rights reserved.
//

//#define PLAY_PIC    @"play.png"
#define PLAY_PIC    @"video_icon.png"
#define PAUSE_PIC   @"pause.png"

#import "VideoPlayImage.h"
#import "VideoPlayJdView.h"


@interface VideoPlayImage(){
    AVPlayer* player;
    AVPlayerLayer* playerLayer;
    AVPlayerItem* playerItem;
    CALayer* playOrPauseLayer;
    
    CGFloat jdFloat;//缓冲进度
    UIActivityIndicatorView* indicatorView;//进度刷新视图
    VideoPlayJdView* m_playJd;
    
    NSTimer* timer;
    
//    CFDanmakuView *_danmakuView;
    
    CGFloat fl;
    CGFloat totalDuration;//视频总时长
}

@end

@implementation VideoPlayImage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init{
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    NSLog(@"layoutSublayersOfLayer");
    
    [playerLayer setFrame:self.bounds];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        [self addGestureRecognizer:tap];
        
        //双击
        UITapGestureRecognizer* doubleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClicked:)];
        doubleClick.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleClick];
        
        jdFloat = 0.f;
        //
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
        [timer setFireDate:[NSDate distantFuture]];//暂停
        
        fl = 0.f;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tanmuOnOrOff:) name:@"tanmu" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerDealloc) name:@"headerDealloc" object:nil];
    }
    return self;
}

//-(void)willMoveToWindow:(UIWindow *)newWindow{
//    [timer setFireDate:[NSDate distantFuture]];
//}
//-(void)willRemoveSubview:(UIView *)subview{
//    [timer setFireDate:[NSDate distantFuture]];
//}

//弹幕初始化
-(void)tanmuInit{
    //    CGRect rect = m_header.player.bounds;
    CGRect rect = CGRectMake(0, 10, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-30.f);
    _danmakuView = [[CFDanmakuView alloc] initWithFrame:rect];
    [_danmakuView setBackgroundColor:[UIColor clearColor]];
    _danmakuView.duration = 6.5;
    _danmakuView.centerDuration = 2.5;
    _danmakuView.lineHeight = 25;
    _danmakuView.maxShowLineCount = 15;
    _danmakuView.maxCenterLineCount = 5;
    
    _danmakuView.delegate = self;
    [self addSubview:_danmakuView];
}

-(CGFloat)getCurrentSecond{
    CMTime currentTime = playerItem.currentTime;
    CGFloat currentPlayTime = (CGFloat)currentTime.value/currentTime.timescale;//
    return currentPlayTime;
}

-(void)setM_strVideoUrl:(NSString *)m_strVideoUrl{
    NSLog(@"setm_videoUrl");
    _m_strVideoUrl = m_strVideoUrl;
    //
    NSURL* url = [NSURL URLWithString:m_strVideoUrl];
    AVURLAsset* urlAssert = [AVURLAsset URLAssetWithURL:url options:nil];
    if (playerItem == nil) {
        playerItem = [AVPlayerItem playerItemWithAsset:urlAssert];
    }
    if (player == nil) {
        player = [AVPlayer playerWithPlayerItem:playerItem];
    }
    if (playerLayer == nil) {
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    }
    playOrPauseLayer = [CALayer layer];
    playOrPauseLayer.bounds = CGRectMake(0, 0, 24, 24);
    playOrPauseLayer.position = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2, CGRectGetHeight(self.bounds)/2);
    playOrPauseLayer.contents = (id)[UIImage imageNamed:PLAY_PIC].CGImage;
    
    //
    [playerLayer setFrame:self.bounds];
    playerLayer.masksToBounds = YES;
//    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.needsDisplayOnBoundsChange = YES;
    [self.layer addSublayer:playerLayer];
    [self.layer addSublayer:playOrPauseLayer];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemPlayToEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    [self tanmuInit];
}
/*
-(void)setTheVideoUrl:(NSString*) strUrl{
    NSLog(@"setm_videoUrl");
    _m_strVideoUrl = strUrl;
    //
    NSURL* url = [NSURL URLWithString:_m_strVideoUrl];
    AVURLAsset* urlAssert = [AVURLAsset URLAssetWithURL:url options:nil];
    if (playerItem == nil) {
        playerItem = [AVPlayerItem playerItemWithAsset:urlAssert];
    }
    if (player == nil) {
        player = [AVPlayer playerWithPlayerItem:playerItem];
    }
    if (playerLayer == nil) {
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    }
    
    //
    playerLayer.masksToBounds = YES;
    playerLayer.cornerRadius = 2.0f;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.needsDisplayOnBoundsChange = YES;
    [self.layer addSublayer:playerLayer];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemPlayToEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    [self tanmuInit];
}
*/
//
-(void)imageClicked:(UITapGestureRecognizer*)tap{
    if (player.rate == 1.f) {//正在播放 暂停
        [player pause];
        [timer setFireDate:[NSDate distantFuture]];//定时器关闭
        
        playOrPauseLayer.contents = (id)[UIImage imageNamed:PAUSE_PIC].CGImage;
        [_danmakuView pause];
    }
    else{
        if (fabs(jdFloat-1.f) < 1e-6) {//缓冲完毕方可播放
            [player play];
            [timer setFireDate:[NSDate distantPast]];
            playOrPauseLayer.contents = nil;
            if (_danmakuView.isPrepared && _danmakuView.isHidden == NO) {
                [_danmakuView start];
            }
        }
        else{
            if (indicatorView != nil) {
                return;
            }
//            playOrPauseLayer.contents = (id)[UIImage imageNamed:nil].CGImage;
            playOrPauseLayer.contents = nil;
            indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [indicatorView startAnimating];
            indicatorView.center = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2 );
            [self addSubview:indicatorView];
        }
    }
}

//双击
-(void)doubleClicked:(id)sender{
    NSLog(@"双击");
}

-(void)playerItemPlayToEnd:(id)sender{
    NSLog(@"播放完成");
    [timer setFireDate:[NSDate distantFuture]];//定时器关闭
    
    m_playJd.jdView.progress = 0.f;
    
    CMTime dragedCMTime = CMTimeMake(1, 10);
    [player seekToTime:dragedCMTime];
    playOrPauseLayer.contents = (id)[UIImage imageNamed:PLAY_PIC].CGImage;
    
    //
    [self.danmakuView stop];
    fl = 0.f;
}

-(void)dealloc{
    NSLog(@"释放");

//    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
}

-(void)headerDealloc{
    [timer invalidate];
    timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tanmu" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"headerDealloc" object:nil];
    
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.danmakuView pause];
    
//    playOrPauseLayer = nil;
//    playerLayer = nil;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem* item = (AVPlayerItem*)object;
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        NSLog(@"Time Interval:%f",timeInterval);
        CMTime duration = item.duration;
        totalDuration = CMTimeGetSeconds(duration);
        jdFloat = timeInterval / totalDuration;
        NSLog(@"%f",jdFloat);
        if (fabs(jdFloat-1.f) <= 1e-6) {
            int minu = (int)timeInterval/60;
            int sec = (int)timeInterval % 60;
            NSString* strMinu,*strSec;
            if (minu < 10) {
                strMinu = [NSString stringWithFormat:@"0%d",minu];
            }
            else{
                strMinu = [NSString stringWithFormat:@"%d",minu];
            }
            if (sec < 10) {
                strSec = [NSString stringWithFormat:@"0%d",sec];
            }
            else{
                strSec = [NSString stringWithFormat:@"%d",sec];
            }
            NSString* strTime = [NSString stringWithFormat:@"%@:%@",strMinu,strSec];
            
            if (m_playJd == nil) {
                m_playJd = [VideoPlayJdView getInstance];
                [m_playJd setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds)-30.f,21.f)];
                [m_playJd setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height-20.f)];
                [m_playJd.lb_allTime setText:strTime];
                [self addSubview:m_playJd];
            }
            if (indicatorView != nil) {
                [indicatorView stopAnimating];
                [player play];
                
                if (self.danmakuView.isPrepared == YES && [self.danmakuView isHidden] == NO){
                    [self.danmakuView start];
                }
                
                //
                [timer setFireDate:[NSDate date]];
            }
        }
    }
}

-(NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

//获取当前播放进度
-(CGFloat)getPlayJd{
    CGFloat playTime = [self getCurrentSecond];
    CMTime duration = playerItem.duration;
    CGFloat totalDuration = CMTimeGetSeconds(duration);
    CGFloat jd = playTime/totalDuration;
    //
    int minu = (int)playTime/60;
    int sec = (int)playTime % 60;
    NSString* strMinu;
    NSString* strSec;
    if (minu < 10) {
        strMinu = [NSString stringWithFormat:@"0%d",minu];
    }
    else{
        strMinu = [NSString stringWithFormat:@"%d",minu];
    }
    if (sec < 10) {
        strSec = [NSString stringWithFormat:@"0%d",sec];
    }
    else{
        strSec = [NSString stringWithFormat:@"%d",sec];
    }
    [m_playJd.lb_playTime setText:[NSString stringWithFormat:@"%@:%@",strMinu,strSec]];
    
    return jd;
}

//时间戳开启
-(void)timerStart:(id)sender{
    fl += 0.1 / totalDuration;
    CGFloat jd = [self getPlayJd];
    [m_playJd.jdView setProgress:jd];
}

-(void)play{
    [player play];
    [timer setFireDate:[NSDate date]];//定时器开启
    playOrPauseLayer.contents = (id)[UIImage imageNamed:nil].CGImage;
//    [self.danmakuView pause];
    //通知播放
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bf" object:nil];
}

-(void)pause{
    [player pause];
    
    [timer setFireDate:[NSDate distantFuture]];//定时器关闭
    playOrPauseLayer.contents = (id)[UIImage imageNamed:PAUSE_PIC].CGImage;
    [self.danmakuView pause];
    //通知暂停
    [[NSNotificationCenter defaultCenter] postNotificationName:@"zt" object:nil];
}

// 获取视频播放时间
- (NSTimeInterval)danmakuViewGetPlayTime:(CFDanmakuView *)danmakuView{
    return fl * totalDuration;
}
// 加载视频中
- (BOOL)danmakuViewIsBuffering:(CFDanmakuView *)danmakuView{
    return NO;
}

//弹幕的开启与关闭
-(void)tanmuOnOrOff:(NSNotification*)not{
    NSDictionary* dic = not.userInfo;
    if ([dic[@"tanmu"] intValue] == 1) {
        [self.danmakuView setHidden:NO];
        if ([self isPlay]) {
           [self.danmakuView start];
        }
    }
    else
    {
        [self.danmakuView setHidden:YES];
        [self.danmakuView pause];
    }
}

//
-(BOOL)isPlay{
    return (player.rate == 1.f);
}




@end
