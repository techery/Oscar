#import <Kiwi/Kiwi.h>
// Class under test
#import "OSInstanceActorProvider.h"

#import "OSActor.h"

SPEC_BEGIN(OSInstanceActorProviderTests)
describe(@"OSInstanceActorProvider", ^{
    OSActor *instance = [OSActor mock];
    OSInstanceActorProvider *sut = [OSInstanceActorProvider providerWithInstance:instance];
    
    it(@"Should be correctly initialized", ^{
        [[(NSObject *)sut.actorHandler shouldNot] beNil];
        [[(NSObject *)sut.actorType shouldNot] beNil];
    });    
    
    it(@"should correctly create handler", ^{
        id handler = [sut create:any()];
        [[handler shouldNot] beNil];
        [[handler should] equal:sut.actorHandler];
    });    
});
SPEC_END
