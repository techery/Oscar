#import <Kiwi/Kiwi.h>
// Class under test
#import "DTMessageHandler.h"
#import "DTPromiseMatcher.h"

@interface DTMessageHandlerTestMessage : NSObject
@end

@implementation DTMessageHandlerTestMessage
@end

#pragma mark - DTVoidMessageHandler

SPEC_BEGIN(DTVoidMessageHandlerTest)
registerMatchers(@"DT");

describe(@"DTVoidMessageHandler", ^{
    __block DTVoidMessageHandler *sut;
    
    __block BOOL blockWasCalled = NO;
    void (^voidBlock)(id) = ^void(id message) {
        blockWasCalled = YES;
    };
    
    beforeEach(^{
        sut = [[DTVoidMessageHandler alloc] initWithHandler:voidBlock messageType:[DTMessageHandlerTestMessage class]];
    });
    
    it(@"should be correctly initialized", ^{
        [sut.messageType isSubclassOfClass:[DTMessageHandlerTestMessage class]];
    });
    
    context(@"on valid message type", ^{
        it(@"should call handler block and return fulfilled result", ^{
            RXPromise *result = [sut handle:[DTMessageHandlerTestMessage new]];
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

#pragma mark - DTResultMessageHandler

SPEC_BEGIN(DTResultMessageHandlerTest)
registerMatchers(@"DT");

describe(@"DTResultMessageHandler", ^{
    __block DTResultMessageHandler *sut;
    
    __block BOOL blockWasCalled = NO;
    id resultObject = [NSObject new];
    id (^resultBlock)(id) = ^id(id message) {
        blockWasCalled = YES;
        return resultObject;
    };
    
    beforeEach(^{
        sut = [[DTResultMessageHandler alloc] initWithHandler:resultBlock messageType:[DTMessageHandlerTestMessage class]];
    });
    
    it(@"should be correctly initialized", ^{
        [sut.messageType isSubclassOfClass:[DTMessageHandlerTestMessage class]];
    });
    
    context(@"on valid message type", ^{
        it(@"should call handler block and return fulfilled result", ^{
            RXPromise *result = [sut handle:[DTMessageHandlerTestMessage new]];
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

#pragma mark - DTFutureMessageHandler

SPEC_BEGIN(DTFutureMessageHandlerTest)
registerMatchers(@"DT");

describe(@"DTFutureMessageHandler", ^{
    __block DTFutureMessageHandler *sut;
    
    __block BOOL blockWasCalled = NO;
    id resultObject = [NSObject new];
    RXPromise * (^promiseBlock)(id) = ^RXPromise *(id message) {
        blockWasCalled = YES;
        RXPromise *promise = [RXPromise new];
        [promise resolveWithResult:resultObject];
        return promise;
    };
    
    beforeEach(^{
        sut = [[DTFutureMessageHandler alloc] initWithHandler:promiseBlock messageType:[DTMessageHandlerTestMessage class]];
    });
    
    it(@"should be correctly initialized", ^{
        [sut.messageType isSubclassOfClass:[DTMessageHandlerTestMessage class]];
    });
    
    context(@"on valid message type", ^{
        it(@"should call handler block and return fulfilled result", ^{
            RXPromise *result = [sut handle:[DTMessageHandlerTestMessage new]];
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

