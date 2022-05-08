//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift
import Alamofire

protocol GetPostsDataSource: AnyObject {
    func getPostsDataSource() -> Single<[Data.PostEntity]>
}