//
//  ZHHTTPRequest.m
//  ZHThirdDemo
//
//  Created by walen on 16/12/19.
//  Copyright © 2016年 吴志和. All rights reserved.
//

#import "ZHHTTPRequest.h"

@implementation ZHHTTPRequest

+ (instancetype)requestWithTask:(NSURLSessionDataTask *)task error:(NSError *)error operation:(ZHHTTPOperation *)operation
{
    return [[self alloc] initWithTask:task error:error operation:operation];
}

- (instancetype)initWithTask:(NSURLSessionDataTask *)task error:(NSError *)error operation:(ZHHTTPOperation *)operation
{
    if (self = [super init]) {
        _task = task;
        _request = task.currentRequest;
        _response = task.response;
        _error = error;
        _operation = operation;
    }
    return self;
}

@end
