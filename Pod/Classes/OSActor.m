//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "OSActor.h"
#import "OSMessageDispatcher.h"
#import "OSActorSystem.h"
#import <RXPromise/RXPromise.h>

@interface OSActor ()
@property(nonatomic, strong) OSMessageDispatcher *dispatcher;
@property (nonatomic, strong) OSInvocation *currentInvocation;
@end

@implementation OSActor

#pragma mark - Initialization

- (instancetype)initWithActorSystem:(id <OSActorSystem>)actorSystem {
    self = [super init];
    if (self) {
        _actorSystem = actorSystem;
        _dispatcher = [OSMessageDispatcher new];
        _serviceLocator = actorSystem.serviceLocator;
        _configs = actorSystem.configs;
        [self setup];
    }

    return self;
}

+ (instancetype)actorWithActorSystem:(id<OSActorSystem>)actorSystem {
    return [[self alloc] initWithActorSystem:actorSystem];
}

#pragma mark - Public

- (void)setup {
    
}

- (void)on:(Class)messageType _do:(void (^)(id))handler {
    [self.dispatcher on:messageType do:handler];
}

- (void)on:(Class)messageType doFuture:(OSFutureMessageBlock)handler {
    [self.dispatcher on:messageType doFuture:handler];
}

- (void)on:(Class)messageType doResult:(OSResultMessageBlock)handler {
    [self.dispatcher on:messageType doResult:handler];
}

#pragma mark - OSActorHandler

- (RXPromise *)handle:(OSInvocation *)invocation {
    self.currentInvocation = invocation;
    RXPromise *promise = [self.dispatcher handle:invocation.message];
    promise.then(^id(id result){
        self.currentInvocation = nil;
        return result;
    }, ^(NSError *error) {
        self.currentInvocation = nil;
        return error;
    });
    return promise;
}

@end


@interface OSActorRef()
@property (nonatomic, strong) id<OSActorHandler> actor;
@property (nonatomic, weak) id caller;
@end

@implementation OSActorRef

- (instancetype)initWithActor:(id<OSActorHandler>)actor caller:(id)caller {
    if (self = [super init]) {
        _actor = actor;
        _caller = caller;
    }

    return self;
}

- (RXPromise *)ask:(id)message {
    return [self handle:message];
}

- (void)tell:(id)message {
    [self handle:message];
}

- (RXPromise *)handle:(id)message {
    OSInvocation *invocation = [OSInvocation invocationWithMessage:message caller:self.caller];
    return [self.actor handle:invocation];
}

@end