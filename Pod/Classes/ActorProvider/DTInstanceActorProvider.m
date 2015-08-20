//
// Created by Anastasiya Gorban on 8/19/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTInstanceActorProvider.h"
#import "DTActor.h"
#import "DTActorExecutor.h"


@interface DTInstanceActorProvider ()
@property(nonatomic, strong) id<DTActorHandler> actorHandler;
@property(nonatomic) Class<DTSystemActor> actorType;
@end

@implementation DTInstanceActorProvider

- (instancetype)initWithInstance:(DTActor *)instance {
    self = [super init];
    if (self) {
        _actorHandler = [DTActorExecutor executorWithActorHandler:instance];
        _actorType = [instance class];
    }

    return self;
}

+ (instancetype)providerWithInstance:(DTActor *)instance {
    return [[self alloc] initWithInstance:instance];
}

#pragma mark - DTActorProvider

- (Class <DTSystemActor>)actorType {
    return _actorType;
}

- (id <DTActorHandler>)create:(id <DTActorSystem>)actorSystem {
    return self.actorHandler;
}

@end
