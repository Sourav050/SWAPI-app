//
//  NetworkMonitorDelegate.swift
//  FinalApp
//
//  Created by Sourav Choubey on 12/02/24.
//

import Foundation

protocol NetworkMonitorDelegate: AnyObject {
    func networkStatusChanged(isConnected: Bool)
}
