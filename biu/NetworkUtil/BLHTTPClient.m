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

+ (BLHTTPClient *)sharedBLHTTPClient {
    static BLHTTPClient *_sharedHttpClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHttpClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:BLBaseURLString]];
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

@end
