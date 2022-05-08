//
// Created by Engineering on 08/05/22.
//

import Foundation
import RxSwift
import Alamofire

class GetPhotosUseCaseImpl: GetPhotosUseCase {
    private var getPhotoDataSource: GetPhotoDataSource

    private var disposeBag = DisposeBag()

    init(
            getPhotoDataSource: GetPhotoDataSource
    ) {
        self.getPhotoDataSource = getPhotoDataSource
    }

    func execute(albumId: Int) -> Single<[Domain.PhotoEntity]> {
        Single.create(subscribe: { [self] observer in
            getPhotoDataSource
                    .getPhotos(albumId: albumId)
                    .subscribe(
                            onSuccess: { [weak self] photos in
                                var finalPhotos : [Domain.PhotoEntity] = []
                                var processedData = rawDataMapper(photos: photos)
                                finalPhotos.append(contentsOf: processedData ?? [])
                                observer(.success(finalPhotos))
                            },
                            onError: { error in
                                observer(.error(error))
                            }
                    )
            return Disposables.create()
        })
    }
}

extension GetPhotosUseCaseImpl {
    private func rawDataMapper(photos: [Data.PhotoEntity]) -> [Domain.PhotoEntity] {
        var photoDomain: [Domain.PhotoEntity] = []

        for photo in photos {
            if let albumId = photo.albumId,
               let id = photo.id,
               let rawUrl = photo.thumbnailUrl,
               let url = URL(string: rawUrl) {
                var data = Domain.PhotoEntity(
                        albumId: albumId,
                        id: id,
                        title: photo.title,
                        url: url
                )
                photoDomain.append(data)
            }
        }
        return photoDomain
    }
}