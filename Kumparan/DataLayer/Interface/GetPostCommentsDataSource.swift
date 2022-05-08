//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift
import Alamofire

protocol GetPostCommentsDataSource: AnyObject {
    func getComments(postId: Int) -> Single<[Data.CommentEntity]>
}