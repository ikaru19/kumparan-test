//
// Created by Engineering on 04/05/22.
//

import Foundation
import Cleanse

struct MainPageModule: Module {
    static func configure(binder: UnscopedBinder) {
        binder.bindPropertyInjectionOf(ViewController.self)
                .to(injector: ViewController.injectProperties)
    }
}