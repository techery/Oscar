//
// Created by Anastasiya Gorban on 7/31/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OSActorSystem;
@protocol OSSystemActor;
@protocol OSActorHandler;


@protocol OSActorProvider

@property (nonatomic, readonly) Class<OSSystemActor> actorType;

- (id<OSActorHandler>)create:(id<OSActorSystem>)actorSystem;

@end
