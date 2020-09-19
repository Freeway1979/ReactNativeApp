//
//  RNCommon.m
//  ReactNativeApp
//
//  Created by Andy Liu on 2020/9/19.
//  Copyright © 2020 Study. All rights reserved.
//

#import "RNCommon.h"
#import <Foundation/Foundation.h>
#import <React/RCTLog.h>
#import <React/RCTLinkingManager.h>
#import <React/RCTEventEmitter.h>
#import "UIDevice+Extension.h"
#import "NSDictionary+Extension.h"

static BOOL isTheReactNativeReady = NO;

NSString * const kReactNativeReady = @"ReactNativeReady";

@interface RNCommon ()
- (BOOL)isJailBroken;
@end

@implementation RNCommon
- (dispatch_queue_t)methodQueue
{
  return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

RCT_EXPORT_MODULE()

- (NSDictionary *)constantsToExport
{
  UIDevice *currentDevice = [UIDevice currentDevice];
  NSDictionary* constants = @{
           @"appVersion"  : [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
           @"buildVersion": [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey],
           @"bundleIdentifier"  : [[NSBundle mainBundle] bundleIdentifier],
           @"os": [currentDevice systemName],
           @"osVersion":[currentDevice systemVersion],
           @"deviceModel": [currentDevice deviceModel],
#if TARGET_OS_SIMULATOR
           @"isEmulator": @TRUE,
#else
           @"isEmulator": @FALSE,
#endif
           @"isJailBroken": [self isJailBroken] == YES ? @TRUE : @FALSE,
           };
 
  return constants;
}

RCT_EXPORT_METHOD(notifyReactReady) {
  NSLog(@"React native is ready.");
  isTheReactNativeReady = YES;
  [[NSNotificationCenter defaultCenter] postNotificationName:kReactNativeReady object:nil];
}

RCT_EXPORT_METHOD(notifyLoggedIn) {
  
}

RCT_EXPORT_METHOD(notifyLoggedOut) {
  
}

RCT_EXPORT_METHOD(exitApp) {
  dispatch_async(dispatch_get_main_queue(), ^{
    UIApplication *app = [UIApplication sharedApplication];
    SEL sSelector = NSSelectorFromString(@"suspend");
    if ([app respondsToSelector:sSelector]) {
      [[UIControl new] sendAction:sSelector to:app forEvent:nil];
    }
  });
}

RCT_EXPORT_METHOD(getDeviceToken:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"devicekToken"];
    if (!token) {
      token= @"";
    }
    resolve(token);
}

- (BOOL)isJailBroken {
#if !(TARGET_OS_SIMULATOR)
  if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"] ||
      [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"] ||
      [[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"] ||
      [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/sbin/sshd"] ||
      [[NSFileManager defaultManager] fileExistsAtPath:@"/etc/apt"] ||
      [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] ||
      [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]]) {
    return YES;
  }
  
  FILE *f = NULL;
  if ((f = fopen("/bin/bash", "r")) ||
      (f = fopen("/Applications/Cydia.app", "r")) ||
      (f = fopen("/Library/MobileSubstrate/MobileSubstrate.dylib", "r")) ||
      (f = fopen("/usr/sbin/sshd", "r")) ||
      (f = fopen("/etc/apt", "r"))) {
    fclose(f);
    return YES;
  }
  fclose(f);
  NSError *error;
  NSString *stringToBeWritten = @"This is a test.";
  [stringToBeWritten writeToFile:@"/private/jailbreak.txt" atomically:YES encoding:NSUTF8StringEncoding error:&error];
  [[NSFileManager defaultManager] removeItemAtPath:@"/private/jailbreak.txt" error:nil];
  if(error == nil) {
    return YES;
  }
#endif
  return NO;
}

+ (BOOL)isReactNativeReady {
  return isTheReactNativeReady;
}

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

+ (void)dispatchWhileReactReady:(dispatch_block_t) block {
  if (block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      while (!isTheReactNativeReady) {
        [NSThread sleepForTimeInterval:0.5];
      }
      block();
    });
  }
}

+ (void)openUrlSafely:(NSURL *)url {
  [RNCommon dispatchWhileReactReady:^{
    [RCTLinkingManager application:[UIApplication sharedApplication] openURL:url options:@{}];
  }];
}

@end
