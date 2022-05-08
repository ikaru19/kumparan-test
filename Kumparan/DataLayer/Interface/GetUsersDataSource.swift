//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift
import Alamofire

protocol GetUsersDataSource: AnyObject {
    func getUsersDataSource() -> Single<[Data.UserEntity]>
}