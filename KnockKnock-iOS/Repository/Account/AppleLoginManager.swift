//
//  AppleAccountManager.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/12/23.
//

import Foundation
import AuthenticationServices

protocol AppleLoginManagerProtocol {
  func excute(delegate: AppleLoginDelegate)
}
 
final class AppleLoginManager: NSObject, AppleLoginManagerProtocol {

  // MARK: - Properties
  
  private var token: String = "" {
    didSet {
      self.delegate?.success(token: self.token)
    }
  }
  
  weak var delegate: AppleLoginDelegate?
  
  // MARK: - Login
  
  func excute(delegate: AppleLoginDelegate) {
    self.delegate = delegate

    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
    authorizationController.performRequests()
  }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleLoginManager: ASAuthorizationControllerDelegate {
  
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      if let identityToken = appleIDCredential.identityToken,
         let tokenString = String(data: identityToken, encoding: .utf8) {
        
        self.token = tokenString
      }
    }
  }
}
