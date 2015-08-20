//
// Created by Anastasiya Gorban on 8/19/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTActorProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface DTPullActorProvider : NSObject <DTActorProvider>

@property(nonatomic, strong, readonly) Class <DTSystemActor> actorType;
@property(nonatomic, readonly) NSInteger count;

- (instancetype)initWithActorType:(Class <DTSystemActor>)actorType count:(NSInteger)count;
+ (instancetype)providerWithActorType:(Class <DTSystemActor>)actorType count:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END