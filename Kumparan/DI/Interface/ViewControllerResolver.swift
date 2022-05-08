//
// Created by Engineering on 04/05/22.
//

import Foundation
import Cleanse

protocol ViewControllerResolver: AnyObject {
    func instantiatePostViewController() -> Provider<PostViewController>
    func instantiateCommentsViewController() -> Provider<CommentViewController>
    func instantiateUserDetailViewController() -> Provider<UserDetailViewController>
    func instantiatePhotosViewController() -> Provider<PhotosViewController>
}