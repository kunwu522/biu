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
+ (NSString *)blBaseURL;

- (instancetype)initWithBaseURL:(NSURL *)url;

- (void)registToken:(NSString *)token
               user:(User *)user
            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)updateToken:(NSString *)token
               user:(User *)user
            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

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

- (void)resetPassword:(User *)user
          oldPassword:(NSString *)oldPassword
          newPassword:(NSString *)newPassword
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)forgotPassword:(User *)user
               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)uploadAvatar:(User *)user
              avatar:(UIImage *)avatar
              isRect:(BOOL)isRect
             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)createProfile:(Profile *)profile
                 user:(User *)user
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)createPartner:(Partner *)partner
                 user:(User *)user
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)updateProfile:(Profile *)profile
                 user:(User *)user
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)updatePartner:(Partner *)partner
                 user:(User *)user
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)updateLocation:(User *)user
               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)match:(User *)user
        event:(BLMatchEvent)event
     distance:(NSNumber *)distance
  matchedUser:(User *)matchedUser
      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)getMatchInfo:(User *)user
             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)createSuggestion:(NSString *)advice
                   email:(NSString *)email
                  userId:(NSNumber *)userId
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

//上传微信微博个人信息
- (void)thirdParty:(User *)user
           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

//获取userIfo
- (void)getUserIfo:(User *)user
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;



@end

@protocol BLHTTPClientDelegate <NSObject>
@optional
- (void)canNotReachNetworkWithHttpClient:(BLHTTPClient *)client;
- (void)blHTTPClient:(BLHTTPClient *)client didFailWithError:(NSError *)error;
@end




