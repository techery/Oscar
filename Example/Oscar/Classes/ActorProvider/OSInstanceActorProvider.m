//
// Created by Anastasiya Gorban on 8/19/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "OSInstanceActorProvider.h"
#import "OSActor.h"
#import "OSActorExecutor.h"


@interface OSInstanceActorProvider ()
@property(nonatomic, strong) id<OSActorHandler> actorHandler;
@property(nonatomic) Class<OSSystemActor> actorType;
@end

@implementation OSInstanceActorProvider

- (instancetype)initWithInstance:(OSActor *)instance {
    self = [super init];
    if (self) {
        _actorHandler = [OSActorExecutor executorWithActorHandler:instance];
        _actorType = [instance class];
    }

    return self;
}

+ (instancetype)providerWithInstance:(OSActor *)instance {
    return [[self alloc] initWithInstance:instance];
}

#pragma mark - OSActorProvider

- (Class <OSSystemActor>)actorType {
    return _actorType;
}

- (id <OSActorHandler>)create:(id <OSActorSystem>)actorSystem {
    return self.actorHandler;
}

@end
