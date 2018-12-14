//
//  IJsonSerializer.swift
//
//  Created by Oleg Kertanov on 14/12/2018.
//  Copyright © 2018 Blockvis. All rights reserved.
//

import Foundation

@objc protocol IJsonSerializer {
}

protocol IGenericJsonSerializer : IJsonSerializer {
    func serialize<T: Encodable>(_ obj: T) -> String
    func deserialize<T: Decodable>(_ repr: String) -> T?
}
