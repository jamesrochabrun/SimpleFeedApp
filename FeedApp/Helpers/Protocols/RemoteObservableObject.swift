//
//  RemoteObservableObject.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/22/21.
//

import Foundation

/// Protocol that allows instantiation on a generic constraint
protocol RemoteObservableObject : ObservableObject {
    init()
}
extension ItunesRemote: RemoteObservableObject {}
extension MarvelRemote: RemoteObservableObject {}
