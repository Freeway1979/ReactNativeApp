//
//  ReactNativeHelper.m
//  ReactNativeApp
//
//  Created by Andy Liu on 2020/9/19.
//  Copyright © 2020 Study. All rights reserved.
//

#import "ReactNativeHelper.h"
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>

@implementation ReactNativeHelper

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE(ReactNativeHelper);

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

RCT_EXPORT_METHOD(
                  invokeNative:(nonnull NSNumber *)reactTag
                  params:(NSDictionary *)params
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    RCTUIManager *uiManager = _bridge.uiManager;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view = [uiManager viewForReactTag:reactTag];
        UIViewController *viewController = (UIViewController *)view.reactViewController;
        SEL selector = NSSelectorFromString(@"handleJSCallWithOptions:");
        if ([viewController respondsToSelector:selector]) {
            IMP imp = [viewController methodForSelector:selector];
            void (*func)(id, SEL,NSDictionary *  ) = (void *)imp;
            func(viewController, selector, params);
        }
    });
    resolve(nil);
}

@end
