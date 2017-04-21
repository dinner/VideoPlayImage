//
//  ViewController.m
//  VideoPlayImageDemo
//
//  Created by zhanglingxiang on 17/4/21.
//  Copyright © 2017年 James. All rights reserved.
//

#define font [UIFont systemFontOfSize:12]

#import "ViewController.h"
#import "CFDanmaku.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.VideoScreenShortImage setM_strVideoUrl:@"http://23.106.155.217:8090/VideoPro/video/a5327c6b89e3ad86.mp4"];

}

-(void)setDanmu{
    NSMutableArray* danmakus = [NSMutableArray array];
    int postion=0;//0 1 2三个值分别表示弹幕出现的位置上中下
    for (int i=0;i<10;i++) {
        postion = postion % 3;
        CFDanmaku* danmaku = [[CFDanmaku alloc] init];
        NSString* content = [NSString stringWithFormat:@"我是弹幕:%d",postion];
        NSMutableAttributedString* strMain = [[NSMutableAttributedString alloc] init];
        NSAttributedString* strM = [[NSAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor redColor]}];
        [strMain appendAttributedString:strM];
        
        danmaku.contentStr = strMain;
        danmaku.timePoint = 1.000;
        danmaku.position = postion;
        [danmakus addObject:danmaku];
        postion++;
    }
    [self.VideoScreenShortImage.danmakuView prepareDanmakus:danmakus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btAddDanmuClicked:(id)sender {
    [self setDanmu];
}


@end
