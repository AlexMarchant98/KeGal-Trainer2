//
//  ConnectionRequiredPresenterProtocol.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 02/12/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol ConnectionRequiredPresenterView {
    func connectionNotFound()
}

protocol ConnectionRequiredPresenterDelegate {
    func connectionFound()
}

class ConnectionRequiredPresenter: ConnectionRequiredPresenterProtocol {
    
    let networkManagerService: NetworkManagerServiceProtocol
    let view: ConnectionRequiredPresenterView
    let delegate: ConnectionRequiredPresenterDelegate
    
    init(
        _ networkManagerService: NetworkManagerServiceProtocol,
        with view: ConnectionRequiredPresenterView,
        delegate: ConnectionRequiredPresenterDelegate) {
        
        self.networkManagerService = networkManagerService
        self.view = view
        self.delegate = delegate
    }
    
    func didTapRetryConnection() {
        if(networkManagerService.isNetworkAvailable()) {
            self.delegate.connectionFound()
        } else {
            self.view.connectionNotFound()
        }
    }
}

