//
// Created by Engineering on 04/05/22.
//

import Foundation

final class MyJsonAPI {
    private(set) var jsonRequestService: JsonRequest

    init(apiService: JsonRequest) {
        jsonRequestService = apiService
    }
}