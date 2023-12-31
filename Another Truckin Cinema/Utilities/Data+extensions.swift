//
//  Data+extensions.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 11/18/23.
//

import Foundation


extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
            guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
                  let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
                  let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

            let result = prettyPrintedString.replacingOccurrences(of: #"\"#, with: "") as NSString?
            return result
        }
}
