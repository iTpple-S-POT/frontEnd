//
//  PotListViewCell.swift
//  MainScreenUI
//
//  Created by 최준영 on 2/23/24.
//

import GlobalObjects
import UIKit

class PotListViewCell: UICollectionViewCell {
    
    var model: PotModel!
    
    private var isImageInitialized = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var thumbNailView: UIImageView = {
        
        let view = UIImageView()
        
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    private var nickNameLabel: UILabel = {
        
        let view = UILabel()
        
        view.text = "닉네임"
        
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
        
        view.text = "1시간 전"
        
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
        
        loadImageView()
    }
    
    func loadImageView() {
        
        guard let imageKey = model.imageKey, !isImageInitialized else {
            
            return;
        }
        
        isImageInitialized = true
        
        let url = URL(string: imageKey.getPreSignedUrlString())
        
//        let processor = DownsamplingImageProcessor(size: self.bounds.size)
        
        thumbNailView.kf.indicatorType = .none
        thumbNailView.kf.setImage(
            with: url,
            options: [
//                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.1)),
                .cacheOriginalImage,
            ]) {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    override func prepareForReuse() {
        
        thumbNailView.image = nil
        
        isImageInitialized = false
    }
}

extension PotListViewCell {
    
    @objc
    func tapGestureCallBack() {
        
        NotificationCenter.potSelection.post(name: .singlePotSelection, object: model)
    }
}
