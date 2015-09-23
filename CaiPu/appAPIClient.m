//
//  appAPIClient.m
//  Zhong Rui
//
//  Created by Ziyao Yang on 8/5/15.
//  Copyright (c) 2015 Ziyao Yang. All rights reserved.
//

#import "appAPIClient.h"

@implementation appAPIClient
//公司自己的接口
+ (instancetype)sharedClient
{
    static appAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[appAPIClient alloc] initWithBaseURL:nil];
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
    });
    return _sharedClient;
}
//大型公司用的比如微信接口
+ (instancetype)sharedResponseDataClient
{
    static appAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[appAPIClient alloc] initWithBaseURL:nil];
        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return _sharedClient;
}

//所有和
+ (instancetype)sharedJSONClient
{
    static appAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[appAPIClient alloc] initWithBaseURL:nil];
        _sharedClient.requestSerializer     = [AFJSONRequestSerializer serializer];
        _sharedClient.responseSerializer    = [AFJSONResponseSerializer serializer];
        NSMutableSet* set = [NSMutableSet set];
        [set addObjectsFromArray:[_sharedClient.responseSerializer.acceptableContentTypes allObjects]];
        [set addObject:@"text/plain"];
        [_sharedClient.responseSerializer setAcceptableContentTypes:[set copy]];
    });
    return _sharedClient;
}

@end
