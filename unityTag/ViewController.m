//
//  ViewController.m
//  unityTag
//
//  Created by Kelley Sheffield on 11/1/13.
//  Copyright (c) 2013 Kelley Sheffield. All rights reserved.
//

#import "ViewController.h"
#import "findSensor.h"
#import "sensorTag.h"
#import <CoreBluetooth/CoreBluetooth.h>



@interface ViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>
@property findSensor *sens;
@property (nonatomic) BOOL found;
@end

@implementation ViewController
//@synthesize sensor;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.sens = [[findSensor alloc]init];
    self.sens.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    [self.sens startSearching];
    
}

- (void)startScanning
{
    NSLog(@"openConnection");
   
    [self.sens.centralManager scanForPeripheralsWithServices:nil options:nil];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *) central {
    if (central.state != CBCentralManagerStatePoweredOn) {
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
    [self startScanning];
    
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if (peripheral.name == NULL) {NSLog(@"No name found"); return; }
    if (peripheral.identifier == NULL) { NSLog(@"No identifier found"); return; }
    NSUUID *tagUUID = [[NSUUID alloc] initWithUUIDString:@"D03124B2-DC31-AA94-3276-B5422868E2F7"]; //UUID specific to my sensor tag
   
        NSLog(@"Identifier %@", peripheral.identifier);
    
    if([peripheral.identifier isEqual:tagUUID]  && !self.found) {
        
             NSLog(@"SensorTag Found!");
             self.found = TRUE;
             [self.sens.centralManager stopScan];
             self.sens.periph = peripheral;
             [self.sens.centralManager connectPeripheral:peripheral options:nil];
    }
    else{
        NSLog(@"Cannot find tag");
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
    for (CBService *service in peripheral.services)
    {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSString *UUIDString = CFBridgingRelease(CFUUIDCreateString(NULL, CFBridgingRetain(service.UUID)));
    
    NSLog([NSString stringWithFormat:@"%@: %@", UUIDString, service.debugDescription]);
    
}

-(void) peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateNotificationStateForCharacteristic %@ error = %@",characteristic,error);
}

-(void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic,error);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
