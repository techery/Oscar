//
// Created by Anastasiya Gorban on 7/31/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTActorExecutor.h"
#import "DTActorOperation.h"
#import "DTInvocation.h"


@interface DTActorExecutor ()
@property(nonatomic, strong) NSOperationQueue *operationQueue;
@property(nonatomic, readwrite) id <DTActorHandler> actorHandler;
@end

@implementation DTActorExecutor

- (instancetype)initWithActorHandler:(id<DTActorHandler>)actorHandler {
    self = [super init];
    if (self) {
        _operationQueue = [NSOperationQueue new];
        _operationQueue.maxConcurrentOperationCount = 1;
        
        _actorHandler = actorHandler;
    }

    return self;
}

+ (instancetype)executorWithActorHandler:(id <DTActorHandler>)actorHandler {
    return [[self alloc] initWithActorHandler:actorHandler];
}

#pragma mark - DTActorHandler

- (RXPromise *)handle:(DTInvocation *)invocation {
    DTActorOperation *operation = [[DTActorOperation alloc] initWithInvocation:invocation handler:self.actorHandler];
    [self.operationQueue addOperation:operation];
    return [operation promise];
}

@end