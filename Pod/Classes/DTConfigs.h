//
//  DTConfigs.h
//  Pods
//
//  Created by Anastasiya Gorban on 8/20/15.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DTConfigs

- (nullable id)objectForKey:(NSString *)key;

@end

@interface DTPlistConfigs : NSObject <DTConfigs>

- (instancetype)initWithFileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END

