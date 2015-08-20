//
// Created by Anastasiya Gorban on 8/19/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DTActorProvider.h"

@interface DTSingletonActorProvider: NSObject<DTActorProvider>

@property (nonatomic, readonly) Class<DTSystemActor> actorType;
@property (nonatomic, readonly) id<DTActorHandler> actorHandler;

- (instancetype)initWithActorType:(Class)actorType;
+ (instancetype)providerWithActorType:(Class)actorType;

@end