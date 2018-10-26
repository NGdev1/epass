//
//  MulticastDelegate.swift
//  idtp
//
//  Created by Apple on 02.04.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation

class MulticastDelegate <T> {
    private var delegates = [T]()
    
    func addDelegate(delegate: T) {
        delegates.append(delegate)
    }
    
    func invoke(invocation: (T) -> ()) {
        // Enumerating in reverse order prevents a race condition from happening when removing elements.
        for delegate in delegates {
            invocation(delegate)
        }
    }
}
