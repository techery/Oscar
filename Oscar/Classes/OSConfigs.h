//
//  OSConfigs.h
//  Pods
//
//  Created by Anastasiya Gorban on 8/20/15.
//
//

#import <Foundation/Foundation.h>


@protocol OSConfigs

- (id)objectForKey:(NSString *)key;

@end

@interface OSPlistConfigs : NSObject <OSConfigs>

- (instancetype)initWithFileName:(NSString *)fileName;

@end


