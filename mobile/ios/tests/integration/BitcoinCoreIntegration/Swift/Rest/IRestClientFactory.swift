//
//  IRestClientFactory.swift
//
//  Created by Oleg Kertanov on 14/12/2018.
//  Copyright © 2018 Blockvis. All rights reserved.
//

import Foundation

@objc protocol IRestClientFactory {
    func get(baseURL: URL) -> IRestClient
}

enum RestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct EmptyRequest: Encodable {}
struct EmptyResponse: Decodable {}

@objc protocol IRestClient {
}

protocol SimpleRestClient : IRestClient {
    var baseURL: URL { get }
    var session: URLSession { get }
    func get<D: Decodable>(_ responseType: D.Type, endpoint: String, params: [String : String]?, headers: [String : String]?, completion: @escaping (D?, URLResponse?, Error?) -> Void)
    func post<E: Encodable, D: Decodable>(_ responseType: D.Type, endpoint: String, params: [String : String]?, body: E?, headers: [String : String]?, completion: @escaping (D?, URLResponse?, Error?) -> Void)
    func put<E: Encodable, D: Decodable>(_ responseType: D.Type, endpoint: String, params: [String : String]?, body: E?, headers: [String : String]?, completion: @escaping (D?, URLResponse?, Error?) -> Void)
    func delete<E: Encodable, D: Decodable>(_ responseType: D.Type, endpoint: String, params: [String : String]?, body: E?, headers: [String : String]?, completion: @escaping (D?, URLResponse?, Error?) -> Void)
    func performRequest<D: Decodable>(_ responseType: D.Type, request: URLRequest, completion: @escaping (D?, URLResponse?, Error?) -> Void)
}
