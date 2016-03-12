//
//  ZHModelFormater.m
//  ZHThirdDemo
//
//  Created by 吴志和 on 16/3/12.
//  Copyright © 2016年 吴志和. All rights reserved.
//

#import "ZHModelFormater.h"
#import "MJExtension.h"

@implementation ZHModelFormater

+ (void)formatDictionary:(NSDictionary *)dict dataClass:(DataClass)dataClass callBack:(FormatDictCallBack)callBack
{
    NSParameterAssert([dict isKindOfClass:[NSDictionary class]]);
    
    Class modelClass = dataClass(dict);
    id model = [modelClass mj_objectWithKeyValues:dict];
    if (callBack) {
        callBack(model);
    }
}

+ (void)formatArray:(NSArray *)dataArray dataClass:(DataClass)dataClass callBack:(FormatArrayCallBack)callBack
{
    NSMutableArray *models = @[].mutableCopy;
    for (NSDictionary *dict in dataArray) {
        [self formatDictionary:dict dataClass:dataClass callBack:^(id model) {
            [models addObject:model];
        }];
    }
    if (callBack) {
        callBack(models);
    }
}

@end
