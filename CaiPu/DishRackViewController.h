//
//  DishRackViewController.h
//  CaiPu
//
//  Created by MS on 15/9/22.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"ActivityTableViewCell.h"
#import "Constants.h"
@interface DishRackViewController : UIViewController<ActivityTableViewCellDelegate, UIActionSheetDelegate> {
    NSIndexPath *ip;
    BOOL loadingMore;
    NSInteger loadCount;
    NSInteger perPage;
    NSInteger totalPage;
}

@property (strong, nonatomic) UIImageView *zoomedIV;
@property (strong, nonatomic) UIActivityIndicatorView *aiv;
@property (strong, nonatomic) UIActivityIndicatorView *tableFooterAI;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *objectsForShow;

@end
