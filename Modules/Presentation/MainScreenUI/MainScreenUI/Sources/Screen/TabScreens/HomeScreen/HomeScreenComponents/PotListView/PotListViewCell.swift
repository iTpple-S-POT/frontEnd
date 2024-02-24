//
//  PotListViewCell.swift
//  MainScreenUI
//
//  Created by 최준영 on 2/23/24.
//

import GlobalObjects
import UIKit

fileprivate class ThumbNailView: UIImageView {
    
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        
        self.contentMode = .scaleAspectFill
    
        let colors: [CGColor] = [
            UIColor.black.withAlphaComponent(0.5).cgColor,
            UIColor.clear.cgColor
        ]
        
        gradientLayer.colors = colors
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.25)
        
        gradientLayer.shouldRasterize = false
        gradientLayer.drawsAsynchronously = false
        
        self.layer.addSublayer(gradientLayer)
    }
    
    func loadImageView(imageKey: String) {

        let url = URL(string: imageKey.getPreSignedUrlString())
        
        self.kf.indicatorType = .none
        self.kf.setImage(
            with: url,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.1)),
                .cacheOriginalImage,
                .backgroundDecode
            ]
        ) {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    override func layoutSubviews() {
        
        // 상위뷰의 layoutIfNeeded에 의해 호출됨
        gradientLayer.frame = self.frame
    }
}


class PotListViewCell: UICollectionViewCell {
    
    var model: PotModel!
    
    private var userInfo: UserInfoObject?
    
    private var isGredientAdded = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var thumbNailView = ThumbNailView(frame: .zero)
    
    private var nickNameLabel: UILabel = {
        
        let view = UILabel()
        
        view.text = ""
        
        view.font = .systemFont(ofSize: 16, weight: .semibold)
        view.textColor = .white
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 4
        
        return view
    }()
    
    private var timeLavel: UILabel = {
        
        let view = UILabel()
        
        view.text = ""
        
        view.font = .systemFont(ofSize: 14)
        view.textColor = .white
        view.shadowColor = .black
        view.shadowOffset = CGSize(width: 0, height: 0)
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowOpacity = 0.75
        view.layer.shadowRadius = 4
        
        return view
    }()
    
    private var stackView: UIStackView = {
        
        let view = UIStackView()
        
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 4.0
        
        return view
    }()
        
    func setUp() {
        
        self.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureCallBack))
        self.addGestureRecognizer(tapGesture)
        
        self.addSubview(thumbNailView)
        self.insertSubview(stackView, aboveSubview: thumbNailView)
        
        stackView.addArrangedSubview(nickNameLabel)
        stackView.addArrangedSubview(timeLavel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        thumbNailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbNailView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            thumbNailView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            thumbNailView.widthAnchor.constraint(equalTo: self.widthAnchor),
            thumbNailView.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            stackView.heightAnchor.constraint(equalToConstant: 44),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -11),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
    }
    
    override func draw(_ rect: CGRect) {
        
        thumbNailView.layer.setNeedsLayout()
    }
    
    func externalSetUp() {
        
        if let imageKey = model.imageKey {

            thumbNailView.loadImageView(imageKey: imageKey)
        }
        loadAdditionalData()
    }
    
    private func loadAdditionalData() {
        
        Task {
            
            do {
                
                if let potObject = try? await APIRequestGlobalObject.shared.getPotForPotDetailAbout(potId: model.id) {
                    
                    model.viewCount = potObject.viewCount
                    model.hashTagList = potObject.hashtagList
                    
                    timeLavel.text = getTimeText(dateString: potObject.expirationDate)
                }

                if let userObject = try? await APIRequestGlobalObject.shared.getUserInfo(userId: Int(model.userId)) {
                    
                    self.userInfo = userObject
                    
                    nickNameLabel.text = userObject.nickname
                }

            }
            
        }
        
    }
    
    override func prepareForReuse() {
        
        thumbNailView.image = nil
        
        timeLavel.text = ""
        nickNameLabel.text = ""
    }
}

extension PotListViewCell {
    
    @objc
    func tapGestureCallBack() {
        
        if let info = userInfo {
            
            let to: [String: Any] = [
                "userInfo" : info,
                "model" : model!
            ]
            
            NotificationCenter.potSelection.post(name: .potFromPotListView, object: to)
            
        } else {
            
            NotificationCenter.potSelection.post(name: .singlePotSelection, object: model!)
        }
    }
    
    func getTimeText(dateString: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        let expirationDate = formatter.date(from: dateString)!
        
        let calendar = Calendar.current
        
        let creationDate = calendar.date(byAdding: .hour, value: -24, to: expirationDate)!
        
        let timeInterval = creationDate.distance(to: Date.now)
        
        let hour = Int(timeInterval / (3600))
        
        if hour > 0 {
            
            return "\(hour)시간 전"
        }
        
        return "방금전"
    }
}
