//
//  ViewController.m
//  NetworkTool
//
//  Created by continue on 2019/7/22.
//  Copyright © 2019 continue. All rights reserved.
//

#import "ViewController.h"
#import "URLManager.h"

@interface ViewController ()<URLManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[URLManager shareSingle] getAllBaseUrlState];
    [URLManager shareSingle].delegate = self;;
}

//返回不超时的域名
- (void)getSuccessBaseUrl:(NSString *)url {
    
    NSLog(@"SUCCESS : URL -> %@", url);
}




@end
