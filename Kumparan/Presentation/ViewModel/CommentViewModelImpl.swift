//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift
import RxRelay

class CommentViewModelImpl: CommentViewModel {
    private var _errors: PublishRelay<Error> = PublishRelay()
    private var _comments: PublishRelay<[Domain.CommentEntity]> = PublishRelay()
    private var getCommentsUseCase: GetCommentsUseCase
    private var disposeBag = DisposeBag()
    var delegate: CommentViewModelDelegate?

    var errors: Observable<Error> {
        _errors.asObservable()
    }

    var comments: Observable<[Domain.CommentEntity]> {
        _comments.asObservable()
    }

    init(getCommentsUseCase: GetCommentsUseCase) {
        self.getCommentsUseCase = getCommentsUseCase
    }

    func refreshPage(postId: Int) {
        getComment(postId: postId)
    }

    func getComment(postId: Int) {
        getCommentsUseCase.execute(postId: postId)
                .subscribe(
                onSuccess: { [weak self] data in
                    self?._comments.accept(data)
                    self?.delegate?.onFinishFetch()
                },
                onError: { [weak self] error in
                    self?._errors.accept(error)
                }
        )
    }
}