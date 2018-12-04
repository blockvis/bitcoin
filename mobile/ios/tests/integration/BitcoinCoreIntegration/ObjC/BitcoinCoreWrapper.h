//
//  BitcoinCoreWrapper.h
//  BitcoinCoreIntegration
//
//  Created by Oleg Kertanov on 03/12/2018.
//  Copyright © 2018 Blockvis. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BitcoinCoreWrapper_h
#define BitcoinCoreWrapper_h

@protocol BitcoinCoreWrapperDelegate <NSObject>

@optional -(void)bitcoinCoreStarted;
@optional -(void)bitcoinCoreStopped;

@end

@interface BitcoinCoreWrapper : NSObject

@property (nonatomic, weak) id <BitcoinCoreWrapperDelegate> delegate;

-(instancetype)init;

-(void)start;
-(void)stop;

@end

#endif /* BitcoinCoreWrapper_h */
