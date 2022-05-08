//
// Created by Engineering on 04/05/22.
//

import Foundation
import Cleanse
import RxSwift
import Alamofire

final class MyAFRequest {
    private var baseUrl: TaggedProvider<MyBaseUrl>

    init(
            baseUrl: TaggedProvider<MyBaseUrl>
    ) {
        self.baseUrl = baseUrl
    }

    static func isNetworkConnected() -> Bool {
        if let manager = NetworkReachabilityManager() {
            return manager.isReachable
        } else {
            return false
        }
    }

    func injectBaseUrl(endPoint: String) -> String {
        "\(baseUrl.get())\(endPoint)"
    }
}