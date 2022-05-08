//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

extension MyJsonAPI: GetPostCommentsDataSource {
    func getComments(postId: Int) -> Single<[Data.CommentEntity]> {
        let endpoint = "comments"
        let param : [String:String] = [
            "postId" : "\(postId)"
        ]

        return Single.create(subscribe: { [weak self] observer in
            self?.jsonRequestService.get(to: endpoint, param: param, header: [:])
                    .subscribe(
                            onNext: { [weak self] data in
                                var commentsData : [Data.CommentEntity] = []
                                if let dict = data as? [[String: Any]] {
                                    let processedData = self?.commentDataMapper(dictionary: dict)
                                    commentsData.append(contentsOf: processedData ?? [])
                                }
                                observer(.success(commentsData))
                            },
                            onError: { [weak self] error in
                                observer(.error(error))
                            }
                    )
            return Disposables.create()
        })
    }
}

private extension MyJsonAPI {
    func commentDataMapper(dictionary: [[String:Any]]) -> [Data.CommentEntity] {
        var posts : [Data.CommentEntity] = []

        for processed in dictionary {
            let data = Data.CommentEntity(
                    postId: processed["postId"] as? Int,
                    id: processed["id"] as? Int,
                    name: processed["name"] as? String,
                    email: processed["email"] as? String,
                    body: processed["body"] as? String
            )
            posts.append(data)
        }
        return posts
    }
}