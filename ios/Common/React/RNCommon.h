//
//  RNCommon.h
//  ReactNativeApp
//
//  Created by Andy Liu on 2020/9/19.
//  Copyright © 2020 Study. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#else
#import "RCTBridgeModule.h"
#endif


@interface RNCommon : NSObject <RCTBridgeModule>

+ (BOOL)isReactNativeReady ;

+ (void)dispatchWhileReactReady:(dispatch_block_t) block;

+ (void)openUrlSafely:(NSURL *)url;


@end
