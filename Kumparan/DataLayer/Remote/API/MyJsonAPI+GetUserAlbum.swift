//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

extension MyJsonAPI: GetUserAlbumDataSource {
    func getAlbum(userId: Int) -> Single<[Data.AlbumEntity]> {
        let endpoint = "albums"
        let param : [String:String] = [
            "userId" : "\(userId)"
        ]

        return Single.create(subscribe: { [weak self] observer in
            self?.jsonRequestService.get(to: endpoint, param: param, header: [:])
                    .subscribe(
                            onNext: { [weak self] data in
                                var albumData : [Data.AlbumEntity] = []
                                if let dict = data as? [[String: Any]] {
                                    let processedData = self?.albumDataMapper(dictionary: dict)
                                    albumData.append(contentsOf: processedData ?? [])
                                }
                                observer(.success(albumData))
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
    func albumDataMapper(dictionary: [[String:Any]]) -> [Data.AlbumEntity] {
        var album : [Data.AlbumEntity] = []

        for processed in dictionary {
            let data = Data.AlbumEntity(
                    userId: processed["userId"] as? Int,
                    id: processed["id"] as? Int,
                    title: processed["title"] as? String
            )
            album.append(data)
        }
        return album
    }
}