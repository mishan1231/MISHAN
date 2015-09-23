//
//  Item.h
//  greedIsland
//
//  Created by ZIYAO YANG on 15/9/9.
//  Copyright (c) 2015年 ZIYAO YANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *describe;
@property (strong, nonatomic) PFFile *photo;
@property (strong, nonatomic) NSNumber *cost;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *range;
@property (strong, nonatomic) NSString *owner;

- (id)initWithObject:(PFObject *)object;

@end
