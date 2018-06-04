//
//  MessageSectionController.swift
//  Marslink
//
//  Created by B_Litwin on 6/3/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit
import IGListKit


class MessageSectionController: IGListSectionController {
    var message: Message!
    var cellClass = MessageCell.self
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

extension MessageSectionController: IGListSectionType {
    func numberOfItems() -> Int {
        return 1
    }
    func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        let width = context.containerSize.width
        return MessageCell.cellSize(width: width, text: message.text)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index) as! MessageCell
        cell.messageLabel.text = message.text
        cell.titleLabel.text = message.user.name
        return cell 
    }
    
    func didUpdate(to object: Any) {
        message = object as? Message
    }
    
    func didSelectItem(at index: Int) {}
}
