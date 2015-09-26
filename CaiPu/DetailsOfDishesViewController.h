//
//  DetailsOfDishesViewController.h
//  CaiPu
//
//  Created by MS on 15/9/22.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsOfDishesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) PFObject *object;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *DanLabel;
@property (weak, nonatomic) IBOutlet UITextField *TextFile;
@property(strong,nonatomic)PFObject *item;
@end
