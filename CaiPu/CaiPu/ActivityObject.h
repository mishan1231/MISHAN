//
//  ActivityObject.h
//  realTableView
//
//  Created by ZIYAO YANG on 15/8/6.
//  Copyright (c) 2015年 ZIYAO YANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityObject : NSObject

@property (strong, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *content;
@property (nonatomic) NSInteger like;
@property (nonatomic) NSInteger unlike;
@property (nonatomic) BOOL applied;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
