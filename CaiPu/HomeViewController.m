//
//  HomeViewController.m
//  CaiPu
//
//  Created by MS on 15/9/21.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCell.h"
#import "DetailsOfDishesViewController.h"

@interface HomeViewController ()

- (IBAction)caixiAction:(UISegmentedControl *)sender forEvent:(UIEvent *)event;
- (IBAction)kouweiAction:(UISegmentedControl *)sender forEvent:(UIEvent *)event;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self naviConfiguration];
    //[NSDate date];
    _refreshControl = [[UIRefreshControl alloc] init];
    NSString *title = [NSString stringWithFormat:@"下拉即可刷新"];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attrsDictionary = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                                      NSFontAttributeName:[UIFont systemFontOfSize:13],
                                      NSParagraphStyleAttributeName:style,
                                      NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    _refreshControl.attributedTitle = attributedTitle;
    _refreshControl.tintColor = [UIColor darkGrayColor];
    _refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [_collectionView addSubview:_refreshControl];
    
    
    //[self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"refreshHome" object:nil];
    
   // [self popUpHomeTab];
    //[self.navigationController.navigationBar setTranslucent:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*- (void)popUpHomeTab {
    TabBarController *tabVC = [Utilities getStoryboardInstanceByIdentity:@"Tab"];
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:tabVC];
    naviVC.navigationBarHidden = YES;
}*/
- (void)naviConfiguration {
    NSDictionary* textTitleOpt = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:textTitleOpt];
    
    self.navigationController.navigationBar.barTintColor = [UIColor brownColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void)requestData {
    //查询Food表
    PFQuery *query = [PFQuery queryWithClassName:@"Food"];
    switch (_caixi.selectedSegmentIndex) {
        case 0: {
            [query whereKey:@"kind" equalTo:@"家常菜"];
        }
            break;
        case 1: {
             [query whereKey:@"kind" equalTo:@"川菜"];
        }
            break;
        case 2: {
             [query whereKey:@"kind" equalTo:@"湘菜菜"];
        }
            break;
        case 3: {
             [query whereKey:@"kind" equalTo:@"点心"];
        }
            break;
        case 4: {
             [query whereKey:@"kind" equalTo:@"汤菜"];
        }
        case 5: {
            [query whereKey:@"kind" equalTo:@"拌菜"];
        }

            break;
        default:
            break;
    }
    switch (_kouwei.selectedSegmentIndex) {
        case 0: {
            [query whereKey:@"kouwei" equalTo:@"甜"];
        }
            break;
        case 1: {
             [query whereKey:@"kouwei" equalTo:@"辣"];
        }
            break;
        case 2: {
             [query whereKey:@"kouwei" equalTo:@"酸"];
        }
            break;
        case 3: {
             [query whereKey:@"kouwei" equalTo:@"苦"];
        }
            break;
        case 4: {
             [query whereKey:@"kouwei" equalTo:@"清淡"];
        }
        case 5: {
            [query whereKey:@"kouwei" equalTo:@"咸"];
        }

            break;
        default:
            break;
    }
    //执行查询
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [aiv stopAnimating];
        //完成时候的回调：returnedObjects数组；error错误信息
        if (!error) {
            //打印结果
            _objectsForShow = returnedObjects;
            NSLog(@"%@", _objectsForShow);
            [_collectionView reloadData];
        } else {
            [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
            //NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (void)refreshData {
   
    
    PFQuery *query = [PFQuery queryWithClassName:@"Food"];
    
    [query orderByDescending:@"price"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [_refreshControl endRefreshing];
        if (!error) {
            _objectsForShow = returnedObjects;
            [_collectionView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//指针的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"homeToXiang"]) {
        NSIndexPath *ip = _collectionView.indexPathsForSelectedItems.firstObject;
        PFObject *object = [_objectsForShow objectAtIndex:ip.row];
        //获取指针并指向终点
        DetailsOfDishesViewController *detailVC = segue.destinationViewController;
        detailVC.item = object;
        detailVC.hidesBottomBarWhenPushed = YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _objectsForShow.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    
    UIView *bv = [[UIView alloc] init];
    bv.backgroundColor = [UIColor lightGrayColor];
    cell.backgroundView = bv;
    UIView *sbv = [[UIView alloc] init];
    sbv.backgroundColor = [UIColor orangeColor];
    cell.selectedBackgroundView = sbv;
    
    PFFile *imgFile = object[@"image"];
    [imgFile getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.image.image = image;
            });
        }
    }];
    cell.name.text = object[@"Name"];
    cell.price.text = [NSString stringWithFormat:@"%@", object[@"price"]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width / 2, self.view.frame.size.width / 2 + 40);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
   
    return 0;
}

- (IBAction)caixiAction:(UISegmentedControl *)sender forEvent:(UIEvent *)event {
    [self requestData];
}

- (IBAction)kouweiAction:(UISegmentedControl *)sender forEvent:(UIEvent *)event {
    [self requestData];
}

@end
