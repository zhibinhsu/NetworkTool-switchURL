//
//  BaseURLModel.m
//  NetworkTool
//
//  Created by continue on 2019/7/23.
//  Copyright © 2019 continue. All rights reserved.
//

#import "BaseURLModel.h"

#define kModelKey     @"kModelKey"

@implementation BaseURLModel

+ (void)saveErrorUrl:(NSMutableArray *)arr {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:arr];
    [userDefaults setObject:udObject forKey:kModelKey];
    [userDefaults synchronize];
}

+ (NSMutableArray *)getUrlArr {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *objectData = [userDefaults objectForKey:kModelKey];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
    
    return array;
}

+ (void)uploadUrlArrByUrl:(NSString *)url isInvalid:(BOOL)isInvalid invalidTime:(NSInteger)invalidTime {
    
    NSMutableArray *array = [BaseURLModel getUrlArr];
    
    if (array && array.count > 0) {
        
        for (int i = 0; i < array.count; i++) {
            
            BaseURLModel *model = array[i];
            if ([model.url isEqualToString:url]) {
                model.isInvalid = isInvalid;
                model.invalidTime = invalidTime;
                [array replaceObjectAtIndex:i withObject:model];
                [BaseURLModel saveErrorUrl:array];
                break;
            }
        }
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_url forKey:@"url"];
    [aCoder encodeBool:_isInvalid forKey:@"isInvalid"];
    [aCoder encodeInteger:_invalidTime forKey:@"invalidTime"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if([super init]){
        
        _url = [aDecoder decodeObjectForKey:@"url"];
        _isInvalid = [aDecoder decodeBoolForKey:@"isInvalid"];
        _invalidTime = [aDecoder decodeIntegerForKey:@"invalidTime"];
    }
    return self;
}


@end
