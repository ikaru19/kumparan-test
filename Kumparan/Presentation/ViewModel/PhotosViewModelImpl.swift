//
// Created by Engineering on 08/05/22.
//

import Foundation
import RxSwift
import RxRelay

class PhotoViewModelImpl: PhotosViewModel {
    private var _errors: PublishRelay<Error> = PublishRelay()
    private var _photos: PublishRelay<[Domain.PhotoEntity]> = PublishRelay()
    private var getPhotosUseCase: GetPhotosUseCase
    private var disposeBag = DisposeBag()
    var delegate: PhotosViewModelDelegate?

    var errors: Observable<Error> {
        _errors.asObservable()
    }

    var photos: Observable<[Domain.PhotoEntity]> {
        _photos.asObservable()
    }

    init(getPhotosUseCase: GetPhotosUseCase) {
        self.getPhotosUseCase = getPhotosUseCase
    }

    func refreshPage(albumId: Int) {
        getPhotos(albumId: albumId)
    }

    func getPhotos(albumId: Int) {
        getPhotosUseCase.execute(albumId: albumId)
                .subscribe(
                        onSuccess: { [weak self] data in
                            self?._photos.accept(data)
                            self?.delegate?.onFinishFetch()
                        },
                        onError: { [weak self] error in
                            self?._errors.accept(error)
                        }
                )
    }
}