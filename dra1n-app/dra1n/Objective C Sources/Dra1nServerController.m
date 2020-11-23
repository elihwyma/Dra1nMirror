//
//  dra1nServerController.m
//  dra1n
//
//  Created by Amy While on 14/07/2020.
//

#import "Dra1nServerController.h"

@implementation Dra1nServerController

#ifdef jailed
NSUserDefaults *defaults;
#else
CPDistributedMessagingCenter *_center;
#endif

-(instancetype)init
{
    if ((self = [super init]))
    {
#ifdef jailed
        defaults = [NSUserDefaults standardUserDefaults];
#else
        _center = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.dra1n.dra1nServer"];
        rocketbootstrap_distributedmessagingcenter_apply(_center);
#endif
    }
    return self;
}


-(NSDictionary *)batteryData {
    
#ifdef jailed
    NSDictionary *arrayOfItems = @{ @"dischargeCurrent" : [NSNumber numberWithInt: 500], @"cycles" : [NSNumber numberWithInt: 500], @"designCapacity" : [NSNumber numberWithInt: 500], @"maxCapacity" : [NSNumber numberWithInt: 500], @"currentCapacity" : [NSNumber numberWithInt: 500], @"temperature" : [NSNumber numberWithInt: 500], @"voltage" : [NSNumber numberWithInt: 500]};
        return error;
#else
    return [_center sendMessageAndReceiveReplyName:@"getTheDra1n" userInfo:nil];
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

-(void)nuke {
    [_center sendMessageName:@"nuke" userInfo:nil];
}

-(void)respring {
    [_center sendMessageName:@"respring" userInfo:nil];
}
/*
-(void)set:(NSString *)key object:(id)object {
    NSDictionary *message = @{@"key" : key, @"object" : object};
    [_center sendMessageName:@"set" userInfo:message];
}

-(bool)getBool:(NSString *)key {
    NSDictionary *message = @{@"key" : key};
    NSDictionary *response = [_center sendMessageAndReceiveReplyName:@"getBool" userInfo:message];
    if (response[@"bool"] == [NSNumber numberWithInt:1]) { return true ;} else { return false; }
}

-(id)getObject:(NSString *)key {
    NSDictionary *message = @{@"key" : key};
    NSDictionary *response = [_center sendMessageAndReceiveReplyName:@"getObject" userInfo:message];
    return response[@"object"];
}


-(int)getInt:(NSString *)key {
    NSDictionary *message = @{@"key" : key};
    NSDictionary *response = [_center sendMessageAndReceiveReplyName:@"getInt" userInfo:message];
    return [response[@"int"] intValue];
}
*/
@end

