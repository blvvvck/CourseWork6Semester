//
//  DictionaryReceiver.swift
//  Tools
//
//  Created by Rinat Mukhammetzyanov on 13.03.2018.
//  Copyright © 2018 iOSLab. All rights reserved.
//

import Foundation

public protocol DictionaryReceiver {

    // MARK: - Instance Methods

    func apply(dictionary: [String: Any])
}
