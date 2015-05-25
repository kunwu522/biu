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
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)signup:(User *)user
       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

@protocol BLHTTPClientDelegate <NSObject>
@optional
- (void)blHTTPClient:(BLHTTPClient *)client didFailWithError:(NSError *)error;
@end
