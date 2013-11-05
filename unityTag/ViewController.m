//
//  ViewController.m
//  unityTag
//
//  Created by Kelley Sheffield on 11/1/13.
//  Copyright (c) 2013 Kelley Sheffield. All rights reserved.
//

#import "ViewController.h"
//#import "findSensor.h"
//#import "sensorTag.h"
#import <CoreBluetooth/CoreBluetooth.h>
//#import "BLEUtility.h"
#import "GyroData.h"


@interface ViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (nonatomic) BOOL found;
@end

@implementation ViewController

@synthesize d;

@synthesize sensorsEnabled;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.d = [[sensorTag alloc]init];
    self.d.setupData = [[NSMutableDictionary alloc]init];

}

-(bool)sensorEnabled:(NSString *)Sensor {
    NSString *val = [self.d.setupData valueForKey:Sensor];
    
    if (val) {
        if ([val isEqualToString:@"1"]) return TRUE;
    
    }
    return FALSE;
}

-(int)sensorPeriod:(NSString *)Sensor {
    NSString *val = [self.d.setupData valueForKey:Sensor];
    return [val integerValue];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.sensorsEnabled = [[NSMutableArray alloc] init];

    self.d.central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    self.currentVal = [[sensorTagValues alloc]init];
    
    self.vals = [[NSMutableArray alloc]init];
    self.d.setupData = [self makeSensorTagConfiguration];
    self.logInterval = 1.0; //1000 ms
    
    self.logTimer = [NSTimer scheduledTimerWithTimeInterval:self.logInterval target:self selector:@selector(logValues:) userInfo:nil repeats:YES];
    
    self.gData = [[GyroscopeData alloc] init];
    
}

- (void)startScanning
{
    NSLog(@"openConnection");
   
    [self.d.central scanForPeripheralsWithServices:nil options:nil];
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
    if (central.state == CBCentralManagerStatePoweredOn) {
        NSLog(@"about to scan");
        [self startScanning];
    }
    
   
    
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if (peripheral.name == NULL) {NSLog(@"No name found"); return; }
    if (peripheral.identifier == NULL) { NSLog(@"No identifier found"); return; }
    NSUUID *tagUUID = [[NSUUID alloc] initWithUUIDString:@"D03124B2-DC31-AA94-3276-B5422868E2F7"]; //UUID specific to my sensor tag
   
      //  NSLog(@"Identifier %@", peripheral.identifier);
    
    if([peripheral.identifier isEqual:tagUUID]  && !self.found) {
        
             NSLog(@"SensorTag Found!");
             self.found = TRUE;
             [self.d.central stopScan];
             self.d.p = peripheral;
            // self.connectingPeripheral = peripheral;
             [self.d.central connectPeripheral:peripheral options:Nil];
        
        
           //  [self configureSensorTag];
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
    
    NSLog(@"Peripheral services = %@", peripheral.services);
    
    for (CBService *service in peripheral.services)
    {
        [peripheral discoverCharacteristics:nil forService:service];
      //  [self configureSensorTag];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
   // NSLog([NSString stringWithFormat:@"Service Characs:%@ UUID: %@ debug info:%@", service.characteristics, service.UUID, service.debugDescription]);
    
    [self configureSensorTag];
    
    
    
}

-(void) peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateNotificationStateForCharacteristic %@ error = %@",characteristic,error);
}

-(void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic,error);
}


-(void) configureSensorTag {
   if ([self sensorEnabled:@"Accelerometer active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer service UUID"]];
       // NSUUID *sUUID= [[NSUUID alloc] initWithUUIDString:[self.d.setupData valueForKey:@"Accelerometer service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer config UUID"]];
       
        CBUUID *pUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer period UUID"]];
        NSInteger period = [[self.d.setupData valueForKey:@"Accelerometer period"] integerValue];
        uint8_t periodData = (uint8_t)(period / 10);
       
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:pUUID data:[NSData dataWithBytes:&periodData length:1]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
       
        [self.sensorsEnabled addObject:@"Accelerometer"];
    }
    
    if ([self sensorEnabled:@"Gyroscope active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope config UUID"]];
        uint8_t data = 0x07;
        [BLEUtility writeCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.d.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        [self.sensorsEnabled addObject:@"Gyroscope"];
    }
}



-(void) logValues:(NSTimer *)timer {
    NSString *date = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                    dateStyle:NSDateFormatterShortStyle
                                                    timeStyle:NSDateFormatterMediumStyle];
    self.currentVal.timeStamp = date;
    sensorTagValues *newVal = [[sensorTagValues alloc]init];
    
    newVal.accX = self.currentVal.accX;
    newVal.accY = self.currentVal.accY;
    newVal.accZ = self.currentVal.accZ;
    
    newVal.gyroX = self.currentVal.gyroX;
    newVal.gyroY = self.currentVal.gyroY;
    newVal.gyroZ = self.currentVal.gyroZ;
    
    newVal.timeStamp = date;
    
    [self.vals addObject:newVal];
    
}


