
import Foundation

public struct NetworkingEnvironment {
    
    // Name of environment
    public var name: String
    
    // Base URL
    public var host: String
    
    /// This is the list of common headers which will be part of each Request
    /// Some headers value maybe overwritten by Request's own headers
    public var headers: [String: Any] = [:]
    
    public init(_ name: String, host: String) {
        self.name = name
        self.host = host
    }
}
