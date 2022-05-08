//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

extension MyJsonAPI: GetPostsDataSource {
    func getPostsDataSource() -> Single<[Data.PostEntity]> {
        let endpoint = "posts"

        return Single.create(subscribe: { [weak self] observer in
            self?.jsonRequestService.get(to: endpoint, param: [:], header: [:])
                    .subscribe(
                            onNext: { [weak self] data in
                                var postsData : [Data.PostEntity] = []
                                if let dict = data as? [[String: Any]] {
                                    let processedData = self?.postDataMapper(dictionary: dict)
                                    postsData.append(contentsOf: processedData ?? [])
                                }
                                observer(.success(postsData))
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
    func postDataMapper(dictionary: [[String:Any]]) -> [Data.PostEntity] {
        var posts : [Data.PostEntity] = []

        for processed in dictionary {
           let data = Data.PostEntity(
                   userId: processed["userId"] as? Int,
                   id: processed["id"] as? Int,
                   title: processed["title"] as? String,
                   body: processed["body"] as? String
           )
           posts.append(data)
        }
        return posts
    }
}