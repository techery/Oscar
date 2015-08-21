//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSActorConstants.h"
#import "OSInvocation.h"

#pragma mark - Protocol - OSActorHandler

@protocol OSActorHandler
- (RXPromise *)handle:(OSInvocation *)invocation;
@end

@protocol OSActorSystem;

#pragma mark - Protocol - OSSystemActor

@protocol OSSystemActor

@property (nonatomic, readonly, weak) id<OSActorSystem> actorSystem;
+ (id)actorWithActorSystem:(id <OSActorSystem>)actorSystem;

@end

#pragma mark - OSActor

@protocol OSActorSystem, OSConfigs;
@class OSServiceLocator;

@interface OSActor : NSObject<OSActorHandler, OSSystemActor>

@property (nonatomic, readonly, weak) id<OSActorSystem> actorSystem;

@property (nonatomic, readonly) OSServiceLocator *serviceLocator;
@property (nonatomic, readonly) id<OSConfigs> configs;

@property (nonatomic, readonly) OSInvocation *currentInvocation;

- (instancetype)initWithActorSystem:(id <OSActorSystem>)actorSystem;
+ (instancetype)actorWithActorSystem:(id <OSActorSystem>)actorSystem;

- (void)setup;

- (void)on:(Class)messageType _do:(void (^)(id))handler;
- (void)on:(Class)messageType doFuture:(RXPromise *(^)(id))handler;
- (void)on:(Class)messageType doResult:(id (^)(id))handler;

@end

#pragma mark - OSActorRef

@interface OSActorRef: NSObject

@property (nonatomic, readonly) id<OSActorHandler> actor;

- (instancetype)initWithActor:(id<OSActorHandler>)actor caller:(id)caller;

- (void)tell:(id)message;
- (RXPromise *)ask:(id)message;

@end
