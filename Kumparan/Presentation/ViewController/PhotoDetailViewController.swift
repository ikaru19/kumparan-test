//
// Created by Engineering on 08/05/22.
//

import Foundation
import UIKit
import SnapKit
import ImageScrollView

class PhotoDetailViewController: UIViewController {
    private var imageScrollView: ImageScrollView?

    var photo: Domain.PhotoEntity?

    override func viewDidLoad() {
        super.viewDidLoad()
        initDesign()
        initData()
    }
}

// MARK: UIKIT
private extension PhotoDetailViewController {
    func initDesign() {
        setupBaseView()
        let imageScrollView = generateImageView()

        view.addSubview(imageScrollView)
        imageScrollView.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }

        self.imageScrollView = imageScrollView
    }

    func setupBaseView() {
        view.backgroundColor = .black
        self.navigationItem.title = photo?.title
    }

    func generateImageView() -> ImageScrollView {
        let view = ImageScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setup()
        return view
    }

    func initData() {
        if let url = photo?.url {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async { /// execute on main thread
                    if let image = UIImage(data: data) {
                        self.imageScrollView?.display(image: image)
                    }
                }
            }

            task.resume()
        }
    }
}