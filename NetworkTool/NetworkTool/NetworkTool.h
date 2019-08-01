//
//  NetworkTool.h
//  NetworkTool
//
//  Created by continue on 2019/7/23.
//  Copyright © 2019 continue. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NetworkToolDelegate <NSObject>

@optional

- (void)requestResult:(NSString *)state url:(NSString *)url;

@end

@interface NetworkTool : NSObject

//检测域名是否超时
- (void)startTask:(NSString *)baseUrl;
- (void)fentchMoreUrlRequest;

@property (nonatomic, weak) id<NetworkToolDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
