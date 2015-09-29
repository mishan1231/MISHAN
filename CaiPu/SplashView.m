//
//  SplashView.m
//  CaiPu
//
//  Created by MS on 15/9/29.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "SplashView.h"

@implementation SplashView

- (void)layoutSubviews {
    [super layoutSubviews];
    _containerSV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _containerSV.contentSize = CGSizeMake(UI_SCREEN_W * 4, _containerSV.frame.size.height);
    _containerSV.pagingEnabled = YES;
    _containerSV.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < 4; i ++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_W * i, 0, UI_SCREEN_W, _containerSV.frame.size.height)];
        iv.image = [UIImage imageNamed:@"Image1"];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        [_containerSV addSubview:iv];
    }
    
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(browser) userInfo:nil repeats:YES];
}

- (void)browser {
    if (_containerSV.contentOffset.x == UI_SCREEN_W * (4 - 1)) {
        [_containerSV setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        CGPoint point = _containerSV.contentOffset;
        point.x += UI_SCREEN_W;
        [_containerSV setContentOffset:point animated:YES];
    }
    if (_pageControl.currentPage == 3) {
        _pageControl.currentPage = 0;
    } else {
        _pageControl.currentPage += 1;
    }
}

@end
