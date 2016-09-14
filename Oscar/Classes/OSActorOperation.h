//
// Created by Anastasiya Gorban on 7/31/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSActorConstants.h"
#import "OSInvocation.h"

@protocol OSActorHandler;

@interface OSBaseOperation : NSOperation
- (void)finish;
@end

@interface OSActorOperation : OSBaseOperation

@property(nonatomic, readonly) RXPromise *promise;

- (instancetype)initWithInvocation:(OSInvocation *)invocation handler:(id<OSActorHandler>)handler;

@end
