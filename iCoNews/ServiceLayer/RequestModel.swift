//
//  RequestModel.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 6/4/23.
//

import Foundation

enum HeaderType: String {
    case contentType = "Content-Type"
    case appXwwwFormUrlencoded = "application/x-www-form-urlencoded"
    case accept = "Accept"
    case applicationJson = "application/json"
    case authorization = "Authorization"
    case bearer = "Bearer "
}

public struct RequestModel {
    let service: Service
    let body: Data?
    let requestTimeout: Float?
    let token: String?
    
    public init (service: Service, reqBody: Data? = nil, reqTimeout:Float? = nil, token:String? = nil) {
        self.service = service
        self.body = reqBody
        self.requestTimeout = reqTimeout
        self.token = token
    }
    
    public func getUrlRequest() -> URLRequest? {
        guard let url = service.getUrl() else {
            appLog(tag: .error, "RequestModel: getUrlRequest: URL no found")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = service.method.rawValue
        
        for header in service.headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        if let token, !token.isEmpty {
            request.addValue("\(HeaderType.bearer.rawValue) \(token)", forHTTPHeaderField: HeaderType.authorization.rawValue)
        }
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                return nil
            }
        }
        
        return request
    }
}

