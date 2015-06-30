//
//  BLHTTPClient.m
//  biu
//
//  Created by Tony Wu on 5/21/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLHTTPClient.h"

//static NSString* const BLBaseURLString = @"http://123.56.129.119/cn/api/v1/";
static NSString* const BLBaseURLString = @"http://localhost:3000/cn/api/v1/";

@implementation BLHTTPClient

//@synthesize delegate = _delegate;

+ (BLHTTPClient *)sharedBLHTTPClient {
    static BLHTTPClient *_sharedHttpClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHttpClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:BLBaseURLString]];
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BLBaseURLString]];
        NSOperationQueue *operationQueue = manager.operationQueue;
        [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
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
        
        [manager.reachabilityManager startMonitoring];
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
       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!profile) {
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:profile.birthday];
    
    NSDictionary *parameters = @{@"profile" : @{@"user_id" : profile.userId,
                                                @"gender" : [NSNumber numberWithInteger:profile.gender],
                                              @"birthday" : dateString,
                                             @"zodiac_id" : [NSNumber numberWithInteger:profile.zodiac],
                                              @"style_id" : [NSNumber numberWithInteger:profile.style]}};
    
    [self POST:@"profiles.json" parameters:parameters success:success failure:failure];
}

- (void)updateProfile:(Profile *)profile
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
    
    NSDictionary *parameters = @{@"profile" : @{@"user_id" : profile.userId,
                                                @"gender" : [NSNumber numberWithInteger:profile.gender],
                                                @"birthday" : dateString,
                                                @"zodiac_id" : [NSNumber numberWithInteger:profile.zodiac],
                                                @"style_id" : [NSNumber numberWithInteger:profile.style]}};
    
    [self PUT:[NSString stringWithFormat:@"profiles/%@.json", profile.profileId] parameters:parameters success:success failure:failure];
}

- (void)createPartner:(Partner *)partner
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!partner) {
        return;
    }
    
    NSDictionary *parameters = @{@"partner" : @{@"user_id" : partner.userId,
                                                @"sexuality_ids" : partner.sexualities,
                                                @"min_age" : partner.minAge,
                                                @"max_age" : partner.maxAge,
                                                @"zodiac_ids" : partner.preferZodiacs,
                                                @"style_ids" : partner.preferStyles}};
    [self POST:@"partners.json" parameters:parameters success:success failure:failure];
}

- (void)updatePartner:(Partner *)partner
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!partner) {
        return;
    }
    
    if (!partner.partnerId) {
        return;
    }
    
    NSDictionary *parameters = @{@"partner" : @{@"user_id" : partner.userId,
                                                @"sexuality_ids" : partner.sexualities,
                                                @"min_age" : partner.minAge,
                                                @"max_age" : partner.maxAge,
                                                @"zodiac_ids" : partner.preferZodiacs,
                                                @"style_ids" : partner.preferStyles}};
    [self PUT:[NSString stringWithFormat:@"partners/%@.json", partner.partnerId] parameters:parameters success:success failure:failure];
}

- (void)uploadAvatar:(Profile *)profile
              avatar:(UIImage *)avatar
              isRect:(BOOL)isRect
             success:(void (^)(NSURLSessionDataTask *, id))success
             failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSString *url = nil;
    NSString *fileName = nil;
    if (isRect) {
        url = [NSString stringWithFormat:@"rect/avatar/%@.json", profile.profileId];
        fileName = @"avatar_rect.jpg";
    } else {
        url = [NSString stringWithFormat:@"cycle/avatar/%@.json", profile.profileId];
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

- (void)matching:(User *)user
         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    [self GET:[NSString stringWithFormat:@"match/%@", user.userId] parameters:nil success:success failure:failure];
}

- (void)deviceToken:(NSString *)token
               user:(User *)user
            success:(void (^)(NSURLSessionDataTask *, id))success
            failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    if (!token || !user) {
        return;
    }
    NSDictionary *parameters = @{@"device" : @{@"token" : token,
                                               @"user_id" : user.userId}};
    [self POST:@"device.json" parameters:parameters success:success failure:failure];
}

@end
