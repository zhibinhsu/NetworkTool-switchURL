//
//  URLManager.m
//  NetworkTool
//
//  Created by continue on 2019/7/24.
//  Copyright © 2019 continue. All rights reserved.
//

#import "URLManager.h"
#import "NetworkTool.h"
#import "BaseURLModel.h"
#import "TimerManager.h"
#import "TimerManager.h"

@interface URLManager ()<NetworkToolDelegate>
{
    int i;
}

@end

@implementation URLManager

static URLManager *manager;
+ (instancetype)shareSingle {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[URLManager alloc] init];
    });
    return manager;
}

//获取所有域名的状态
- (void)getAllBaseUrlState {
    
    NSArray *arr = [BaseURLModel getUrlArr];
    if (arr.count == 0) {
        
        i = 0;
        NSMutableArray *urlArr = [NSMutableArray arrayWithCapacity:10];
        BaseURLModel *model0 = [BaseURLModel new];
        model0.url = @"http://172.16.2.254";
        model0.isInvalid = NO;
        [urlArr addObject:model0];
        
        BaseURLModel *model1 = [BaseURLModel new];
        model1.url = @"http://172.16.2.255";
        model1.isInvalid = NO;
        [urlArr addObject:model1];
        
        BaseURLModel *model2 = [BaseURLModel new];
        model2.url = @"http://172.16.2.250";
        model2.isInvalid = NO;
        [urlArr addObject:model2];
        
        BaseURLModel *model3 = [BaseURLModel new];
        model3.url = @"http://172.16.2.252";
        model3.isInvalid = NO;
        [urlArr addObject:model3];
        
        BaseURLModel *model4 = [BaseURLModel new];
        model4.url = @"http://172.16.2.251";
        model4.isInvalid = NO;
        [urlArr addObject:model4];
        [BaseURLModel saveErrorUrl:urlArr];
    } else {
        
        if (arr && arr.count > 0) {
            
            for (int n = 0; n < arr.count; n++) {
                
                BaseURLModel *model = arr[n];
                NSInteger currentTime = [TimerManager getCurrentTime];
                NSInteger invalidTime = model.invalidTime;
                if (model.isInvalid == YES && currentTime - invalidTime >= 60*60) {//判断失效的域名过一小时重新有效
                    
                    [BaseURLModel uploadUrlArrByUrl:model.url isInvalid:NO invalidTime:0];
                }
            }
        }
    }
    
    [self getCurrentRequestBaseUrl];
}

//获取当前域名
- (void)getCurrentRequestBaseUrl {
    
    NSArray *arr = [BaseURLModel getUrlArr];
    if (arr && arr.count > 0) {
        
        for (int m = 0; m < arr.count; m++) {
            
            BaseURLModel *model = arr[m];
            if (model.isInvalid == NO) {//打开app第一次请求判断url是否有效
                i = m;
                [self startRequest:model.url];
                break;
            }
        }
    }
}

//开始请求
- (void)startRequest:(NSString *)url {
    
    NSLog(@"*** i : %d baseUrl=%@", i, url);
    NetworkTool *tool = [[NetworkTool alloc] init];
    tool.delegate = self;
    [tool startTask:url];
}

//回调请求结果
- (void)requestResult:(NSString *)state url:(nonnull NSString *)url {
    
    if ([state isEqualToString:@"1"]) { //超时
        
        //记录失效url
        [BaseURLModel uploadUrlArrByUrl:url isInvalid:YES invalidTime:[TimerManager getCurrentTime]];
        
        NSArray *arr = [BaseURLModel getUrlArr];
        if (i < arr.count && arr && arr.count > 0) {
            
            i++;
            if (i == 3) {//请求获取更多url
                NetworkTool *tool = [[NetworkTool alloc] init];
                [tool fentchMoreUrlRequest];
            }
            for (int j = i; j < arr.count; j++) {
                
                BaseURLModel *model = arr[j];
                if (model.isInvalid == NO) {//判断url是否有效
                    
                    [self startRequest:model.url];
                    break;
                }
            }
        }
    } else {
        //返回不超时的域名
        if ([self.delegate respondsToSelector:@selector(getSuccessBaseUrl:)]) {
            [self.delegate getSuccessBaseUrl:url];
        }
    }
}


@end
