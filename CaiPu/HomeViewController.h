//
//  HomeViewController.h
//  CaiPu
//
//  Created by MS on 15/9/21.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *objectsForShow;
@property (weak, nonatomic) IBOutlet UISegmentedControl *caixi;
@property (weak, nonatomic) IBOutlet UISegmentedControl *kouwei;

@end
