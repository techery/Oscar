#import <Kiwi/Kiwi.h>
// Class under test
#import "OSActors.h"
#import "OSActorSystemMock.h"
#import "OSPromiseMatcher.h"

@interface ActorTestMessage : NSObject
@end

@implementation ActorTestMessage
@end

SPEC_BEGIN(OSActorTest)
registerMatchers(@"OS");

describe(@"OSActor", ^{
    __block OSActor *sut;
    __block OSActorRef *sutRef;
    ActorTestMessage *message = [ActorTestMessage new];
    OSInvocation *invocation = [OSInvocation invocationWithMessage:message caller:self];
    
    beforeEach(^{
        sut = [[OSActor alloc] initWithActorSystem:actorSystemMock()];
        sutRef = [[OSActorRef alloc] initWithActor:sut caller:self];
    });
    
    it(@"should be correctly initialized", ^{
        [[(NSObject *)sut.actorSystem shouldNot] beNil];
        [[(NSObject *)sut.configs shouldNot] beNil];
    });
    
    context(@"void handler", ^{
        __block BOOL blockWasCalled = NO;
        void (^voidBlock)(id) = ^void(id message) {
            blockWasCalled = YES;
        };
        
        context(@"handler was added", ^{
            it(@"should call handler block and return fulfilled result", ^{
                [sut on:[message class] _do:voidBlock];
                
                RXPromise *result = [sut handle:invocation];
                [result wait];
                
                [[result should] beFulfilled];
                [[theValue(blockWasCalled) should] beTrue];
            });
        });
        
        context(@"handler wasn't added", ^{
            it(@"shouldn't call handler block and return failed result", ^{
                __block BOOL blockWasCalled = NO;
                id result = [sut handle:invocation];
                [result wait];
                [[result should] beRejected];
                [[theValue(blockWasCalled) should] beFalse];
            });
        });
    });
    
    context(@"result handler", ^{
        __block BOOL blockWasCalled = NO;
        id resultObject = [NSObject new];
        id (^resultBlock)(id) = ^id(id message) {
            blockWasCalled = YES;
            return resultObject;
        };
        
        context(@"handler was added", ^{
            it(@"should call handler block and return fulfilled result", ^{
                [sut on:[message class] doResult:resultBlock];
                
                RXPromise *result = [sut handle:invocation];
                [result wait];
                
                [[result should] beFulfilled];
                [[result.get should] equal:resultObject];
                [[theValue(blockWasCalled) should] beTrue];
            });
        });
        
        context(@"handler wasn't added", ^{
            it(@"shouldn't call handler block and return failed result", ^{
                __block BOOL blockWasCalled = NO;
                id result = [sut handle:invocation];
                [result wait];
                [[result should] beRejected];
                [[theValue(blockWasCalled) should] beFalse];
            });
        });
    });
    
    context(@"future handler", ^{
        __block BOOL blockWasCalled = NO;
        id resultObject = [NSObject new];
        RXPromise * (^futureBlock)(id) = ^RXPromise *(id message) {
            blockWasCalled = YES;
            RXPromise *promise = [RXPromise new];
            [promise resolveWithResult:resultObject];
            return promise;
        };
        
        context(@"handler was added", ^{
            it(@"should call handler block and return fulfilled result", ^{
                [sut on:[message class] doFuture:futureBlock];
                
                RXPromise *result = [sut handle:invocation];
                [result wait];
                
                [[result should] beFulfilled];
                [[result.get should] equal:resultObject];
                [[theValue(blockWasCalled) should] beTrue];
            });
        });
        
        context(@"handler wasn't added", ^{
            it(@"shouldn't call handler block and return failed result", ^{
                __block BOOL blockWasCalled = NO;
                id result = [sut handle:invocation];
                [result wait];
                [[result should] beRejected];
                [[theValue(blockWasCalled) should] beFalse];
            });
        });
    });
});
SPEC_END


