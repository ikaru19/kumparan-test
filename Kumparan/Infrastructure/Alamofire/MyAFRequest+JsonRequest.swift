//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

extension MyAFRequest: JsonRequest {
    func get(
            to endPoint: String,
            param: [String: Any],
            header: [String: String]
    ) -> Observable<Any> {
        let endPoint = injectBaseUrl(endPoint: endPoint)
        return RxAlamofire.json(
                .get,
                endPoint,
                parameters: param,
                encoding: URLEncoding.default,
                headers: HTTPHeaders(header)
        )
    }
}