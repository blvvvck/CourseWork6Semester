//
//  AlertModel.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 07/02/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import UIKit

public struct ActionSheetModel {
    public enum Style {
        case normal
        case cancel
        case destructive
        
        public var alertActionStyle: UIAlertAction.Style {
            switch self {
            case .normal:
                return .default
            case .cancel:
                return .cancel
            case .destructive:
                return .destructive
            }
        }
    }
    
    public let title: String
    public let style: Style
    public let action: () -> Void
    
    public init(title: String, style: Style, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
}
