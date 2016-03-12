//
//  ZHModelFormater.h
//  ZHThirdDemo
//
//  Created by 吴志和 on 16/3/12.
//  Copyright © 2016年 吴志和. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef Class(^DataClass)(id modelData);

typedef void(^FormatDictCallBack)(id model);

typedef void(^FormatArrayCallBack)(NSArray *models);

@interface ZHModelFormater : NSObject

+ (void)formatDictionary:(NSDictionary *)dict dataClass:(DataClass)dataClass callBack:(FormatDictCallBack)callBack;

+ (void)formatArray:(NSArray *)dataArray dataClass:(DataClass)dataClass callBack:(FormatArrayCallBack)callBack;

@end
