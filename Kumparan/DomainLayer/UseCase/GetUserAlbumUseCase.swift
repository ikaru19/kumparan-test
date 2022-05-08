//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift

protocol GetUserAlbumUseCase: AnyObject {
    func execute(userId: Int) -> Single<[Domain.AlbumEntity]>
}