//
//  NetworkRequestable.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 6/4/23.
//

import Foundation
import Combine

public protocol Requestable {
    var requestTimeout: Float { get }
    func request<T: Decodable>(_ req: RequestModel, model: T.Type) -> AnyPublisher<T,NetworkError>
}

public class NetworkRequestable: Requestable {
    public var requestTimeout: Float = 30
    
    public func request<T>(_ req: RequestModel, model: T.Type) ->  AnyPublisher<T,NetworkError> where T: Decodable {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(req.requestTimeout ?? requestTimeout)
        
        guard let urlRequest = req.getUrlRequest() else {
            return Fail(error: NetworkError.apiError(code: 0, error: "Error encoding http body")).eraseToAnyPublisher()
        }
        
        appLog(tag: .debug, "Request = \(urlRequest)")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError({ error in
            return NetworkError.transportError(code: error.errorCode, error: error.localizedDescription)
        })
            .tryMap { output in
                guard
                    output.response is HTTPURLResponse,
                    let response = output.response as? HTTPURLResponse
                else {
                    throw NetworkError.noResponse("Invalid Response")
                }
                
                if (200..<300) ~= response.statusCode {
                    appLog(tag: .debug, "Request Succesfull: code = \(response.statusCode)")
                    
                    if let dataStr = String(data: output.data, encoding: .utf8) {
                        appLog(tag: .debug, "Request Succesfull: data = \(dataStr)")
                    }
                    
                } else if (300..<400) ~= response.statusCode {
                    throw NetworkError.redirection(code: response.statusCode, error: "Redirection")
                } else if (400..<500) ~= response.statusCode {
                    appLog(tag: .warning, "CLIENT ERROR: code = \(response.statusCode)")
                    throw NetworkError.clientError(code: response.statusCode, error: "Client error")
                } else if (500..<600) ~= response.statusCode {
                    appLog(tag: .error, "SERVER ERROR: code = \(response.statusCode)")
                    throw NetworkError.serverError(code: response.statusCode, error: "Server error")
                }
                
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                appLog(tag: .error, "Decoding JSON Error: \(error.localizedDescription)")
                return NetworkError.invalidJSON(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

