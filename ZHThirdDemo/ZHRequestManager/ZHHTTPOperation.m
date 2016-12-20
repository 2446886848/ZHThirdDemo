//
//  ZHHTTPOperation.m
//  ZHThirdDemo
//
//  Created by walen on 16/11/2.
//  Copyright © 2016年 吴志和. All rights reserved.
//

#import "ZHHTTPOperation.h"
#import "ZHRequestManager.h"
#import <objc/runtime.h>

@implementation ZHHTTPOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        //默认值初始化
        _httpShowNetworkIndicator = YES;
        _httpTimeoutInterval = @(60);
    }
    return self;
}

+ (id<ZHHTTPRequestProtocol>)defaultHttpRequestDelegate
{
    return objc_getAssociatedObject(self, @selector(defaultHttpRequestDelegate));
}

+ (void)setDefaultHttpRequestDelegate:(id<ZHHTTPRequestProtocol>)defaultHttpRequestDelegate
{
    objc_setAssociatedObject(self, @selector(defaultHttpRequestDelegate), defaultHttpRequestDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - chaining block

+ (ZHHTTPOperation * (^)(NSString *url))url;
{
    return ^ZHHTTPOperation *(NSString *url){
        ZHHTTPOperation *operation = [[ZHHTTPOperation alloc] init];
        operation.httpUrl = url;
        return operation;
    };
}

- (ZHHTTPOperation * (^)(ZHHTTPMethod method))method;
{
    return ^ZHHTTPOperation *(ZHHTTPMethod method){
        self.httpMethod = method;
        return self;
    };
}

- (ZHHTTPOperation * (^)(NSDictionary *params))params;
{
    return ^ZHHTTPOperation *(NSDictionary *params){
        self.httpParams = params;
        return self;
    };
}

- (ZHHTTPOperation * (^)(ZHHTTPRequestSerilizer requestSerilizer))requestSerilizer;
{
    return ^ZHHTTPOperation *(ZHHTTPRequestSerilizer requestSerilizer){
        self.httpRequestSerilizer = requestSerilizer;
        return self;
    };
}

- (ZHHTTPOperation * (^)(ZHHTTPResponseSerilizer responseSerilizer))responseSerilizer;
{
    return ^ZHHTTPOperation *(ZHHTTPResponseSerilizer responseSerilizer){
        self.httpResponseSerilizer = responseSerilizer;
        return self;
    };
}


- (ZHHTTPOperation * (^)(void (^)(NSProgress *progress)))progress;
{
    return ^ZHHTTPOperation *(void (^progress)(NSProgress *progress)){
        self.httpProgress = progress;
        return self;
    };
}

+ (void(^)(id<ZHHTTPRequestProtocol>))defaultRequestDelegate
{
    return ^void(id<ZHHTTPRequestProtocol> defaultRequestDelegate){
        self.defaultHttpRequestDelegate = defaultRequestDelegate;
    };
}

- (ZHHTTPOperation *(^)(id<ZHHTTPRequestProtocol>))requestDelegate
{
    return ^ZHHTTPOperation *(id<ZHHTTPRequestProtocol> requestDelegate){
        self.httpRequestDelegate = requestDelegate;
        return self;
    };
}

- (ZHHTTPOperation * (^)(void (^)(NSURLSessionDataTask *task, id responseObject, NSError * error)))response;
{
    return ^ZHHTTPOperation *(void (^response)(NSURLSessionDataTask *task, id responseObject, NSError * error)){
        self.httpResponse = response;
        return self;
    };
}

- (ZHHTTPOperation * (^)(void (^)(id<AFMultipartFormData> formData)))mutipartBody;
{
    return ^ZHHTTPOperation *(void (^mutipartBody)(id<AFMultipartFormData> formData)){
        self.httpMutipartBody = mutipartBody;
        return self;
    };
}

- (ZHHTTPOperation *(^)(BOOL))showNetworkIndicator
{
    return ^ZHHTTPOperation *(BOOL show){
        self.httpShowNetworkIndicator = show;
        return self;
    };
}

- (ZHHTTPOperation *(^)(NSNumber *))timeoutInterval
{
    return ^ZHHTTPOperation *(NSNumber *timeoutInterval){
        self.httpTimeoutInterval = timeoutInterval;
        return self;
    };
}

- (ZHHTTPOperation *(^)(NSDictionary<NSString *, NSString *> *))basicAuth
{
    return ^ZHHTTPOperation *(NSDictionary<NSString *, NSString *> *basicAuth){
        self.httpBasicAuth = basicAuth;
        return self;
    };
}

- (ZHHTTPOperation *(^)(NSDictionary<NSString *, NSString *> *))customHeaderField
{
    return ^ZHHTTPOperation *(NSDictionary<NSString *, NSString *> *customHeaderField){
        self.httpCustomHeaderField = customHeaderField;
        return self;
    };
}

- (NSURLSessionDataTask *(^)())start
{
    return ^NSURLSessionDataTask *() {
        return [ZHRequestManager startWithOperation:self];
    };
}

#pragma mark - method
+ (instancetype)url:(NSString *)url
{
    ZHHTTPOperation *operation = [[self alloc] init];
    operation.httpUrl = url;
    return operation;
}
- (instancetype)method:(ZHHTTPMethod)method
{
    self.httpMethod = method;
    return self;
}
- (instancetype)params:(NSDictionary *)params
{
    self.httpParams = params;
    return self;
}
- (instancetype)requestSerilizer:(ZHHTTPRequestSerilizer)requestSerilizer
{
    self.httpRequestSerilizer = requestSerilizer;
    return self;
}
- (instancetype)responseSerilizer:(ZHHTTPResponseSerilizer)responseSerilizer
{
    self.httpResponseSerilizer = responseSerilizer;
    return self;
}
- (instancetype)progress:(void (^)(NSProgress *progress))progress
{
    self.httpProgress = progress;
    return self;
}
- (instancetype)response:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError * error))response
{
    self.httpResponse = response;
    return self;
}
- (instancetype)mutipartBody:(void (^)(id<AFMultipartFormData> formData))mutipartBody
{
    self.httpMutipartBody = mutipartBody;
    return self;
}

- (instancetype)showNetworkIndicator:(BOOL)showNetworkIndicator
{
    self.httpShowNetworkIndicator = showNetworkIndicator;
    return self;
}

- (instancetype)timeoutInterval:(NSNumber *)timeoutInterval
{
    self.httpTimeoutInterval = timeoutInterval;
    return self;
}

- (instancetype)basicAuth:(NSDictionary<NSString *,NSString *> *)basicAuth
{
    self.httpBasicAuth = basicAuth;
    return self;
}

- (instancetype)customHeaderField:(NSDictionary<NSString *, NSString *> *)customHeaderField
{
    self.httpCustomHeaderField = customHeaderField;
    return self;
}

- (instancetype)requestDelegate:(id<ZHHTTPRequestProtocol>)requestDelegate
{
    self.httpRequestDelegate = requestDelegate;
    return self;
}

/**
 *  设置请求发送前后的通知对象（建议用来显示加载动画等操作）
 */
+ (void)defaultRequestDelegate:(id<ZHHTTPRequestProtocol>)defaultRequestDelegate
{
    self.defaultHttpRequestDelegate = defaultRequestDelegate;
}

@end
