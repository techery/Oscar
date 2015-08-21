//
// Created by Anastasiya Gorban on 7/31/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSActor.h"


@interface OSActorExecutor : NSObject <OSActorHandler>

@property(nonatomic, readonly) id<OSActorHandler> actorHandler;
@property(nonatomic, readonly) NSOperationQueue *operationQueue;

- (instancetype)initWithActorHandler:(id <OSActorHandler>)actorHandler;
+ (instancetype)executorWithActorHandler:(id <OSActorHandler>)actorHandler;

@end