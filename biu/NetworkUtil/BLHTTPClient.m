//
//  BLHTTPClient.m
//  biu
//
//  Created by Tony Wu on 5/21/15.
//  Copyright (c) 2015 BiuLove. All rights reserved.
//

#import "BLHTTPClient.h"

static NSString* const BLBaseURLString = @"http://localhost:3000/api/v1/";

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

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (void)signup:(User *)user
       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!self) {
        return;
    }
    
    NSDictionary *parameter = @{@"username" : user.username,
                                   @"email" : user.email,
                                @"password" : user.password,
                   @"password_confirmation" : user.password};
    
    [self POST:@"users" parameters:parameter success:success failure:failure];
}

- (void)login:(User *)user
      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!self) {
        return;
    }
    
    NSDictionary *parameter = @{@"email" : user.email,
                                @"password" : user.password};
    [self POST:@"login" parameters:parameter success:success failure:failure];
}

- (void)logout:(User *)user
       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    if (!self) {
        return;
    }
    
    [self DELETE:@"logout" parameters:nil success:success failure:failure];
}

@end
