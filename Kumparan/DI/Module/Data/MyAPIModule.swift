//
// Created by Engineering on 04/05/22.
//

import Foundation
import Cleanse

struct MyAPIModule: Module {
    static func configure(binder: SingletonScope) {
        binder.bind()
                .sharedInScope()
                .to(factory: MyJsonAPI.init)
    }
}