//
// Created by Engineering on 04/05/22.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class CommentViewController: UIViewController {
    private var tvContent: UITableView?
    private var vwPostContainer: UIView?
    private var lbName: UILabel?
    private var lbComment: UILabel?
    private var lbTitle: UILabel?
    private var lbBody: UILabel?

    private let viewModel: CommentViewModel

    private var comments: [Domain.CommentEntity] = []
    var post: Domain.PostDetailEntity?

    private var alert: UIAlertController?
    private var commentsSubscriber: Disposable?
    private var errorSubscriber: Disposable?

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: CommentViewModel) {
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
        if let postId = post?.post.id,
           let id = Int(postId) {
            viewModel.getComment(postId: id)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeViewModel()

        super.viewWillDisappear(animated)
    }

    private func subscribeViewModel() {
        viewModel.delegate = self
        commentsSubscriber = viewModel.comments
                .observeOn(MainScheduler.instance)
                .subscribe(
                        onNext: { [weak self] comments in
                            DispatchQueue.main.async {
                                self?.initComments(comments)
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
        commentsSubscriber?.dispose()
        commentsSubscriber = nil
        errorSubscriber?.dispose()
        errorSubscriber = nil
    }

    private func updateUI() {
        lbName?.text = post?.user.name
        lbTitle?.text = post?.post.title
        lbBody?.text = post?.post.body
        initEvents()
    }
}

// MARK: UIKIT
private extension CommentViewController {
    func initDesign() {
        setupBaseView()
        let tvContent = generateTableView()
        let vwPostContainer = generateContainer()
        let lbName = generateFullNameLabel()
        let lbTitle = generatePostTitleLabel()
        let lbBody = generatePostBodyLabel()
        let lbComment = generateCommentLabel()

        view.addSubview(vwPostContainer)
        vwPostContainer.addSubview(lbName)
        vwPostContainer.addSubview(lbTitle)
        vwPostContainer.addSubview(lbBody)
        view.addSubview(lbComment)
        view.addSubview(tvContent)

        vwPostContainer.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.trailing.equalTo(view).offset(-16)
            make.leading.equalTo(view).offset(16)
        }

        lbComment.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(vwPostContainer.snp.bottom).offset(8)
            make.trailing.leading.equalTo(vwPostContainer)
        }

        lbName.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(vwPostContainer)
            make.leading.equalTo(vwPostContainer)
        }

        lbTitle.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbName.snp.bottom).offset(16)
            make.leading.equalTo(vwPostContainer)
            make.trailing.equalTo(vwPostContainer)
        }

        lbBody.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbTitle.snp.bottom).offset(8)
            make.leading.equalTo(vwPostContainer)
            make.trailing.equalTo(vwPostContainer)
            make.bottom.equalTo(vwPostContainer.snp.bottom).offset(-8)
        }

        tvContent.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbComment.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-8)
            make.bottom.equalTo(view)
        }

        self.vwPostContainer = vwPostContainer
        self.lbName = lbName
        self.lbTitle = lbTitle
        self.lbBody = lbBody
        self.tvContent = tvContent
    }

    func setupBaseView() {
        view.backgroundColor = .white
        self.navigationItem.title = "Comments"
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
        view.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        view.textColor = .link
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
        view.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        view.textColor = .black
        view.numberOfLines = 0
        view.text = "Comments :"
        return view
    }
}

private extension CommentViewController {
    func initViews() {
        initTableView()
        initEvents()
    }

    func initEvents()  {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedLabel(tapGestureRecognizer:)))
        lbName?.addGestureRecognizer(tapGesture)
    }

    @objc
    func tappedLabel(tapGestureRecognizer: UITapGestureRecognizer) {
        // Your code goes here
        if let vc = (UIApplication.shared.delegate as? ProvideViewControllerResolver)?.vcResolver.instantiateUserDetailViewController().get() {
            guard let navigationController = self.navigationController else { return }
            vc.post = post
            navigationController.pushViewController(vc, animated: true)
        }
    }

    func initTableView() {
        tvContent?.register(
                CommentTableCell.self,
                forCellReuseIdentifier: CommentTableCell.identifier
        )
        self.tvContent?.delegate = self
        self.tvContent?.dataSource = self
        tvContent?.rowHeight = UITableView.automaticDimension
        tvContent?.estimatedRowHeight = 600
        initPullToRefresh()
    }

    private func initPullToRefresh() {
        tvContent?.cr.addHeadRefresh(animator: PullToRefreshAnimator()) { [weak self] in
            if let postId = self?.post?.post.id,
               let id = Int(postId) {
                self?.viewModel.refreshPage(postId: id)
            }
        }
    }
}

// MARK: TABLE DELEGATE
extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CommentTableCell.identifier, for: indexPath
        ) as? CommentTableCell else {
            return UITableViewCell()
        }
        cell.updateUI(data: comments[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    private func initComments(_ comments: [Domain.CommentEntity]) {
        self.comments = comments
        tvContent?.reloadData()
    }
}

// MARK: ViewModel DELEGATE
extension CommentViewController: CommentViewModelDelegate{
    internal func onFinishFetch() {
        DispatchQueue.main.async {
            self.tvContent?.cr.endHeaderRefresh()
        }
    }
}

// MARK: ERROR HANDLER
private extension CommentViewController {
    func handleError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}