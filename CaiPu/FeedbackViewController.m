//
//  FeedbackViewController.m
//  CaiPu
//
//  Created by MS on 15/9/22.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()
- (IBAction)Feedbutton:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)Feedbutton:(UIButton *)sender forEvent:(UIEvent *)event {
    
    [Utilities popUpAlertViewWithMsg:@"感谢您的宝贵建议，本店会认真考虑！" andTitle:nil];


}
@end
