//
// Created by Anastasiya Gorban on 7/31/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTActor.h"


@interface DTActorExecutor : NSObject <DTActorHandler>

@property(nonatomic, readonly) id<DTActorHandler> actorHandler;
@property(nonatomic, readonly) NSOperationQueue *operationQueue;

- (instancetype)initWithActorHandler:(id <DTActorHandler>)actorHandler;
+ (instancetype)executorWithActorHandler:(id <DTActorHandler>)actorHandler;

@end