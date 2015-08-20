#import <Kiwi/Kiwi.h>
// Class under test
#import "DTInstanceActorProvider.h"

#import "DTActor.h"

SPEC_BEGIN(DTInstanceActorProviderTests)
describe(@"DTInstanceActorProvider", ^{
    DTActor *instance = [DTActor mock];
    DTInstanceActorProvider *sut = [DTInstanceActorProvider providerWithInstance:instance];
    
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
