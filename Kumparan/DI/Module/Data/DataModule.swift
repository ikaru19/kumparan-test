//
// Created by Engineering on 04/05/22.
//

import Foundation
import Cleanse

struct DataModule: Module {
    static func configure(binder: SingletonScope) {
        binder.include(module: NetworkingModule.self)
        binder.include(module: MyAPIModule.self)
        binder.bind(GetPostsDataSource.self)
                .sharedInScope()
                .to { (api: MyJsonAPI) in
                    api
                }
        binder.bind(GetUsersDataSource.self)
                .sharedInScope()
                .to { (api: MyJsonAPI) in
                    api
                }
        binder.bind(GetPostCommentsDataSource.self)
                .sharedInScope()
                .to { (api: MyJsonAPI) in
                    api
                }
        binder.bind(GetUserAlbumDataSource.self)
                .sharedInScope()
                .to { (api: MyJsonAPI) in
                    api
                }
        binder.bind(GetPhotoDataSource.self)
                .sharedInScope()
                .to { (api: MyJsonAPI) in
                    api
                }
    }
}