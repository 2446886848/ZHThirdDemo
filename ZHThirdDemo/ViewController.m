//
//  ViewController.m
//  ZHThirdDemo
//
//  Created by 吴志和 on 16/1/10.
//  Copyright © 2016年 吴志和. All rights reserved.
//

#import "ViewController.h"
#import "ZHRequestTool.h"
#import "ZHParam.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary *dict = @{@"domain" : @"juhe.cn",
                           @"dtype" : @"json",
                           @"key" : @"e8653d8956536b7ee9fdc538be7bb707"};
    
    ZHParam *parm = [[ZHParam alloc] init];
    parm.domin = @"juhe.cn";
    parm.dtype = @"json";
    parm.key = @"e8653d8956536b7ee9fdc538be7bb707";
    
    [ZHRequestTool GET:@"http://apis.juhe.cn/webscan/" parameters:parm responseSerializer:ZHResponseSeriliserJSON requestResult:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSLog(@"task = %@, responseObject = %@, error = %@", task, responseObject, error.localizedDescription);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
