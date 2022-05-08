//
// Created by Engineering on 04/05/22.
//

import Foundation
import RxSwift

protocol UserDetailViewModelDelegate: AnyObject {
    func onFinishFetch()
}

protocol UserDetailViewModel: AnyObject {
    var errors: Observable<Error> { get }
    var albums: Observable<[Domain.AlbumEntity]> { get }
    var delegate: UserDetailViewModelDelegate? { get set }

    func refreshPage(userId: Int)
    func getAlbum(userId: Int)
}