//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift
import Alamofire

class GetPostsUseCaseImpl: GetPostsUseCase {
    private var getPostsRemoteDataSource: GetPostsDataSource
    private var getUsersRemoteDataSource: GetUsersDataSource

    private var disposeBag = DisposeBag()

    init(
            getPostsRemoteDataSource: GetPostsDataSource,
            getUsersRemoteDataSource: GetUsersDataSource
    ) {
        self.getPostsRemoteDataSource = getPostsRemoteDataSource
        self.getUsersRemoteDataSource = getUsersRemoteDataSource
    }

    func execute() -> Single<[Domain.PostDetailEntity]> {
        Single.create(subscribe: { [self] observer in
            Single.zip(
                    getPostsRemoteDataSource.getPostsDataSource(),
                    getUsersRemoteDataSource.getUsersDataSource()
            )
                    .subscribe(
                            onSuccess: { [weak self] posts, users in
                                var postDetail : [Domain.PostDetailEntity] = []
                                var processedData = rawDataMapper(posts: posts, users: users)
                                postDetail.append(contentsOf: processedData ?? [])
                                observer(.success(postDetail))
                            }, onError: { error in
                                observer(.error(error))
                            }
                    )
            return Disposables.create()
        })
    }
}

extension GetPostsUseCaseImpl {
    private func rawDataMapper(posts: [Data.PostEntity], users: [Data.UserEntity]) -> [Domain.PostDetailEntity] {
        var postDetail : [Domain.PostDetailEntity] = []
        for post in posts {
            if let postId = post.id,
               let user = users.filter({ $0.id == post.userId }).first,
               let userId = user.id {
                var data = Domain.PostDetailEntity(
                        post: Domain.PostEntity(
                                id: "\(postId)",
                                title: post.title,
                                body: post.body
                        ),
                        user: Domain.UserEntity(
                                id: "\(userId)",
                                name: user.name,
                                username: user.username,
                                email: user.email,
                                phone: user.phone,
                                website: user.website,
                                company: Domain.Company(
                                        name: user.company?.name,
                                        catchPhrase: user.company?.catchPhrase,
                                        bs: user.company?.bs
                                ),
                                address: Domain.Address(
                                        street: user.address?.street,
                                        suite: user.address?.suite,
                                        city: user.address?.city,
                                        zipCode: user.address?.zipCode
                                )
                        )
                )
                postDetail.append(data)
            }
        }
        return postDetail
    }
}