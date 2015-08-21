#import <Kiwi/Kiwi.h>
// Class under test
#import "OSMessageHandler.h"
#import "OSPromiseMatcher.h"

@interface OSMessageHandlerTestMessage : NSObject
@end

@implementation OSMessageHandlerTestMessage
@end

#pragma mark - OSVoidMessageHandler

SPEC_BEGIN(OSVoidMessageHandlerTest)
registerMatchers(@"OS");

describe(@"OSVoidMessageHandler", ^{
    __block OSVoidMessageHandler *sut;
    
    __block BOOL blockWasCalled = NO;
    void (^voidBlock)(id) = ^void(id message) {
        blockWasCalled = YES;
    };
    
    beforeEach(^{
        sut = [[OSVoidMessageHandler alloc] initWithHandler:voidBlock messageType:[OSMessageHandlerTestMessage class]];
    });
    
    it(@"should be correctly initialized", ^{
        [sut.messageType isSubclassOfClass:[OSMessageHandlerTestMessage class]];
    });
    
    context(@"on valid message type", ^{
        it(@"should call handler block and return fulfilled result", ^{
            RXPromise *result = [sut handle:[OSMessageHandlerTestMessage new]];
            [result wait];
            
            [[result should] beFulfilled];
            [[theValue(blockWasCalled) should] beTrue];
        });
    });
        
    context(@"on invalid message type", ^{
        it(@"shouldn't call handler block and return failed result", ^{
            __block BOOL blockWasCalled = NO;
            id result = [sut handle:[NSObject new]];
            [result wait];
            [[result should] beRejected];
            [[theValue(blockWasCalled) should] beFalse];
        });
    });
});
SPEC_END

#pragma mark - OSResultMessageHandler

SPEC_BEGIN(OSResultMessageHandlerTest)
registerMatchers(@"OS");

describe(@"OSResultMessageHandler", ^{
    __block OSResultMessageHandler *sut;
    
    __block BOOL blockWasCalled = NO;
    id resultObject = [NSObject new];
    id (^resultBlock)(id) = ^id(id message) {
        blockWasCalled = YES;
        return resultObject;
    };
    
    beforeEach(^{
        sut = [[OSResultMessageHandler alloc] initWithHandler:resultBlock messageType:[OSMessageHandlerTestMessage class]];
    });
    
    it(@"should be correctly initialized", ^{
        [sut.messageType isSubclassOfClass:[OSMessageHandlerTestMessage class]];
    });
    
    context(@"on valid message type", ^{
        it(@"should call handler block and return fulfilled result", ^{
            RXPromise *result = [sut handle:[OSMessageHandlerTestMessage new]];
            [result wait];
            
            [[result should] beFulfilled];
            [[result.get should] equal:resultObject];
            [[theValue(blockWasCalled) should] beTrue];
        });
    });
    
    context(@"on invalid message type", ^{
        it(@"shouldn't call handler block and return failed result", ^{
            __block BOOL blockWasCalled = NO;
            id result = [sut handle:[NSObject new]];
            [result wait];
            [[result should] beRejected];
            [[theValue(blockWasCalled) should] beFalse];
        });
    });
});
SPEC_END

#pragma mark - OSFutureMessageHandler

SPEC_BEGIN(OSFutureMessageHandlerTest)
registerMatchers(@"OS");

describe(@"OSFutureMessageHandler", ^{
    __block OSFutureMessageHandler *sut;
    
    __block BOOL blockWasCalled = NO;
    id resultObject = [NSObject new];
    RXPromise * (^promiseBlock)(id) = ^RXPromise *(id message) {
        blockWasCalled = YES;
        RXPromise *promise = [RXPromise new];
        [promise resolveWithResult:resultObject];
        return promise;
    };
    
    beforeEach(^{
        sut = [[OSFutureMessageHandler alloc] initWithHandler:promiseBlock messageType:[OSMessageHandlerTestMessage class]];
    });
    
    it(@"should be correctly initialized", ^{
        [sut.messageType isSubclassOfClass:[OSMessageHandlerTestMessage class]];
    });
    
    context(@"on valid message type", ^{
        it(@"should call handler block and return fulfilled result", ^{
            RXPromise *result = [sut handle:[OSMessageHandlerTestMessage new]];
            [result wait];
            
            [[result should] beFulfilled];
            [[result.get should] equal:resultObject];
            [[theValue(blockWasCalled) should] beTrue];
        });
    });
    
    context(@"on invalid message type", ^{
        it(@"shouldn't call handler block and return failed result", ^{
            __block BOOL blockWasCalled = NO;
            id result = [sut handle:[NSObject new]];
            [result wait];
            [[result should] beRejected];
            [[theValue(blockWasCalled) should] beFalse];
        });
    });
});
SPEC_END

