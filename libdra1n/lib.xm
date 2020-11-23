#import "header.h"

HBPreferences *def;
NSString* bundleIdentifier;

@interface CPNotification : NSObject
+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message userInfo:(NSDictionary*)userInfo badgeCount:(int)badgeCount soundName:(NSString*)soundName delay:(double)delay repeats:(BOOL)repeats bundleId:(nonnull NSString*)bundleId uuid:(NSString*)uuid silent:(BOOL)silent;
+ (void)hideAlertWithBundleId:(NSString *)bundleId uuid:(NSString*)uuid;
@end


@implementation Dra1nManager

+(void)load
{
	[self sharedInstance];
}

+(instancetype)sharedInstance
{
	static dispatch_once_t onceToken = 0;
	__strong static Dra1nManager* sharedInstance = nil;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

-(instancetype)init
{
	if ((self = [super init]))
	{
    [self checkDefaults];
	}
	return self;
}

-(void)checkDefaults {
  def = [[HBPreferences alloc] initWithIdentifier :@"com.megadev.dra1n"];
    if(![def objectForKey: @"increaseSinceLastCheck"]) { [def setBool: NO  forKey: @"increaseSinceLastCheck"]; }
    if(![def objectForKey: @"DailyReport"]) { [def setBool: YES  forKey: @"DailyReport"]; }

  //The arrays
  if(![def objectForKey: @"CulpritLog"]) { [def setObject: [[NSMutableArray alloc] init]  forKey: @"CulpritLog"]; }
  if(![def objectForKey: @"DrainAvarageLog"]) { [def setObject: [[NSMutableArray alloc] init]  forKey: @"DrainAvarageLog"]; }
  if(![def objectForKey: @"DrainLog"]) { [def setObject: [[NSMutableArray alloc] init] forKey: @"DrainLog"]; }
  if(![def objectForKey: @"arrayOfGoodness"]) { [def setObject: [[NSMutableArray alloc] init]  forKey: @"arrayOfGoodness"]; }

  //The ints
  if(![def objectForKey: @"AverageTime"]) { [def setInteger: 21600  forKey: @"AverageTime"]; }
  if(![def objectForKey: @"DrainSensitivity"]) { [def setInteger: 125  forKey: @"DrainSensitivity"]; }
  if(![def objectForKey: @"DailyReport"]) { [def setBool: YES forKey: @"DailyReport"]; }

  [def synchronize];
}


-(void)Dra1nRecord{

 def = [[HBPreferences alloc] initWithIdentifier :@"com.megadev.dra1n"];

	io_service_t powerSource = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMPowerSource"));



           	if (powerSource) {
           		CFMutableDictionaryRef batteryDictionaryRef = NULL;
           		kern_return_t retVal = IORegistryEntryCreateCFProperties(powerSource, &batteryDictionaryRef, 0, 0);
           
           		if (retVal == KERN_SUCCESS) {
           
           			int dischargeCurrent = 0;
           		
           		
           			CFNumberRef dischargeCurrentRef = (CFNumberRef)IORegistryEntryCreateCFProperty(powerSource, CFSTR("InstantAmperage"), kCFAllocatorDefault, 0);
           			CFNumberGetValue(dischargeCurrentRef, kCFNumberIntType, &dischargeCurrent);
           			CFRelease(dischargeCurrentRef);
                    
            
             	    NSDate *rightnow = [NSDate date];
             		
             
                    


                   if([[def objectForKey:@"DrainLog"] mutableCopy]){
                    
                    
                    [def synchronize];
                    NSMutableArray *dra1nArray = [[def objectForKey:@"DrainLog"] mutableCopy] ?: [[NSMutableArray alloc] init];
                    [dra1nArray addObject:[NSNumber numberWithInt: dischargeCurrent]];
                    [def setObject:dra1nArray forKey:@"DrainLog"];
                    [def synchronize];
                    
                    }else{
                    
                     NSMutableArray *dra1nArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt: dischargeCurrent], nil];
                    [def setObject:dra1nArray forKey:@"DrainLog"];
                    [def synchronize];
                    
                    } 


                 
                    NSDate *Dra1nLogStarted = [def objectForKey:@"Dra1nLogStarted"];

                     NSDate *DailyReportStarted = [def objectForKey:@"DailyReportStarted"];
                    
                    //  If this is the first time the app has been launched we record right now as the first time the app was launched.
                    if (!Dra1nLogStarted) {

                        [def setObject:[NSDate date] forKey:@"Dra1nLogStarted"];
                        
                    }
                    

                     if (!DailyReportStarted) {

                        [def setObject:[NSDate date] forKey:@"DailyReportStarted"];
                        
                    }




                    NSTimeInterval fourhours = [rightnow timeIntervalSinceDate:Dra1nLogStarted];

                    NSTimeInterval daily = [rightnow timeIntervalSinceDate:DailyReportStarted];

                      int timeComparrison =  [[def objectForKey:@"AverageTime"]intValue] ?: 14400;

                      BOOL isDaily = [def boolForKey:@"DailyReport"];
                      if(isDaily){

                        if(daily > 46800){
    
                         [def setObject:[NSDate date] forKey:@"DailyReportStarted"];

                         NSMutableArray *DailyDrainArray = [[def objectForKey:@"DrainAvarageLog"] mutableCopy] ?: [[NSMutableArray alloc] init];
                         int ArrayDailyCount = [DailyDrainArray count];
                         if(ArrayDailyCount > 0){
                         int DailySum = 0;
                         int i;
                         int compare;
                         int devide;

                         if(ArrayDailyCount < 8){
                         compare = ArrayDailyCount+1;
                         devide = ArrayDailyCount;
                         }else{
                         compare = 8;
                         devide = 8;
                         }
                         int DailyDrainAvr = 0;
                         NSDictionary *DailyDict;
                         for(i=1;i<compare;i++)
                         {
                           
                           int dailyarraycount = [DailyDrainArray count] - i;
  


                          DailyDict = [DailyDrainArray objectAtIndex:dailyarraycount];

                           
                           DailySum += [[DailyDict objectForKey:@"drain"] intValue];


                           DailyDrainAvr = DailySum / devide;
                         
                            
                         }



                  
                                           
                     
                     


                         

                      	void *handle = dlopen("/usr/lib/libnotifications.dylib", RTLD_LAZY);
                       	if (handle != NULL) {                                            
                           
 	                      NSString *uid = [[NSUUID UUID] UUIDString];        
  	                      [objc_getClass("CPNotification") showAlertWithTitle:@"Daily Report"
  	                                              message:[NSString stringWithFormat:@"Your daily average is %i mA",DailyDrainAvr]
	                                               userInfo:@{@"" : @""}
	                                             badgeCount:0
	                                              soundName:nil //research UNNotificationSound
	                                                  delay:1.00 //cannot be zero & cannot be < 60 if repeats is YES
	                                                repeats:NO
	                                               bundleId:@"com.megadev.dra1n"
	                                                   uuid:uid //specify if you need to use hideAlertWithBundleId and store the string for later use
	                                                 silent:NO];
					       				       
	                          dlclose(handle);
	                              
                                
                                }

                         }



                        }
   
}

                         if ( fourhours > timeComparrison ){
                         

                          [def removeObjectForKey:@"Dra1nLogStarted"];



                     if([[def objectForKey:@"DrainLog"] mutableCopy]){
                    
                    
                
                    NSMutableArray *dra1nArray = [[def objectForKey:@"DrainLog"] mutableCopy] ?: [[NSMutableArray alloc] init];
      
                    [def removeObjectForKey:@"DrainLog"];

                    [def synchronize];


                                         
                     int arrayLength = [dra1nArray count];
                     
                     
                     int sum = 0;
                     for (NSNumber * n in dra1nArray) {
                       sum += [n intValue];
                     }



                     int DrainAvarage = sum / arrayLength;
                      

                    NSMutableArray *lastdra1nArray = [[def objectForKey:@"DrainAvarageLog"] mutableCopy] ?: [[NSMutableArray alloc] init];

                    NSDictionary *lastDra1nAvarage = [lastdra1nArray lastObject];
                    
                    NSNumber *lastestDra1nNumber = lastDra1nAvarage[@"drain"];
                    int lastDra1nAvarageint = [lastestDra1nNumber intValue];

                    int increaseSinceLast = 100 * (DrainAvarage - (lastDra1nAvarageint)) / lastDra1nAvarageint;

              
            int sensitivity =  [[def objectForKey:@"DrainSensitivity"]intValue] ?: 75;

            int POSlastestDra1nNumber = (0 - DrainAvarage);

            int POSTAvarageInt = (0 - lastDra1nAvarageint);





            if(increaseSinceLast<sensitivity){
              
              [def setBool:NO forKey:@"increaseSinceLastCheck"];
            }
           if(increaseSinceLast>sensitivity && POSlastestDra1nNumber > 65 && POSTAvarageInt > 50){
                if([[def objectForKey:@"UpdatedNewTweaks"] mutableCopy]){

       				[def setBool:YES forKey:@"increaseSinceLastCheck"];
                    NSMutableArray *culprittweaks = [def objectForKey:@"UpdatedNewTweaks"];
                    if(culprittweaks){
                    for (NSDictionary * tweak in culprittweaks) {
                           NSDate *currentitme = [NSDate date];
                           NSDictionary *culdict = @{ @"time": currentitme, @"culrpit" : tweak[@"tweak"] };
                                              if([[def objectForKey:@"CulpritLog"] mutableCopy]){
                    
                    
                    [def synchronize];
                    NSMutableArray *culpritArray = [[def objectForKey:@"CulpritLog"] mutableCopy] ?: [[NSMutableArray alloc] init];
                    [culpritArray addObject:culdict];
                    [def setObject:culpritArray forKey:@"CulpritLog"];
                    [def synchronize];


                    
                    }else{
                    
                     NSMutableArray *culpritArray = [NSMutableArray arrayWithObjects:culdict, nil];
                    [def setObject:culpritArray forKey:@"CulpritLog"];
                    [def synchronize];
                  
                    } 
                     }
                    }else{


                           NSDate *currentitme = [NSDate date];
                           NSDictionary *culdict = @{ @"time": currentitme, @"culrpit" : @"Unkown Cause" };
                           NSMutableArray *culpritArray = [NSMutableArray arrayWithObjects:culdict, nil];
                           [culpritArray addObject:culdict];
                           [def setObject:culpritArray forKey:@"CulpritLog"];
                          [def synchronize];
                    }



               


   }else{
                             [def setBool:YES forKey:@"increaseSinceLastCheck"];

                   NSDate *currentitme = [NSDate date];
                   
       

                   NSDictionary *culdict = @{ @"time": currentitme, @"culrpit" : @"Unknown Cause" };

                   if([[def objectForKey:@"CulpritLog"] mutableCopy]){
                    
                    
                    [def synchronize];
                    NSMutableArray *culpritArray = [[def objectForKey:@"CulpritLog"] mutableCopy] ?: [[NSMutableArray alloc] init];
                    [culpritArray addObject:culdict];
                    [def setObject:culpritArray forKey:@"CulpritLog"];
                    [def synchronize];


                    
                    }else{
                    
                     NSMutableArray *culpritArray = [NSMutableArray arrayWithObjects:culdict, nil];
                    [def setObject:culpritArray forKey:@"CulpritLog"];
                    [def synchronize];
                  
                    } 
   }

                      	void *handle = dlopen("/usr/lib/libnotifications.dylib", RTLD_LAZY);
                       	if (handle != NULL) {                                            
                           
 	                      NSString *uid = [[NSUUID UUID] UUIDString];        
  	                      [objc_getClass("CPNotification") showAlertWithTitle:@"Report"
  	                                              message:[NSString stringWithFormat:@"%@%d%@%d%@",@"Your current average is ",DrainAvarage,@"mA and is increased by ",increaseSinceLast,@"%"]
	                                               userInfo:@{@"" : @""}
	                                             badgeCount:0
	                                              soundName:nil //research UNNotificationSound
	                                                  delay:1.00 //cannot be zero & cannot be < 60 if repeats is YES
	                                                repeats:NO
	                                               bundleId:@"com.megadev.dra1n"
	                                                   uuid:uid //specify if you need to use hideAlertWithBundleId and store the string for later use
	                                                 silent:NO];
					       				       
	                          dlclose(handle);
	                              
                                
                                }

           }

               
                   NSDictionary *dict = @{ @"time": rightnow, @"drain" : [NSNumber numberWithInt: DrainAvarage]};

                   if([[def objectForKey:@"DrainAvarageLog"] mutableCopy]){
                    
                    
                    [def synchronize];
                    NSMutableArray *dra1nArray = [[def objectForKey:@"DrainAvarageLog"] mutableCopy] ?: [[NSMutableArray alloc] init];
                    [dra1nArray addObject:dict];
                    [def setObject:dra1nArray forKey:@"DrainAvarageLog"];
                    [def synchronize];


                    
                    }else{
                    
                     NSMutableArray *dra1nArray = [NSMutableArray arrayWithObjects:dict, nil];
                    [def setObject:dra1nArray forKey:@"DrainAvarageLog"];
                    [def synchronize];
                  
                    } 
                    
                    }
                     






                          }





            
           
           
           
           		
           		} 
           	} 



}

