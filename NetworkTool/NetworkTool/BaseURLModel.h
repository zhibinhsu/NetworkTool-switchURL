//
//  BaseURLModel.h
//  NetworkTool
//
//  Created by continue on 2019/7/23.
//  Copyright © 2019 continue. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseURLModel : NSObject<NSCoding>

@property (strong, nonatomic) NSString *url;
@property (assign, nonatomic) BOOL isInvalid;
@property (assign, nonatomic) NSInteger invalidTime;
//保存
+ (void)saveErrorUrl:(NSMutableArray *)arr;
//获取
+ (NSMutableArray *)getUrlArr;
//更新
+ (void)uploadUrlArrByUrl:(NSString *)url isInvalid:(BOOL)isInvalid invalidTime:(NSInteger)invalidTime;

@end

NS_ASSUME_NONNULL_END
