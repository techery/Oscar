//
// Created by Anastasiya Gorban on 7/31/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DTActorSystem;
@protocol DTSystemActor;
@protocol DTActorHandler;

NS_ASSUME_NONNULL_BEGIN

@protocol DTActorProvider

@property (nonatomic, readonly) Class<DTSystemActor> actorType;

- (id<DTActorHandler>)create:(id<DTActorSystem>)actorSystem;

@end

NS_ASSUME_NONNULL_END