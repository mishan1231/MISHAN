//
//  DetailsOfDishesViewController.m
//  CaiPu
//
//  Created by MS on 15/9/22.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "DetailsOfDishesViewController.h"


@interface DetailsOfDishesViewController () {
    CGFloat price;
}
- (IBAction)jianButton:(UIButton *)sender;
- (IBAction)jiaButton:(UIButton *)sender;
- (IBAction)joinAddButton:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)MoveButton:(UIButton *)sender forEvent:(UIEvent *)event;

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
        //NSString *price = _priceLabel.text;
        //NSString *describe = _describeLabel.text;
        
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
   
    
    
//    NSData *photoData = UIImagePNGRepresentation(_photoIV.image);
//    PFFile *photoFile = [PFFile fileWithName:@"photo.png" data:photoData];
//    item1[@"photo"] = photoFile;
    
    
    


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
    
    
    
    
    
}





- (IBAction)MoveButton:(UIButton *)sender forEvent:(UIEvent *)event {
    
    
    
    
}
@end
