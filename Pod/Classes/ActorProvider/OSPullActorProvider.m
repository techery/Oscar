//
// Created by Anastasiya Gorban on 8/19/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "OSPullActorProvider.h"
#import "NSArray+Functional_Oscar.h"
#import "OSActor.h"
#import "OSActorExecutor.h"


@interface OSPullActorProvider ()

@property (nonatomic, strong) NSMutableArray *handlers;
@property(nonatomic, strong, readwrite) Class <OSSystemActor> actorType;
@property(nonatomic, readwrite) NSInteger count;
@end

@implementation OSPullActorProvider

- (instancetype)initWithActorType:(Class<OSSystemActor>)actorType count:(NSInteger)count {
    self = [super init];
    if (self) {
        self.actorType = actorType;
        self.count = count;
        self.handlers = [NSMutableArray arrayWithCapacity:count];
    }

    return self;
}

+ (instancetype)providerWithActorType:(Class <OSSystemActor>)actorType count:(NSInteger)count {
    return [[self alloc] initWithActorType:actorType count:count];
}

#pragma mark - OSActorProvider

- (id <OSActorHandler>)create:(id <OSActorSystem>)actorSystem {
    OSActorExecutor *handler;
    handler = [self findFreeHandler];
    
    if (!handler) {
        BOOL pullFilled = self.handlers.count == self.count;
        if (!pullFilled) {
            handler = [self createNewHandler:actorSystem];
        } else {
            handler = [self.handlers firstObject];
        }
    }
    
    return handler;
}

#pragma mark - Private

- (OSActorExecutor *)findFreeHandler {
    return [[self.handlers filter:^BOOL(OSActorExecutor *handler) {
        return handler.operationQueue.operationCount == 0;
    }] firstObject];
}

- (OSActorExecutor *)createNewHandler:(id<OSActorSystem>)actorSystem {
    OSActor *actor = [self.actorType actorWithActorSystem:actorSystem];
    OSActorExecutor *handler = [OSActorExecutor executorWithActorHandler:actor];
    [self.handlers addObject:handler];
    return handler;
}

@end
