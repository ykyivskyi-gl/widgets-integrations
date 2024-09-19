//
//  ContentView.swift
//  WidgetsIntegration
//
//  Created by Yevhen Kyivskyi on 13/09/2024.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var interactor = MainInteractor()
    
    var body: some View {
        VStack {
            Image("glia-logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(Color.gliaMainColor)
                .frame(height: 60)
                .padding(.top, 24)
            
            Spacer()
            
            if interactor.isEngagementsProviderReady {
                actionsView
            } else {
                loadingView
            }
            
            Spacer()
        }
        .padding()
        .alert("Failed starting engagement", isPresented: $interactor.isShowingErrorAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

private extension MainView {
    
    var actionsView: some View {
        VStack(alignment: .center, spacing: 8) {
            Button("Audio Call", action: interactor.startAudioCall)
                .foregroundStyle(Color.textColor)
            
            Button("Video Call", action: interactor.startVideoCall)
                .foregroundStyle(Color.textColor)
            
            Button("Chat", action: interactor.startChat)
                .foregroundStyle(Color.textColor)
            
            Button(
                action: interactor.authenticateAction,
                label: {
                    interactor.authenticationState.label
                }
            )
            .foregroundStyle(Color.textColor)
            
            Button("Visitor code", action: interactor.showVisitorCode)
                .foregroundStyle(Color.textColor)
            
            Button("Secure Conversation", action: interactor.startSecuredConversation)
                .disabled(!interactor.isSecuredMessagesAvailable)
                .foregroundStyle(
                    interactor.isSecuredMessagesAvailable ? Color.textColor : Color.textColor.opacity(0.4)
                )
        }
    }
    
    var loadingView: some View {
        VStack(spacing: 8) {
            ProgressView()
            Text("Please wait until Engagements Provider is ready")
                .multilineTextAlignment(.center)
        }
    }
}

private extension AuthenticationService.State {

    @ViewBuilder var label: some View {
        switch self {
        case .authenticated:
            Text("Deauthenticate")
        case .unauthenticated:
            Text("Authenticate")
        case .loading:
            ProgressView()
        }
    }
}

#Preview {
    MainView()
}
