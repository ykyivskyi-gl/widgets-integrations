//
//  MainInteractor.swift
//  WidgetsIntegration
//
//  Created by Yevhen Kyivskyi on 13/09/2024.
//

import GliaWidgets
import GliaCoreSDK
import Combine

final class MainInteractor: ObservableObject {
    
    private let engagementsService: EngagementsService
    private let authenticationService: AuthenticationService
    
    @Published var isEngagementsProviderReady = false
    @Published var isShowingErrorAlert = false
    @Published var authenticationState: AuthenticationService.State = .unauthenticated
    
    var isSecuredMessagesAvailable: Bool {
        authenticationState == .authenticated
        && engagementsService.queueState?.status == .open
        && engagementsService.queueState?.media.contains(.messaging) == true
    }
    
    init(
        engagementsService: EngagementsService = .init(),
        authenticationService: AuthenticationService = .init()
    ) {
        self.engagementsService = engagementsService
        self.authenticationService = authenticationService
        
        engagementsService.$isInitialized
            .assign(to: &$isEngagementsProviderReady)
        authenticationService.$state
            .assign(to: &$authenticationState)
    }
    
    func startChat() {
        startEngagement(with: .chat)
    }
    
    func startAudioCall() {
        startEngagement(with: .audioCall)
    }
    
    func startVideoCall() {
        startEngagement(with: .videoCall)
    }
    
    func authenticateAction() {
        switch authenticationState {
        case .authenticated:
            authenticationService.deauthenticate()
        case .unauthenticated:
            authenticationService.authenticate()
        case .loading:
            break
        }
    }
    
    func showVisitorCode() {
        var topViewController: UIViewController?
        for scene in UIApplication.shared.connectedScenes {
            if let windowScene = scene as? UIWindowScene {
                for window in windowScene.windows {
                    if window.isKeyWindow {
                        topViewController = window.rootViewController
                    }
                }
            }
        }
        
        if let topViewController {
            Glia.sharedInstance.callVisualizer.showVisitorCodeViewController(from: topViewController)
        }
    }
    
    func startSecuredConversation() {
        startEngagement(with: .messaging(.welcome))
    }
}

private extension MainInteractor {
    
    func startEngagement(with kind: EngagementKind) {
        do {
            try engagementsService.startEngagement(with: kind)
        } catch {
            isShowingErrorAlert = true
        }
    }
}
