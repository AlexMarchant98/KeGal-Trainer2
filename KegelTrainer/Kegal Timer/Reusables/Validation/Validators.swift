//
//  Validators.swift
//  PTFinder
//
//  Created by Alex Marchant on 27/07/2019.
//  Copyright © 2019 Alex Marchant. All rights reserved.
//

import Foundation

class ValidationError: Error, Equatable {
    
    static func == (lhs: ValidationError, rhs: ValidationError) -> Bool {
        if(lhs.message == rhs.message) {
            return true
        }
        
        return false
    }
    
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
}

enum ValidatorType {
    case email
    case password
    case requiredField(field: String)
    case age
}

enum VaildatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .email: return EmailValidator()
        case .password: return PasswordValidator()
        case .requiredField(let fieldName): return RequiredFieldValidator(fieldName)
        case .age: return AgeValidator()
        }
    }
}

struct EmailValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Invalid e-mail Address")
            }
        } catch {
            throw ValidationError("Invalid e-mail Address")
        }
        return value
    }
}

struct PasswordValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError("Password is Required")}
        guard value.count >= 6 else { throw ValidationError("Password must contain at least 6 characters") }
        
        do {
            if try NSRegularExpression(pattern: "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)[A-Za-z0-9[!@#$&*]\\d]{6,}$").firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Password must contain at least one uppercase letter, one lowercase letter and one number")
            }
        } catch {
            throw ValidationError("Password must contain at least one uppercase letter, one lowercase letter and one number")
        }
        return value
    }
}

struct RequiredFieldValidator: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field
    }
    
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else {
            throw ValidationError("\(fieldName) is required")
        }
        if(value.hasPrefix(" ")) {
            throw ValidationError("\(fieldName) is required")
        }
        return value
    }
}

struct AgeValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError("Age is required")}
        guard let age = Int(value) else {throw ValidationError("Age must be a number!")}
        guard value.count < 3 else {throw ValidationError("Invalid age number!")}
        guard age >= 18 else {throw ValidationError("You have to be over 18 years old to user our app :)")}
        return value
    }
}

struct UnknownElementValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        throw ValidationError("Validation could not be performed" )
    }
}
