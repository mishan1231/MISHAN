//
//  SearchViewController.m
//  CaiPu
//
//  Created by MS on 15/9/21.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import "SearchViewController.h"
#import "HomeCell.h"
@interface SearchViewController ()

@end

@implementation SearchViewController

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
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _objectsForShow.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchCell" forIndexPath:indexPath];
    
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self setSearchBeginWithText:searchText];
}

- (void)setSearchBeginWithText:(NSString *)text {
    

}

@end
