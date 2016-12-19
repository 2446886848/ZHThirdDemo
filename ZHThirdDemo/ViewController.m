//
//  ViewController.m
//  ZHThirdDemo
//
//  Created by 吴志和 on 16/1/10.
//  Copyright © 2016年 吴志和. All rights reserved.
//

#import "ViewController.h"
#import "ZHParam.h"
#import "ZHRequestManager.h"

@interface ViewController ()<ZHHTTPRequestProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary *dict = @{@"domain" : @"juhe.cn",
                           @"dtype" : @"json",
                           @"key" : @"e8653d8956536b7ee9fdc538be7bb707"};

    ZHRequestManager.url(@"http://apis.juhe.cn/webscan/").method(ZHHTTPMethodGet).params(dict).requestSerilizer(ZHHTTPRequestSerilizerHttp).responseSerilizer(ZHHTTPResponseSerilizerJson).progress(^(NSProgress *progress){
        NSLog(@"progress:%@", @(progress.completedUnitCount * 1.0 / progress.totalUnitCount));
    }).response(^(NSURLSessionDataTask *task, id responseObject, NSError * error){
        NSLog(@"response:task = %@, responseObject = %@, error = %@", task, responseObject, error);
    }).showNetworkIndicator(YES).requestDelegate(self).start();
    
    for (int i = 0; i < 10; i++) {
        [[[[[[[[ZHRequestManager url:@"http://apis.juhe.cn/webscan/"] method:ZHHTTPMethodGet] params:dict] requestSerilizer:ZHHTTPRequestSerilizerHttp] responseSerilizer:ZHHTTPResponseSerilizerJson] showNetworkIndicator:YES] progress:^(NSProgress *progress) {
            NSLog(@"progress:%@", @(progress.completedUnitCount * 1.0 / progress.totalUnitCount));
        }] response:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
            NSLog(@"response:task = %@, responseObject = %@, error = %@", task, responseObject, error);
        }].start();
    }
    
//    NSDictionary *dict = @{@"domain" : @"juhe.cn",
//                           @"dtype" : @"json",
//                           @"key" : @"e8653d8956536b7ee9fdc538be7bb707"};
//    
//    ZHParam *parm = [[ZHParam alloc] init];
//    parm.domin = @"juhe.cn";
//    parm.dtype = @"json";
//    parm.key = @"e8653d8956536b7ee9fdc538be7bb707";
//    
//    [ZHRequestTool GET:@"http://apis.juhe.cn/webscan/" parameters:parm responseSerializer:ZHResponseSeriliserJSON requestResult:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
//        NSLog(@"task = %@, responseObject = %@, error = %@", task, responseObject, error.localizedDescription);
//    }];
}

- (void)rquestWillPerform:(ZHHTTPOperation *)operation
{
    NSLog(@"rquestWillPerform:operation.url = %@", operation.httpUrl);
}
- (void)rquestDidFinished:(ZHHTTPOperation *)operation request:(ZHHTTPRequest *)request
{
    NSLog(@"rquestDidFinished:operation.url = %@", operation.httpUrl);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
