//
//  URLManager.h
//  NetworkTool
//
//  Created by continue on 2019/7/24.
//  Copyright © 2019 continue. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol URLManagerDelegate <NSObject>

@optional
//返回不超时的域名
- (void)getSuccessBaseUrl:(NSString *)url;

@end

@interface URLManager : NSObject

+ (instancetype)shareSingle;

//获取所有域名的状态
- (void)getAllBaseUrlState;

@property (nonatomic, weak) id<URLManagerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
