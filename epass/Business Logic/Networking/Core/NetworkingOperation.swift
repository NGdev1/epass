
import Foundation

protocol NetworkingOperation {
    
    associatedtype Result
    
    /// Request to execute
    var request: Request { get }
    
    /// Execute request in passed dispatcher
    ///
    /// - Parameter dispatcher: dispatcher
    /// - Returns: a promise
    //func execute(in dispatcher: NetworkingDispatcher, completionHandler: @escaping (Bool, Error?) -> Void) -> URLSessionDataTask
    
    func execute(in dispatcher: NetworkingDispatcher, completionHandler: @escaping (Result, Error?) -> Void) -> URLSessionDataTask
}
