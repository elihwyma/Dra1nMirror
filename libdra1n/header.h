#import "NSTask.h"
#import <objc/runtime.h>
#include <dlfcn.h>

#import <mach/mach.h>
#import <mach/mach_host.h>

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <IOKit/IOKitLib.h>
#import <Cephei/HBPreferences.h>
#import "rocketbootstrap.h"

@interface Dra1nManager : NSObject
@end

@interface SBUIController
+ (id)sharedInstanceIfExists;
+ (id)sharedInstance;
- (BOOL)isBatteryCharging;
- (BOOL)isOnAC;
- (float)batteryCapacity;

@end


@interface SpringBoard
-(id)_accessibilityFrontMostApplication;
@end

@interface SBLockScreenManager

@property (readonly) BOOL isUILocked;  
+(id)sharedInstance;
-(BOOL)isUILocked;

@end

@interface dra1nServer : NSObject {
	CPDistributedMessagingCenter * _center;	
	HBPreferences *def;
}
@end