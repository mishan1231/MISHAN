//
//  SplashView.h
//  CaiPu
//
//  Created by MS on 15/9/29.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface SplashView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIScrollView *containerSV;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSTimer *timer;

@end
