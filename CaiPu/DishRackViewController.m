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
@interface DishRackViewController ()

@end

@implementation DishRackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfiguration];
    [self dataPreparation];
    [self uiConfiguration];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfiguration {
    NSDictionary* textTitleOpt = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:textTitleOpt];
   // self.navigationItem.title = @"活动";
    self.navigationController.navigationBar.barTintColor = [UIColor brownColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setTranslucent:YES];
}
//进入页面：菊花膜+初始数据（第一页数据）
- (void)dataPreparation {
    _objectsForShow = nil;
    _objectsForShow = [NSMutableArray new];
    _aiv = [Utilities getCoverOnView:[[UIApplication sharedApplication] keyWindow]];
    [self initializeData];
}
//下拉刷新：刷新器+初始数据（第一页数据）
- (void)initializeData {
    loadCount = 1;
    perPage = 3;
    loadingMore = NO;
    [self urlAction];
}
- (void)urlAction {
    NSString *url = @"http://v0430.api.gym.yundongbang.com/event/list";
    NSString *decodedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:loadCount], @"page", [NSNumber numberWithInteger:perPage], @"perPage", nil];
    
    [[appAPIClient sharedClient] GET:decodedUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"resultFlag"] integerValue] == 8001) {
            NSDictionary *resultDic = [responseObject objectForKey:@"result"];
            NSArray *models = [resultDic objectForKey:@"models"];
            if (loadCount == 1) {
                _objectsForShow = nil;
                _objectsForShow = [NSMutableArray new];
            }
            for (NSDictionary *dic in models) {
                [_objectsForShow addObject:[[ActivityObject alloc] initWithDictionary:dic]];
            }
            NSDictionary *pageDic = [resultDic objectForKey:@"pagingInfo"];
            totalPage = [[pageDic objectForKey:@"totalPage"] intValue];
            [self.tableView reloadData];
        } else {
            [Utilities popUpAlertViewWithMsg:[responseObject objectForKey:@"message"] andTitle:nil];
        }
        [_aiv stopAnimating];
        [self loadDataEnd];
        UIRefreshControl *refreshControl = (UIRefreshControl *)[self.tableView viewWithTag:8001];
        [refreshControl endRefreshing];
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        [_aiv stopAnimating];
        [self loadDataEnd];
        UIRefreshControl *refreshControl = (UIRefreshControl *)[self.tableView viewWithTag:8001];
        [refreshControl endRefreshing];
        [Utilities popUpAlertViewWithMsg:[error localizedDescription] andTitle:nil];
    }];
}
- (void)uiConfiguration {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    NSString *title = [NSString stringWithFormat:@"下拉即可刷新"];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attrsDictionary = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                      NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                      NSParagraphStyleAttributeName:style,
                                      NSForegroundColorAttributeName:[UIColor brownColor]};
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    refreshControl.tintColor = [UIColor brownColor];
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    refreshControl.tag = 8001;
    [refreshControl addTarget:self action:@selector(initializeData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
         // Return the number of rows in the section.
         return _objectsForShow.count;
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
         ActivityObject *object = [_objectsForShow objectAtIndex:indexPath.row];
         cell.indexPath = indexPath;
         [cell.PhotoView sd_setImageWithURL:[NSURL URLWithString:[object.imgUrl isKindOfClass:[NSNull class]] ? nil : object.imgUrl] placeholderImage:[UIImage imageNamed:@"Default"]];
         cell.NameLabel.text = object.name;
         cell.ContentLabel.text = object.content;
         cell.LikeLabel.attributedText = [self setAttributedStringWithFirstText:@"顶:" andSecondText:[NSString stringWithFormat:@"%ld", (long)object.like]];
         cell.UnlikeLabel.attributedText = [self setAttributedStringWithFirstText:@"踩:" andSecondText:[NSString stringWithFormat:@"%ld", (long)object.unlike]];
         
         return cell;
     }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
         ActivityObject *object = [_objectsForShow objectAtIndex:indexPath.row];
         ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
         CGSize maxSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 30, 1000);
         CGSize contentLabelSize = [object.content boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:cell.ContentLabel.font} context:nil].size;
         return cell.ContentLabel.frame.origin.y + contentLabelSize.height + 16;
     }
     
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
         [tableView deselectRowAtIndexPath:indexPath animated:YES];
     }
     
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
         if (scrollView.contentSize.height > scrollView.frame.size.height) {
             if (!loadingMore && scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height)) {
                 [self loadDataBegin];
             }
         } else {
             if (!loadingMore && scrollView.contentOffset.y > 0) {
                 [self loadDataBegin];
             }
         }
     }
     
     - (void)loadDataBegin {
         if (loadingMore == NO) {
             loadingMore = YES;
             [self createTableFooter];
             _tableFooterAI = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((UI_SCREEN_W - 86.0f) / 2 - 30.0f, 10.0f, 20.0f, 20.0f)];
             [_tableFooterAI setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
             [self.tableView.tableFooterView addSubview:_tableFooterAI];
             [_tableFooterAI startAnimating];
             [self loadDataing];
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
     
     - (void)createTableFooter {
         UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 40.0f)];
         UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_W - 86.0f) / 2, 0.0f, 116.0f, 40.0f)];
         loadMoreText.tag = 9001;
         [loadMoreText setFont:[UIFont systemFontOfSize:B_Font]];
         [loadMoreText setText:@"上拉显示更多数据"];
         [tableFooterView addSubview:loadMoreText];
         loadMoreText.textColor = [UIColor grayColor];
         self.tableView.tableFooterView = tableFooterView;
     }
     
     - (NSMutableAttributedString *)setAttributedStringWithFirstText:(NSString *)first andSecondText:(NSString *)second {
         NSMutableParagraphStyle *styleL = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
         [styleL setAlignment:NSTextAlignmentLeft];
         [styleL setLineBreakMode:NSLineBreakByWordWrapping];
         NSMutableParagraphStyle *styleR = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
         [styleR setAlignment:NSTextAlignmentRight];
         [styleR setLineBreakMode:NSLineBreakByWordWrapping];
         UIFont *font = [UIFont systemFontOfSize:11];
         
         NSDictionary *dictL = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                 NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:styleL,
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor]
                                 };
         NSDictionary *dictR = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                 NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:styleR,
                                 NSForegroundColorAttributeName:[UIColor brownColor]
                                 };
         
   NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
   [attString appendAttributedString:[[NSAttributedString alloc] initWithString:first attributes:dictL]];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:second attributes:dictR]];
         return attString;
     }
- (void)photoTapAtIndexPath:(NSIndexPath *)indexPath {
   // ActivityObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    _zoomedIV = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _zoomedIV.userInteractionEnabled = YES;
    //_zoomedIV.image = [Utilities imageUrl:object.imgUrl];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([[_objectsForShow objectAtIndex:ip.row] applied]) {
            [[_objectsForShow objectAtIndex:ip.row] setApplied:NO];
        } else {
            [[_objectsForShow objectAtIndex:ip.row] setApplied:YES];
        }
        [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end
