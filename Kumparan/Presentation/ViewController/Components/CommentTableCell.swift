//
// Created by Engineering on 04/05/22.
//

import Foundation
import UIKit
import SnapKit

class CommentTableCell: UITableViewCell {
    public static let identifier: String = "CommentTableCell"
    private var vwContainer: UIView?
    private var lbName: UILabel?
    private var lbBody: UILabel?

    private var item: Domain.CommentEntity?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initDesign()
        updateUI(data: item)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initDesign()
    }

    func updateUI(data: Domain.CommentEntity?) {
        item = data
        lbName?.text = data?.name
        lbBody?.text = data?.body
    }
}

// MARK: UIKIT
private extension CommentTableCell {
    func initDesign() {
        let vwContainer = generateContainer()
        let lbName = generateFullNameLabel()
        let lbBody = generatePostBodyLabel()

        self.contentView.addSubview(vwContainer)
        vwContainer.addSubview(lbName)
        vwContainer.addSubview(lbBody)

        vwContainer.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalToSuperview()
        }

        lbName.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(vwContainer).offset(8)
            make.leading.equalTo(vwContainer)
        }

        lbBody.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(lbName.snp.bottom).offset(8)
            make.leading.equalTo(vwContainer)
            make.trailing.equalTo(vwContainer)
            make.bottom.equalTo(vwContainer.snp.bottom).offset(-8)
        }

        self.vwContainer = vwContainer
        self.lbName = lbName
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

    func generatePostBodyLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        view.textColor = .black
        view.numberOfLines = 0
        return view
    }
}