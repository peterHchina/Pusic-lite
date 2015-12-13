//
//  PusicContant.m
//  Pusic Lite
//
//  Created by peter on 15/5/9.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "PusicContant.h"
 static  NSString * DataBaseURL = @"default.sqlite";

@implementation PusicContant

+(NSString *) getDataBasePath
{
    return DataBaseURL;
}
@end
