#import <Kiwi/Kiwi.h>
// Class under test
#import "OSCancellableActor.h"
#import "OSActorSystemMock.h"

// Integration test on promise control
SPEC_BEGIN(OSActorFutureCancellationTest)



describe(@"Cancellation", ^() {

    OSCancellableActor __block *sut = nil;
    OSActorRef __block *actorRef = nil;
    
    beforeEach(^{
        sut = [[OSCancellableActor alloc] initWithActorSystem:actorSystemMock()];
        actorRef = [[OSActorRef alloc] initWithActor:sut caller:self];
    });
    
    it(@"should pass cancellation from client to service", ^() {
        RXPromise *promise = [actorRef ask:[NSObject new]];
        [[sut shouldEventually] receive:@selector(didCancel)];
        [[sut shouldNotEventually] receive:@selector(didSucceed:)];
        [[sut shouldNotEventually] receive:@selector(didFail:)];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [promise cancel];
        });
    });
    
    it(@"should pass cancellation through helper method", ^() {
        RXPromise * __unused promise = [actorRef ask:[NSObject new]];
        [[sut shouldEventually] receive:@selector(didCancel)];
        [[sut shouldNotEventually] receive:@selector(didSucceed:)];
        [[sut shouldNotEventually] receive:@selector(didFail:)];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [sut cancelCurrentPromise];
        });
    });
    
    it(@"should pass success from client to service", ^() {
        RXPromise * __unused promise = [actorRef ask:[NSObject new]];
        [[sut shouldNotEventually] receive:@selector(didCancel)];
        [[sut shouldEventually] receive:@selector(didSucceed:)];
        [[sut shouldNotEventually] receive:@selector(didFail:)];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [sut finishCurrentPromiseWithResult:[NSObject new]];
        });
    });
    
    it(@"should pass error from client to service", ^() {
        RXPromise * __unused promise = [actorRef ask:[NSObject new]];
        [[sut shouldNotEventually] receive:@selector(didCancel)];
        [[sut shouldNotEventually] receive:@selector(didSucceed:)];
        [[sut shouldEventually] receive:@selector(didFail:)];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [sut finishCurrentPromiseWithError:[NSError new]];
        });
    });
});
SPEC_END
