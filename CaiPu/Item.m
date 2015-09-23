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
    self.name = [NSString stringWithFormat:@"贪婪%@", object[@"name"]];
    self.describe = object[@"describe"];
    self.photo = object[@"photo"];
    self.cost = object[@"cost"];
    self.price = object[@"price"];
    self.range = object[@"range"];
    PFUser *user = object[@"owner"];
    self.owner = user.username;
    return self;
}

@end
