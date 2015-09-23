//
//  ActivityObject.m
//  realTableView
//
//  Created by ZIYAO YANG on 15/8/6.
//  Copyright (c) 2015年 ZIYAO YANG. All rights reserved.
//

#import "ActivityObject.h"

@implementation ActivityObject

- (id)initWithDictionary:(NSDictionary *)dic {
    self.imgUrl = [dic objectForKey:@"imgUrl"];
    self.name = [dic objectForKey:@"name"];
    self.content = [dic objectForKey:@"content"];
    self.like = [[dic objectForKey:@"like"] integerValue];
    self.unlike = [[dic objectForKey:@"unlike"] integerValue];
    self.applied = [[dic objectForKey:@"applied"] integerValue] == 0 ? NO : YES;
    
    return self;
}

@end
