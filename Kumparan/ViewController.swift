//
//  ViewController.swift
//  Kumparan
//
//  Created by Engineering on 04/05/22.
//

import UIKit
import SnapKit
import Alamofire
import RxSwift
import RxAlamofire
import Cleanse
import Lottie

class ViewController: UIViewController {
    private var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (UIApplication.shared.delegate as? ProvideInjectorResolver)?.injectorResolver.inject(self)
//        test()
        goToPost()
    }

    func goToPost() {
        if let vc = (UIApplication.shared.delegate as? ProvideViewControllerResolver)?.vcResolver.instantiatePostViewController().get() {
            guard let navigationController = self.navigationController else { return }
            navigationController.pushViewController(vc, animated: true)
            navigationController.viewControllers.remove(at: navigationController.viewControllers.count - 2)
        }
    }

    var data: GetPhotosUseCase?
    func injectProperties(
            viewController: TaggedProvider<MyBaseUrl>,
            data: GetPhotosUseCase
    ) {
        self.data = data
    }

    func test() {
        print("here 48")
        data?.execute(albumId: 1).subscribe(onSuccess: { data in print(data.count)}, onError: { error in print(error)})
    }

}

