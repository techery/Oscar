#import <Kiwi/Kiwi.h>
// Class under test
#import "DTServiceLocator.h"

@protocol DTServiceLocatorTestProtocol
@end

SPEC_BEGIN(DTServiceLocatorTests)
describe(@"DTServiceLocator", ^{
    __block id classService;
    __block id<DTServiceLocatorTestProtocol> protocolService;
    __block DTServiceLocator *sut;

    beforeAll(^{
        classService = any();
        protocolService = any();
        sut = [[DTServiceLocator alloc] initWithBuilderBlock:^(DTServiceLocator *locator) {
            [locator registerService:classService];
            [locator registerService:protocolService forProtocol:@protocol(DTServiceLocatorTestProtocol)];
        }];
    });
    
    describe(@"ask service for class", ^{
        context(@"class is registered", ^{
            it(@"should return service", ^{
                id service = [sut serviceForClass:[classService class]];
                [[service shouldNot] beNil];
                [[service should] beKindOfClass:[classService class]];
            });
        });
        
        context(@"class isn't registered", ^{
            it(@"should return nil", ^{
                id service = [sut serviceForClass:[NSObject class]];
                [[service should] beNil];
            });
        });
    });
    
    describe(@"ask service for protocol", ^{
        context(@"instance for protocol is regirstered", ^{
            it(@"should return service for protocol", ^{
                id service = [sut serviceForProtocol:@protocol(DTServiceLocatorTestProtocol)];
                [[service shouldNot] beNil];
            });
        });
        
        context(@"instance for protocol isn't registered", ^{
            it(@"should return nil", ^{
                id service = [sut serviceForProtocol:@protocol(NSObject)];
                [[service should] beNil];
            });
        });
    });
});
SPEC_END
