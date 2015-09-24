//
//  RecommendationViewController.h
//  CaiPu
//
//  Created by MS on 15/9/22.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentCollectionViewCell.h"
@interface RecommendationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *objectsForShow;


@end
