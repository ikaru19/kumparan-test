//
// Created by Engineering on 04/05/22.
//

import Foundation
import NVActivityIndicatorView
import CRRefresh

class PullToRefreshAnimator: UIView, CRRefreshProtocol {
    open var pullToRefreshDescription = "pull down to refresh"
    open var releaseToRefreshDescription = "release to refresh"

    open var view: UIView { return self }
    open var insets: UIEdgeInsets = .zero
    open var trigger: CGFloat  = 60.0
    open var execute: CGFloat  = 60.0
    open var endDelay: CGFloat = 0
    public var hold: CGFloat   = 60

    fileprivate let backgroundTextView: UIView = {
        let v = UIView()
        v.frame.size.width = 256
        v.frame.size.height = 32
        v.layer.cornerRadius = 16
        v.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        v.alpha = 1
        return v
    }()
    fileprivate let backgroundIndicatorView: UIView = {
        let v = UIView()
        v.frame.size.width = 32
        v.frame.size.height = 32
        v.layer.cornerRadius = 16
        v.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        v.alpha = 0
        return v
    }()
    fileprivate let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    fileprivate let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .gray)
        indicatorView.alpha = 0
        return indicatorView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = pullToRefreshDescription
        self.addSubview(backgroundTextView)
        self.addSubview(backgroundIndicatorView)
        self.addSubview(titleLabel)
        self.addSubview(indicatorView)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func refreshBegin(view: CRRefreshComponent) {
        indicatorView.startAnimating()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.indicatorView.alpha = 1
            self?.titleLabel.alpha = 0
            self?.backgroundTextView.alpha = 0
            self?.backgroundIndicatorView.alpha = 1
        }
        setNeedsLayout()
    }

    open func refreshEnd(view: CRRefreshComponent, finish: Bool) {
        if finish {
            indicatorView.stopAnimating()
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.indicatorView.alpha = 0
                self?.titleLabel.alpha = 1
                self?.backgroundTextView.alpha = 1
                self?.backgroundIndicatorView.alpha = 0
            }
            setNeedsLayout()
        }
    }

    public func refreshWillEnd(view: CRRefreshComponent) {

    }

    open func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat) {

    }

    open func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState) {
        switch state {
        case .refreshing:
            setNeedsLayout()
        case .pulling:
            titleLabel.text = releaseToRefreshDescription
            self.setNeedsLayout()
        case .idle:
            titleLabel.text = pullToRefreshDescription
            self.setNeedsLayout()
        default:
            break
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let s = bounds.size
        let w = s.width
        let h = s.height

        UIView.performWithoutAnimation {
            backgroundTextView.center = .init(x: w / 2.0, y: h / 2.0)
            backgroundIndicatorView.center = .init(x: w / 2.0, y: h / 2.0)
            titleLabel.sizeToFit()
            titleLabel.center = .init(x: w / 2.0, y: h / 2.0)
            indicatorView.center = .init(x: w / 2.0, y: h / 2.0)
        }
    }

}
