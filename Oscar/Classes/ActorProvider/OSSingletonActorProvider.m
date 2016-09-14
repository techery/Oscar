//
// Created by Anastasiya Gorban on 8/19/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "OSSingletonActorProvider.h"


#import "OSActor.h"
#import "OSActorExecutor.h"


@interface OSSingletonActorProvider ()
@property (nonatomic, readwrite) id<OSActorHandler> actorHandler;
@end

@implementation OSSingletonActorProvider

- (instancetype)initWithActorType:(Class)actorType {
    if (self = [super init]) {
        _actorType = actorType;
    }

    return self;
}

+ (instancetype)providerWithActorType:(Class)actorType {
    return [[self alloc] initWithActorType:actorType];
}

#pragma mark - OSActorProvider

- (id<OSActorHandler>)create:(id <OSActorSystem>)actorSystem {
    if (!self.actorHandler) {
        OSActor *actor = [self.actorType actorWithActorSystem:actorSystem];
        OSActorExecutor *executor = [OSActorExecutor executorWithActorHandler:actor];
        self.actorHandler = executor;
    }

    return self.actorHandler;
}

@end