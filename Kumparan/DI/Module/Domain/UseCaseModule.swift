//
// Created by Engineering on 04/05/22.
//

import Foundation
import Cleanse

struct UseCaseModule: Module {
    static func configure(binder: UnscopedBinder) {
        binder.bind(GetPostsUseCase.self)
                .to(factory: GetPostsUseCaseImpl.init)
        binder.bind(GetCommentsUseCase.self)
                .to(factory: GetCommentsUseCaseImpl.init)
        binder.bind(GetUserAlbumUseCase.self)
                .to(factory: GetUserAlbumUseCaseImpl.init)
        binder.bind(GetPhotosUseCase.self)
                .to(factory: GetPhotosUseCaseImpl.init)
    }
}