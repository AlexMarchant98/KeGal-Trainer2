//
//  SettingsTableViewController-TextFieldNumbersOnly.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 21/06/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import UIKit

extension SettingsTableViewController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedChracters = "0123456789"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedChracters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        
        self.dirtyInput = true
        
        return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    }
}
