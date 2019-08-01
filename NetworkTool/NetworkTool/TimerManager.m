//
//  TimerManager.m
//  NetworkTool
//
//  Created by continue on 2019/7/23.
//  Copyright © 2019 continue. All rights reserved.
//

#import "TimerManager.h"

@implementation TimerManager

+ (NSInteger)getCurrentTime {
    
    return (long)[[NSDate date] timeIntervalSince1970];
}

@end
