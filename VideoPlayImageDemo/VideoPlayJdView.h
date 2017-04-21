//
//  playJdView.h
//  videoPro
//
//  Created by zhanglingxiang on 15/10/10.
//  Copyright (c) 2015年 zhanglingxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoPlayJdView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lb_playTime;

@property (weak, nonatomic) IBOutlet UILabel *lb_allTime;

@property (weak, nonatomic) IBOutlet UIProgressView *jdView;


+(VideoPlayJdView*)getInstance;

@end
