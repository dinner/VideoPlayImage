//
//  ViewController.h
//  VideoPlayImageDemo
//
//  Created by zhanglingxiang on 17/4/21.
//  Copyright © 2017年 James. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPlayImage.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet VideoPlayImage *VideoScreenShortImage;
- (IBAction)btAddDanmuClicked:(id)sender;


@end

