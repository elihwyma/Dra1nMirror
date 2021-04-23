//
//  dra1nServerController.h
//  dra1n
//
//  Created by Amy While on 14/07/2020.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

#import <objc/runtime.h>
#import <mach/mach.h>
#import <mach/mach_host.h>

@interface Dra1nServerController : NSObject
-(NSNumber *)freeMemory;
-(NSDictionary *)batteryData;
@end
