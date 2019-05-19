//
//  AlertHandler.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 07/02/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import UIKit

public protocol ActionSheetCoordinator {
    func openActionSheet(
        with title: String?,
        message: String?,
        models: [ActionSheetModel]
        ) -> UIViewController
}


public final class ActionSheetCoordinatorImp {
    public init() {}
}

extension ActionSheetCoordinatorImp: ActionSheetCoordinator {
    public func openActionSheet(
        with title: String?,
        message: String?,
        models: [ActionSheetModel]
        ) -> UIViewController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        models.forEach { model in
            let action = UIAlertAction(title: model.title, style: model.style.alertActionStyle, handler: { _ in
                model.action()
            })
            alertController.addAction(action)
        }
        
        return alertController
    }
}
