//
//  playImage.h
//  videoPro
//
//  Created by zhanglingxiang on 15/9/30.
//  Copyright (c) 2015年 zhanglingxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CFDanmakuView.h"

@interface VideoPlayImage : UIImageView

@property(retain,nonatomic) AVPlayer* m_mediaPlayer;
@property(retain,nonatomic) CALayer* m_pauseOrPlayLayer;
@property(retain,nonatomic) AVPlayerLayer* m_playerLayer;
@property(retain,nonatomic) NSString* m_strVideoUrl;
@property (retain,nonatomic) CFDanmakuView *danmakuView;


-(void)setM_strVideoUrl:(NSString *)m_strVideoUrl;
-(void)setTheVideoUrl:(NSString*) strUrl;

-(CGFloat)getCurrentSecond;

-(void)play;

-(void)pause;


@end
