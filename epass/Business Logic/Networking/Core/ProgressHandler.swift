//
//  ProgressHandler.swift
//  idtp
//
//  Created by Apple on 31.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation

class ProgressHandler: NSObject, URLSessionDataDelegate {
    
    var delegate: ProgressDelegate?
    
    static let shared = ProgressHandler()
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)

        delegate?.progressChanged(forTaskWithId: task.taskIdentifier, value: uploadProgress)
    }
}
