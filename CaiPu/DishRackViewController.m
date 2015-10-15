//
//  DishRackViewController.m
//  CaiPu
//
//  Created by MS on 15/9/22.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "DishRackViewController.h"
#import "ActivityObject.h"
#import "UIImageView+WebCache.h"
#import "HomeCell.h"
#import "DetailsOfDishesViewController.h"

@interface DishRackViewController (){  
}


@end

@implementation DishRackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 0;
    [self naviConfiguration];
    [self dataPreparation];
    [self uiConfiguration];
    _tableView.allowsSelection = NO;
    _tableView.allowsMultipleSelection = YES;
    
    _priceLabeal = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_W - 215, _piceview.frame.size.height / 2 - 15, 85, 30)];
    _priceLabeal.textColor=[UIColor redColor];
    
    _priceLabeal.textAlignment = NSTextAlignmentRight;
    _priceLabeal.textColor = [UIColor darkGrayColor];
    _priceLabeal.text = @"";

    [_piceview addSubview:_priceLabeal];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)naviConfiguration {
    NSDictionary* textTitleOpt = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:textTitleOpt];
   
    self.navigationController.navigationBar.barTintColor = [UIColor brownColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
   
}
//进入页面：菊花膜+初始数据（第一页数据）
- (void)dataPreparation {
    _objectsForShow = nil;
    _objectsForShow = [NSMutableArray new];
    //_aiv = [Utilities getCoverOnView:[[UIApplication sharedApplication] keyWindow]];
    [self initializeData];
}
//下拉刷新：刷新器+初始数据（第一页数据）
- (void)initializeData {
    loadCount = 1;
    perPage = 3;
    loadingMore = NO;
    _aiv = [Utilities getCoverOnView:self.view];
    [self urlAction];
}
- (void)urlAction {
    PFQuery *query = [PFQuery queryWithClassName:@"caijia"];
    [query includeKey:@"food"];
    //[query orderByDescending:@"price"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [_aiv stopAnimating];
        UIRefreshControl *rc = (UIRefreshControl *)[_tableView viewWithTag:8001];
        [rc endRefreshing];
        if (!error) {
            _objectsForShow = [NSMutableArray arrayWithArray:returnedObjects];
            [_tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];


}

- (void)uiConfiguration {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    NSString *title = [NSString stringWithFormat:@"下拉即可刷新"];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attrsDictionary = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:[UIColor brownColor]};
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    refreshControl.tintColor = [UIColor brownColor];
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    refreshControl.tag = 8001;
    [refreshControl addTarget:self action:@selector(urlAction) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectsForShow.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (count % 2 == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        CGFloat total = 0.f;
        NSArray *indexPaths = tableView.indexPathsForSelectedRows;
        for (NSIndexPath *ipip in indexPaths) {
            PFObject *obj = [_objectsForShow objectAtIndex:ipip.row];
            PFObject *food = obj[@"food"];
            CGFloat price = [food[@"price"] floatValue] * [obj[@"amount"] floatValue];
            total += price;
        }
        NSLog(@"总价 = %f", total);
        _priceLabeal.text = [Utilities notRounding:total afterPoint:2];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (count % 2 == 1) {
        CGFloat total = 0.f;
        NSArray *indexPaths = tableView.indexPathsForSelectedRows;
        for (NSIndexPath *ipip in indexPaths) {
            PFObject *obj = [_objectsForShow objectAtIndex:ipip.row];
            PFObject *food = obj[@"food"];
            CGFloat price = [food[@"price"] floatValue] * [obj[@"amount"] floatValue];
            total += price;
        }
        NSLog(@"总价 = %f", total);
        _priceLabeal.text = [Utilities notRounding:total afterPoint:2];

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
         ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
         if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
             [cell setSeparatorInset:UIEdgeInsetsZero];
         }
         if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
             [cell setPreservesSuperviewLayoutMargins:NO];
         }
         if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
             [cell setLayoutMargins:UIEdgeInsetsZero];
         }
    cell.delegate = self;
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    PFObject *food = object[@"food"];
    cell.indexPath = indexPath;
    PFFile *photo = food[@"image"];
    CGFloat price= [food[@"price"] floatValue] * [object[@"amount"] floatValue];
    NSString *priceStr = [Utilities notRounding:price afterPoint:2];
    cell.priceLabel.text = [NSString stringWithFormat:@"价格：%@", priceStr];
    //NSString *feng=object[@"amount"];
    NSString *like=food[@"like"] ;
     NSString *unlike=food[@"unlike"] ;
    NSString *kind=food[@"kind"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.PhotoView.image = image;
            });
        }
    }];
   
    cell.NameLabel.text = food[@"Name"];
    cell.ContentLabel.text = food[@"xiangqing"];
    cell.LikeLabel.text=[NSString stringWithFormat:@"👌：%@", like];
    cell.UnlikeLabel.text=[NSString stringWithFormat:@"👌：%@", unlike];
    cell.kindLabel.text=[NSString stringWithFormat:@"菜系：%@", kind];
    return cell;
     }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *cj = [_objectsForShow objectAtIndex:indexPath.row];
        
        [cj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [_objectsForShow removeObjectAtIndex:indexPath.row];
                
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                //[_tableView respondsToSelector:YES];
            }
        }];
    }
}

