//
//  appAPIClient.h
//  Zhong Rui
//
//  Created by Ziyao Yang on 8/5/15.
//  Copyright (c) 2015 Ziyao Yang. All rights reserved.
//

#import "AFNetworking.h"

@interface appAPIClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;
+ (instancetype)sharedResponseDataClient;
+ (instancetype)sharedJSONClient;

@end