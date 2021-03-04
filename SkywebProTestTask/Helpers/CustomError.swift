//
//  CustomError.swift
//  SkywebProTestTask
//
//  Created by Ярослав Карпунькин on 04.03.2021.
//

import Foundation
import UIKit

enum CustomError {
    case APIError
    case parsingError
    case incorrectUrl
}

extension CustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .APIError:
            return NSLocalizedString("Server error.", comment: "")
        case .parsingError:
            return NSLocalizedString("Can't decode data", comment: "")
        case .incorrectUrl:
            return NSLocalizedString("Incorrect URL", comment: "")
        }
    }
}

