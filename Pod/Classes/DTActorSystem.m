//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTActorSystem.h"
#import "DTActor.h"
#import "DTSingletonActorProvider.h"
#import "DTInstanceActorProvider.h"
#import "DTPullActorProvider.h"


@interface DTMainActorSystem()
@property (nonatomic, strong) NSMutableDictionary *actorsProviders;
@property (nonatomic, strong) DTServiceLocator *serviceLocator;
@end

@implementation DTMainActorSystem

- (instancetype)initWithConfigs:(id<DTConfigs>)configs serviceLocator:(DTServiceLocator *)serviceLocator builderBlock:(void (^)(DTActorSystemBuilder *))builderBlock {
    if (self = [super init]) {
        _actorsProviders = [NSMutableDictionary new];
        _serviceLocator = serviceLocator;
        _configs = configs;
        DTActorSystemBuilder *builder = [[DTActorSystemBuilder alloc] initWithActorSystem:self];
        builderBlock(builder);
    }
    
    return self;
}

#pragma mark -  DTActorSystem

- (nullable DTActorRef *)actorOfClass:(Class)class caller:(id)caller {
    id<DTActorHandler> actor = [self getActor:class];
    if (actor) {
        DTActorRef *actorRef = [[DTActorRef alloc] initWithActor:actor caller:caller];
        return actorRef;
    } else {
        return nil;
    }
};

- (void)addActorProvider:(id<DTActorProvider>)actorProvider {
    // TODO: log warning if provider with same actorType has beed already added that it would be replaced
    NSString *key = NSStringFromClass(actorProvider.actorType);
    _actorsProviders[key] = actorProvider;
}

#pragma mark - Private

- (id<DTActorHandler>)getActor:(Class)actorType {
    NSString *key = NSStringFromClass(actorType);
    id<DTActorProvider> actorProvider = _actorsProviders[key];
    return [actorProvider create:self];
}

@end

@implementation DTActorSystemBuilder

- (instancetype)initWithActorSystem:(id <DTActorSystem>)actorSystem {
    self = [super init];
    if (self) {
        _actorSystem = actorSystem;
    }

    return self;
}

+ (instancetype)builderWithActorSystem:(id <DTActorSystem>)actorSystem {
    return [[self alloc] initWithActorSystem:actorSystem];
}

- (void)addSingleton:(Class<DTSystemActor>)actorType {
    [self.actorSystem addActorProvider:[DTSingletonActorProvider providerWithActorType:actorType]];
}

- (void)addActor:(DTActor * (^)(id<DTActorSystem>))addBlock {
    DTActor *instance = addBlock(self.actorSystem);
    [self.actorSystem addActorProvider:[DTInstanceActorProvider providerWithInstance:instance]];
}

- (void)addActorsPull:(Class<DTSystemActor>)actorType count:(int)count {
    [self.actorSystem addActorProvider:[DTPullActorProvider providerWithActorType:actorType count:count]];
}

@end