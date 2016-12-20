//
//  ZHRequestManager.m
//  ZHThirdDemo
//
//  Created by walen on 16/11/2.
//  Copyright © 2016年 吴志和. All rights reserved.
//

#import "ZHRequestManager.h"
#import <AFNetworking.h>
#import "ZHHTTPRequest.h"

@implementation ZHRequestManager

static inline AFHTTPSessionManager *afManager()
{
    static AFHTTPSessionManager *manager = nil;
    if (!manager) {
        manager = [AFHTTPSessionManager manager];
    }
    return manager;
}

+ (ZHHTTPOperation * (^)(NSString *url))url;
{
    return ^ZHHTTPOperation *(NSString *url){
        return ZHHTTPOperation.url(url);
    };
}

+ (ZHHTTPOperation *)url:(NSString *)url
{
    return [ZHHTTPOperation url:url];
}

+ (NSURLSessionDataTask *)startWithOperation:(ZHHTTPOperation *)operation
{
    NSParameterAssert(operation.httpUrl);
    
    if (operation.httpUrl.length == 0 ) {
        NSLog(@"operation.httpUrl is invalid!");
        if (operation.httpResponse) {
            operation.httpResponse(nil, nil, [NSError errorWithDomain:@"url is empty!" code:-30001 userInfo:@{}]);
        }
        return nil;
    }
    //为了防止多次重复创建AFHTTPSessionManager，特采用静态变量的方式多次服用
    AFHTTPSessionManager *manager = afManager();
    
    //加入锁，防止多线程访问情况下出现的数据混乱问题
    @synchronized (manager) {
        //deal request serilizer
        switch (operation.httpRequestSerilizer) {
            case ZHHTTPRequestSerilizerHttp:
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                break;
            case ZHHTTPRequestSerilizerJson:
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                break;
            default:
                break;
        }
        if (operation.httpBasicAuth) {
            [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:operation.httpBasicAuth.allKeys.firstObject password:operation.httpBasicAuth.allValues.firstObject];
        }
        
        //设置超时时间
        if (operation.httpTimeoutInterval) {
            manager.requestSerializer.timeoutInterval = [operation.httpTimeoutInterval doubleValue];
        }
        if (operation.httpCustomHeaderField) {
            [operation.httpCustomHeaderField enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
            }];
        }
        //deal response serilizer
        switch (operation.httpResponseSerilizer) {
            case ZHHTTPResponseSerilizerJson:
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                break;
            case ZHHTTPResponseSerilizerHttp:
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                break;
            default:
                break;
        }
        
        if (operation.httpShowNetworkIndicator) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
        
        void(^requestDelegateCallBack)(ZHHTTPRequest *) = ^(ZHHTTPRequest *request){
            if ([request.operation.httpRequestDelegate respondsToSelector:@selector(rquestDidFinished:request:)]) {
                [request.operation.httpRequestDelegate rquestDidFinished:request.operation request:request];
            }
            else if ([ZHHTTPOperation.defaultHttpRequestDelegate respondsToSelector:@selector(rquestDidFinished:request:)])
            {
                [ZHHTTPOperation.defaultHttpRequestDelegate rquestDidFinished:request.operation request:request];
            }
        };
        
        switch (operation.httpMethod) {
            case ZHHTTPMethodGet:
            {
                //网络用户自定义操作响应
                if ([operation.httpRequestDelegate respondsToSelector:@selector(rquestWillPerform:)]) {
                    [operation.httpRequestDelegate rquestWillPerform:operation];
                }
                return [manager GET:operation.httpUrl parameters:operation.httpParams progress:operation.httpProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    //网络用户自定义操作响应
                    ZHHTTPRequest *request = [ZHHTTPRequest requestWithTask:task error:nil operation:operation];
                    requestDelegateCallBack(request);
                    
                    if (operation.httpShowNetworkIndicator) {
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    }
                    if (operation.httpResponse) {
                        operation.httpResponse(task, responseObject, nil);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    //网络用户自定义操作响应
                    ZHHTTPRequest *request = [ZHHTTPRequest requestWithTask:task error:error operation:operation];
                    requestDelegateCallBack(request);
                    
                    if (operation.httpShowNetworkIndicator) {
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    }
                    if (operation.httpResponse) {
                        operation.httpResponse(task, nil, error);
                    }
                }];
            }
                break;
            case ZHHTTPMethodPost:
            {
                //网络用户自定义操作响应
                if ([operation.httpRequestDelegate respondsToSelector:@selector(rquestWillPerform:)]) {
                    [operation.httpRequestDelegate rquestWillPerform:operation];
                }
                if (operation.httpMutipartBody) {
                    return [manager POST:operation.httpUrl parameters:operation.httpParams constructingBodyWithBlock:operation.httpMutipartBody progress:operation.httpProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        //网络用户自定义操作响应
                        ZHHTTPRequest *request = [ZHHTTPRequest requestWithTask:task error:nil operation:operation];
                        requestDelegateCallBack(request);
                        
                        if (operation.httpShowNetworkIndicator) {
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        }
                        if (operation.httpResponse) {
                            operation.httpResponse(task, responseObject, nil);
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                        //网络用户自定义操作响应
                        ZHHTTPRequest *request = [ZHHTTPRequest requestWithTask:task error:error operation:operation];
                        requestDelegateCallBack(request);
                        
                        if (operation.httpShowNetworkIndicator) {
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        }
                        if (operation.httpResponse) {
                            operation.httpResponse(task, nil, error);
                        }
                    }];
                } else {
                    return [manager POST:operation.httpUrl parameters:operation.httpParams progress:operation.httpProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        //网络用户自定义操作响应
                        ZHHTTPRequest *request = [ZHHTTPRequest requestWithTask:task error:nil operation:operation];
                        requestDelegateCallBack(request);
                        
                        if (operation.httpShowNetworkIndicator) {
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        }
                        if (operation.httpResponse) {
                            operation.httpResponse(task, responseObject, nil);
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                        //网络用户自定义操作响应
                        ZHHTTPRequest *request = [ZHHTTPRequest requestWithTask:task error:error operation:operation];
                        requestDelegateCallBack(request);
                        
                        if (operation.httpShowNetworkIndicator) {
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        }
                        if (operation.httpResponse) {
                            operation.httpResponse(task, nil, error);
                        }
                    }];
                }
            }
                break;
            case ZHHTTPMethodHead:
            {
                //网络用户自定义操作响应
                if ([operation.httpRequestDelegate respondsToSelector:@selector(rquestWillPerform:)]) {
                    [operation.httpRequestDelegate rquestWillPerform:operation];
                }
                return [manager HEAD:operation.httpUrl parameters:operation.httpParams success:^(NSURLSessionDataTask * _Nonnull task) {
                    
                    //网络用户自定义操作响应
                    ZHHTTPRequest *request = [ZHHTTPRequest requestWithTask:task error:nil operation:operation];
                    requestDelegateCallBack(request);
                    
                    if (operation.httpShowNetworkIndicator) {
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    }
                    if (operation.httpResponse) {
                        operation.httpResponse(task, nil, nil);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    //网络用户自定义操作响应
                    ZHHTTPRequest *request = [ZHHTTPRequest requestWithTask:task error:error operation:operation];
                    requestDelegateCallBack(request);
                    
                    if (operation.httpShowNetworkIndicator) {
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    }
                    if (operation.httpResponse) {
                        operation.httpResponse(task, nil, error);
                    }
                }];
            }
                break;
                
            case ZHHTTPMethodPut:
            {
                //网络用户自定义操作响应
                if ([operation.httpRequestDelegate respondsToSelector:@selector(rquestWillPerform:)]) {
                    [operation.httpRequestDelegate rquestWillPerform:operation];
                }
                return [manager PUT:operation.httpUrl parameters:operation.httpParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    //网络用户自定义操作响应
                    ZHHTTPRequest *request = [ZHHTTPRequest requestWithTask:task error:nil operation:operation];
                    requestDelegateCallBack(request);
                    
                    if (operation.httpShowNetworkIndicator) {
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    }
                    if (operation.httpResponse) {
                        operation.httpResponse(task, responseObject, nil);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    //网络用户自定义操作响应
                    ZHHTTPRequest *request = [ZHHTTPRequest requestWithTask:task error:error operation:operation];
                    requestDelegateCallBack(request);
                    
                    if (operation.httpShowNetworkIndicator) {
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    }
                    if (operation.httpResponse) {
                        operation.httpResponse(task, nil, error);
                    }
                }];
            }
                break;
            case ZHHTTPMethodPatch:
            {
                //网络用户自定义操作响应
                if ([operation.httpRequestDelegate respondsToSelector:@selector(rquestWillPerform:)]) {
                    [operation.httpRequestDelegate rquestWillPerform:operation];
                }
                return [manager PATCH:operation.httpUrl parameters:operation.httpParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    //网络用户自定义操作响应
                    ZHHTTPRequest *request = [ZHHTTPRequest requestWithTask:task error:nil operation:operation];
                    requestDelegateCallBack(request);
                    
                    if (operation.httpShowNetworkIndicator) {
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    }
                    if (operation.httpResponse) {
                        operation.httpResponse(task, responseObject, nil);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    //网络用户自定义操作响应
                    ZHHTTPRequest *request = [ZHHTTPRequest requestWithTask:task error:error operation:operation];
                    requestDelegateCallBack(request);
                    
                    if (operation.httpShowNetworkIndicator) {
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    }
                    if (operation.httpResponse) {
                        operation.httpResponse(task, nil, error);
                    }
                }];
            }
                break;
            case ZHHTTPMethodDelete:
            {
                //网络用户自定义操作响应
                if ([operation.httpRequestDelegate respondsToSelector:@selector(rquestWillPerform:)]) {
                    [operation.httpRequestDelegate rquestWillPerform:operation];
                }
                return [manager DELETE:operation.httpUrl parameters:operation.httpParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    //网络用户自定义操作响应
                    ZHHTTPRequest *request = [ZHHTTPRequest requestWithTask:task error:nil operation:operation];
                    requestDelegateCallBack(request);
                    
                    if (operation.httpShowNetworkIndicator) {
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    }
                    if (operation.httpResponse) {
                        operation.httpResponse(task, responseObject, nil);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    //网络用户自定义操作响应
                    ZHHTTPRequest *request = [ZHHTTPRequest requestWithTask:task error:error operation:operation];
                    requestDelegateCallBack(request);
                    
                    if (operation.httpShowNetworkIndicator) {
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    }
                    if (operation.httpResponse) {
                        operation.httpResponse(task, nil, error);
                    }
                }];
            }
                break;
            default:
                NSLog(@"unknow request type = %@", @(operation.httpMethod));
                if (operation.httpResponse) {
                    operation.httpResponse(nil, nil, [NSError errorWithDomain:@"unknow request type" code:-30002 userInfo:@{}]);
                }
                break;
        }
    }
    return nil;
}

@end
