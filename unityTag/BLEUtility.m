/*
 *  bleUtility.m
 *
 * Created by Ole Andreas Torvmark on 10/2/12.
 * Copyright (c) 2012 Texas Instruments Incorporated - http://www.ti.com/
 * ALL RIGHTS RESERVED
 */

#import "BLEUtility.h"

@implementation BLEUtility


/****
 This file implements more of the Core Bluetooth functionality on the iOS side
 This is from the iOS app from TI
 ***/

+(void)writeCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID data:(NSData *)data {
    // Sends data to BLE peripheral to process HID and send EHIF command to PC
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:sUUID]]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]]) {
                    /* EVERYTHING IS FOUND, WRITE characteristic ! */
                    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                    
                }
            }
        }
    }
}

+(void)writeCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID data:(NSData *)data {
    // Sends data to BLE peripheral to process HID and send EHIF command to PC
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:sCBUUID]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                NSString *testUUID = [self CBUUIDToString:characteristic.UUID];
                //  NSLog(@"Service UUID to String: %@", servUUID);
                NSString *anotherTestUUID = [self CBUUIDToString:cCBUUID];
                if ([testUUID isEqual:anotherTestUUID]) {
                    /* EVERYTHING IS FOUND, WRITE characteristic ! */
                    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    NSLog(@"Periph data: %@ For Char: %@", data, characteristic);

                }
            }
        }
    }
}


+(void)readCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID {
    for ( CBService *service in peripheral.services ) {
        if([service.UUID isEqual:[CBUUID UUIDWithString:sUUID]]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]]) {
                    /* Everything is found, read characteristic ! */
                    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    [peripheral readValueForCharacteristic:characteristic];
                }
            }
        }
    }
}

+(void)readCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID {
    for ( CBService *service in peripheral.services ) {
        if([service.UUID isEqual:sCBUUID]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cCBUUID]) {
                    /* Everything is found, read characteristic ! */
                    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    [peripheral readValueForCharacteristic:characteristic];
                }
            }
        }
    }
}

+(void)setNotificationForCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID enable:(BOOL)enable {
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:sUUID]]) {
            for (CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]])
                {
                    /* Everything is found, set notification ! */
                    NSLog(@"Characteristic UUID %@ characteristic: %@", characteristic.UUID, characteristic);
                    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    [peripheral setNotifyValue:enable forCharacteristic:characteristic];
                    
                }
                
            }
        }
    }
}

+(void)setNotificationForCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID enable:(BOOL)enable {
    NSArray *periphChars = [[NSArray alloc]init];
    CBCharacteristic *characteristic = [[CBCharacteristic alloc]init];
    for ( CBService *service in peripheral.services ) {
      //  NSLog(@"Service description found: %@ in Peripheral: %@", service.debugDescription, peripheral);
        NSString *servUUID = [self CBUUIDToString:service.UUID];
      //  NSLog(@"Service UUID to String: %@", servUUID);
        NSString *scb = [self CBUUIDToString:sCBUUID];
      //  NSLog(@"sCBUIID: %@", scb);
       
        periphChars = service.characteristics;
      //  NSLog(@"service characteristics %@", periphChars);
      //  if ([service.UUID isEqual:sCBUUID]) {
        if([servUUID isEqual:scb]){
            for (characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cCBUUID])
                {
                    /* Everything is found, set notification ! */
                  //  [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                    [peripheral setNotifyValue:enable forCharacteristic:characteristic];
                    
                }
                
            }
        }
    }
}


+(bool) isCharacteristicNotifiable:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *) cCBUUID {
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:sCBUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cCBUUID])
                {
                    if (characteristic.properties & CBCharacteristicPropertyNotify) return YES;
                    else return NO;
                }
                
            }
        }
    }
    return NO;
}


+(CBUUID *) expandToTIUUID:(CBUUID *)sourceUUID {
    CBUUID *expandedUUID = [CBUUID UUIDWithString:TI_BASE_LONG_UUID];
    unsigned char expandedUUIDBytes[16];
    unsigned char sourceUUIDBytes[2];
    [expandedUUID.data getBytes:expandedUUIDBytes];
    [sourceUUID.data getBytes:sourceUUIDBytes];
    expandedUUIDBytes[2] = sourceUUIDBytes[0];
    expandedUUIDBytes[3] = sourceUUIDBytes[1];
    expandedUUID = [CBUUID UUIDWithData:[NSData dataWithBytes:expandedUUIDBytes length:16]];
    return expandedUUID;
}


+(NSString *) CBUUIDToString:(CBUUID *)inUUID {
    unsigned char i[16];
    [inUUID.data getBytes:i];
    if (inUUID.data.length == 2) {
        return [NSString stringWithFormat:@"%02hhx%02hhx",i[0],i[1]];
    }
    else {
        uint32_t g1 = ((i[0] << 24) | (i[1] << 16) | (i[2] << 8) | i[3]);
        uint16_t g2 = ((i[4] << 8) | (i[5]));
        uint16_t g3 = ((i[6] << 8) | (i[7]));
        uint16_t g4 = ((i[8] << 8) | (i[9]));
        uint16_t g5 = ((i[10] << 8) | (i[11]));
        uint32_t g6 = ((i[12] << 24) | (i[13] << 16) | (i[14] << 8) | i[15]);
        return [NSString stringWithFormat:@"%08x-%04hx-%04hx-%04hx-%04hx%08x",g1,g2,g3,g4,g5,g6];
    }
    return nil;
}

@end
