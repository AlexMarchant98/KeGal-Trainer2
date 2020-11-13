//
//  AlertHandlerService.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 09/11/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit

class AlertHandlerService {
    
    init() {}
    
    func showWarningAlert(view: UIViewController, message: String) {
        let alert = UIAlertController(
            title: "Warning",
            message: message,
            preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil))
        
        DispatchQueue.main.async {
            view.present(alert, animated: true, completion: nil)
        }
    }

    func showCustomAlert(view: UIViewController, title: String, message: String, actionTitles:[String?], actions: [((UIAlertAction) -> Void)?]) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert)
        
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(
                title: title,
                style: .default,
                handler: actions[index])
            
            alert.addAction(action)
        }
        
        DispatchQueue.main.async {
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    func showGeneralErrorAlert(view: UIViewController) {
        let alert = UIAlertController(
            title: "Oh no",
            message: "Apologies, something went wrong on our end; please restart the app. \n\n If this continues to occur please email support.",
            preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        
        DispatchQueue.main.async {
            view.present(alert, animated: true, completion: nil)
        }
    }
}

