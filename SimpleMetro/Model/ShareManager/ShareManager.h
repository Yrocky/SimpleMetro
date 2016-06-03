//
//  ShareManager.h
//  HangmanGameDemo
//
//  Created by Youngrocky on 16/4/25.
//  Copyright © 2016年 Young Rocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <UIKit/UIKit.h>

typedef void(^ShareBeginHandle)(SSDKPlatformType platformType);
typedef void(^ShareSucessHandle)(SSDKPlatformType platformType);
typedef void(^ShareFailedHandle)(SSDKPlatformType platformType,NSError * error);
typedef void(^ShareCancelHandle)(SSDKPlatformType platformType);

@interface ShareManager : NSObject

+ (void) linkShareSDK;

/**
 * 基本的文字、图片分享
 */
+ (void) simplyShareParamsWithImage:(UIImage *)image
                            content:(NSString *)content
                          urlString:(NSString *)urlString
                              begin:(ShareBeginHandle)begin
                             sucess:(ShareSucessHandle)sucess
                             failed:(ShareFailedHandle)failed
                             cancel:(ShareCancelHandle)cancel;

/**
 * 截屏分享，用于解不开单词求助好友的时候
 */
+ (void) screenShareParamsWithContent:(NSString *)content
                            urlString:(NSString *)urlString
                                begin:(ShareBeginHandle)begin
                               sucess:(ShareSucessHandle)sucess
                               failed:(ShareFailedHandle)failed
                               cancel:(ShareCancelHandle)cancel;

/**
 * 摇一摇分享，
 */
+ (void) shakeShareParamsWithImage:(UIImage *)image
                           content:(NSString *)content
                         urlString:(NSString *)urlString
                             begin:(ShareBeginHandle)begin
                            sucess:(ShareSucessHandle)sucess
                            failed:(ShareFailedHandle)failed
                            cancel:(ShareCancelHandle)cancel;

@end