- (void)loadDataing {
    if (totalPage > loadCount) {
        loadCount ++;
        [self urlAction];
} else {
             [self performSelector:@selector(beforeLoadEnd) withObject:nil afterDelay:0.25];
        }
     }
- (void)beforeLoadEnd {
    UILabel *label = (UILabel *)[self.tableView.tableFooterView viewWithTag:9001];
    [label setText:@"当前已无更多数据"];
    [_tableFooterAI stopAnimating];
    _tableFooterAI = nil;
    [self performSelector:@selector(loadDataEnd) withObject:nil afterDelay:0.25];
     }
- (void)loadDataEnd {
    self.tableView.tableFooterView = [[UIView alloc] init];
    loadingMore = NO;
}
- (void)photoTapAtIndexPath:(NSIndexPath *)indexPath {
    //ActivityObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    PFObject *food = object[@"food"];
    PFFile *photo = food[@"image"];
    _zoomedIV = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _zoomedIV.userInteractionEnabled = YES;
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _zoomedIV.image = image;
            });
        }
    }];

    _zoomedIV.contentMode = UIViewContentModeScaleAspectFit;
    _zoomedIV.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *ivTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ivTap:)];
    [_zoomedIV addGestureRecognizer:ivTap];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_zoomedIV];
}
- (void)ivTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateRecognized) {
        [_zoomedIV removeFromSuperview];
        _zoomedIV = nil;
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    ActivityObject *object = [_objectsForShow objectAtIndex:ip.row];
    if (buttonIndex == 0) {
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        [pasteBoard setString:object.name];
    } else if (buttonIndex == 1) {
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        [pasteBoard setString:object.content];
    }
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 1) {
//        if ([[_objectsForShow objectAtIndex:ip.row] applied]) {
//            [[_objectsForShow objectAtIndex:ip.row] setApplied:NO];
//        } else {
//            [[_objectsForShow objectAtIndex:ip.row] setApplied:YES];
//        }
//        [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}


- (IBAction)BianjiButton:(UIBarButtonItem *)sender {
    if (++ count % 2 == 1) {
        _tableView.allowsSelection = YES;
        [_tableView setEditing:YES animated:YES];
        _editBarButtonItem.title = @"取消";
    } else {
        _priceLabeal.text = @"";
        _tableView.allowsSelection = NO;
        [_tableView setEditing:NO animated:YES];
        _editBarButtonItem.title = @"选单";
    }
    
}

- (IBAction)jiesuanButton:(UIButton *)sender {
    if ([_priceLabeal.text isEqualToString:@""]) {
        [Utilities  popUpAlertViewWithMsg:@"请选择一种需要的餐点！" andTitle:nil] ;
        return;
    }
    else{
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:[NSString stringWithFormat:@"您将消费%@元", _priceLabeal.text] delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"确定",nil];
    [promptAlert show];
}
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UIAlertView *proptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"本次消费成功，请稍后！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
     [proptAlert show];
        return;
    }
    
}


@end
