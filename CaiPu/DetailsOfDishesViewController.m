//
//  DetailsOfDishesViewController.m
//  CaiPu
//
//  Created by MS on 15/9/22.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "DetailsOfDishesViewController.h"
#import "DishRackViewController.h"

@interface DetailsOfDishesViewController () {
    CGFloat price;
}
- (IBAction)jianButton:(UIButton *)sender;
- (IBAction)jiaButton:(UIButton *)sender;
- (IBAction)joinAddButton:(UIButton *)sender forEvent:(UIEvent *)event;



@end

@implementation DetailsOfDishesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor brownColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    

    _TextFile.text = @"1";
    NSLog(@"%@", _item);
    PFFile *photo = _item[@"image"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _photoIV.image = image;
            });
        }
    }];
    _describeLabel.text = _item[@"xiangqing"];
    _priceLabel.text = [NSString stringWithFormat:@"%@", _item[@"price"]];
    _DanLabel.text = [NSString stringWithFormat:@"%@", _item[@"danwei"]];
    price = [_priceLabel.text floatValue];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)jianButton:(UIButton *)sender {
    if ([_TextFile.text integerValue] > 1) {
        NSInteger count = [_TextFile.text integerValue] - 1;
        _TextFile.text = [NSString stringWithFormat:@"%ld", (long)count];
        CGFloat total = price * count;
        _priceLabel.text = [Utilities notRounding:total afterPoint:2];
    }
}

- (IBAction)jiaButton:(UIButton *)sender {
    NSInteger count = [_TextFile.text integerValue] + 1;
    _TextFile.text = [NSString stringWithFormat:@"%ld", (long)count];
    CGFloat total = price * count;
    _priceLabel.text = [Utilities notRounding:total afterPoint:2];
}

- (IBAction)joinAddButton:(UIButton *)sender forEvent:(UIEvent *)event {
    
    PFObject *cj = [PFObject objectWithClassName:@"caijia"];
    cj[@"food"] = _item;
    cj[@"amount"] = _TextFile.text;
    cj[@"data"]=[NSDate date];
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [cj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [aiv stopAnimating];
        if (succeeded) {
            UIAlertView *proptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"成功加入菜架！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [proptAlert show];
} else {
            [Utilities popUpAlertViewWithMsg:@"加入菜架失败，请重试！" andTitle:nil];
        }
    }];
    
}

//- (IBAction)caijiaGoTo:(UIBarButtonItem *)sender {
    //DishRackViewController *vc = [Utilities getStoryboardInstanceByIdentity:@"dish"];
    //UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    //vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //[self presentViewController:navi animated:YES completion:nil];
    //[self.navigationController popToViewController:vc animated:YES];
//}
@end
