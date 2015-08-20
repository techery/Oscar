//
// Created by Anastasiya Gorban on 8/6/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "OSServiceLocator.h"


@implementation OSServiceLocator {
    NSMutableDictionary *_registry;
}

#pragma mark - Init

- (instancetype)initWithBuilderBlock:(void (^)(OSServiceLocator *))builderBlock {
    self = [super init];
    if (self) {
        _registry = [NSMutableDictionary new];
        builderBlock(self);
    }

    return self;
}

#pragma mark - Keys

- (NSString *)protocolToKey:(Protocol *)value {
    return [NSString stringWithFormat:@"%@ %@", NSStringFromProtocol(value), @"Protocol"];
}

- (NSString *)classToKey:(Class)value {
    return [NSString stringWithFormat:@"%@ %@", NSStringFromClass(value), @"Class"];
}

#pragma mark - Registration

- (void)registerInstance:(id)instance forKey:(NSString *)key {
    NSParameterAssert(instance != nil);
    NSParameterAssert(key != nil);

    _registry[key] = instance;
}

- (id)instanceForKey:(NSString *)key {
    return _registry[key];
}

- (void)registerService:(id)service forProtocol:(Protocol *)protocol {
    [self registerInstance:service forKey:[self protocolToKey:protocol]];
}

- (id)serviceForProtocol:(Protocol *)protocol {
    return [self instanceForKey:[self protocolToKey:protocol]];
}

- (void)registerService:(id)service {
    [self registerInstance:service forKey:[self classToKey:[service class]]];
}

- (id)serviceForClass:(Class)class {
    return [self instanceForKey:[self classToKey:class]];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    typeof(self) copy = (OSServiceLocator *)[self.class new];
    copy->_registry = [self->_registry mutableCopy];

    return copy;
}

@end
