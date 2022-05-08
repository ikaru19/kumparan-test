//
// Created by Engineering on 04/05/22.
//

import Foundation
import Cleanse

class MainViewControllerResolver: ViewControllerResolver {
    var postVcProvider: Provider<PostViewController>
    var commentVcProvider: Provider<CommentViewController>
    var userDetailVcProvider: Provider<UserDetailViewController>
    var userPhotosVcProvider: Provider<PhotosViewController>

    init(
            postVcProvider: Provider<PostViewController>,
            commentVcProvider: Provider<CommentViewController>,
            userDetailVcProvider: Provider<UserDetailViewController>,
            userPhotosVcProvider: Provider<PhotosViewController>
    ) {
        self.postVcProvider = postVcProvider
        self.commentVcProvider = commentVcProvider
        self.userDetailVcProvider = userDetailVcProvider
        self.userPhotosVcProvider = userPhotosVcProvider
    }

    func instantiatePostViewController() -> Provider<PostViewController> {
        postVcProvider
    }

    func instantiateCommentsViewController() -> Provider<CommentViewController> {
        commentVcProvider
    }

    func instantiateUserDetailViewController() -> Provider<UserDetailViewController> {
        userDetailVcProvider
    }

    func instantiatePhotosViewController() -> Provider<PhotosViewController> {
        userPhotosVcProvider
    }
}