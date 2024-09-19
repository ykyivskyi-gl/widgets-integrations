//
//  SupportService.swift
//  WidgetsIntegration
//
//  Created by Yevhen Kyivskyi on 17/09/2024.
//

import Combine
import GliaCoreSDK
import GliaWidgets

final class EngagementsService {
    
    private let credentials: Credentials = GliaCredentials()
    private var queueSubscriptionId: String?
    
    @Published var isInitialized = false
    @Published var queueState: GliaCoreSDK.QueueState?
    
    var engagementQueueId: String {
        credentials.queueId
    }
    
    init() {
        initializeCoreSDK()
    }
    
    func startEngagement(with kind: EngagementKind) throws {
        try Glia.sharedInstance.startEngagement(
            engagementKind: kind,
            in: [credentials.queueId]
        )
    }
}

private extension EngagementsService {
    
    func initializeCoreSDK() {
        do {
            try Glia.sharedInstance.configure(
                with: credentials.gliaConfiguration,
                theme: Theme()
            ) { [weak self] result in
                guard let self else {
                    return
                }
                switch result {
                case .success:
                    self.isInitialized = true
                    self.subscribeQueueUpdates()
                    print("Glia SDK succesfully initialized")
                case .failure(let error):
                    self.isInitialized = false
                    print("Glia SDK failed to initialize: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Glia SDK failed to initialize: \(error.localizedDescription)")
        }
    }
    
    func subscribeQueueUpdates() {
        queueSubscriptionId = GliaCore.sharedInstance.subscribeForUpdates(
            forQueue: [engagementQueueId],
            onError: { error in
                print("Failed observing queue: \(error.localizedDescription)")
            },
            onUpdate: { [weak self] queue in
                if queue.id == self?.engagementQueueId {
                    self?.queueState = queue.state
                }
                print("Received updated queue: \(queue)")
            }
        )
    }
}
