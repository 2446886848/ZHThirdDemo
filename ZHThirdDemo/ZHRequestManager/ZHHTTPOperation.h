//
//  ZHHTTPOperation.h
//  ZHThirdDemo
//
//  Created by walen on 16/11/2.
//  Copyright © 2016年 吴志和. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "ZHHTTPRequest.h"

//http post method
typedef NS_ENUM(NSUInteger, ZHHTTPMethod) {
    ZHHTTPMethodGet,    //GET
    ZHHTTPMethodPost,   //POST
    ZHHTTPMethodHead,   //HEAD
    ZHHTTPMethodPut,    //PUT
    ZHHTTPMethodPatch,  //PATCH
    ZHHTTPMethodDelete  //DELETE
};

typedef NS_ENUM(NSUInteger, ZHHTTPRequestSerilizer) {
    ZHHTTPRequestSerilizerHttp = 0,     //default
    ZHHTTPRequestSerilizerJson,
};

typedef NS_ENUM(NSUInteger, ZHHTTPResponseSerilizer) {
    ZHHTTPResponseSerilizerJson = 0,    //default
    ZHHTTPResponseSerilizerHttp
};

@class ZHHTTPOperation;
/**
 * 用于用户在网络请求之前和之后进行自定义操作的协议
 */
@protocol ZHHTTPRequestProtocol <NSObject>

@optional
- (void)rquestWillPerform:(ZHHTTPOperation *)operation;
- (void)rquestDidFinished:(ZHHTTPOperation *)operation request:(ZHHTTPRequest *)request;

@end

@interface ZHHTTPOperation : NSObject

#pragma mark - property
/**
 *  请求的url
 */
@property (nonatomic, copy) NSString *httpUrl;
/**
 *  请求的方法，由ZHHTTPMethod枚举定义
 */
@property (nonatomic, assign) ZHHTTPMethod httpMethod;
/**
 *  请求的参数
 */
@property (nonatomic, strong) NSDictionary *httpParams;
/**
 *  请求的序列化 HTTP 和JSON 默认为HTTP
 */
@property (nonatomic, assign) ZHHTTPRequestSerilizer httpRequestSerilizer;
/**
 *  服务器回复的序列化 HTTP 和JSON 默认为JSON
 */
@property (nonatomic, assign) ZHHTTPResponseSerilizer httpResponseSerilizer;

/**
 *  用户自定义的网络请求前后的默认操作对象
 *  mark 会对代理的对象进行强引用
 *  bref （建议用来显示加载动画等操作）
 */
@property (nonatomic, strong, class) id<ZHHTTPRequestProtocol> defaultHttpRequestDelegate;

/**
 *  用户自定义的网络请求前后的操作对象
 *  mark 会对代理的对象进行强引用
 */
@property (nonatomic, strong) id<ZHHTTPRequestProtocol> httpRequestDelegate;
/**
 *  请求的进度
 */
@property (nonatomic, copy) void (^httpProgress)(NSProgress *downloadProgress);
/**
 *  请求的答复
 */
@property (nonatomic, copy)  void (^httpResponse)(NSURLSessionDataTask *task, id /*_Nullable*/ responseObject, NSError * /*_Nullable*/ error);
/**
 *  文件上传的body创建block
 */
@property (nonatomic, copy) void (^httpMutipartBody)(id<AFMultipartFormData> formData);
/**
 *  是否需要在请求的时候显示导航栏菊花 默认为YES
 */
@property (nonatomic, assign) BOOL httpShowNetworkIndicator;
/**
 *  请求的超时时间 默认为60s
 */
@property (nonatomic, strong) NSNumber *httpTimeoutInterval;
/**
 *  BasicAuth头部
 */
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *httpBasicAuth;
/**
 *  用户自定义请求头部
 */
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *httpCustomHeaderField;

#pragma mark - chaining block
/**
 *  设置url的block
 */
@property (class, nonatomic, copy, readonly) ZHHTTPOperation *(^url)(NSString *httpUrl);
/**
 *  设置请求方法的block
 */
@property (nonatomic, copy, readonly) ZHHTTPOperation *(^method)(ZHHTTPMethod method);
/**
 *  设置请求参数的block
 */
@property (nonatomic, copy, readonly) ZHHTTPOperation *(^params)(NSDictionary *params);
/**
 *  设置请求序列化的block
 */
@property (nonatomic, copy, readonly) ZHHTTPOperation *(^requestSerilizer)(ZHHTTPRequestSerilizer requestSerilizer);
/**
 *  设置回复序列化的block
 */
