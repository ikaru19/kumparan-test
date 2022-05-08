//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift
import Alamofire

class GetUserAlbumUseCaseImpl: GetUserAlbumUseCase {
    private var getUserAlbumDataSource: GetUserAlbumDataSource

    private var disposeBag = DisposeBag()

    init(
            getUserAlbumDataSource: GetUserAlbumDataSource
    ) {
        self.getUserAlbumDataSource = getUserAlbumDataSource
    }


    func execute(userId: Int) -> Single<[Domain.AlbumEntity]> {
        Single.create(subscribe: { [self] observer in
            getUserAlbumDataSource
                    .getAlbum(userId: userId)
                    .subscribe(
                            onSuccess: { [weak self] album in
                                var finalAlbum : [Domain.AlbumEntity] = []
                                var processedData = rawDataMapper(albums: album)
                                finalAlbum.append(contentsOf: processedData ?? [])
                                observer(.success(finalAlbum))
                            },
                            onError: { error in
                                observer(.error(error))
                            }
                    )
            return Disposables.create()
        })
    }
}

extension GetUserAlbumUseCaseImpl {
    private func rawDataMapper(albums: [Data.AlbumEntity]) -> [Domain.AlbumEntity] {
        var albumDetail : [Domain.AlbumEntity] = []
        for album in albums {
            if let userId = album.userId,
               let id = album.id {
                var data = Domain.AlbumEntity(
                        userId: userId,
                        id: id,
                        title: album.title
                )
                albumDetail.append(data)
            }
        }
        return albumDetail
    }
}