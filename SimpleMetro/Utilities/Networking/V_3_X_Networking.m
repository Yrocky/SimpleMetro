//
//  V_3_X_Networking.m
//  HLLNetworking
//
//  Created by admin on 16/2/22.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "V_3_X_Networking.h"
#import "AFNetworking.h"

@interface V_3_X_Networking ()

@property (nonatomic ,strong) AFHTTPSessionManager * session;

@property (nonatomic ,strong) NSURLSessionDataTask * dataTask;

@end
@implementation V_3_X_Networking

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.method = [HLLGETMethodType type];
        self.requestType = [HLLHTTPBodyType type];
        self.responseType = [HLLJsonDataType type];
        self.timeoutInterval = @(5);
        
        self.session = [AFHTTPSessionManager manager];
        
        self.HTTPHeaderFieldsWithValues = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)startRequest{

    [self resetData];
    [self accessRequestSerializer];
    [self accessHeaderFiled];
    [self accessResponseSerializer];
    [self accessTimeoutInterval];
    self.isRunning = YES;
    
    if ([self.method isKindOfClass:[HLLGETMethodType class]]) {
        
        typeof(self) weakSelf = self;
        
        NSDictionary * requestDictionary = [self accessRequestDictionarySerializerWithRequestDictionary:self.requestDictionary];
        _dataTask = [self.session GET:self.urlString
                           parameters:requestDictionary
                             progress:nil
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                  
                                  weakSelf.isRunning = NO;
                                  weakSelf.originalResponseData = responseObject;
                                  
                                  // 如果设置了转换策略，则进行数据的转换
                                  if (weakSelf.requestDictionarySerializer && [weakSelf.requestDictionarySerializer respondsToSelector:@selector(serializerRequestDictionary:)]) {
                                      weakSelf.serializerResponseData = [weakSelf.requestDictionarySerializer serializerRequestDictionary:responseObject];
                                  }
                                  
                                  if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(networkingDidRequestSuccess:data:)]) {
                                      [weakSelf.delegate networkingDidRequestSuccess:weakSelf
                                                                                data:(weakSelf.serializerResponseData == nil ? weakSelf.originalResponseData : weakSelf.serializerResponseData)];
                                  }
                                  
                              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  weakSelf.isRunning = NO;
                                  if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(networkingDidRequestFailed:error:)]) {
                                      [weakSelf.delegate networkingDidRequestFailed:weakSelf error:error];
                                  }
                              }];
    }else if ([self.method isKindOfClass:[HLLPOSTMethodType class]]){
    
        typeof(self) weakSelf = self;
        
        NSDictionary * requestDictionary = [self accessRequestDictionarySerializerWithRequestDictionary:self.requestDictionary];
        _dataTask = [self.session POST:self.urlString
                           parameters:requestDictionary
                             progress:nil
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                  
                                  weakSelf.isRunning = NO;
                                  weakSelf.originalResponseData = responseObject;
                                  
                                  // 如果设置了转换策略，则进行数据的转换
                                  if (weakSelf.requestDictionarySerializer && [weakSelf.requestDictionarySerializer respondsToSelector:@selector(serializerRequestDictionary:)]) {
                                      weakSelf.serializerResponseData = [weakSelf.requestDictionarySerializer serializerRequestDictionary:responseObject];
                                  }
                                  
                                  if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(networkingDidRequestSuccess:data:)]) {
                                      [weakSelf.delegate networkingDidRequestSuccess:weakSelf
                                                                                data:(weakSelf.serializerResponseData == nil ? weakSelf.originalResponseData : weakSelf.serializerResponseData)];
                                  }
                                  
                              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  weakSelf.isRunning = NO;
                                  if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(networkingDidRequestFailed:error:)]) {
                                      [weakSelf.delegate networkingDidRequestFailed:weakSelf error:error];
                                  }
                              }];

    }
    
    NSLog(@"RequestURL:%@",[self descriptionRequestURL]);
}

- (void) resetData{

    self.originalResponseData = nil;
    self.serializerResponseData = nil;
}
- (void) accessRequestSerializer{

    if ([self.requestType isKindOfClass:[HLLJsonBodyType class]]) {
        
        self.session.requestSerializer = [AFJSONRequestSerializer serializer];
    }else if ([self.requestType isKindOfClass:[HLLHTTPBodyType class]]){
    
        self.session.requestSerializer = [AFHTTPRequestSerializer serializer];
    }else if([self.requestType isKindOfClass:[HLLPlistBodyType class]]){
        
        self.session.requestSerializer = [AFPropertyListRequestSerializer serializer];
    }else{
        self.session.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
}
- (void) accessResponseSerializer{

    if ([self.responseDataSerializer isKindOfClass:[HLLHttpDataType class]]) {
        
        self.session.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.session.responseSerializer.acceptableContentTypes = [self.session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    }else if ([self.responseDataSerializer isKindOfClass:[HLLJsonDataType class]]){
    
        self.session.responseSerializer = [AFJSONResponseSerializer serializer];
        self.session.responseSerializer.acceptableContentTypes = [self.session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/json"];
    }else{
        self.session.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.session.responseSerializer.acceptableContentTypes = [self.session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    }
}
- (void) accessHeaderFiled{

    if (self.HTTPHeaderFieldsWithValues) {
        NSArray * allKeys = self.HTTPHeaderFieldsWithValues.allKeys;
        for (NSString * headerField in allKeys) {
            NSString * value = [self.HTTPHeaderFieldsWithValues objectForKey:headerField];
            [self.session.requestSerializer setValue:value forHTTPHeaderField:headerField];
        }
    }
}
- (void) accessTimeoutInterval{
    
    if (self.timeoutInterval && self.timeoutInterval.floatValue > 0.0) {
        self.session.requestSerializer.timeoutInterval = self.timeoutInterval.floatValue;
    }
}
- (void)cancelRequest{

    [self.dataTask cancel];
}


- (NSDictionary *) accessRequestDictionarySerializerWithRequestDictionary:(NSDictionary *)requestDictionary{
 
    if (self.requestDictionarySerializer &&
        [self.requestDictionarySerializer respondsToSelector:@selector(serializerRequestDictionary:)]) {
        return [self.requestDictionarySerializer serializerRequestDictionary:requestDictionary];
    }else{
        return requestDictionary;
    }
}
+ (id)getMethodNetworkingWithUrlString:(NSString *)urlString
                     requestDictionary:(NSDictionary *)requestDictioinary
                       requestBodyType:(HLLRequestBodyType *)requestType
                      responseDataType:(HLLResponseDataType *)responseType{

    HLLNetworking * networking = [[V_3_X_Networking alloc] init];
    networking.urlString = urlString;
    networking.requestDictionary = requestDictioinary;
    networking.method = [HLLGETMethodType type];
    
    if (requestType) {
        networking.requestType = requestType;
    }
    if (responseType) {
        networking.responseType = responseType;
    }
    return networking;
}

+ (id)postMethodNetworkingWithUrlString:(NSString *)urlString
                      requestDictionary:(NSDictionary *)requestDictioinary
                        requestBodyType:(HLLRequestBodyType *)requestType
                       responseDataType:(HLLResponseDataType *)responseType{
    
    HLLNetworking * networking = [[V_3_X_Networking alloc] init];
    networking.urlString = urlString;
    networking.requestDictionary = requestDictioinary;
    networking.method = [HLLPOSTMethodType type];
    
    if (requestType) {
        networking.requestType = requestType;
    }
    if (responseType) {
        networking.responseType = responseType;
    }
    return networking;
}
@end
