//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift

protocol CommentViewModelDelegate: AnyObject {
    func onFinishFetch()
}

protocol CommentViewModel: AnyObject {
    var errors: Observable<Error> { get }
    var comments: Observable<[Domain.CommentEntity]> { get }
    var delegate: CommentViewModelDelegate? { get set }

    func refreshPage(postId: Int)
    func getComment(postId: Int)
}