@end


%hook SBUIController
- (void)updateBatteryState:(id)arg1 {
%orig;

       
       if([(SpringBoard *)[%c(SpringBoard) sharedApplication] _accessibilityFrontMostApplication] == nil || [[%c(SBLockScreenManager) sharedInstance] isUILocked]){
  
       
      


   if (![[%c(SBUIController) sharedInstance] isOnAC]) {


            


               [[%c(Dra1nManager) sharedInstance] Dra1nRecord];
        
   }

 }


}
%end




%hook SpringBoard 

-(void)applicationDidFinishLaunching:(id)arg1 {
	%orig;



@try{
 def = [[HBPreferences alloc] initWithIdentifier :@"com.megadev.dra1n"];

NSMutableArray *oldNewTweakList = [[def objectForKey:@"NewTweaks"] mutableCopy];
NSMutableArray *newNewTweakList = [[def objectForKey:@"UpdatedNewTweaks"] mutableCopy];

NSLog(@"[Dra1n] this is running uuw, %@, %@", oldNewTweakList, newNewTweakList);

for (int i = 0; i<[oldNewTweakList count]; i++) {
  NSDictionary *uwu = @{@"tweak": [oldNewTweakList objectAtIndex:i]};
  [newNewTweakList addObject: uwu];
}

[def removeObjectForKey:@"NewTweaks"];
[def setObject:newNewTweakList forKey:@"UpdatedNewTweaks"];

NSTask * list = [[NSTask alloc] init];
[list setLaunchPath:@"/usr/bin/dpkg"];
NSArray *args = [NSArray arrayWithObjects:@"--get-selections",nil];
[list setArguments:args];



NSPipe * out = [NSPipe pipe];
[list setStandardOutput:out];

[list launch];
 
[list waitUntilExit];


NSFileHandle * read = [out fileHandleForReading];
NSData * dataRead = [read readDataToEndOfFile];
NSString * stringRead = [[NSString alloc] initWithData:dataRead encoding:NSUTF8StringEncoding];


NSString *stringRead2 = [stringRead stringByReplacingOccurrencesOfString:@"install" withString:@""];
NSString *tweaklist2 = [stringRead2 stringByReplacingOccurrencesOfString:@" " withString:@""];
NSString *tweaklist = [tweaklist2 stringByReplacingOccurrencesOfString:@"\t" withString:@""];


NSMutableArray * tweaklistArray = [[NSMutableArray alloc] initWithArray:[tweaklist componentsSeparatedByString:@"\n"] copyItems: YES];

NSMutableArray *TweakListOld = [def objectForKey:@"TweakList"];
NSMutableArray *TweakListModified = [[NSMutableArray alloc] init];

  for(int i =0; i<[tweaklistArray count]; i++)
{
        if (![[tweaklistArray objectAtIndex:i] containsString:@"gsc."]) {
        [TweakListModified addObject:[tweaklistArray objectAtIndex:i]];
        
        }

        if(i == [tweaklistArray count]-1){
      


if (!TweakListOld) {

       [def setObject:TweakListModified forKey:@"TweakList"];
        [def synchronize];


}else{
NSMutableArray *NewTweaks = [[NSMutableArray alloc] init];
if([TweakListModified count] > [TweakListOld count]){
  
[def removeObjectForKey:@"TweakList"];
[def removeObjectForKey:@"UpdatedNewTweaks"];
[def setObject:TweakListModified forKey:@"TweakList"];
[def synchronize];





for(int i =0; i<[TweakListModified count]; i++)
{
    if (![TweakListOld containsObject:[TweakListModified objectAtIndex:i]]){
		NSDictionary *uwu = @{@"tweak": [TweakListModified objectAtIndex:i]};
        [NewTweaks addObject: uwu];
    }
       

      
}    

  [def setObject:NewTweaks forKey:@"UpdatedNewTweaks"];
  
  [def synchronize];
}else{
  [def removeObjectForKey:@"TweakList"];

[def setObject:TweakListModified forKey:@"TweakList"];
[def synchronize];
}

if([tweaklistArray count] < [TweakListOld count]){

[def setBool:NO forKey:@"increaseSinceLastCheck"];
 [def removeObjectForKey:@"UpdatedNewTweaks"];
  [def synchronize];
      




}


}
        }
} 


}
    @catch (NSException *e) {
      NSLog(@"[Dra1n] exception %@", e);
    }



}


