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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self start_];
    });
}

-(void)stop {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self stop_];
    });
}

-(void)start_ {
    SetupEnvironment();
    
    // Connect bitcoind signal handlers
    noui_connect();
    
    InitInterfaces interfaces;
    interfaces.chain = interfaces::MakeChain();
    
    SetupServerArgs();
    
    std::string error;
    std::vector<const char*> args = {
        "BitcoinCoreIntegration",
        "-dbcache=8",
        "-maxmempool=8",
        "-maxorphantx=10",
        "-mempoolexpiry=1",
        "-persistmempool=0",
        "-prune=550",
        "-txindex=0",
        "-discover=1",
        "-dns=1",
        "-dnsseed=1",
        "-noonion",
        "-listen=0",
        "-listenonion=0",
        "-maxconnections=32",
        "-peerbloomfilters=1",
        "-permitbaremultisig=1",
        "-rest=0",
        "-rpcallowip=127.0.0.0",
        "-rpcbind=127.0.0.1",
        "-rpcport=8332",
        "-rpcthreads=2",
        "-server",
        "-testnet",
        "-rpcuser=bitcoin",
        "-rpcpassword=core"
    };
    const char** argv= reinterpret_cast<const char**>(&args[0]);
    int argc = (int)args.size();
    auto parsedParams = gArgs.ParseParameters(argc, argv, error);
    if (!parsedParams) {
        fprintf(stderr, "Error parsing command line arguments: %s\n", error.c_str());
    }
    
    auto licenseInfo = LicenseInfo();
    fprintf(stdout, "License info: %s\n", licenseInfo.c_str());
    
    std::string strUsage = PACKAGE_NAME " Daemon version " + FormatFullVersion() + "\n";
    strUsage += "\nUsage:  bitcoind [options]  Start " PACKAGE_NAME " Daemon\n";
    strUsage += "\n" + gArgs.GetHelpMessage();
    
    fprintf(stdout, "%s", strUsage.c_str());
    
    bool fRet = false;
    
    try {
        auto dataDir = GetDataDir(false);
        if (!fs::is_directory(dataDir)) {
            fprintf(stderr, "Error: Specified data directory \"%s\" does not exist.\n", gArgs.GetArg("-datadir", "").c_str());
        }
        
        if (!gArgs.ReadConfigFiles(error, true)) {
            fprintf(stderr, "Error reading configuration file: %s\n", error.c_str());
        }
        
        // Check for -testnet or -regtest parameter (Params() calls are only valid after this clause)
        try {
            auto chainName = gArgs.GetChainName();
            SelectParams(chainName);
        }
        catch (const std::exception& e) {
            fprintf(stderr, "Error: %s\n", e.what());
        }
        
        // Error out when loose non-argument tokens are encountered on command line
        for (int i = 1; i < argc; i++) {
            if (!IsSwitchChar(argv[i][0])) {
                fprintf(stderr, "Error: Command line contains unexpected token '%s', see bitcoind -h for a list of options.\n", argv[i]);
            }
        }
        
        // -server defaults to true for bitcoind but not for the GUI so do this here
        gArgs.SoftSetBoolArg("-server", true);
        
        // Set this early so that parameter interactions go to console
        InitLogging();
        InitParameterInteraction();
        
        if (!AppInitBasicSetup()) {
            // InitError will have been called with detailed error, which ends up on console
        }
        
        if (!AppInitParameterInteraction()) {
            // InitError will have been called with detailed error, which ends up on console
        }
        
        if (!AppInitSanityChecks()) {
            // InitError will have been called with detailed error, which ends up on console
        }
        
        // Lock data directory after daemonization
        if (!AppInitLockDataDirectory()) {
            // If locking the data directory failed, exit immediately
        }
        
        fRet = AppInitMain(interfaces);
    }
    catch (const std::exception& e) {
        PrintExceptionContinue(&e, "AppInit()");
    } catch (...) {
        PrintExceptionContinue(nullptr, "AppInit()");
    }
    
    if (!fRet) {
        Interrupt();
    } else {
        while (!ShutdownRequested()) {
            MilliSleep(200);
        }
        Interrupt();
    }
    Shutdown(interfaces);
}

-(void)stop_ {
    StartShutdown();
}

@end
