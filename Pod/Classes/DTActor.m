//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTActor.h"
#import "DTMessageDispatcher.h"
#import "DTActorSystem.h"
#import <RXPromise/RXPromise.h>

@interface DTActor ()
@property(nonatomic, strong) DTMessageDispatcher *dispatcher;
@property (nonatomic, strong) DTInvocation *currentInvocation;
@end

@implementation DTActor

#pragma mark - Initialization

- (instancetype)initWithActorSystem:(id <DTActorSystem>)actorSystem {
    self = [super init];
    if (self) {
        _actorSystem = actorSystem;
        _dispatcher = [DTMessageDispatcher new];
        _serviceLocator = actorSystem.serviceLocator;
        _configs = actorSystem.configs;
        [self setup];
    }

    return self;
}

+ (instancetype)actorWithActorSystem:(id<DTActorSystem>)actorSystem {
    return [[self alloc] initWithActorSystem:actorSystem];
}

#pragma mark - Public

- (void)setup {
    
}

- (void)on:(Class)messageType _do:(void (^)(id))handler {
    [self.dispatcher on:messageType do:handler];
}

- (void)on:(Class)messageType doFuture:(DTFutureMessageBlock)handler {
    [self.dispatcher on:messageType doFuture:handler];
}

- (void)on:(Class)messageType doResult:(DTResultMessageBlock)handler {
    [self.dispatcher on:messageType doResult:handler];
}

#pragma mark - DTActorHandler

- (RXPromise *)handle:(DTInvocation *)invocation {
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


@interface DTActorRef()
@property (nonatomic, strong) id<DTActorHandler> actor;
@property (nonatomic, weak) id caller;
@end

@implementation DTActorRef

- (instancetype)initWithActor:(id<DTActorHandler>)actor caller:(id)caller {
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
    DTInvocation *invocation = [DTInvocation invocationWithMessage:message caller:self.caller];
    return [self.actor handle:invocation];
}

@end