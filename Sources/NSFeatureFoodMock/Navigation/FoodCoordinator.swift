//
//  FoodCoordinator.swift
//  NSFeatureFoodMock
//
//  Created by apple on 12/07/26.
//

import SwiftData
import SwiftUI
import NammaAppUI

@MainActor
struct FoodViewFactory {
    @ViewBuilder
    func buildPage(_ page: FoodCoordinatorPage) -> some View {
        switch page {
        case .landingView(let foodViewModel):
            FoodLandingView(foodViewModel: foodViewModel)
        }
    }
    
    @ViewBuilder
    func buildSheet(_ sheet: FoodCoordinatorSheet) -> some View {
        EmptyView()
    }
    
    @ViewBuilder
    func buildCover(_ cover: FoodCoordinatorCover) -> some View {
        EmptyView()
    }
}

enum FoodCoordinatorPage: Hashable {
    case landingView(FoodViewModel)
}

enum FoodCoordinatorSheet: String, Identifiable {
    var id: String { rawValue }
    case noSheet
}

enum FoodCoordinatorCover: String, Identifiable {
    var id: String { rawValue }
    case noCover
}

extension EnvironmentValues {
    @Entry var FoodCoordinator: FoodCoordinator?
    @Entry var FoodViewModel: FoodViewModel?
}

@Observable
class FoodCoordinator: NSObject {
    var path: NavigationPath = NavigationPath()
    var sheet: FoodCoordinatorSheet?
    var cover: FoodCoordinatorCover?
    private(set) var currenScreen: [FoodCoordinatorPage] = []
    
    func push(page: FoodCoordinatorPage) {
        currenScreen.append(page)
        path.append(page)
    }
    
    func pop(_ last: Int = 1) {
        currenScreen.removeLast()
        path.removeLast(last)
    }
    
    func popToRoot() {
        currenScreen.removeAll()
        path.removeLast(path.count)
    }
    
    func present(sheet: FoodCoordinatorSheet) {
        self.sheet = sheet
    }
    
    func present(cover: FoodCoordinatorCover) {
        self.cover = cover
    }
    
    func popSheet() {
        withAnimation(.spring()) {
            self.sheet = nil
        }
    }
    
    func popCover() {
        self.cover = nil
    }
}

public struct FoodCoordinatorView: View {
    @State
    private var foodCoordinator = FoodCoordinator()
    @State
    private var foodViewModel: FoodViewModel = FoodViewModel()
    @State
    private var appTheme = AppThemeManager.shared
    
    let foodViewFactory: FoodViewFactory = FoodViewFactory()
    
    public init() {}
    
    public var body: some View {
        foodViewFactory.buildPage(.landingView(foodViewModel))
            .navigationDestination(for: FoodCoordinatorPage.self) {
                foodViewFactory.buildPage($0)
            }
            .sheet(item: $foodCoordinator.sheet) { foodViewFactory.buildSheet($0).presentationBackground(appTheme.current.secondary).presentationDetents([.medium]).presentationCornerRadius(24)
            }
            .fullScreenCover(item: $foodCoordinator.cover) {
                foodViewFactory.buildCover($0)
            }
    }
}
