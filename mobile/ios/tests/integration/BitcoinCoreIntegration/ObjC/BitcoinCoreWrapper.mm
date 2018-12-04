//
//  BitcoinCoreWrapper.m
//  BitcoinCoreIntegration
//
//  Created by Oleg Kertanov on 03/12/2018.
//  Copyright © 2018 Blockvis. All rights reserved.
//

#import "BitcoinCoreWrapper.h"
#import "BitcoinCore/BitcoinCore.h"

#include <stdio.h>

#include <config/bitcoin-config.h>
#include <chainparams.h>
#include <clientversion.h>
#include <compat.h>
#include <fs.h>
#include <interfaces/chain.h>
#include <rpc/server.h>
#include <init.h>
#include <noui.h>
#include <shutdown.h>
#include <util/system.h>
#include <httpserver.h>
#include <httprpc.h>
#include <util/strencodings.h>
#include <walletinitinterface.h>

const std::function<std::string(const char*)> G_TRANSLATION_FUN = nullptr;


@implementation BitcoinCoreWrapper

@synthesize delegate = _delegate;

- (instancetype)init {
    self = [super init];
    return self;
}

-(void)start {
    [self start_];
}

-(void)stop {
    [self stop_];
}

-(void)start_ {
    SetupEnvironment();
    
    // Connect bitcoind signal handlers
    noui_connect();
    
    InitInterfaces interfaces;
    interfaces.chain = interfaces::MakeChain();
    
    /*SetupServerArgs();
    
    std::string error;
    std::vector<std::string> args = { std::string("BitcoinCoreIntegration").c_str() };
    const char** argv= reinterpret_cast<const char**>(&args[0]);
    int argc = (int)args.size();
    auto parsedParams = gArgs.ParseParameters(argc, argv, error);
    if (!parsedParams) {
        fprintf(stderr, "Error parsing command line arguments: %s\n", error.c_str());
    }*/
}

-(void)stop_ {
}

@end
