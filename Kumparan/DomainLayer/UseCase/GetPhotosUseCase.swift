//
// Created by Engineering on 08/05/22.
//

import Foundation
import RxSwift

protocol GetPhotosUseCase: AnyObject {
    func execute(albumId: Int) -> Single<[Domain.PhotoEntity]>
}