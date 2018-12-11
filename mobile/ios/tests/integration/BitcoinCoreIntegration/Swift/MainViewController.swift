//
//  ViewController.swift
//  BitcoinCoreIntegration
//
//  Created by Oleg Kertanov on 30/11/2018.
//  Copyright © 2018 Blockvis. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, BitcoinCoreWrapperDelegate {
    private var bitcoinCoreWrapper: BitcoinCoreWrapper?
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var logTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bitcoinCoreWrapper = BitcoinCoreWrapper()
        bitcoinCoreWrapper?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func onStartButtonTouchUpInside(_ sender: Any) {
        bitcoinCoreWrapper?.start()
    }
    
    @IBAction func onStopButtonTouchUpInside(_ sender: Any) {
        bitcoinCoreWrapper?.stop()
    }
    
    deinit {
    }
}
