//
//  findSensor.m
//  unityTag
//
//  Created by Kelley Sheffield on 11/1/13.
//  Copyright (c) 2013 Kelley Sheffield. All rights reserved.
//
//  Search for available sensor tags
//  Following along with the TI Sensor Tag application to communicate with the tag

#import "findSensor.h"
#import "sensorTag.h"



@interface findSensor () <CBPeripheralDelegate, CBCentralManagerDelegate>
-(void)startSearching;
@end


@implementation findSensor
@synthesize centralManager,foundDevices,sensorTags; //prepare for getters and setters


-(void)startSearching
{
    
   // self.periph = [[CBPeripheral alloc]init]; //set up to auto connect to my device
   // sensorTag *tag = [[sensorTag alloc]init];
    
   // tag.peripheral = self.periph;
  //  tag.central = self.centralManager;
  //  NSLog(self.periph);
   // tag.initialData = [self makeSensorTagConfiguration];
    // */
  
        
        NSLog(@"Init central");
    
    
    
    
  //  NSArray *services = @[ [CBUUID UUIDWithString:@"FFE1"]];
  //  [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

- (void)openConnection
{
    NSLog(@"openConnection");
  //  NSArray *services = @[ [CBUUID UUIDWithString:@"FFE1"]];
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *) central {
  if (central.state < CBCentralManagerStatePoweredOn) {
      NSLog(@"Not on!");
    }
    if(central.state == CBCentralManagerStateUnknown)
    {
        NSLog(@"Unknown");
    }
    if(central.state == CBCentralManagerStateUnauthorized)
    {
        NSLog(@"Not authorized");
    }
    
        NSLog(@"about to scan");
        [self openConnection];
    
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
   // NSLog([NSString stringWithFormat:@"%@",peripheral.name]);
    if (peripheral.name == NULL) { return; }
    if (peripheral.identifier == NULL) { return; }
  // isEqualToString:@"KelleyTag (TI BLE Sensor Tag)"
    CBUUID *tagID = [CBUUID UUIDWithString:@"180a"];
    if ([peripheral.identifier isEqual:tagID]) {
        NSLog(@"SensorTag Found!");
        self.found = TRUE;
        [self.centralManager stopScan];
        self.periph = peripheral;
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central
didFailToConnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error
{
    NSLog(@"failed  %@:", error);
    
}


-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
}

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
       // NSString *UUIDString = CFBridgingRelease(CFUUIDCreateString(NULL, CFBridgingRetain(service.UUID)));
        NSLog(@"discovered services");
      //  NSLog([NSString stringWithFormat:@"%@: %@", UUIDString, service.debugDescription]);
        [peripheral discoverCharacteristics:nil forService:service];
    }}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSString *UUIDString = CFBridgingRelease(CFUUIDCreateString(NULL, CFBridgingRetain(service.UUID)));
    
       NSLog([NSString stringWithFormat:@"%@: %@", UUIDString, service.debugDescription]);
    
    }

-(void) peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateNotificationStateForCharacteristic %@ error = %@",characteristic,error);
}

-(void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"Characteristic value : %@ with ID %@", characteristic.value, characteristic.UUID);
   
}


@end
