//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "OSActorSystem.h"
#import "OSActor.h"
#import "OSSingletonActorProvider.h"
#import "OSInstanceActorProvider.h"
#import "OSPullActorProvider.h"


@interface OSMainActorSystem()
@property (nonatomic, strong) NSMutableDictionary *actorsProviders;
@property (nonatomic, strong) OSServiceLocator *serviceLocator;
@end

@implementation OSMainActorSystem

- (instancetype)initWithConfigs:(id<OSConfigs>)configs serviceLocator:(OSServiceLocator *)serviceLocator builderBlock:(void (^)(OSActorSystemBuilder *))builderBlock {
    if (self = [super init]) {
        _actorsProviders = [NSMutableDictionary new];
        _serviceLocator = serviceLocator;
        _configs = configs;
        OSActorSystemBuilder *builder = [[OSActorSystemBuilder alloc] initWithActorSystem:self];
        builderBlock(builder);
    }
    
    return self;
}

#pragma mark -  OSActorSystem

- (OSActorRef *)actorOfClass:(Class)class caller:(id)caller {
    id<OSActorHandler> actor = [self getActor:class];
    if (actor) {
        OSActorRef *actorRef = [[OSActorRef alloc] initWithActor:actor caller:caller];
        return actorRef;
    } else {
        return nil;
    }
};

- (void)addActorProvider:(id<OSActorProvider>)actorProvider {
    // TODO: log warning if provider with same actorType has beed already added that it would be replaced
    NSString *key = NSStringFromClass(actorProvider.actorType);
    _actorsProviders[key] = actorProvider;
}

#pragma mark - Private

- (id<OSActorHandler>)getActor:(Class)actorType {
    NSString *key = NSStringFromClass(actorType);
    id<OSActorProvider> actorProvider = _actorsProviders[key];
    return [actorProvider create:self];
}

@end

@implementation OSActorSystemBuilder

- (instancetype)initWithActorSystem:(id <OSActorSystem>)actorSystem {
    self = [super init];
    if (self) {
        _actorSystem = actorSystem;
    }

    return self;
}

+ (instancetype)builderWithActorSystem:(id <OSActorSystem>)actorSystem {
    return [[self alloc] initWithActorSystem:actorSystem];
}

- (void)addSingleton:(Class<OSSystemActor>)actorType {
    [self.actorSystem addActorProvider:[OSSingletonActorProvider providerWithActorType:actorType]];
}

- (void)addActor:(OSActor * (^)(id<OSActorSystem>))addBlock {
    OSActor *instance = addBlock(self.actorSystem);
    [self.actorSystem addActorProvider:[OSInstanceActorProvider providerWithInstance:instance]];
}

- (void)addActorsPull:(Class<OSSystemActor>)actorType count:(int)count {
    [self.actorSystem addActorProvider:[OSPullActorProvider providerWithActorType:actorType count:count]];
}

@end