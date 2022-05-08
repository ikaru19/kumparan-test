//
// Created by Engineering on 05/05/22.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class UserDetailViewController: UIViewController {
    private var tvContent: UITableView?
    private var vwPostContainer: UIView?
    private var lbName: UILabel?
    private var lbEmail: UILabel?
    private var lbCompany: UILabel?
    private var lbAlbum: UILabel?
    private var lbAddress: UILabel?

    private let viewModel: UserDetailViewModel

    private var albums: [Domain.AlbumEntity] = []
    var post: Domain.PostDetailEntity?

    private var alert: UIAlertController?
    private var albumSubscriber: Disposable?
    private var errorSubscriber: Disposable?

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: UserDetailViewModel) {
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
        updateUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        subscribeViewModel()
        if let userId = post?.user.id,
           let id = Int(userId) {
            viewModel.getAlbum(userId: id)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeViewModel()

        super.viewWillDisappear(animated)
    }

    private func subscribeViewModel() {
        viewModel.delegate = self
        albumSubscriber = viewModel.albums
                .observeOn(MainScheduler.instance)
                .subscribe(
                        onNext: { [weak self] albums in
                            DispatchQueue.main.async {
                                self?.initAlbums(albums)
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
        albumSubscriber?.dispose()
        albumSubscriber = nil
        errorSubscriber?.dispose()
        errorSubscriber = nil
    }

    private func updateUI() {
        lbName?.text = post?.user.name
        lbEmail?.text = post?.user.email
        lbCompany?.text = post?.user.company?.name
        if let street = post?.user.address?.street,
           let city = post?.user.address?.city {
            lbAddress?.text = "\(street), \(city)"
        }
    }
}

// MARK: UIKIT
private extension UserDetailViewController {
    func initDesign() {
        setupBaseView()
        let tvContent = generateTableView()
        let vwPostContainer = generateContainer()
        let lbName = generateFullNameLabel()
        let lbEmail = generatePostTitleLabel()
        let lbCompany = generatePostTitleLabel()
        let lbAddress = generatePostBodyLabel()
        let lbAlbum = generateCommentLabel()

        view.addSubview(vwPostContainer)
        vwPostContainer.addSubview(lbName)
        vwPostContainer.addSubview(lbEmail)
        vwPostContainer.addSubview(lbCompany)
        vwPostContainer.addSubview(lbAddress)
        view.addSubview(lbAlbum)
        view.addSubview(tvContent)

        vwPostContainer.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.trailing.equalTo(view).offset(-16)
            make.leading.equalTo(view).offset(16)
        }

        lbAlbum.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(vwPostContainer.snp.bottom).offset(16)
            make.trailing.leading.equalTo(vwPostContainer)
        }

        lbName.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(vwPostContainer)
            make.leading.equalTo(vwPostContainer)
        }

        lbEmail.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbName.snp.bottom).offset(16)
            make.leading.equalTo(vwPostContainer)
            make.trailing.equalTo(vwPostContainer)
        }

        lbCompany.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbEmail.snp.bottom).offset(8)
            make.leading.equalTo(vwPostContainer)
            make.trailing.equalTo(vwPostContainer)
        }

        lbAddress.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbCompany.snp.bottom).offset(16)
            make.leading.equalTo(vwPostContainer)
            make.trailing.equalTo(vwPostContainer)
            make.bottom.equalTo(vwPostContainer.snp.bottom).offset(-8)
        }

        tvContent.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbAlbum.snp.bottom).offset(4)
            make.trailing.leading.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }

        self.vwPostContainer = vwPostContainer
        self.lbName = lbName
        self.lbEmail = lbEmail
        self.lbCompany = lbCompany
        self.lbAddress = lbAddress
        self.tvContent = tvContent
    }

    func setupBaseView() {
        view.backgroundColor = .white
        self.navigationItem.title = post?.user.name
    }

    func generateTableView() -> UITableView {
        let view = UITableView(frame: .zero,style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func generateContainer() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func generateFullNameLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        view.isUserInteractionEnabled = true
        return view
    }

    func generatePostTitleLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        view.numberOfLines = 0
        return view
    }

    func generatePostBodyLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        view.textColor = .black
        view.numberOfLines = 0
        return view
    }

    func generateCommentLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        view.textColor = .black
        view.numberOfLines = 0
        view.text = "Albums :"
        return view
    }
}

private extension UserDetailViewController {
    func initViews() {
        initTableView()
    }

    func initTableView() {
        self.tvContent?.delegate = self
        self.tvContent?.dataSource = self
        tvContent?.rowHeight = UITableView.automaticDimension
        tvContent?.estimatedRowHeight = 600
        initPullToRefresh()
    }

    private func initPullToRefresh() {
        tvContent?.cr.addHeadRefresh(animator: PullToRefreshAnimator()) { [weak self] in
            if let userId = self?.post?.user.id,
               let id = Int(userId) {
                self?.viewModel.refreshPage(userId: id)
            }
        }
    }
}

// MARK: TABLE DELEGATE
extension UserDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel?.text = albums[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = (UIApplication.shared.delegate as? ProvideViewControllerResolver)?.vcResolver.instantiatePhotosViewController().get() {
            guard let navigationController = self.navigationController else { return }
            vc.albumData = albums[indexPath.row]
            navigationController.pushViewController(vc, animated: true)
        }
    }

    private func initAlbums(_ albums: [Domain.AlbumEntity]) {
        self.albums = albums
        tvContent?.reloadData()
    }
}

// MARK: ViewModel DELEGATE
extension UserDetailViewController: UserDetailViewModelDelegate{
    internal func onFinishFetch() {
        DispatchQueue.main.async {
            self.tvContent?.cr.endHeaderRefresh()
        }
    }
}

// MARK: ERROR HANDLER
private extension UserDetailViewController {
    func handleError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}