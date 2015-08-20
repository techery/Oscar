//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTActorConstants.h"
#import "DTInvocation.h"

#pragma mark - Protocol - DTActorHandler

NS_ASSUME_NONNULL_BEGIN

@protocol DTActorHandler
- (RXPromise *)handle:(DTInvocation *)invocation;
@end

@protocol DTActorSystem;

#pragma mark - Protocol - DTSystemActor

@protocol DTSystemActor

@property (nonatomic, readonly, weak) id<DTActorSystem> actorSystem;
+ (id)actorWithActorSystem:(id <DTActorSystem>)actorSystem;

@end

#pragma mark - DTActor

@protocol DTActorSystem, DTConfigs;
@class DTServiceLocator;

@interface DTActor : NSObject<DTActorHandler, DTSystemActor>

@property (nonatomic, readonly, weak) id<DTActorSystem> actorSystem;

@property (nonatomic, readonly) DTServiceLocator *serviceLocator;
@property (nonatomic, readonly) id<DTConfigs> configs;

@property (nonatomic, readonly, nullable) DTInvocation *currentInvocation;

- (instancetype)initWithActorSystem:(id <DTActorSystem>)actorSystem;
+ (instancetype)actorWithActorSystem:(id <DTActorSystem>)actorSystem;

- (void)setup;

- (void)on:(Class)messageType _do:(void (^)(id))handler;
- (void)on:(Class)messageType doFuture:(RXPromise *(^)(id))handler;
- (void)on:(Class)messageType doResult:(id (^)(id))handler;

@end

#pragma mark - DTActorRef

@interface DTActorRef: NSObject

@property (nonatomic, readonly) id<DTActorHandler> actor;

- (instancetype)initWithActor:(id<DTActorHandler>)actor caller:(id)caller;

- (void)tell:(id)message;
- (RXPromise *)ask:(id)message;

@end

NS_ASSUME_NONNULL_END