%end


@implementation dra1nServer

+(void)load
{
	[self sharedInstance];
}

+(instancetype)sharedInstance
{
	static dispatch_once_t onceToken = 0;
	__strong static dra1nServer* sharedInstance = nil;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

-(instancetype)init
{
	if ((self = [super init]))
	{
		_center = [CPDistributedMessagingCenter centerNamed:@"com.dra1n.dra1nServer"];
		rocketbootstrap_distributedmessagingcenter_apply(_center);
		[_center runServerOnCurrentThread];

		[_center registerForMessageName:@"getTheDra1n" target:self selector:@selector(getTheDra1n)];
    [_center registerForMessageName:@"nuke" target:self selector:@selector(nuke)];
    [_center registerForMessageName:@"respring" target:self selector:@selector(respring)];
    /*
    [_center registerForMessageName:@"set" target:self selector:@selector(set)];
    [_center registerForMessageName:@"getInt" target:self selector:@selector(getInt)];
    [_center registerForMessageName:@"getBool" target:self selector:@selector(getBool)];
    [_center registerForMessageName:@"getObject" target:self selector:@selector(getObject)];
		*/
		def = [[HBPreferences alloc] initWithIdentifier:@"com.megadev.dra1n"];
	}
	return self;
}

-(NSDictionary *)getTheDra1n {
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
}

-(void)respring {
  NSTask *task = [[NSTask alloc] init];
  [task setLaunchPath:@"/usr/bin/killall"];
  [task setArguments:@[ @"backboardd"]];
  [task launch];
}

-(void)nuke {
  [def removeAllObjects];
}

/*
-(void)set:(NSString *)ignore userInfo:(NSDictionary *)userInfo {
  [def setObject:userInfo[@"object"] forKey:userInfo[@"key"]];
}

-(NSDictionary *)getBool:(NSString *)ignore userInfo:(NSDictionary *)userInfo {
  return @{@"bool" : [NSNumber numberWithBool: [def boolForKey: userInfo[@"key"]]]};
}

-(NSDictionary *)getObject:(NSString *)ignore userInfo:(NSDictionary *)userInfo {
  return @{@"object" : [def objectForKey: userInfo[@"key"]]};
}

-(NSDictionary *)getInt:(NSString *)ignore userInfo:(NSDictionary *)userInfo {
  return @{@"int" : [NSNumber numberWithInt: [def integerForKey: userInfo[@"key"]]]};
}
*/
@end