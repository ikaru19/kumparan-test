//
// Created by Engineering on 04/05/22.
//

import Foundation
import Cleanse

struct ViewModelModule: Module {
    static func configure(binder: UnscopedBinder) {
        binder.bind(PostViewModel.self)
                .to(factory: PostViewModelImpl.init)
        binder.bind(CommentViewModel.self)
                .to(factory: CommentViewModelImpl.init)
        binder.bind(UserDetailViewModel.self)
                .to(factory: UserDetailViewModelImpl.init)
        binder.bind(PhotosViewModel.self)
                .to(factory: PhotoViewModelImpl.init)
    }
}