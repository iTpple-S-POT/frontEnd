//
//  File.swift
//  
//
//  Created by 최준영 on 2/26/24.
//

import SwiftUI
import DefaultExtensions
import GlobalObjects

class ReactionModel: Equatable {
    
    static func == (lhs: ReactionModel, rhs: ReactionModel) -> Bool {
        lhs.name == rhs.name
    }
    
    var name: String
    var image: Image
    
    /// 서버 전송에 사용
    var reactionType: String
    
    // PopUp data
    var title: String
    var content: String
    
    init(name: String, image: Image, reactionType: String, title: String, content: String) {
        self.name = name
        self.image = image
        self.reactionType = reactionType
        self.title = title
        self.content = content
    }
}

enum SpotReaction {
    
    static let anger = ReactionModel(
        name: "anger",
        image: Image.makeImageFromBundle(bundle: .module, name: "Anger", ext: .png),
        reactionType: "ANGRY",
        title: "화나요!",
        content: "화난 POT을 공유해 줬어요"
    )
    
    static let like = ReactionModel(
        name: "like",
        image: Image.makeImageFromBundle(bundle: .module, name: "Like", ext: .png),
        reactionType: "GOOD",
        title: "재밌어요!",
        content: "재밌는 POT을 공유해 줬어요"
    )
    
    static let sad = ReactionModel(
        name: "sad",
        image: Image.makeImageFromBundle(bundle: .module, name: "Sad", ext: .png),
        reactionType: "SAD",
        title: "슬퍼요!",
        content: "슬픈 POT을 공유해 줬어요"
    )
    
    static let heart = ReactionModel(
        name: "heart",
        image: Image.makeImageFromBundle(bundle: .module, name: "Heart", ext: .png),
        reactionType: "HEART",
        title: "좋아요!",
        content: "좋은 POT을 공유해 줬어요"
    )
    
    static let smile = ReactionModel(
        name: "smile",
        image: Image.makeImageFromBundle(bundle: .module, name: "Smile", ext: .png),
        reactionType: "SMILE",
        title: "재밌어요!",
        content: "재밌는 POT을 공유해 줬어요"
    )
    
}
