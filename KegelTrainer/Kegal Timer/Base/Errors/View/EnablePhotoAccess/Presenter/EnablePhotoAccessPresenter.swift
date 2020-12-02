//
//  EnablePhotosPresenter.swift
//  PTFinder
//
//  Created by Alex Marchant on 11/08/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

protocol EnablePhotoAccessPresenterView {
    
}

protocol EnablePhotoAccessPresenterDelegate {
    func didTapClose()
}

class EnablePhotoAccessPresenter: EnablePhotoAccessPresenterProtocol {
    
    let uiApplicationHelperService: UIApplicationHelperServiceProtocol
    let view: EnablePhotoAccessPresenterView
    let delegate: EnablePhotoAccessPresenterDelegate
    
    init(
        _ uiApplicationHelperService: UIApplicationHelperServiceProtocol,
        with view: EnablePhotoAccessPresenterView,
        delegate: EnablePhotoAccessPresenterDelegate) {
        
        self.uiApplicationHelperService = uiApplicationHelperService
        self.view = view
        self.delegate = delegate
    }
    
    func didTapEnablePhotoAccess() {
        uiApplicationHelperService.openSettingsUrl()
    }
    
    func didTapClose() {
        self.delegate.didTapClose()
    }
}
