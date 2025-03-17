//
//  Router.swift
//  Mytask
//
//  Created by Vineet Rai on 17-Mar-25.
//

import SwiftUI

enum Route: Hashable {
    case addTask
    case settings
}

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
