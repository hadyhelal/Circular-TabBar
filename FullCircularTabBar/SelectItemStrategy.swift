//
//  SelectItemStrategy.swift
//  FullCircularTabBar
//
//  Created by Hady on 08/09/2023.
//

import UIKit

//Utilized Strategy design pattern to do same selection with different tabs

protocol ChangeSelection {
    func changeSelection(toButton middleBtn: UIButton)
}


class SelectFirstItem: ChangeSelection {
    
    let tabBar: UITabBar
    
    init(tabBar: UITabBar) {
        self.tabBar = tabBar
    }
    
    func changeSelection(toButton middleBtn: UIButton) {
        middleBtn.setBackgroundImage(TabBarImages.cartSelected, for: .normal)
        tabBar.items![0].image = nil
        
        let homeItem = tabBar.items?[1]
        homeItem?.image = TabBarImages.homeUnselected
        
        let quizeItem = tabBar.items?[2]
        quizeItem?.image = TabBarImages.orderUnSelected
    }
}


class SelectSecondItem: ChangeSelection {
    
    let tabBar: UITabBar
    
    init(tabBar: UITabBar) {
        self.tabBar = tabBar
    }
    
    func changeSelection(toButton middleBtn: UIButton) {
        middleBtn.setBackgroundImage(TabBarImages.homeSelected, for: .normal)

        tabBar.items![1].image = nil

        let quizeItem = tabBar.items?[2]
        quizeItem?.image = TabBarImages.orderUnSelected
        
        let chatITem = tabBar.items?[0]
        chatITem?.image = TabBarImages.cartUnselected
    }
}


class SelectThirdItem: ChangeSelection {
    
    let tabBar: UITabBar
    
    init(tabBar: UITabBar) {
        self.tabBar = tabBar
    }
    
    func changeSelection(toButton middleBtn: UIButton) {
        middleBtn.setBackgroundImage(TabBarImages.orderSelected, for: .normal)
        
        tabBar.items![2].image = nil
        
        let homeItem = tabBar.items?[1]
        homeItem?.image = TabBarImages.homeUnselected
        
        let chatITem = tabBar.items?[0]
        chatITem?.image = TabBarImages.cartUnselected
    }
}


//MARK: -Strategy class for Strategy Design pattern
class SelectItemStrategy {
    
    var strategy: ChangeSelection
    let circleButton: UIButton
    
    init(strategy: ChangeSelection, circleButton: UIButton) {
        self.strategy = strategy
        self.circleButton = circleButton
    }
    
    
    func selectTabBarItem() {
        strategy.changeSelection(toButton: circleButton)
    }
    
    func changeTo(strategy: ChangeSelection) {
        self.strategy = strategy
    }
}
