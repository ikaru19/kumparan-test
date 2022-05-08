//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

protocol JsonRequest: AnyObject {
    func get(
            to endPoint: String,
            param: [String: Any],
            header: [String: String]
    ) -> Observable<Any>
}