//
// Created by Anastasiya Gorban on 8/19/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSActorProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface OSPullActorProvider : NSObject <OSActorProvider>

@property(nonatomic, strong, readonly) Class <OSSystemActor> actorType;
@property(nonatomic, readonly) NSInteger count;

- (instancetype)initWithActorType:(Class <OSSystemActor>)actorType count:(NSInteger)count;
+ (instancetype)providerWithActorType:(Class <OSSystemActor>)actorType count:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END