//
//  AppNativeEventEmitter.m
//  ReactNativeApp
//
//  Created by Andy Liu on 2020/9/19.
//  Copyright © 2020 Study. All rights reserved.
//

#import "AppNativeEventEmitter.h"

@implementation AppNativeEventEmitter

NSString * const kOnLeftBarButtonClicked = @"onLeftBarButtonClicked";
NSString * const kOnRightBarButtonClicked = @"onRightBarButtonClicked";
NSString * const kOnDataChanged = @"onDataChanged";

NSString * const kDataEventCallback = @"DataEventCallback";

+ (instancetype)sharedInstance
{
    return [[AppNativeEventEmitter alloc] init];
}

// It is very important making a singleton object.
+(id)allocWithZone:(NSZone *)zone
{
    static AppNativeEventEmitter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

RCT_EXPORT_MODULE();
+ (BOOL)requiresMainQueueSetup {
    return YES;
}

- (NSDictionary *)constantsToExport {
    return @{};
}

- (NSArray<NSString *> *)supportedEvents {
    return @[
             (NSString *)kDataEventCallback
    ];
}

- (void)callLeftBarButtonClickedOnJS {
    [self callDataEventCallbackOnJS:@{
        @"eventType": kOnLeftBarButtonClicked
    }];
}

- (void)callRightBarButtonClickedOnJS {
    [self callDataEventCallbackOnJS:@{
        @"eventType": kOnRightBarButtonClicked
    }];
}

- (void)notifyDataChangedOnJS:(NSDictionary *)data {
    [self callDataEventCallbackOnJS:@{
        @"eventType": kOnDataChanged,
        @"data": data
    }];
}

- (void)callDataEventCallbackOnJS: (NSDictionary *)parameters {
    [self callJSWithEvent:kDataEventCallback parameters:parameters];
}

- (void)callJSWithEvent:(NSString *) eventName parameters:(NSDictionary *)parameters {
    [self sendEventWithName:eventName body:parameters];
}


- (void)startObserving {

}

- (void)stopObserving {

}


@end

