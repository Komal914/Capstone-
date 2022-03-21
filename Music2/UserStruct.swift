//
//  UserStruct.swift
//  Music2
//
//  Created by Amogh Kalyan on 3/20/22.
//

import Foundation
import AuthenticationServices

struct User {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    
    init(credentials: ASAuthorizationAppleIDCredential) {
        self.id = credentials.user 
        self.firstName = credentials.fullName?.givenName ?? "no first name"
        self.lastName = credentials.fullName?.familyName ?? "no last name"
        self.email = credentials.email ?? "no email"
    }
}

extension User: CustomDebugStringConvertible {
    var debugDescription: String {
        return """
        ID: \(id)
        First Name: \(firstName)
        Last Name: \(lastName)
        Email: \(email)
        """
    }
}
