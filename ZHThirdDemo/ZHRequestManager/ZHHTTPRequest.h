//
//  ZHHTTPRequest.h
//  ZHThirdDemo
//
//  Created by walen on 16/12/19.
//  Copyright © 2016年 吴志和. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZHHTTPOperation;

@interface ZHHTTPRequest : NSObject

+ (instancetype)requestWithTask:(NSURLSessionDataTask *)task error:(NSError *)error operation:(ZHHTTPOperation *)operation;

- (instancetype)initWithTask:(NSURLSessionDataTask *)task error:(NSError *)error operation:(ZHHTTPOperation *)operation;
/**
 请求对应的task
 */
@property (nonatomic, strong) NSURLSessionDataTask *task;

/**
 网络请求头
 */
@property (nonatomic, strong) NSURLRequest *request;

/**
 请求的response
 */
@property (nonatomic, strong) NSURLResponse *response;

/**
 请求的错误信息
 */
@property (nonatomic, strong) NSError *error;

/**
 请求的自定义请求对象
 */
@property (nonatomic, strong) ZHHTTPOperation *operation;

@end
