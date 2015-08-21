#import <Kiwi/Kiwi.h>
// Class under test
#import "OSMessageDispatcher.h"

#import "OSActors.h"
#import "OSPromiseMatcher.h"

@interface MessageDispatcherTestHandler : NSObject
@end

@implementation MessageDispatcherTestHandler
@end

SPEC_BEGIN(OSMessageDispatcherTest)
    registerMatchers(@"OS");

    describe(@"OSMessageDispatcher", ^{
        __block OSMessageDispatcher *sut;
        
        beforeEach(^{
            sut = [OSMessageDispatcher new];
        });
        
        context(@"void handler", ^{
            __block BOOL blockWasCalled = NO;
            void (^voidBlock)(id) = ^void(id message) {
                blockWasCalled = YES;
            };
            
            context(@"handler was added", ^{
                it(@"should call handler block and return fulfilled result", ^{
                    [sut on:[MessageDispatcherTestHandler class] do:voidBlock];
                    
                    RXPromise *result = [sut handle:[MessageDispatcherTestHandler new]];
                    [result wait];
                    
                    [[result should] beFulfilled];
                    [[theValue(blockWasCalled) should] beTrue];
                });
            });
            
            context(@"handler wasn't added", ^{
                it(@"shouldn't call handler block and return failed result", ^{
                    __block BOOL blockWasCalled = NO;
                    id result = [sut handle:[MessageDispatcherTestHandler new]];
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
                    [sut on:[MessageDispatcherTestHandler class] doResult:resultBlock];
                    
                    RXPromise *result = [sut handle:[MessageDispatcherTestHandler new]];
                    [result wait];
                    
                    [[result should] beFulfilled];
                    [[result.get should] equal:resultObject];
                    [[theValue(blockWasCalled) should] beTrue];
                });
            });
            
            context(@"handler wasn't added", ^{
                it(@"shouldn't call handler block and return failed result", ^{
                    __block BOOL blockWasCalled = NO;
                    id result = [sut handle:[MessageDispatcherTestHandler new]];
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
                    [sut on:[MessageDispatcherTestHandler class] doFuture:futureBlock];
                    
                    RXPromise *result = [sut handle:[MessageDispatcherTestHandler new]];
                    [result wait];
                    
                    [[result should] beFulfilled];
                    [[result.get should] equal:resultObject];
                    [[theValue(blockWasCalled) should] beTrue];
                });
            });
            
            context(@"handler wasn't added", ^{
                it(@"shouldn't call handler block and return failed result", ^{
                    __block BOOL blockWasCalled = NO;
                    id result = [sut handle:[MessageDispatcherTestHandler new]];
                    [result wait];
                    [[result should] beRejected];
                    [[theValue(blockWasCalled) should] beFalse];
                });
            });
        });
        
    });
SPEC_END
