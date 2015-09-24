//
//  HomeViewController.m
//  CaiPu
//
//  Created by MS on 15/9/21.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
- (IBAction)foodbutton:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    //查询Food表
    PFQuery *query = [PFQuery queryWithClassName:@"Food"];
    //执行查询
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        //完成时候的回调：returnedObjects数组；error错误信息
        if (!error) {
            //打印结果
            _objectsForShow = returnedObjects;
            NSLog(@"%@", _objectsForShow);
        } else {
            //打印错误
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectsForShow.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"名称%@", object[@"name"]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"价格：%@", object[@"price"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (IBAction)foodbutton:(UIButton *)sender forEvent:(UIEvent *)event {
    
    
    
}
@end
