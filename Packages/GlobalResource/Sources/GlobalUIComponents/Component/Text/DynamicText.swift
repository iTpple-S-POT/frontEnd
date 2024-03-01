//
//  File.swift
//  
//
//  Created by 최준영 on 2/25/24.
//

import SwiftUI

public struct DynamicText: View {
    
    var content: String
    
    var textColor: UIColor
    
    var weight: UIFont.Weight
    
    var lineCount: Int
    
    var kern: CGFloat
    
    var linespacing: CGFloat
    
    var textAlignment: NSTextAlignment
    
    public init(_ content: String, textColor: UIColor = .black, weight: UIFont.Weight = .regular, lineCount: Int = 1, kern: CGFloat = 0, linespacing: CGFloat = 5, textAlignment: NSTextAlignment = .left) {
        
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.content = trimmed.reduce("") { partialResult, char in
            if char == "\n" {
                return partialResult + " "
            } else {
                return partialResult + String(char)
            }
        }
        self.textColor = textColor
        self.weight = weight
        self.lineCount = lineCount
        self.kern = kern
        self.linespacing = linespacing
        self.textAlignment = textAlignment
    }
    
    public var body: some View {
        
        GeometryReader { geo in
            
            UILabelRepresentable(
                content,
                textColor: textColor,
                weight: weight,
                viewSize: geo.size,
                lineCount: lineCount,
                kern: kern,
                linespacing: linespacing, 
                textAlignment: textAlignment
            )
        }
        
    }
    
}

private extension DynamicText {
    
    class StringCoordinator {
        
        // Attrs
        var stringAttributes: [NSMutableAttributedString.Key : Any] = [:]
        
    }
    
    struct UILabelRepresentable: UIViewRepresentable {
        
        var content: String
        
        var textColor: UIColor
        
        var viewSize: CGSize
        
        var lineCount: Int
        
        var font: UIFont
        
        var kern: CGFloat
        
        var linespacing: CGFloat
        
        var textAlignment: NSTextAlignment
        
        private let textView: UITextView = {
            let textView = UITextView()
            
            textView.textColor = .white
            textView.backgroundColor = .clear
            textView.textContainer.lineBreakMode = .byCharWrapping
            textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            textView.textContainer.lineFragmentPadding = 0
            textView.isUserInteractionEnabled = false
            textView.isSelectable = false
            textView.isEditable = false
            
            return textView
        }()
        
        init(_ content: String, textColor: UIColor, weight: UIFont.Weight, viewSize: CGSize, lineCount: Int, kern: CGFloat = 0.0, linespacing: CGFloat = 5.0, textAlignment: NSTextAlignment = .left) {
            self.content = content
            self.textColor = textColor
            self.viewSize = viewSize
            self.lineCount = lineCount
            self.font = .systemFont(ofSize: 0.1, weight: weight)
            self.kern = kern
            self.linespacing = linespacing
            self.textAlignment = textAlignment
        }
        
        func makeUIView(context: Context) -> UITextView {
            
            let coordinator = context.coordinator
            
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = linespacing
            style.alignment = textAlignment
            
            coordinator.stringAttributes = [
                .font : self.font,
                .kern : self.kern,
                .paragraphStyle : style
            ]
            
            textView.bounds.size = viewSize
            
            return textView
        }
        
        func updateUIView(_ uiView: UITextView, context: Context) {
            
            let coordinator = context.coordinator
            var prevFont: UIFont = font
            var newFont: UIFont = font
            
            while(true) {
                newFont = prevFont.withSize(prevFont.pointSize+0.1)
                
                coordinator.stringAttributes[.font] = newFont
                coordinator.stringAttributes[.foregroundColor] = self.textColor
                
                var errorInset: CGSize = .zero
                
                if lineCount >= 2 {
                    errorInset = "한".size(withAttributes: coordinator.stringAttributes)
                }

                let textSize = content.size(withAttributes: coordinator.stringAttributes)
                
                // 가로영역이 더 커지거나 세로영역이 더커지는 경우 그전 조정값이 가장 적절한 조정값이다.
                if textSize.width > viewSize.width*CGFloat(lineCount)-errorInset.width || textSize.height > viewSize.height/CGFloat(lineCount) - linespacing*CGFloat(lineCount-1) {
                    
                    coordinator.stringAttributes[.font] = prevFont
                    
                    // 수직적 정렬을 위해 높이를 파악하여 패딩을 추가한다.
                    let textHeight = content.size(withAttributes: coordinator.stringAttributes).height * CGFloat(lineCount) + linespacing * CGFloat(lineCount-1)
                    let verticalPadding = (viewSize.height - textHeight)/2
                    
                    uiView.textContainerInset.top = verticalPadding
                    
                    let attributedString = NSMutableAttributedString(string: content)
                    
                    let stringRange = NSRange(location: 0, length: attributedString.length)
                    
                    attributedString.addAttributes(coordinator.stringAttributes, range: stringRange)

                    uiView.attributedText = attributedString
                    
                    break
                }
                
                prevFont = newFont
            }
        }
        
        func makeCoordinator() -> StringCoordinator {
            StringCoordinator()
        }
        
        typealias UIViewType = UITextView
    }
}



#Preview {
    
    DynamicText("안녕하세요 반갑습니다 다음에 또만날수 있다면 정말 좋을 것 같아요!!!!", lineCount: 1)
        .frame(width: 300, height: 64)
        .border(.red)
    
}
