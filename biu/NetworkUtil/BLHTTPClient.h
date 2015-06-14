//
//  BLHTTPClient.h
//  biu
//
//  Created by Tony Wu on 5/21/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "User.h"

@protocol BLHTTPClientDelegate;

@interface BLHTTPClient : AFHTTPSessionManager

@property (weak, nonatomic) id<BLHTTPClientDelegate> delegate;

+ (BLHTTPClient *)sharedBLHTTPClient;
+ (NSString *)responseMessage:(NSURLSessionDataTask *)task error:(NSError *)error;

- (instancetype)initWithBaseURL:(NSURL *)url;

- (void)passcode:(NSString *)code phoneNumber:(NSString *)phoneNumber
         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (void)signup:(User *)user
       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (void)login:(User *)user
      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (void)logout:(User *)user
       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (void)createProfile:(Profile *)profile
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (void)createPartner:(Partner *)partner
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (void)updateProfile:(Profile *)profile
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (void)uploadAvatar:(Profile *)porfile avatar:(UIImage *)avatar
             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

@protocol BLHTTPClientDelegate <NSObject>
@optional
- (void)canNotReachNetworkWithHttpClient:(BLHTTPClient *)client;
- (void)blHTTPClient:(BLHTTPClient *)client didFailWithError:(NSError *)error;
@end
