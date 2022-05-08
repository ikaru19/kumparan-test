//
// Created by Engineering on 04/05/22.
//

import Foundation

protocol InjectorResolver: AnyObject {
    func inject(_ viewController: ViewController)
}