@property (nonatomic, copy, readonly) ZHHTTPOperation *(^responseSerilizer)(ZHHTTPResponseSerilizer responseSerilizer);
/**
 *  设置用户自定义的网络请求前后的操作对象block （建议用来显示加载动画等操作）
 */
@property (nonatomic, copy, readonly, class) void(^defaultRequestDelegate)(id<ZHHTTPRequestProtocol> defaultRequestDelegate);
/**
 *  设置用户自定义的网络请求前后的默认操作对象block
 */
@property (nonatomic, copy, readonly) ZHHTTPOperation *(^requestDelegate)(id<ZHHTTPRequestProtocol> requestDelegate);
/**
 *  设置请求进度block的block
 */
@property (nonatomic, copy, readonly) ZHHTTPOperation *(^progress)(void (^)(NSProgress *progress));
/**
 *  设置回复block的block
 */
@property (nonatomic, copy, readonly) ZHHTTPOperation *(^response)(void (^)(NSURLSessionDataTask *task, id /*_Nullable*/ responseObject, NSError * /*_Nullable*/ error));
/**
 *  设置文件上传请求body体block的block
 */
@property (nonatomic, copy, readonly) ZHHTTPOperation *(^mutipartBody)(void (^)(id<AFMultipartFormData> formData));
/**
 *  设置是否在请求时显示导航栏菊花的block 默认为显示
 */
@property (nonatomic, copy, readonly) ZHHTTPOperation *(^showNetworkIndicator)(BOOL show);
/**
 *  设置请求超时的block
 */
@property (nonatomic, copy, readonly) ZHHTTPOperation *(^timeoutInterval)(NSNumber *timeoutInterval);
/**
 *  设置用户BasicAuth的block
 */
@property (nonatomic, copy, readonly) ZHHTTPOperation *(^basicAuth)(NSDictionary<NSString *, NSString *> *customHeaderField);
/**
 *  设置用户自定义请求头部的block
 */
@property (nonatomic, copy, readonly) ZHHTTPOperation *(^customHeaderField)(NSDictionary<NSString *, NSString *> *customHeaderField);
/**
 *  设置开始发送请求的block
 *  mark 所有请求必须手动调用这个block方可发送请求
 */
@property (nonatomic, copy, readonly) NSURLSessionDataTask *(^start)();

#pragma mark - method

/**
 *  设置请求的url
 */
+ (instancetype)url:(NSString *)url;
/**
 *  设置请求的方法 HTTP或JSON
 */
- (instancetype)method:(ZHHTTPMethod)method;
/**
 *  设置请求的参数
 */
- (instancetype)params:(NSDictionary *)params;
/**
 *  设置请求的序列化 HTTP或JSON 默认为HTTP
 */
- (instancetype)requestSerilizer:(ZHHTTPRequestSerilizer)requestSerilizer;
/**
 *  设置回复的序列化 HTTP或JSON 默认为JSON
 */
- (instancetype)responseSerilizer:(ZHHTTPResponseSerilizer)responseSerilizer;
/**
 *  设置请求发送前后的默认通知对象（建议用来显示加载动画等操作）
 */
+ (void)defaultRequestDelegate:(id<ZHHTTPRequestProtocol>)defaultRequestDelegate;
/**
 *  设置请求发送前后的通知对象
 */
- (instancetype)requestDelegate:(id<ZHHTTPRequestProtocol>)requestDelegate;
/**
 *  设置请求的进度block
 */
- (instancetype)progress:(void (^)(NSProgress *progress))progress;
/**
 *  设置请求的回调block
 */
- (instancetype)response:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError * error))response;
/**
 *  设置文件上传的请求体构建block
 */
- (instancetype)mutipartBody:(void (^)(id<AFMultipartFormData> formData))mutipartBody;
/**
 *  设置请求过程中是否需要显示导航栏菊花
 */
- (instancetype)showNetworkIndicator:(BOOL)showNetworkIndicator;
/**
 *  设置请求的超时时间
 */
- (instancetype)timeoutInterval:(NSNumber *)timeoutInterval;
/**
 *  设置请求的BasicAuth
 */
- (instancetype)basicAuth:(NSDictionary<NSString *, NSString *> *)basicAuth;
/**
 *  设置请求的用户自定义头部
 */
- (instancetype)customHeaderField:(NSDictionary<NSString *, NSString *> *)customHeaderField;

@end
