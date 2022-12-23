//
//  AppleAccountManager.swift
//  KnockKnock-iOS
//
//  Created by sangwon yoon on 2022/12/23.
//

import Foundation
import AuthenticationServices

protocol AppleLoginRepository {
  func login(delegate: AppleLoginDelegate)
}
 
final class AppleAccountManager: NSObject, AppleLoginRepository {

  // MARK: - Properties
  
  private var token: String = "" {
    didSet {
      self.delegate?.success(token: self.token)
    }
  }
  
  weak var delegate: AppleLoginDelegate?
  
  // MARK: - Login
  
  func login(delegate: AppleLoginDelegate) {
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

extension AppleAccountManager: ASAuthorizationControllerDelegate {
  
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      if let authorizationCode = appleIDCredential.authorizationCode,
         let identityToken = appleIDCredential.identityToken,
         let authString = String(data: authorizationCode, encoding: .utf8),
         let tokenString = String(data: identityToken, encoding: .utf8) {
        
        self.token = tokenString
      }
    }
  }
}
