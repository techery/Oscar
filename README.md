# Oscar

[![CI Status](http://img.shields.io/travis/techery/Oscar.svg?style=flat)](https://travis-ci.org/techery/Oscar)
[![Version](https://img.shields.io/cocoapods/v/Oscar.svg?style=flat)](http://cocoapods.org/pods/Oscar)
[![License](https://img.shields.io/cocoapods/l/Oscar.svg?style=flat)](http://cocoapods.org/pods/Oscar)
[![Platform](https://img.shields.io/cocoapods/p/Oscar.svg?style=flat)](http://cocoapods.org/pods/Oscar)

## Requirements

iOS7

## Installation

Oscar is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Oscar"
```

## Usage

# Swactors

The actor model in computer science is a mathematical model of concurrent computation that treats "actors" as the universal primitives of concurrent computation: in response to a message that it receives, an actor can make local decisions, create more actors, send more messages, and determine how to respond to the next message received. [(Wikipedia)](https://en.wikipedia.org/wiki/Actor_model).

In actor model we have complete set of actor objects, where every actor implements it's own behavior. In order to execute it's behavior actor should receive a message of a certain type.
Actor define set of messages that he can accept and reactions for them. Messages are sent asynchronously, but actor is processing them one at time, while other messages are waiting for their turn in a queue.

##Actors and messages##

To create an actor you have to inherit from OSActor class:
```objc
@interface THSessionActor : OSActor
@end
```
Then override `-setup:`, define what kind of messeges actor can accept and provide reactions for them:
```objc
- (void)setup {
    [self on:[THLogin class] doFuture:^RXPromise *(THLogin *message) {
        return [self askSession:message.email password:message.password];
    }];

    [self on:[THLogout class] _do:^(id o) {
        [self.sessionStorage clear];
    }];
}
```
There 3 types of reactions to message: 
- **void** - just do work, return nothing;
- **result** - return result immediately;
- **future** - return future object - useful for async tasks, or then message is redirected to another actor.

##Actor System##

Actor usually have references to other actors and communicates with them also through message-passing mechanism.
Actors initialize inside actor system and reference to them can only be obtained through system.

How to create actor system:
```objc
OSMainActorSystem *system = [[OSMainActorSystem alloc] initWithConfigs:configs serviceLocator:serviceLocator builderBlock:^(OSActorSystemBuilder * builder) {
    [builder addActorsPull:[THAPIActor class] count:3];
    [builder addSingleton:[THSessionActor class]];
    [builder addActor:^OSActor *(id<OSActorSystem> system) {
        return [THAuthActor actorWithActorSystem:system];
    }];
}];
```
Types of actor providers that could be added to system:

- **Singleton** - an actor of provided class would be created on first access;
- **Instance** - already inialized actor, could be useful if you need custom initialization;
- **Actors Pull** - as was said before, every actor could handle only one message at a time, which sometime is not useful. For netwrok for example needed possibility to proccess few messages simultaniously. On sending messages to actors pull system eather take first free actor, or creates new if pull isn't filled yet, or if all actors are busy it just takes any actor from the pull.

##Sending message##

To send message to actor you need actor reference:
```objc
OSActorRef *sessionActor = [sut actorOfClass:[SomeActor class] caller:self];
```
Message of any class could be sent to actor (but it's preffered for message to be immutable):
```objc
RXPromise *session = [sessionActor ask:[[THLogin alloc] initWithLogin:login password:password]];
```

Result of message sending is Future object which will be fulfilled with some result or rejected with error:
```objc
session.then(^id(id result){
    NSLog(@"Session: %@", result);
    return nil;
}, 
^id(NSError* error){
    NSLog(@"Error: %@", error);
    return nil;
});
```

##ServiceLocator ##

Actor system is initizlized with ServiceLocator. ServiceLocator is an object that contains references to your custom services that are not actors.
You can register you services by class or protocol:
```objc
OSServiceLocator *serviceLocator = [[OSServiceLocator alloc] initWithBuilderBlock:^(OSServiceLocator *locator) {
    THSessionStorage *sessionStorage = [THSessionStorage new];
    [serviceLocator registerService:sessionStorage];
    [serviceLocator registerService:[THSessionStorage new] forProtocol:@protocol(THSessionProvider)];
}];
```
And later get access to them in your actor:
```objc
[self on:[THLogout class] _do:^(id o) {
    THSessionStorage *sessionStorage = [self.serviceLocator serviceForClass:[THSessionStorage class]];
    [sessionStorage clear];
}];
```

## Authors

* Anastasiya Gorban, gorbannastya@gmail.com
* Sergey Zenchenko, sergeizenchenko@gmail.com

## License

Oscar is available under the MIT license. See the LICENSE file for more info.
