//
//  ActivityTableViewCell.h
//  CaiPu
//
//  Created by MS on 15/9/23.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ActivityTableViewCellDelegate;
@interface ActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) id<ActivityTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIImageView *PhotoView;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *LikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *UnlikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *kindLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *danweiLabel;
@property (weak, nonatomic) IBOutlet UILabel *fengLabel;


@end
@protocol ActivityTableViewCellDelegate <NSObject>
@required
- (void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath;
- (void)photoTapAtIndexPath:(NSIndexPath *)indexPath;
- (void)applyPressed:(NSIndexPath *)indexPath;
@end
