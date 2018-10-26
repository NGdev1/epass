
import UIKit

public enum NetworkErrors: Error {
    case badInput
    case noData
}

public enum APIErrors: Error {
    case serverError
    case noConnection
    case unknounError
    case cancelled
}


extension APIErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .serverError:
            return "ErrorServer"
        case .unknounError:
            return "ErrorUnknoun"
        case .noConnection:
            return "ErrorNoConnection"
        case .cancelled:
            return "Cancelled"
        }
    }
}


class ConcreateNetworkingDispatcher: NetworkingDispatcher {
    
    private var environment: NetworkingEnvironment
    private var session: URLSession
    
    required public init(environment: NetworkingEnvironment) {
        self.environment = environment
        self.session = URLSession(configuration: URLSessionConfiguration.default,
                                  delegate: ProgressHandler.shared,
                                  delegateQueue: OperationQueue.main)
    }
    
    public func execute(request: Request,
                        completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let urlRequest = try! prepareURLRequest(for: request)
        let dataTask = self.session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let err = error { //let urlErrpr = (error as! Swift.Error) as? URLError
                    let urlErrpr  = err as! URLError
                    print(urlErrpr.code)
                    switch urlErrpr.code {
                    case .timedOut, .networkConnectionLost, .notConnectedToInternet:
                        completionHandler(data, response as! HTTPURLResponse? , APIErrors.noConnection)
                    case .cancelled:
                        completionHandler(data, response as! HTTPURLResponse?,
                            APIErrors.cancelled)
                    default:
                        completionHandler(data, response as! HTTPURLResponse?, APIErrors.unknounError)
                    }
                } else {
                    completionHandler(data, response as! HTTPURLResponse?, error)
                }
            }
        }
        dataTask.resume()
        return dataTask
    }
    
    private func prepareURLRequest(for request: Request) throws -> URLRequest {
        
        let fullURL = "\(environment.host)\(request.path)"
        
        var urlRequest = URLRequest(url: URL(string: fullURL)!)
        
        // Working with parameters
        switch request.parameters {
        case .body(let params):
            if params == nil {
                break
            }
            
            // Parameters are part of the body
            if let params = params as? [String: String] { // just to simplify
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .init(rawValue: 0))
            } else {
                throw NetworkErrors.badInput
            }
        case .url(let params):
            // Parameters are part of the url
            if params == nil {
                break
            }
            
            if let params = params as? [String: String] { // just to simplify
                let query_params = params.map({ (element) -> URLQueryItem in
                    return URLQueryItem(name: element.key, value: element.value)
                })
                guard var components = URLComponents(string: fullURL) else {
                    throw NetworkErrors.badInput
                }
                components.queryItems = query_params
                urlRequest.url = components.url
            } else {
                throw NetworkErrors.badInput
            }
        case .bodyUrlencoded(let params):
            if params == nil {
                break
            }
            
            if let params = params as? [String: String] { // just to simplify
                let query_params = params.map({ (element) -> URLQueryItem in
                    return URLQueryItem(name: element.key, value: element.value)
                })
                guard var components = URLComponents(string: fullURL) else {
                    throw NetworkErrors.badInput
                }
                components.queryItems = query_params
                urlRequest.httpBody = components.query?.data(using: .utf8)
            } else {
                throw NetworkErrors.badInput
            }
        }
        
        // Add headers from enviornment and request
        environment.headers.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        request.headers?.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        
        // Setup HTTP method
        urlRequest.httpMethod = request.method.rawValue
        
        return urlRequest
    }
}
