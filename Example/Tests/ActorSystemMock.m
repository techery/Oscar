//
//  ActorSystemMock.m
//  Actors
//
//  Created by Anastasiya Gorban on 8/13/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "ActorSystemMock.h"
#import "DTConfigs.h"
#import "DTServiceLocator.h"

DTMainActorSystem * actorSystemMock() {
    DTMainActorSystem *actorSystem = [DTMainActorSystem mock];

    [actorSystem stub:@selector(configs) andReturn:[KWMock mockForProtocol:@protocol(DTConfigs)]];
    [actorSystem stub:@selector(serviceLocator) andReturn:[[DTServiceLocator alloc] initWithBuilderBlock:^(DTServiceLocator *locator) {

    }]];

    return actorSystem;
}