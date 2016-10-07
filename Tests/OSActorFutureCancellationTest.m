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
    
    it(@"should receive error with RXPromise domain", ^() {
        RXPromise *promise = [actorRef ask:[NSObject new]];
        KWCaptureSpy *spy = [sut captureArgument:@selector(didReceiveErrorFromErrorBlock:) atIndex:0];
        dispatch_semaphore_t dsema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [promise cancel];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_global_queue(0, 0), ^{
                dispatch_semaphore_signal(dsema);
            });
        });
        dispatch_semaphore_wait(dsema, DISPATCH_TIME_FOREVER);
        [[((NSError*)spy.argument).domain should] equal:@"RXPromise"];
    });

    it(@"should receive error with RXPromise domain and provided description", ^() {
        RXPromise *promise = [actorRef ask:[NSObject new]];
        KWCaptureSpy *spy = [sut captureArgument:@selector(didReceiveErrorFromErrorBlock:) atIndex:0];
        dispatch_semaphore_t dsema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [promise cancelWithReason:@"heyho"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_global_queue(0, 0), ^{
                dispatch_semaphore_signal(dsema);
            });
        });
        dispatch_semaphore_wait(dsema, DISPATCH_TIME_FOREVER);
        [[((NSError*)spy.argument).domain should] equal:@"RXPromise"];
        [[((NSError*)spy.argument).localizedFailureReason should] equal:@"heyho"];
    });
    
    it(@"should receive error provided to cancelWithReason:", ^() {
        RXPromise *promise = [actorRef ask:[NSObject new]];
        KWCaptureSpy *spy = [sut captureArgument:@selector(didReceiveErrorFromErrorBlock:) atIndex:0];
        NSError *error = [NSError new];
        dispatch_semaphore_t dsema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [promise cancelWithReason:error];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_global_queue(0, 0), ^{
                dispatch_semaphore_signal(dsema);
            });
        });
        dispatch_semaphore_wait(dsema, DISPATCH_TIME_FOREVER);
        [[spy.argument should] equal:error];
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
