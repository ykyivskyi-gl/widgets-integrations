//
//  Credentials.swift
//  WidgetsIntegration
//
//  Created by Yevhen Kyivskyi on 18/09/2024.
//

import GliaWidgets

protocol Credentials {
    var siteApiSecret: String { get }
    var siteApiId: String { get }
    var environment: Environment { get }
    var siteId: String { get }
    var queueId: String { get }
    var directIdToken: String { get }
}

extension Credentials {
    
    var gliaConfiguration: Configuration {
        let configuration = Configuration(
            authorizationMethod: .siteApiKey(id: siteApiId, secret: siteApiSecret),
            environment: environment,
            site: siteId
        )
        return configuration
    }
}
