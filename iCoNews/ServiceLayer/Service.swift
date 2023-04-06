//
//  Service.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 6/4/23.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol Service {
    var baseURL: String { get }
    var path: String { get }
    var parameter: [URLQueryItem] { get }
    var headers: [String: String] { get }
    var method: HTTPMethod { get }
}

extension Service {
    func getUrl() -> URL? {
        var component = URLComponents()
        component.scheme = "https"
        component.host = baseURL
        component.path = path
        component.queryItems = parameter
        return component.url
    }
}

extension Encodable {
    var encodedJsonAsDictionary: [String: Any]? {
        let jsonEncoder = JSONEncoder()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        guard let data = try? jsonEncoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var queryItem: URLQueryItem {
        if let key = self.encodedJsonAsDictionary?.keys.first,
           let value = self.encodedJsonAsDictionary?[key] as? String
        {
            return URLQueryItem(name: key, value: value)
        }
        return URLQueryItem(name: "", value: "")
    }
}
