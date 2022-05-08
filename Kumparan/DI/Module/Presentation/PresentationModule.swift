//
// Created by Engineering on 04/05/22.
//

import Cleanse

struct PresentationModule: Module {
    static func configure(binder: SingletonScope) {
        binder.include(module: UIKitModule.self)
        binder.include(module: MainPageModule.self)
        binder.include(module: ViewModelModule.self)
        binder.include(module: UIKitControllerModule.self)
    }
}