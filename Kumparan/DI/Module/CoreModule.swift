//
// Created by Engineering on 04/05/22.
//

import Foundation
import Cleanse

struct CoreModule: Module {
    static func configure(binder: SingletonScope) {
        binder.include(module: PresentationModule.self)
        binder.include(module: DataModule.self)
        binder.include(module: DomainModule.self)

        binder.bind(InjectorResolver.self)
                .to(factory: MainInjectorResolver.init)
        binder.bind(ViewControllerResolver.self)
                .to(factory: MainViewControllerResolver.init)
    }
}