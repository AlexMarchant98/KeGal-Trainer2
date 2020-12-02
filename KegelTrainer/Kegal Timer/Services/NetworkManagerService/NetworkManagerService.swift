//
//  NetworkManagerService.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 02/12/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import Network

protocol NetworkManagerServiceDelegate {
    func connectionAvailable()
    func connectionUnavailable()
}

class NetworkManagerService: NetworkManagerServiceProtocol {
    
    var delegate: NetworkManagerServiceDelegate
    var pathMonitor: NWPathMonitor!
    var path: NWPath?
    
   lazy var pathUpdateHandler: ((NWPath) -> Void) = { path in
        self.path = path
        if path.status == NWPath.Status.satisfied {
            self.delegate.connectionAvailable()
        } else if path.status == NWPath.Status.unsatisfied {
            self.delegate.connectionUnavailable()
        } else if path.status == NWPath.Status.requiresConnection {
            self.delegate.connectionUnavailable()
        }
    }

    let backgroundQueue = DispatchQueue.global(qos: .background)

    init(delegate: NetworkManagerServiceDelegate) {
        
        self.delegate = delegate
        self.pathMonitor = NWPathMonitor()
        
        pathMonitor.pathUpdateHandler = self.pathUpdateHandler
        pathMonitor.start(queue: backgroundQueue)
    }
    
    func isNetworkAvailable() -> Bool {
        if let path = self.path {
            if path.status == NWPath.Status.satisfied {
                return true
            }
        }
        return false
    }
}

