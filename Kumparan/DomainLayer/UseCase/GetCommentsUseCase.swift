//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift

protocol GetCommentsUseCase: AnyObject {
    func execute(postId: Int) -> Single<[Domain.CommentEntity]>
}