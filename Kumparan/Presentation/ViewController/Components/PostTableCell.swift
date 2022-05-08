//
// Created by Engineering on 04/05/22.
//

import Foundation
import UIKit
import SnapKit

class PostTableCell: UITableViewCell {
    public static let identifier: String = "PostsListTableCell"
    private var vwContainer: UIView?
    private var lbName: UILabel?
    private var lbCompany: UILabel?
    private var lbTitle: UILabel?
    private var lbBody: UILabel?

    private var item: Domain.PostDetailEntity?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initDesign()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initDesign()
    }

    func initComponents() {
        initDesign()
    }

    func updateUI(data: Domain.PostDetailEntity) {
        lbName?.text = data.user.name
        lbCompany?.text = data.user.company?.name
        lbTitle?.text = data.post.title
        lbBody?.text = data.post.body
    }
}

// MARK: UIKIT
private extension PostTableCell {
    func initDesign() {
        let vwContainer = generateContainer()
        let lbName = generateFullNameLabel()
        let lbCompany = generateCompanyLabel()
        let lbTitle = generatePostTitleLabel()
        let lbBody = generatePostBodyLabel()

        self.contentView.addSubview(vwContainer)
        vwContainer.addSubview(lbName)
        vwContainer.addSubview(lbCompany)
        vwContainer.addSubview(lbTitle)
        vwContainer.addSubview(lbBody)

        vwContainer.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalToSuperview()
        }

        lbName.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(vwContainer).offset(8)
            make.leading.equalTo(vwContainer).offset(16)
        }

        lbCompany.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbName.snp.bottom).offset(4)
            make.leading.equalTo(vwContainer).offset(16)
        }

        lbTitle.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbCompany.snp.bottom).offset(16)
            make.leading.equalTo(vwContainer).offset(16)
            make.trailing.equalTo(vwContainer).offset(-16)
        }

        lbBody.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbTitle.snp.bottom).offset(8)
            make.leading.equalTo(vwContainer).offset(16)
            make.trailing.equalTo(vwContainer).offset(-16)
            make.bottom.equalTo(vwContainer.snp.bottom).offset(-8)
        }

        self.vwContainer = vwContainer
        self.lbName = lbName
        self.lbCompany = lbCompany
        self.lbTitle = lbTitle
        self.lbBody = lbBody
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
        return view
    }

    func generateCompanyLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.textColor = .black
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
}
