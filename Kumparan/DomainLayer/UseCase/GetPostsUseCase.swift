//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift

protocol GetPostsUseCase: AnyObject {
    func execute() -> Single<[Domain.PostDetailEntity]>
}