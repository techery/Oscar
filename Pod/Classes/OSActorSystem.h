//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OSActorProvider, OSConfigs;
@class OSActorRef, OSActor;
@class OSMainActorSystem;
@protocol OSSystemActor;


@protocol OSActorSystem

@property (nonatomic, readonly) id<OSConfigs> configs;

- (OSActorRef *)actorOfClass:(Class)aClass caller:(id)caller;
- (void)addActorProvider:(id<OSActorProvider>)actorProvider;

@end

@interface OSActorSystemBuilder: NSObject

@property (nonatomic, readonly) id<OSActorSystem> actorSystem;

- (instancetype)initWithActorSystem:(id <OSActorSystem>)actorSystem;
+ (instancetype)builderWithActorSystem:(id <OSActorSystem>)actorSystem;

- (void)addSingleton:(Class<OSSystemActor>)actorType;
- (void)addActor:(OSActor * (^)(id<OSActorSystem>))addBlock;

- (void)addActorsPull:(Class<OSSystemActor>)actorType count:(int)count;
@end

@interface OSMainActorSystem : NSObject <OSActorSystem>

@property (nonatomic, readonly) id<OSConfigs> configs;

- (instancetype)initWithConfigs:(id<OSConfigs>)configs
                   builderBlock:(void (^)(OSActorSystemBuilder *))builderBlock;
@end
