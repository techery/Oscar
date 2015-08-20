//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DTActorProvider, DTConfigs;
@class DTActorRef, DTActor, DTServiceLocator;
@class DTMainActorSystem;
@protocol DTSystemActor;

NS_ASSUME_NONNULL_BEGIN

@protocol DTActorSystem

@property(nonatomic, readonly) DTServiceLocator *serviceLocator;
@property (nonatomic, readonly) id<DTConfigs> configs;

- (nullable DTActorRef *)actorOfClass:(Class)class caller:(id)caller;
- (void)addActorProvider:(id<DTActorProvider>)actorProvider;

@end

@interface DTActorSystemBuilder: NSObject

@property (nonatomic, readonly) id<DTActorSystem> actorSystem;

- (instancetype)initWithActorSystem:(id <DTActorSystem>)actorSystem;
+ (instancetype)builderWithActorSystem:(id <DTActorSystem>)actorSystem;

- (void)addSingleton:(Class<DTSystemActor>)actorType;
- (void)addActor:(DTActor * (^)(id<DTActorSystem>))addBlock;

- (void)addActorsPull:(Class<DTSystemActor>)actorType count:(int)count;
@end

@interface DTMainActorSystem : NSObject <DTActorSystem>

@property(nonatomic, readonly) DTServiceLocator *serviceLocator;
@property (nonatomic, readonly) id<DTConfigs> configs;

- (instancetype)initWithConfigs:(id<DTConfigs>)configs
                 serviceLocator:(DTServiceLocator *)serviceLocator
                   builderBlock:(void (^)(DTActorSystemBuilder *))builderBlock;
@end

NS_ASSUME_NONNULL_END