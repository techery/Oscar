//
// Created by Anastasiya Gorban on 8/19/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTPullActorProvider.h"
#import "NSArray+Functional.h"
#import "DTActor.h"
#import "DTActorExecutor.h"


@interface DTPullActorProvider ()

@property (nonatomic, strong) NSMutableArray *handlers;
@property(nonatomic, strong, readwrite) Class <DTSystemActor> actorType;
@property(nonatomic, readwrite) NSInteger count;
@end

@implementation DTPullActorProvider

- (instancetype)initWithActorType:(Class<DTSystemActor>)actorType count:(NSInteger)count {
    self = [super init];
    if (self) {
        self.actorType = actorType;
        self.count = count;
        self.handlers = [NSMutableArray arrayWithCapacity:count];
    }

    return self;
}

+ (instancetype)providerWithActorType:(Class <DTSystemActor>)actorType count:(NSInteger)count {
    return [[self alloc] initWithActorType:actorType count:count];
}

#pragma mark - DTActorProvider

- (id <DTActorHandler>)create:(id <DTActorSystem>)actorSystem {
    DTActorExecutor *handler;
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

- (nullable DTActorExecutor *)findFreeHandler {
    return [[self.handlers filter:^BOOL(DTActorExecutor *handler) {
        return handler.operationQueue.operationCount == 0;
    }] firstObject];
}

- (DTActorExecutor *)createNewHandler:(id<DTActorSystem>)actorSystem {
    DTActor *actor = [self.actorType actorWithActorSystem:actorSystem];
    DTActorExecutor *handler = [DTActorExecutor executorWithActorHandler:actor];
    [self.handlers addObject:handler];
    return handler;
}

@end
