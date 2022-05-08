//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift
import RxRelay

class PostViewModelImpl: PostViewModel {
    private var _errors: PublishRelay<Error> = PublishRelay()
    private var _posts: PublishRelay<[Domain.PostDetailEntity]> = PublishRelay()
    private var getPostDetail: GetPostsUseCase
    private var disposeBag = DisposeBag()
    var delegate: PostViewModelDelegate?

    var errors: Observable<Error> {
        _errors.asObservable()
    }

    var posts: Observable<[Domain.PostDetailEntity]> {
        _posts.asObservable()
    }

    init(getPostDetail: GetPostsUseCase) {
        self.getPostDetail = getPostDetail
    }

    func refreshPage() {
        getPostsLists()
    }

    func getPostsLists() {
        getPostDetail.execute().subscribe(
                onSuccess: { [weak self] data in
                    self?._posts.accept(data)
                    self?.delegate?.onFinishFetch()
                },
                onError: { [weak self] error in
                    self?._errors.accept(error)
                }
        )
    }
}