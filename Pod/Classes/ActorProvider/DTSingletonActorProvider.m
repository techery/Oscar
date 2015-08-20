//
// Created by Anastasiya Gorban on 8/19/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTSingletonActorProvider.h"


#import "DTActor.h"
#import "DTActorExecutor.h"


@interface DTSingletonActorProvider ()
@property (nonatomic, readwrite) id<DTActorHandler> actorHandler;
@end

@implementation DTSingletonActorProvider

- (instancetype)initWithActorType:(Class)actorType {
    if (self = [super init]) {
        _actorType = actorType;
    }

    return self;
}

+ (instancetype)providerWithActorType:(Class)actorType {
    return [[self alloc] initWithActorType:actorType];
}

#pragma mark - DTActorProvider

- (id<DTActorHandler>)create:(id <DTActorSystem>)actorSystem {
    if (!self.actorHandler) {
        DTActor *actor = [self.actorType actorWithActorSystem:actorSystem];
        DTActorExecutor *executor = [DTActorExecutor executorWithActorHandler:actor];
        self.actorHandler = executor;
    }

    return self.actorHandler;
}

@end