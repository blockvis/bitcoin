//
//  ViewController.swift
//  BitcoinCoreIntegration
//
//  Created by Oleg Kertanov on 30/11/2018.
//  Copyright © 2018 Blockvis. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    private var bitcoinCoreWrapper: BitcoinCoreWrapper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bitcoinCoreWrapper = BitcoinCoreWrapper()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bitcoinCoreWrapper?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        bitcoinCoreWrapper?.stop()
    }
    
    deinit {
    }
}
