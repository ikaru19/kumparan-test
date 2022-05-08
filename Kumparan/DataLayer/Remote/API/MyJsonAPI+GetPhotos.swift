//
// Created by Engineering on 08/05/22.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

extension MyJsonAPI: GetPhotoDataSource {
    func getPhotos(albumId: Int) -> RxSwift.Single<[Data.PhotoEntity]> {
        let endpoint = "photos"
        let param : [String:String] = [
            "albumId" : "\(albumId)"
        ]

        return Single.create(subscribe: { [weak self] observer in
            self?.jsonRequestService.get(to: endpoint, param: param, header: [:])
                    .subscribe(
                            onNext: { [weak self] data in
                                var photoData : [Data.PhotoEntity] = []
                                if let dict = data as? [[String: Any]] {
                                    let processedData = self?.photoDataMapper(dictionary: dict)
                                    photoData.append(contentsOf: processedData ?? [])
                                }
                                observer(.success(photoData))
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
    func photoDataMapper(dictionary: [[String:Any]]) -> [Data.PhotoEntity] {
        var photos : [Data.PhotoEntity] = []

        for processed in dictionary {
            let data = Data.PhotoEntity(
                    albumId: processed["albumId"] as? Int,
                    id: processed["id"] as? Int,
                    title: processed["title"] as? String,
                    url: processed["url"] as? String,
                    thumbnailUrl: processed["thumbnailUrl"] as? String
            )
            photos.append(data)
        }
        return photos
    }
}