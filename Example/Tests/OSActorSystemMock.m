//
//  ActorSystemMock.m
//  Actors
//
//  Created by Anastasiya Gorban on 8/13/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "OSActorSystemMock.h"
#import "OSConfigs.h"

OSMainActorSystem * actorSystemMock() {
    OSMainActorSystem *actorSystem = [OSMainActorSystem mock];

    [actorSystem stub:@selector(configs) andReturn:[KWMock mockForProtocol:@protocol(OSConfigs)]];

    return actorSystem;
}