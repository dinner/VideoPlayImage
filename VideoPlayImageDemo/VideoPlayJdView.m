//
//  playJdView.m
//  videoPro
//
//  Created by zhanglingxiang on 15/10/10.
//  Copyright (c) 2015年 zhanglingxiang. All rights reserved.
//

#import "VideoPlayJdView.h"

@implementation VideoPlayJdView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(VideoPlayJdView*)getInstance{
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([VideoPlayJdView class]) owner:nil options:nil];
    VideoPlayJdView* view = (VideoPlayJdView*)array[0];
    [view.jdView setProgress:0.f];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}



@end
