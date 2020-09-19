//
//  AppNativeEventEmitter.h
//  ReactNativeApp
//
//  Created by Andy Liu on 2020/9/19.
//  Copyright © 2020 Study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppNativeEventEmitter : RCTEventEmitter

+ (instancetype)sharedInstance;

- (void)callLeftBarButtonClickedOnJS;

- (void)callRightBarButtonClickedOnJS;

- (void)notifyDataChangedOnJS:(NSDictionary *)data;

- (void)callDataEventCallbackOnJS: (NSDictionary *)parameters;

- (void)callJSWithEvent:(NSString *) eventName parameters:(NSDictionary *)parameters;


@end

NS_ASSUME_NONNULL_END

