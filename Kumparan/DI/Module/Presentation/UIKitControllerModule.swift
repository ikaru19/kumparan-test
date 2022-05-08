//
// Created by Engineering on 04/05/22.
//

import Foundation
import Cleanse

struct UIKitControllerModule: Module {
    static func configure(binder: UnscopedBinder) {
        binder.bind(PostViewController.self)
                .to {
                    PostViewController(nibName: nil, bundle: nil, viewModel: $0)
                }
        binder.bind(CommentViewController.self)
                .to {
                    CommentViewController(nibName: nil, bundle: nil, viewModel: $0)
                }
        binder.bind(UserDetailViewController.self)
                .to {
                    UserDetailViewController(nibName: nil, bundle: nil, viewModel: $0)
                }
        binder.bind(PhotosViewController.self)
                .to {
                    PhotosViewController(nibName: nil, bundle: nil, viewModel: $0)
                }
    }
}