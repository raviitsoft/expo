// Copyright 2016-present 650 Industries. All rights reserved.

#import "ABI26_0_0EXFingerprint.h"

#import <LocalAuthentication/LocalAuthentication.h>

@implementation ABI26_0_0EXFingerprint

ABI26_0_0RCT_EXPORT_MODULE(ExponentFingerprint)

ABI26_0_0RCT_EXPORT_METHOD(hasHardwareAsync:(ABI26_0_0RCTPromiseResolveBlock)resolve
                  rejecter:(ABI26_0_0RCTPromiseRejectBlock)reject)
{
  LAContext *context = [LAContext new];
  NSError *error = nil;

  BOOL isSupported = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
  if (!isSupported && error.code == LAErrorTouchIDNotAvailable) {
    resolve(@(NO));
  } else {
    resolve(@(YES));
  }
}

ABI26_0_0RCT_EXPORT_METHOD(isEnrolledAsync:(ABI26_0_0RCTPromiseResolveBlock)resolve
                  rejecter:(ABI26_0_0RCTPromiseRejectBlock)reject)
{
  LAContext *context = [LAContext new];
  NSError *error = nil;

  BOOL isSupported = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
  resolve(isSupported && !error ? @(YES) : @(NO));
}

ABI26_0_0RCT_EXPORT_METHOD(authenticateAsync:(NSString *)reason
                  resolve:(ABI26_0_0RCTPromiseResolveBlock)resolve
                  rejecter:(ABI26_0_0RCTPromiseRejectBlock)reject)
{
  LAContext *context = [LAContext new];

  [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
          localizedReason:reason
                    reply:^(BOOL success, NSError *error) {
                      if (success) {
                        resolve(@{@"success": @(YES)});
                      } else {
                        resolve(@{
                          @"success": @(NO),
                          @"error": [self convertErrorCode:error.code],
                        });
                      }
                    }];


}

- (NSString *)convertErrorCode:(NSInteger)code
{
  switch (code) {
    case LAErrorSystemCancel:
      return @"system_cancel";
    case LAErrorAppCancel:
      return @"app_cancel";
    case LAErrorTouchIDLockout:
      return @"lockout";
    case LAErrorUserFallback:
      return @"user_fallback";
    case LAErrorUserCancel:
      return @"user_cancel";
    case LAErrorTouchIDNotAvailable:
      return @"not_available";
    case LAErrorInvalidContext:
      return @"invalid_context";
    case LAErrorTouchIDNotEnrolled:
      return @"not_enrolled";
    case LAErrorPasscodeNotSet:
      return @"passcode_not_set";
    case LAErrorAuthenticationFailed:
      return @"authentication_failed";
    default:
      return @"unknown";
  }
}

@end
