//
//  ProgressDelegate.swift
//  idtp
//
//  Created by Apple on 01.04.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation

protocol ProgressDelegate {
    
    func progressChanged(forTaskWithId taskIdentifier: Int, value: Float)
}
