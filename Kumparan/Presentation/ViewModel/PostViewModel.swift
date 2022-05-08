//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift

protocol PostViewModelDelegate: AnyObject {
    func onFinishFetch()
}

protocol PostViewModel: AnyObject {
    var errors: Observable<Error> { get }
    var posts: Observable<[Domain.PostDetailEntity]> { get }
    var delegate: PostViewModelDelegate? { get set }

    func refreshPage()
    func getPostsLists()
}