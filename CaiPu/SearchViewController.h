//
//  SearchViewController.h
//  CaiPu
//
//  Created by MS on 15/9/21.
//  Copyright (c) 2015年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *objectsForShow;
@end
