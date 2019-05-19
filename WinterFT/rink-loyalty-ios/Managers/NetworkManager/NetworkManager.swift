//
//  NetworkManager.swift
//  rink-loyalty-ios
//
//  Created by Timur Shafigullin on 19/02/2019.
//  Copyright © 2019 iOSLab. All rights reserved.
//

import Foundation

class NetworkManager: NSObject {
    enum Router {
        static let wufooBaseUrl = "https://wintertale.wufoo.com/api/v3/forms/m11kexxr16daec2/entries.json"
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
    }

    static func post(parameters: String, completionHandler: @escaping () -> Void) {
        let parameters = "Field1=\(parameters)"

        guard let url = URL(string: Router.wufooBaseUrl) else {
            completionHandler()
            return
        }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: Router.contentType)
        request.addValue("Basic WFpCUC1TV081LUJWOUEtOFFaUjppT1NfRHJlYW1UZWFtITE=", forHTTPHeaderField: Router.authorization)

        request.httpBody = parameters.data(using: .utf8)

        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if response != nil {
                completionHandler()
            }

            if let data = data {
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: [])
                    completionHandler()
                } catch {
                    completionHandler()
                }
            }
        }.resume()
    }
}
