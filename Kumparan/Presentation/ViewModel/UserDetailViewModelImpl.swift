//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift
import RxRelay

class UserDetailViewModelImpl: UserDetailViewModel {
    private var _errors: PublishRelay<Error> = PublishRelay()
    private var _albums: PublishRelay<[Domain.AlbumEntity]> = PublishRelay()
    private var getUserAlbumUseCase: GetUserAlbumUseCase
    private var disposeBag = DisposeBag()
    var delegate: UserDetailViewModelDelegate?

    var errors: Observable<Error> {
        _errors.asObservable()
    }

    var albums: Observable<[Domain.AlbumEntity]> {
        _albums.asObservable()
    }

    init(getUserAlbumUseCase: GetUserAlbumUseCase) {
        self.getUserAlbumUseCase = getUserAlbumUseCase
    }

    func refreshPage(userId: Int) {
        getAlbum(userId: userId)
    }

    func getAlbum(userId: Int) {
        getUserAlbumUseCase.execute(userId: userId)
                .subscribe(
                        onSuccess: { [weak self] data in
                            self?._albums.accept(data)
                            self?.delegate?.onFinishFetch()
                        },
                        onError: { [weak self] error in
                            self?._errors.accept(error)
                        }
                )
    }
}
