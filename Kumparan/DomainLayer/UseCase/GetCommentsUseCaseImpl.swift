//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift
import Alamofire

class GetCommentsUseCaseImpl: GetCommentsUseCase {
    private var getCommentsRemoteDataSource: GetPostCommentsDataSource

    private var disposeBag = DisposeBag()

    init(
            getCommentsRemoteDataSource: GetPostCommentsDataSource
    ) {
        self.getCommentsRemoteDataSource = getCommentsRemoteDataSource
    }

    func execute(postId: Int) -> Single<[Domain.CommentEntity]> {
        Single.create(subscribe: { [self] observer in
            getCommentsRemoteDataSource
                    .getComments(postId: postId)
                    .subscribe(
                            onSuccess: { [weak self] comments in
                                var finalComments : [Domain.CommentEntity] = []
                                var processedData = rawDataMapper(comments: comments)
                                finalComments.append(contentsOf: processedData ?? [])
                                observer(.success(finalComments))
                            }, onError: { error in
                        observer(.error(error))
                    }
                    )
            return Disposables.create()
        })
    }
}

extension GetCommentsUseCaseImpl {
    private func rawDataMapper(comments: [Data.CommentEntity]) -> [Domain.CommentEntity] {
        var commentsDetail : [Domain.CommentEntity] = []
        for comment in comments {
            if let postId = comment.postId,
               let commentId = comment.id {
                var data = Domain.CommentEntity(
                        postId: postId,
                        id: commentId,
                        body: comment.body,
                        name: comment.email
                )
                commentsDetail.append(data)
            }
        }
        return commentsDetail
    }
}
