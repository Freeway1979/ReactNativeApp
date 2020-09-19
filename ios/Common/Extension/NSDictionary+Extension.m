//
//  NSDictionary+Extension.m
//  mmmobile
//
//  Created by Andy Liu on 2019/7/3.
//  Copyright © 2020 Study, Inc. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

- (NSString *)toString {
  NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
  return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

@end
