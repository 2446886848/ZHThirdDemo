//
//  ZHRequestManager.h
//  ZHThirdDemo
//
//  Created by walen on 16/11/2.
//  Copyright © 2016年 吴志和. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHHTTPOperation.h"

typedef ZHHTTPOperation *(^method)(ZHHTTPMethod method);

@interface ZHRequestManager : NSObject

/**
 *  发送请求，请求的信息都在operation里
 */
+ (NSURLSessionDataTask *)startWithOperation:(ZHHTTPOperation *)operation;

/**
 *  返回一个使用url来初始化一个ZHHTTPOperation的block
 */
@property (class, nonatomic, copy, readonly) ZHHTTPOperation *(^url)(NSString *url);
/**
 *  使用url来初始化一个ZHHTTPOperation
 */
+ (ZHHTTPOperation *)url:(NSString *)url;

@end
