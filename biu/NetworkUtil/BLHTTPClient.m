//
//  BLHTTPClient.m
//  biu
//
//  Created by Tony Wu on 5/21/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLHTTPClient.h"

#if TARGET_IPHONE_SIMULATOR
static NSString* const BLBaseURLString = @"http://localhost:3000/cn/api/v1/";
//static NSString* const BLBaseURLString = @"http://182.92.117.218:3001/cn/api/v1/";
#else
static NSString* const BLBaseURLString = @"http://182.92.117.218:3001/cn/api/v1/";
//static NSString* const BLBaseURLString = @"http://123.56.129.119/cn/api/v1/";
#endif
static BLHTTPClient *_sharedHttpClient = nil;

@implementation BLHTTPClient

//@synthesize delegate = _delegate;

+ (BLHTTPClient *)sharedBLHTTPClient {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHttpClient = [[BLHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BLBaseURLString] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        _sharedHttpClient.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BLBaseURLString]];
    
        // 设置超时时间
//        [_sharedHttpClient.manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//        _sharedHttpClient.manager.requestSerializer.timeoutInterval = 10.f;
//        [_sharedHttpClient.manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        NSOperationQueue *operationQueue = _sharedHttpClient.manager.operationQueue;
        [_sharedHttpClient.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:
                    [operationQueue setSuspended:YES];
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                default:
                    [operationQueue setSuspended:NO];
                    break;
            }
        }];
        
        [_sharedHttpClient.manager.reachabilityManager startMonitoring];
    });
    
    return _sharedHttpClient;
}

+ (NSString *)blBaseURL {
    return BLBaseURLString;
}

+ (NSString *)responseMessage:(NSURLSessionDataTask *)task error:(NSError *)error {
    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (!errorData) {
        return nil;
    }
    NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
    if (!serializedData) {
        return nil;
    }
    return [serializedData objectForKey:@"error_message"];
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

+ (void)cancelOperations {
    [_sharedHttpClient.manager.operationQueue cancelAllOperations];

}

- (void)passcode:(NSString *)code phoneNumber:(NSString *)phoneNumber
         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!self) {
        return;
    }
    
    NSDictionary *parameter = @{@"code" : code,
                                @"phone_number" : phoneNumber};
    
    [self POST:@"passcode.json" parameters:parameter success:success failure:failure];
}

- (void)signup:(User *)user
       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!self) {
        return;
    }
    
    NSDictionary *parameter = @{@"user": @{@"username" : user.username,
                                           @"phone" : user.phone,
                                           @"password" : user.password,
                                           @"password_confirmation" : user.password}};
    
    [self POST:@"users.json" parameters:parameter success:success failure:failure];
}

- (void)login:(User *)user
      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!self) {
        return;
    }
    
    NSDictionary *parameter = @{@"phone" : user.phone,
                                @"password" : user.password};
    [self POST:@"login.json" parameters:parameter success:success failure:failure];
}

- (void)logout:(User *)user
       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!self) {
        return;
    }
    
    [self DELETE:@"logout.json" parameters:nil success:success failure:failure];
}

- (void)createProfile:(Profile *)profile
                 user:(User *)user
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!profile) {
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:profile.birthday];
    
    NSDictionary *parameters = @{@"profile" : @{@"user_id" : user.userId,
                                                @"gender" : [NSNumber numberWithInteger:profile.gender],
                                                @"sexuality_id" : [NSNumber numberWithInteger:profile.sexuality],
                                                @"birthday" : dateString,
                                                @"zodiac_id" : [NSNumber numberWithInteger:profile.zodiac],
                                                @"style_id" : [NSNumber numberWithInteger:profile.style]}};
    
    [self POST:@"profiles.json" parameters:parameters success:success failure:failure];
}



- (void)updateProfile:(Profile *)profile
                 user:(User *)user
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!profile) {
        return;
    }
    
    if (!profile.profileId) {
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:profile.birthday];
    
    NSDictionary *parameters = @{@"profile" : @{@"user_id" : user.userId,
                                                @"gender" : [NSNumber numberWithInteger:profile.gender],
                                                @"sexuality_id" : [NSNumber numberWithInteger:profile.sexuality],
                                                @"birthday" : dateString,
                                                @"zodiac_id" : [NSNumber numberWithInteger:profile.zodiac],
                                                @"style_id" : [NSNumber numberWithInteger:profile.style]}};
    
    [self PUT:[NSString stringWithFormat:@"profiles/%@.json", profile.profileId] parameters:parameters success:success failure:failure];
}

- (void)createPartner:(Partner *)partner
                 user:(User *)user
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!partner) {
        return;
    }
    
    NSDictionary *parameters = @{@"partner" : @{@"user_id" : user.userId,
                                                @"sexuality_ids" : partner.sexualities,
                                                @"min_age" : partner.minAge,
                                                @"max_age" : partner.maxAge,
                                                @"zodiac_ids" : partner.preferZodiacs,
                                                @"style_ids" : partner.preferStyles}};
    [self POST:@"partners.json" parameters:parameters success:success failure:failure];
}

- (void)updatePartner:(Partner *)partner
                 user:(User *)user
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!partner) {
        return;
    }
    
    if (!partner.partnerId) {
        return;
    }
    
    NSDictionary *parameters = @{@"partner" : @{@"user_id" : user.userId,
                                                @"sexuality_ids" : partner.sexualities,
                                                @"min_age" : partner.minAge,
                                                @"max_age" : partner.maxAge,
                                                @"zodiac_ids" : partner.preferZodiacs,
                                                @"style_ids" : partner.preferStyles}};
    [self PUT:[NSString stringWithFormat:@"partners/%@.json", partner.partnerId] parameters:parameters success:success failure:failure];
}

