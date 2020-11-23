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

#import <Cephei/HBPreferences.h>
#import "NSTask.h"
#import "RocketBootstrap/rocketbootstrap.h"

@interface Dra1nServerController : NSObject
-(NSNumber *)freeMemory;
-(NSDictionary *)batteryData;
-(void)nuke;
-(void)respring;
/*
-(void)set:(NSString *)key object:(id)object;
-(bool)getBool:(NSString *)key;
-(id)getObject:(NSString *)key;
-(int)getInt:(NSString *)key;
 */
@end
