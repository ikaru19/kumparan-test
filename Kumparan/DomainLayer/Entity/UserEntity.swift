//
// Created by Engineering on 04/05/22.
//

import Foundation

extension Domain {
    struct UserEntity {
        var id: String
        var name: String?
        var username: String?
        var email: String?
        var phone: String?
        var website: String?
        var company: Company?
        var address: Address?
    }
}