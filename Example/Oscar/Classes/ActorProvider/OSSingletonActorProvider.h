//
// Created by Anastasiya Gorban on 8/19/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OSActorProvider.h"

@interface OSSingletonActorProvider: NSObject<OSActorProvider>

@property (nonatomic, readonly) Class<OSSystemActor> actorType;
@property (nonatomic, readonly) id<OSActorHandler> actorHandler;

- (instancetype)initWithActorType:(Class)actorType;
+ (instancetype)providerWithActorType:(Class)actorType;

@end