-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{

    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Accelerometer data UUID"]]])
    {
        float x = [AccelData calcXValue:characteristic.value];
        float y = [AccelData calcYValue:characteristic.value];
        float z = [AccelData calcZValue:characteristic.value];
    
     //   NSLog(@"X: % 0.1fG",x);
     //   NSLog(@"Y: % 0.1fG",y);
     //   NSLog([NSString stringWithFormat:@"Z: % 0.1fG",z]);
    
        
        self.currentVal.accX = x;
        self.currentVal.accY = y;
        self.currentVal.accZ = z;
    
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.d.setupData valueForKey:@"Gyroscope data UUID"]]]) {
        
        
        
        
        float x = [self.gData calcXValue:characteristic.value];
        float y = [self.gData calcYValue:characteristic.value];
        float z = [self.gData calcZValue:characteristic.value];
        
        NSLog(@"X: % 0.1fG", x);
        NSLog(@"Y: % 0.1fG", y);
        NSLog(@"Z: % 0.1fG", z);
        
        //self.gyro.accValueX.text = [NSString stringWithFormat:@"X: % 0.1f°/S",x];
        //self.gyro.accValueY.text = [NSString stringWithFormat:@"Y: % 0.1f°/S",y];
        //self.gyro.accValueZ.text = [NSString stringWithFormat:@"Z: % 0.1f°/S",z];
    
        //self.gyro.accValueX.textColor = [UIColor blackColor];
        //self.gyro.accValueY.textColor = [UIColor blackColor];
        //self.gyro.accValueZ.textColor = [UIColor blackColor];
        
        
        self.currentVal.gyroX = x;
        
        self.currentVal.gyroY = y;
        self.currentVal.gyroZ = z;
        
    }
}



-(NSMutableDictionary *) makeSensorTagConfiguration {
    NSMutableDictionary *servList = [[NSMutableDictionary alloc] init];
    
    // First we set ambient temperature
    [servList setValue:@"1" forKey:@"Ambient temperature active"];
    // Then we set IR temperature
    [servList setValue:@"1" forKey:@"IR temperature active"];
    // Append the UUID to make it easy for app
    [servList setValue:@"F000AA00-0451-4000-B000-000000000000"  forKey:@"IR temperature service UUID"];
    [servList setValue:@"F000AA01-0451-4000-B000-000000000000" forKey:@"IR temperature data UUID"];
    [servList setValue:@"F000AA02-0451-4000-B000-000000000000"  forKey:@"IR temperature config UUID"];
    // Then we setup the accelerometer
    [servList setValue:@"1" forKey:@"Accelerometer active"];
    [servList setValue:@"500" forKey:@"Accelerometer period"];
    [servList setValue:@"F000AA10-0451-4000-B000-000000000000"  forKey:@"Accelerometer service UUID"];
    [servList setValue:@"F000AA11-0451-4000-B000-000000000000"  forKey:@"Accelerometer data UUID"];
    [servList setValue:@"F000AA12-0451-4000-B000-000000000000"  forKey:@"Accelerometer config UUID"];
    [servList setValue:@"F000AA13-0451-4000-B000-000000000000"  forKey:@"Accelerometer period UUID"];
    
    //Then we setup the rH sensor
    [servList setValue:@"1" forKey:@"Humidity active"];
    [servList setValue:@"F000AA20-0451-4000-B000-000000000000"   forKey:@"Humidity service UUID"];
    [servList setValue:@"F000AA21-0451-4000-B000-000000000000" forKey:@"Humidity data UUID"];
    [servList setValue:@"F000AA22-0451-4000-B000-000000000000" forKey:@"Humidity config UUID"];
    
    //Then we setup the magnetometer
    [servList setValue:@"1" forKey:@"Magnetometer active"];
    [servList setValue:@"500" forKey:@"Magnetometer period"];
    [servList setValue:@"F000AA30-0451-4000-B000-000000000000" forKey:@"Magnetometer service UUID"];
    [servList setValue:@"F000AA31-0451-4000-B000-000000000000" forKey:@"Magnetometer data UUID"];
    [servList setValue:@"F000AA32-0451-4000-B000-000000000000" forKey:@"Magnetometer config UUID"];
    [servList setValue:@"F000AA33-0451-4000-B000-000000000000" forKey:@"Magnetometer period UUID"];
    
    //Then we setup the barometric sensor
    [servList setValue:@"1" forKey:@"Barometer active"];
    [servList setValue:@"F000AA40-0451-4000-B000-000000000000" forKey:@"Barometer service UUID"];
    [servList setValue:@"F000AA41-0451-4000-B000-000000000000" forKey:@"Barometer data UUID"];
    [servList setValue:@"F000AA42-0451-4000-B000-000000000000" forKey:@"Barometer config UUID"];
    [servList setValue:@"F000AA43-0451-4000-B000-000000000000" forKey:@"Barometer calibration UUID"];
    
    [servList setValue:@"1" forKey:@"Gyroscope active"];
    [servList setValue:@"F000AA50-0451-4000-B000-000000000000" forKey:@"Gyroscope service UUID"];
    [servList setValue:@"F000AA51-0451-4000-B000-000000000000" forKey:@"Gyroscope data UUID"];
    [servList setValue:@"F000AA52-0451-4000-B000-000000000000" forKey:@"Gyroscope config UUID"];
    
    
  //  NSLog(@"%@",servList);
   // [self.d.setupData addEntriesFromDictionary:servList];
  //  NSLog(@"values to setupData = %@", self.d.setupData);
    return servList;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
