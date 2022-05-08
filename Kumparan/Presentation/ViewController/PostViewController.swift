//
// Created by Engineering on 04/05/22.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class PostViewController: UIViewController {
    private var tvContent: UITableView?
    private let viewModel: PostViewModel

    private var posts: [Domain.PostDetailEntity] = []

    private var postsSubscriber: Disposable?
    private var errorSubscriber: Disposable?

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: PostViewModel) {
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
        viewModel.getPostsLists()
    }

    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeViewModel()

        super.viewWillDisappear(animated)
    }

    private func subscribeViewModel() {
        viewModel.delegate = self
        postsSubscriber = viewModel.posts
                .observeOn(MainScheduler.instance)
                .subscribe(
                        onNext: { [weak self] posts in
                            DispatchQueue.main.async {
                                self?.initPosts(posts)
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
        postsSubscriber?.dispose()
        postsSubscriber = nil
        errorSubscriber?.dispose()
        errorSubscriber = nil
    }
}

// MARK: UIKIT
private extension PostViewController {
    func initDesign() {
        setupBaseView()
        let tvContent = generateTableView()

        view.addSubview(tvContent)
        tvContent.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }

        self.tvContent = tvContent
    }

    func setupBaseView() {
        view.backgroundColor = .white
        self.navigationItem.title = "Posts"
    }

    func generateTableView() -> UITableView {
        let view = UITableView(frame: .zero,style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

private extension PostViewController {
    func initViews() {
        initTableView()
    }

    func initTableView() {
        tvContent?.register(
                PostTableCell.self,
                forCellReuseIdentifier: PostTableCell.identifier
        )
        self.tvContent?.delegate = self
        self.tvContent?.dataSource = self
        tvContent?.rowHeight = UITableView.automaticDimension
        tvContent?.estimatedRowHeight = 600
        initPullToRefresh()
    }

    private func initPullToRefresh() {
        tvContent?.cr.addHeadRefresh(animator: PullToRefreshAnimator()) { [weak self] in
            self?.viewModel.refreshPage()
        }
    }
}

// MARK: TABLE DELEGATE
extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PostTableCell.identifier, for: indexPath
        ) as? PostTableCell else {
            return UITableViewCell()
        }
        cell.updateUI(data: posts[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = (UIApplication.shared.delegate as? ProvideViewControllerResolver)?.vcResolver.instantiateCommentsViewController().get() {
            guard let navigationController = self.navigationController else { return }
            vc.post = posts[indexPath.row]
            navigationController.pushViewController(vc, animated: true)
        }
    }

    private func initPosts(_ posts: [Domain.PostDetailEntity]) {
        self.posts = posts
        tvContent?.reloadData()
    }
}

// MARK: ViewModel DELEGATE
extension PostViewController: PostViewModelDelegate{
    internal func onFinishFetch() {
        DispatchQueue.main.async {
            self.tvContent?.cr.endHeaderRefresh()
        }
    }
}

// MARK: ERROR HANDLER
private extension PostViewController {
    func handleError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}