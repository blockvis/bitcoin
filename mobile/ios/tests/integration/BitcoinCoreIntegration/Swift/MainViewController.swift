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
    private var restClientFactory: IRestClientFactory?
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var callMethodButton: UIButton!
    @IBOutlet weak var logTextView: UITextView!
    @IBOutlet weak var endpointTextField: UITextField!
    @IBOutlet weak var methodTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bitcoinCoreWrapper = BitcoinCoreWrapper()
        bitcoinCoreWrapper?.delegate = self
        
        restClientFactory = RestClientFactory()
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
    
    @IBAction func onCallMethodButtonTouchUpInside(_ sender: Any) {
        let endpoint = URL(string: endpointTextField.text ?? "")
        let restClient = restClientFactory?.get(baseURL: endpoint!) as? SimpleRestClient
        
        let responseType = JsonRpcResponse.self
        let params: [String: String]? = nil
        let headers: [String: String] = [
            "Content-Type": "application/json-rpc"
        ]
        let rpcParams = extractRpcParams()
        let body = JsonRpcRequest(extractMethodName(), rpcParams)
        restClient?.post(responseType, endpoint: "/", params: params, body: body, headers: headers, completion: { data, response, err in
            guard err == nil else {
                self.appendToLogView("Error: \(err!.localizedDescription)")
                return
            }
            guard data != nil else {
                self.appendToLogView("Error: No Data")
                return
            }
            guard data!.error == nil else {
                self.appendToLogView("Error: \(data!.error!.code) - \(data!.error!.message)")
                return
            }
            guard data?.result != nil else {
                self.appendToLogView("Error: No Result")
                return
            }
            self.appendToLogView(data!.result!.toString())
        })
    }
    
    private func extractMethodName() -> String {
        let methodText = methodTextField.text ?? ""
        let methodTextComponents = methodText.components(separatedBy: " ")
        
        guard methodTextComponents.count > 0 else {
            return ""
        }
        
        let methodName = methodTextComponents[0]
        
        return methodName
    }
    
    private func extractRpcParams() -> [String]? {
        var params = [String]()
        
        let paramsText = methodTextField.text ?? ""
        let paramsTextComponents = paramsText.components(separatedBy: " ")
        
        guard paramsTextComponents.count > 1 else {
            return params
        }
        
        for i in 1..<paramsTextComponents.count {
            let paramDecl = paramsTextComponents[i]
            params.append(paramDecl)
        }
        
        return params
    }
    
    private func appendToLogView(_ str: String) {
        DispatchQueue.main.async {
            let head = self.logTextView.text ?? ""
            self.logTextView.text = "\(head)\(str)\n"
        }
    }
    
    func bitcoinCoreStarted() {
        appendToLogView("INFO: Server started.")
    }
    
    func bitcoinCoreStopped() {
        appendToLogView("INFO: Server stopped.")
    }
    
    deinit {
    }
}

fileprivate class JsonRpcRequest : Encodable {
    var jsonrpc: String = "1.0"
    var id: String
    var method: String
    var params: [String]?
    
    init(_ method: String, _ params: [String]?) {
        self.id = NSUUID().uuidString
        self.method = method
        self.params = params
    }
}

fileprivate class JsonRpcResponse : Decodable {
    var id: String = ""
    var result: JsonRpcResponseResult?
    var error: JsonRpcResponseError?
}

// See https://gist.github.com/mbuchetics/c9bc6c22033014aa0c550d3b4324411a
fileprivate class JsonRpcResponseResult : Decodable {
    var resultBool: Bool?
    var resultInt: Int32?
    var resultDouble: Double?
    var resultStr: String?
    var resultArray: [Any]?
    var resultDict: [String: Any]?
    
    required public init(from decoder: Decoder) throws {
        let singleContainer = try decoder.singleValueContainer()
        
        if let bool = try? singleContainer.decode(Bool.self) {
            resultBool = bool
        }
        else if let numI = try? singleContainer.decode(Int32.self) {
            resultInt = numI
        }
        else if let numD = try? singleContainer.decode(Double.self) {
            resultDouble = numD
        }
        else if let str = try? singleContainer.decode(String.self) {
            resultStr = str
        }
        else if let containerKeyed = try? decoder.unkeyedContainer() {
            resultArray = buildArray(from: containerKeyed)
        }
        else if let containerKeyed = try? decoder.container(keyedBy: JSONCodingKeys.self) {
            resultDict = buildDict(from: containerKeyed)
        }
        else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
        }
    }
    
    private func buildArray(from container: UnkeyedDecodingContainer) -> [Any]? {
        var container = container
        var arr: [Any] = []
        while !container.isAtEnd {
            if let value = try? container.decode(Bool.self) {
                arr.append(value)
            } else if let value = try? container.decode(Double.self) {
                arr.append(value)
            } else if let value = try? container.decode(String.self) {
                arr.append(value)
            } else if let value = try? container.nestedContainer(keyedBy: JSONCodingKeys.self) {
                arr.append(buildDict(from: value))
            } else if let value = try? container.nestedUnkeyedContainer() {
                arr.append(buildArray(from: value))
            }
        }
        return arr
    }
    
    private func buildDict(from container: KeyedDecodingContainer<JSONCodingKeys>) -> [String: Any]? {
        let container = container
        var dict: [String: Any] = [:]
        for key in container.allKeys {
            if let value = try? container.decode(Bool.self, forKey: key) {
                dict[key.stringValue] = value
            } else if let value = try? container.decode(Double.self, forKey: key) {
                dict[key.stringValue] = value
            } else if let value = try? container.decode(String.self, forKey: key) {
                dict[key.stringValue] = value
            } else if let value = try? container.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key) {
                dict[key.stringValue] = buildDict(from: value)
            } else if let value = try? container.nestedUnkeyedContainer(forKey: key) {
                dict[key.stringValue] = buildArray(from: value)
            }
        }
        return dict
    }
    
    func toString() -> String {
        var str = "<NO DATA>"
        if let resultBool = resultBool {
            str = String(resultBool)
        }
        else if let resultInt = resultInt {
            str = String(resultInt)
        }
        else if let resultDouble = resultDouble {
            str = String(resultDouble)
        }
        else if let resultStr = resultStr {
            str = resultStr
        }
        else if let resultArray = resultArray {
            str = resultArray.description
        }
        else if let resultDict = resultDict {
            str = resultDict.description
        }
        
        return str
    }
}

struct JSONCodingKeys: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

fileprivate class JsonRpcResponseError : Decodable {
    var code: Int = 0
    var message: String = ""
}