- (void)uploadAvatar:(User *)user
              avatar:(UIImage *)avatar
              isRect:(BOOL)isRect
             success:(void (^)(NSURLSessionDataTask *, id))success
             failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSString *url = nil;
    NSString *fileName = nil;
    if (isRect) {
        url = [NSString stringWithFormat:@"rect/avatar/%@.json", user.userId];
        fileName = @"avatar_rect.jpg";
    } else {
        url = [NSString stringWithFormat:@"cycle/avatar/%@.json", user.userId];
        fileName = @"avatar_cycle.jpg";
    }
    
    [self POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(avatar, 1.0f) name:@"avatar" fileName:fileName mimeType:@"image/jpg"];
    } success:success failure:failure];
}

- (void)updateLocation:(User *)user
               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSDictionary *parameters = @{@"location" : @{@"latitude" : user.latitude,
                                                 @"longitude" : user.longitude}};
    [self PUT:[NSString stringWithFormat:@"location/%@.json", user.userId] parameters:parameters success:success failure:failure];
}

- (void)match:(User *)user
        event:(BLMatchEvent)event
     distance:(NSNumber *)distance
  matchedUser:(User *)matchedUser
      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSMutableDictionary *matchDictionary = [NSMutableDictionary dictionary];
    [matchDictionary setObject:[NSNumber numberWithInteger:event] forKey:@"event"];
    if (distance) {
        [matchDictionary setObject:distance forKey:@"distance"];
    }
    if (matchedUser) {
        [matchDictionary setObject:matchedUser.userId forKey:@"matched_user_id"];
    }
    
    NSDictionary *parameters = @{@"match" : matchDictionary};
    
    [self PUT:[NSString stringWithFormat:@"match/%@", user.userId] parameters:parameters success:success failure:failure];
}

- (void)registToken:(NSString *)token
               user:(User *)user
            success:(void (^)(NSURLSessionDataTask *, id))success
            failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    if (!token || !user) {
        return;
    }
    NSDictionary *parameters = @{@"device" : @{@"token" : token,
                                               @"user_id" : user.userId}};
    [self POST:@"devices.json" parameters:parameters success:success failure:failure];
}

- (void)updateToken:(NSString *)token
               user:(User *)user
            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!token || !user) {
        return;
    }
    
    NSDictionary *parameters = @{@"device" : @{@"token" : token}};
    [self PUT:[NSString stringWithFormat:@"devices/%@", user.userId] parameters:parameters success:success failure:failure];
}

- (void)forgotPassword:(User *)user
               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!user) {
        return;
    }
    
    NSDictionary *parameters = @{@"user" : @{@"password" : user.password,
                                             @"password_confirmation" : user.password}};
    [self PUT:[NSString stringWithFormat:@"password/%@", user.phone] parameters:parameters success:success failure:failure];
}

- (void)resetPassword:(User *)user
          oldPassword:(NSString *)oldPassword
          newPassword:(NSString *)newPassword
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!user || !newPassword || !oldPassword) {
        return;
    }
    
    NSDictionary *parameters = @{@"user" : @{@"old_password" : oldPassword,
                                             @"password" : newPassword,
                                             @"password_confirmation" : newPassword}};
    [self PUT:[NSString stringWithFormat:@"resetpassword/%@", user.userId] parameters:parameters success:success failure:failure];
}

- (void)createSuggestion:(NSString *)advice
                   email:(NSString *)email
                  userId:(NSNumber *)userId
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!advice || !userId) {
        return;
    }
    
    NSMutableDictionary *suggestionDictionary = [NSMutableDictionary dictionary];
    [suggestionDictionary setObject:userId forKey:@"user_id"];
    [suggestionDictionary setObject:advice forKey:@"advice"];
    if (email && ![email isEqualToString:@""]) {
        [suggestionDictionary setObject:email forKey:@"email"];
    }
    
    NSDictionary *parameters = @{@"suggestion" : suggestionDictionary};
    [self POST:@"suggestions" parameters:parameters success:success failure:failure];
}


//上传微信或微博个人信息
- (void)thirdParty:(User *)user
           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    if (!user) {
        return;
    }
    NSDictionary *parameters = @{@"user" : @{@"open_id" : user.open_id,
                                             @"username" : user.username,
                                             @"avatar_url" : user.avatar_url,
                                             @"avatar_large_url" : user.avatar_large_url}};
    [self POST:@"tplogin" parameters:parameters success:success failure:failure];
    
}

//获取userIfo
- (void)getUserIfo:(User *)user
           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    [self GET:[NSString stringWithFormat:@"users/%@", user.userId] parameters:nil success:success failure:failure];
    
}


- (void)getMatchInfo:(User *)user
             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!user) {
        return;
    }
    
    [self GET:[NSString stringWithFormat:@"match/%@.json", user.userId] parameters:nil success:success failure:failure];
}

- (void)sendingMessage:(User *)sender
              receiver:(User *)receiver
               content:(NSString *)content
               success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!sender || !receiver || !content) {
        return;
    }
    
    NSDictionary *parameters = @{@"message" : @{@"from" : sender.userId,
                                                @"to" : receiver.userId,
                                                @"type" : @"chat",
                                                @"content" : content}};
    [self POST:@"messages.json" parameters:parameters success:success failure:failure];
}
@end





