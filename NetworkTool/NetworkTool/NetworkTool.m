//
//  NetworkTool.m
//  NetworkTool
//
//  Created by continue on 2019/7/23.
//  Copyright © 2019 continue. All rights reserved.
//

#import "NetworkTool.h"
#import "BaseURLModel.h"

@implementation NetworkTool

//检测域名是否超时
- (void)startTask:(NSString *)baseUrl {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/php/phonelogin", baseUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 5;
    NSString *args = @"yourname=%@&yourpass=%@&btn=login";
    
    request.HTTPBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error.code == -1001) {// 超时
            
            NSLog(@"请求超时");
            [self getRequestResult:@"1" url:baseUrl];
        } else {
            
            NSLog(@"请求不超时");
            [self getRequestResult:@"2" url:baseUrl];
        }
        
        
    }];
    [sessionDataTask resume];
}

//回调
- (void)getRequestResult:(NSString *)str url:(NSString *)url {
    
    if ([self.delegate respondsToSelector:@selector(requestResult: url:)]) {
        [self.delegate requestResult:str url:url];
    }
}

//请求获取更多url
- (void)fentchMoreUrlRequest {

    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"https://raw.githubusercontent.com/heqijian/wonder/master/list.json"];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError* error) {
                                        
                                        if (data && !error) {
                                            
                                            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
                                            NSArray *arr = dict[@"data"];
                                            if (arr && arr.count > 0) {
                                                
                                                NSMutableArray *normalArr = [BaseURLModel getUrlArr];
                                                for (NSDictionary *dic in arr) {

                                                    BaseURLModel *model = [BaseURLModel new];
                                                    model.url = dic[@"hostname"];
                                                    model.isInvalid = NO;
                                                    [normalArr addObject:model];
                                                    
                                                }
                                                [BaseURLModel saveErrorUrl:normalArr];
                                            }
                                        }
                                        
                                    }];
    
    [task resume];
}


@end
