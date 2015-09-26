//
//  Item.m
//  greedIsland
//
//  Created by ZIYAO YANG on 15/9/9.
//  Copyright (c) 2015年 ZIYAO YANG. All rights reserved.
//

#import "Item.h"

@implementation Item

- (id)initWithObject:(PFObject *)object {
    self.name = [NSString stringWithFormat:nil, object[@"name"]];
    self.describe = object[@"xiangqing"];
    self.photo = object[@"photo"];
    self.price = object[@"price"];
    PFUser *user = object[@"owner"];
    self.owner = user.username;
    return self;
}

@end
