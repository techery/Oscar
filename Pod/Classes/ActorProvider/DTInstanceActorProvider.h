//
// Created by Anastasiya Gorban on 8/19/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTActorProvider.h"

@class DTActor;

NS_ASSUME_NONNULL_BEGIN

@interface DTInstanceActorProvider : NSObject <DTActorProvider>

@property (nonatomic, readonly) id<DTActorHandler> actorHandler;

- (instancetype)initWithInstance:(DTActor *)instance;
+ (instancetype)providerWithInstance:(DTActor *)instance;

@end

NS_ASSUME_NONNULL_END