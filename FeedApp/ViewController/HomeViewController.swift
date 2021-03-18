//
//  HomeViewController.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/14/21.
//

import Foundation
import Combine
import UIKit
import MarvelClient

final class HomeViewController: ViewController {
    
    private let itunesRemote = ItunesRemote()
    private let itunesModels = ItunesRemoteModels()
    
    private var cancellables: Set<AnyCancellable> = []
    private var marvelProvider = MarvelProvider()
    let radQueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        itunesRemote.$feedItems.sink { val in
        }.store(in: &cancellables)
    }
}
