//
//  dra1nServerController.m
//  dra1n
//
//  Created by Amy While on 14/07/2020.
//

#import "Dra1nServerController.h"
#ifdef jailed
#elif TARGET_OS_SIMULATOR
#else
#import <IOKit/IOKitLib.h>
#endif

@implementation Dra1nServerController
-(NSDictionary *)batteryData {
    
#ifdef jailed
    NSDictionary *arrayOfItems = @{ @"dischargeCurrent" : [NSNumber numberWithInt: 500], @"cycles" : [NSNumber numberWithInt: 500], @"designCapacity" : [NSNumber numberWithInt: 500], @"maxCapacity" : [NSNumber numberWithInt: 500], @"currentCapacity" : [NSNumber numberWithInt: 500], @"temperature" : [NSNumber numberWithInt: 500], @"voltage" : [NSNumber numberWithInt: 500]};
        return arrayOfItems;
#elif TARGET_OS_SIMULATOR
    NSDictionary *arrayOfItems = @{ @"dischargeCurrent" : [NSNumber numberWithInt: 500], @"cycles" : [NSNumber numberWithInt: 500], @"designCapacity" : [NSNumber numberWithInt: 500], @"maxCapacity" : [NSNumber numberWithInt: 500], @"currentCapacity" : [NSNumber numberWithInt: 500], @"temperature" : [NSNumber numberWithInt: 500], @"voltage" : [NSNumber numberWithInt: 500]};
        return arrayOfItems;
#else
    io_service_t powerSource = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMPowerSource"));
    if (powerSource) {
        CFMutableDictionaryRef batteryDictionaryRef = NULL;
        kern_return_t retVal = IORegistryEntryCreateCFProperties(powerSource, &batteryDictionaryRef, 0, 0);

        if (retVal == KERN_SUCCESS) {

            int dischargeCurrent = 0;
            int cycles = 0;
            int designCapacity = 0;
            int MaxCapacity = 0;
            int CurrentCapacity = 0;
            int temperature = 0;
            int voltage = 0;
        
            CFNumberRef dischargeCurrentRef = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("InstantAmperage"), kCFAllocatorDefault, 0);
            CFNumberGetValue(dischargeCurrentRef, kCFNumberIntType, &dischargeCurrent);
            CFRelease(dischargeCurrentRef);

            CFNumberRef cycleCurrentRef = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("CycleCount"), kCFAllocatorDefault, 0);
            CFNumberGetValue(cycleCurrentRef, kCFNumberIntType, &cycles);
            CFRelease(cycleCurrentRef);

            CFNumberRef MaxCapacityRef = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("AppleRawMaxCapacity"), kCFAllocatorDefault, 0);
            CFNumberGetValue(MaxCapacityRef, kCFNumberIntType, &MaxCapacity);
            CFRelease(MaxCapacityRef);
    
            CFNumberRef CurrentCapacityRef = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("AppleRawCurrentCapacity"), kCFAllocatorDefault, 0);
            CFNumberGetValue(CurrentCapacityRef, kCFNumberIntType, &CurrentCapacity);
            CFRelease(CurrentCapacityRef);

            CFNumberRef designCapacityNum = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("DesignCapacity"), kCFAllocatorDefault, 0);
            CFNumberGetValue(designCapacityNum, kCFNumberIntType, &designCapacity);
            CFRelease(designCapacityNum);

            CFNumberRef temperatureNum = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("Temperature"), kCFAllocatorDefault, 0);
            CFNumberGetValue(temperatureNum, kCFNumberIntType, &temperature);
            CFRelease(temperatureNum);

            CFNumberRef voltageNum = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("Voltage"), kCFAllocatorDefault, 0);
            CFNumberGetValue(voltageNum, kCFNumberIntType, &voltage);
            CFRelease(voltageNum);
    
            NSDictionary *arrayOfItems = @{ @"dischargeCurrent" : [NSNumber numberWithInt: dischargeCurrent], @"cycles" : [NSNumber numberWithInt: cycles], @"designCapacity" : [NSNumber numberWithInt: designCapacity], @"maxCapacity" : [NSNumber numberWithInt: MaxCapacity], @"currentCapacity" : [NSNumber numberWithInt: CurrentCapacity], @"temperature" : [NSNumber numberWithInt: temperature], @"voltage" : [NSNumber numberWithInt: voltage]};
            return arrayOfItems;
        }
    }
    return nil;
#endif
}


-(NSNumber *)freeMemory {
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS){
        return 0;
    } else {
        host_page_size(host_port, &pagesize);
        
        float bytes = (vm_stat.free_count * pagesize);
        float mbytes = bytes/1048576.f;
        return ([NSNumber numberWithInteger:mbytes]);
    }
}
@end

