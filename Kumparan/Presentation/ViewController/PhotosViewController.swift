//
// Created by Engineering on 08/05/22.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class PhotosViewController: UIViewController {
    var albumData: Domain.AlbumEntity?

    private var cvContent: UICollectionView?
    private let viewModel: PhotosViewModel

    private var photos: [Domain.PhotoEntity] = []

    private var photosSubscriber: Disposable?
    private var errorSubscriber: Disposable?

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: PhotosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initDesign()
        initViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        subscribeViewModel()
        if let albumId = albumData?.id {
            viewModel.getPhotos(albumId: albumId)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeViewModel()

        super.viewWillDisappear(animated)
    }

    private func subscribeViewModel() {
        viewModel.delegate = self
        photosSubscriber = viewModel.photos
                .observeOn(MainScheduler.instance)
                .subscribe(
                        onNext: { [weak self] photos in
                            DispatchQueue.main.async {
                                self?.initPhotos(photos)
                            }
                        }
                )

        errorSubscriber = viewModel.errors
                .observeOn(MainScheduler.instance)
                .subscribe(
                        onNext: { [weak self] error in
                            DispatchQueue.main.async {
                                self?.handleError(error)
                            }
                        }
                )
    }

    private func unsubscribeViewModel() {
        photosSubscriber?.dispose()
        photosSubscriber = nil
        errorSubscriber?.dispose()
        errorSubscriber = nil
    }

    private func initPhotos(_ posts: [Domain.PhotoEntity]) {
        self.photos = posts
        cvContent?.reloadData()
    }
}

// MARK: UIKIT
private extension PhotosViewController {
    func initDesign() {
        setupBaseView()
        let cvContent = generateCollectionView()

        view.addSubview(cvContent)
        cvContent.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }

        self.cvContent = cvContent
    }

    func setupBaseView() {
        view.backgroundColor = .white
        self.navigationItem.title = albumData?.title
    }

    func generateCollectionView() -> UICollectionView {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 60, height: 60)
        let view = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

private extension PhotosViewController {
    func initViews() {
        initCollectionView()
    }

    func initCollectionView() {
        cvContent?.register(
                UICollectionViewCell.self,
                forCellWithReuseIdentifier: "MyCell"
        )
        self.cvContent?.delegate = self
        self.cvContent?.dataSource = self
        initPullToRefresh()
    }

    private func initPullToRefresh() {
        cvContent?.cr.addHeadRefresh(animator: PullToRefreshAnimator()) { [weak self] in
            if let albumId = self?.albumData?.id {
                self?.viewModel.refreshPage(albumId: albumId)
            }
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        let task = URLSession.shared.dataTask(with: photos[indexPath.row].url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async { /// execute on main thread
                var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
                imageView.image = UIImage(data: data)
                myCell.contentView.addSubview(imageView)
            }
        }

        task.resume()
        return myCell
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(photos[indexPath.row].title)")
        let vc = PhotoDetailViewController(nibName: nil, bundle: nil)
        vc.photo = photos[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PhotosViewController: PhotosViewModelDelegate {
    internal func onFinishFetch() {
        DispatchQueue.main.async {
            self.cvContent?.cr.endHeaderRefresh()
        }
    }
}

// MARK: ERROR HANDLER
private extension PhotosViewController {
    func handleError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}