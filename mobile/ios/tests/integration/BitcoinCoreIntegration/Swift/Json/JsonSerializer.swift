//
//  JsonSerializer.swift
//
//  Created by Oleg Kertanov on 14/12/2018.
//  Copyright © 2018 Blockvis. All rights reserved.
//

import Foundation

class JsonSerializer : IJsonSerializer, IGenericJsonSerializer {
    required init() {
    }
    
    func serialize<T: Encodable>(_ obj: T) -> String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(obj)
        let repr = String.init(data: data, encoding: .utf8)!
        return repr
    }
    
    func deserialize<T: Decodable>(_ repr: String) -> T? {
        let decoder = JSONDecoder()
        let data = repr.data(using: .utf8)!
        let obj = try! decoder.decode(T.self, from: data)
        return obj
    }
}
