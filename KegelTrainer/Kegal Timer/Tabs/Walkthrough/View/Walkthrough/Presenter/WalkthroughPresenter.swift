//
//  WalkthroughPresenter.swift
//  PTHub
//
//  Created by Alex Marchant on 20/10/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation


protocol WalkthroughPresenterView {
}

protocol WalkthroughPresenterDelegate {
    func closeWalkthrough()
}

class WalkthroughPresenter: WalkthroughPresenterProtocol {
    
    let view: WalkthroughPresenterView
    let delegate: WalkthroughPresenterDelegate
    
    init(with view: WalkthroughPresenterView, delegate: WalkthroughPresenterDelegate) {
        self.view = view
        self.delegate = delegate
    }
    
    func closeWalkthrough() {
        self.delegate.closeWalkthrough()
    }
}
