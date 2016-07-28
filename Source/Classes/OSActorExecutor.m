//
// Created by Anastasiya Gorban on 7/31/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "OSActorExecutor.h"
#import "OSActorOperation.h"
#import "OSInvocation.h"


@interface OSActorExecutor ()
@property(nonatomic, strong) NSOperationQueue *operationQueue;
@property(nonatomic, readwrite) id <OSActorHandler> actorHandler;
@end

@implementation OSActorExecutor

- (instancetype)initWithActorHandler:(id<OSActorHandler>)actorHandler {
    self = [super init];
    if (self) {
        _operationQueue = [NSOperationQueue new];
        _operationQueue.maxConcurrentOperationCount = 1;
        
        _actorHandler = actorHandler;
    }

    return self;
}

+ (instancetype)executorWithActorHandler:(id <OSActorHandler>)actorHandler {
    return [[self alloc] initWithActorHandler:actorHandler];
}

#pragma mark - OSActorHandler

- (RXPromise *)handle:(OSInvocation *)invocation {
    OSActorOperation *operation = [[OSActorOperation alloc] initWithInvocation:invocation handler:self.actorHandler];
    [self.operationQueue addOperation:operation];
    return [operation promise];
}

@end