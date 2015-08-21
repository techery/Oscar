//
// Created by Anastasiya Gorban on 8/19/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSActorProvider.h"

@class OSActor;

NS_ASSUME_NONNULL_BEGIN

@interface OSInstanceActorProvider : NSObject <OSActorProvider>

@property (nonatomic, readonly) id<OSActorHandler> actorHandler;

- (instancetype)initWithInstance:(OSActor *)instance;
+ (instancetype)providerWithInstance:(OSActor *)instance;

@end

NS_ASSUME_NONNULL_END