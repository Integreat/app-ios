extension Page {
    
    @objc
    func descriptionTextIncludingExcerpt(shouldIncludeExcerpt: Bool) -> NSAttributedString {
        let text = NSMutableAttributedString()
        
        let style = NSMutableParagraphStyle()
        style.alignment = { () -> NSTextAlignment in
            switch self.language?.resourceName {
            case ("ar"?): return .Right
            default: return .Left
            }
        }()
        
        if let title = title, attributedTitle = TextUtils.attributedStringWithHtml(title) {
            text.appendAttributedString(attributedTitle)
            let attributes = [
                NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline),
                NSForegroundColorAttributeName: UIColor(white: 0.2, alpha: 1),
                NSParagraphStyleAttributeName: style
            ]
            let range = NSMakeRange(0, attributedTitle.length)
            text.setAttributes(attributes, range: range)
        }
        
        if title != nil && excerpt != nil && shouldIncludeExcerpt {
            text.appendAttributedString(NSAttributedString(string: "\n", attributes: [
                NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody),
                NSForegroundColorAttributeName: UIColor(white: 0, alpha: 0)
            ]))
        }
        
        if let excerpt = excerpt, attributedExcerpt = TextUtils.attributedStringWithHtml(excerpt) where shouldIncludeExcerpt {
            let range = NSMakeRange(text.length, attributedExcerpt.length)
            text.appendAttributedString(attributedExcerpt)
            let attributes = [
                NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote),
                NSForegroundColorAttributeName: UIColor(white: 0.4, alpha: 1),
                NSParagraphStyleAttributeName: style
            ]
            text.setAttributes(attributes, range: range)
        }
        
        return text.copy() as! NSAttributedString
    }
    
}
