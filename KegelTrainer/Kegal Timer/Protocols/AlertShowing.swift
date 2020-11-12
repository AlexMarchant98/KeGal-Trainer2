//
//  AlertShowing.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 09/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit

/// Allows conforming types to show alerts, optionally with a coordinator and an alternate action configuration.
protocol AlertShowing { }

extension AlertShowing {
    /// This shows an alert message. Note: this a default implementation of showAlert() in the AlertShowing protocol, but it isn't declared in the protocol because we don't want conforming types to provide their own implementation.
    
    func showAlert(title: String = "Workout Complete", body: String, coordinator: AlertHandling? = nil, alternateTitle: String? = nil, alternateAction: (() -> Void)? = nil) {
        let alert = AlertViewController.instantiate()
        
        alert.title = title
        alert.body = NSAttributedString(string: body)
        alert.alternateTitle = alternateTitle
        alert.alternateAction = alternateAction
        alert.coordinator = coordinator
        
        alert.presentAsAlert()
    }
}
