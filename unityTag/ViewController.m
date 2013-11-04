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
   // findSensor *sens = [[findSensor alloc]init];
    
    //sens.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

    
   // NSLog(@"Started searching");
  //  [sens startSearching];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.sens = [[findSensor alloc]init];
    self.sens.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    //paste your viewDidLoad codes
    [self.sens startSearching];
    // [self.sensor startSearching];
    NSLog(@"Back home");
}

- (void)openConnection
{
    NSLog(@"openConnection");
    //  NSArray *services = @[ [CBUUID UUIDWithString:@"FFE1"]];
    [self.sens.centralManager scanForPeripheralsWithServices:nil options:nil];
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
    
    if ([peripheral.name isEqualToString:@"KelleyTag (TI BLE Sensor Tag)"] && !self.found) {
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
    for (CBService *service in peripheral.services) {
        // NSString *UUIDString = CFBridgingRelease(CFUUIDCreateString(NULL, CFBridgingRetain(service.UUID)));
        
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
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic,error);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
