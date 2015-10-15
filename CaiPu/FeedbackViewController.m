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
    self.navigationController.navigationBar.barTintColor = [UIColor brownColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary* textTitleOpt = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:textTitleOpt];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
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
    NSString *text=_TextView.text;
    if ([text isEqualToString:@""]) {
        UIAlertView *propmtAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"对不起！您输入的内容为空，请重新输入。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [propmtAlert show];

        return;
    }
    else{
        _TextView.text=@"";
        UIAlertView *proptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"感谢您的宝贵建议，本店会慎重考虑！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [proptAlert show];
        return;
        
    }
}
@end
