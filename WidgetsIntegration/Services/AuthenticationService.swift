//
//  AuthenticationService.swift
//  WidgetsIntegration
//
//  Created by Yevhen Kyivskyi on 17/09/2024.
//

import Combine
import GliaWidgets

final class AuthenticationService {
    
    enum State {
        case authenticated
        case unauthenticated
        case loading
    }
    
    private let credentials: Credentials = GliaCredentials()
    private let gliaAuthentication: Glia.Authentication
    
    @Published var state = State.unauthenticated
    
    init() {
        do {
            gliaAuthentication = try Glia.sharedInstance.authentication(
                with: .allowedDuringEngagement
            )
        } catch {
            fatalError("Authentication init error: \(error.localizedDescription)")
        }
    }
    
    func authenticate() {
        state = .loading
        gliaAuthentication.authenticate(
            with: credentials.directIdToken, accessToken: nil
        ) { [weak self] result in
            switch result {
            case .success:
                self?.state = .authenticated
                print("Authentication succeeded")
            case .failure(let error):
                self?.state = .unauthenticated
                print("Authentication error: \(error.localizedDescription)")
            }
        }
    }
    
    func deauthenticate() {
        state = .loading
        gliaAuthentication.deauthenticate { [weak self] result in
            switch result {
            case .success:
                self?.state = .unauthenticated
                print("Deauthentication succeeded")
            case .failure(let error):
                self?.state = .authenticated
                print("Deauthentication error: \(error.localizedDescription)")
            }
        }
    }
}
