//
// Created by Engineering on 04/05/22.
//

import Foundation
import Cleanse

struct DomainModule: Module {
    static func configure(binder: SingletonScope) {
        binder.include(module: UseCaseModule.self)
    }
}