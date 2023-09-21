//
//  CircleTabbarController.swift
//  DalilApp
//
//  Created by Hady on 8/8/23.
//  Copyright © 2023 Hady. All rights reserved.
//

import UIKit

struct TabBarImages {
    // TabBarItem images
    static let homeSelected    = #imageLiteral(resourceName: "home_selected")
    static let chatSelected    = #imageLiteral(resourceName: "chat_selected")
    static let quizzedSelected = #imageLiteral(resourceName: "quizzes_selected")
     
    static let homeUnselected    = #imageLiteral(resourceName: "tabBar_home")
    static let chatUnselected    = #imageLiteral(resourceName: "tapbar_chat")
    static let quizzesUnSelected = #imageLiteral(resourceName: "tapBar_quiezzes")
}


class CircleTabbarController: UITabBarController {

    static var radius: CGFloat = 18
    
    var middleBtn: UIButton!
    var middleBtn2: UIButton!
    
    var isSetup = false
    
    lazy var firstItmeSelection  = SelectFirstItem(tabBar: tabBar)
    lazy var secondItemSelection = SelectSecondItem(tabBar: tabBar)
    lazy var thirdItemSelection  = SelectThirdItem(tabBar: tabBar)
    
    lazy var selectionStrategy  = SelectItemStrategy(strategy: secondItemSelection, circleButton: middleBtn) //Start with second item

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isSetup == false { //Flag so we don't repeat below code every view layout
            self.isSetup = true
            self.tabBar.isTranslucent = true
            self.tabBar.barStyle = .default
            self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.tabBar.layer.borderColor = #colorLiteral(red: 0.5607843137, green: 0.5607843137, blue: 0.5607843137, alpha: 1)
            self.tabBar.layer.borderWidth = 0.01
            self.setupMiddleButton()
            //self.setupFirstButton()

            menuButtonAction(sender: UIButton())
        }
        
        if middleBtn2 != nil {
            if self.tabBar.isHidden == true {
                self.middleBtn2.alpha = 0
            }else {
                self.middleBtn2.alpha = 1
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        guard let circleTabBar = tabBar as? CircleTabbar else { return }
        
        var itemViews = tabBar.subviews.compactMap{$0.frame.width}
        itemViews = itemViews.sorted{$0 < $1}
        
        
        let tabBarItemWidth = itemViews.last ?? 0.0 //Pick bigger tapbar item
        
        let totalItemsWidth = tabBarItemWidth * CGFloat(tabBar.items?.count ?? 1) //3 tabBar items
        let emptySpace      = tabBar.frame.width - totalItemsWidth
        
        //middleBtn default location in the middle tabbar (considirng odd tabbar item count number
        if item == (tabBar.items!)[0]{
            
            let tranformX = CGAffineTransform(translationX: -tabBarItemWidth - (emptySpace / 2), y: 0.0)
            changeMiddleButtonLocation(tranformX, tabBarItemWidth / 2)
            
            selectionStrategy.changeTo(strategy: firstItmeSelection)
            selectionStrategy.selectTabBarItem()
            
        } else if item == (tabBar.items!)[1] {
//            UIView.animate(withDuration: 0.40) {
//                self.middleBtn.transform = .identity
//            }
//            circleTabBar.addShape(circleCenter: nil)
            
        
            changeMiddleButtonLocation(.identity, nil)
            
            selectionStrategy.changeTo(strategy: secondItemSelection)
            selectionStrategy.selectTabBarItem()
            
        } else if item == (tabBar.items!)[2] {
            let tranformX = CGAffineTransform(translationX: tabBarItemWidth + (emptySpace / 2), y: 0.0)
//            UIView.animate(withDuration: 0.40) {
//                self.middleBtn.transform = tranformX
//                circleTabBar.addShape(circleCenter: tabBar.frame.width - (tabBarItemWidth / 2))
//            }
            
            let circleCenterWidth = tabBar.frame.width - (tabBarItemWidth / 2)
            changeMiddleButtonLocation(tranformX, circleCenterWidth)
            
            selectionStrategy.changeTo(strategy: thirdItemSelection)
            selectionStrategy.selectTabBarItem()
            
        }
        
        
    }

    fileprivate func changeMiddleButtonLocation(_ tranformX: CGAffineTransform, _ circleCenterWidth: CGFloat?) {
        guard let circleTabBar = self.tabBar as? CircleTabbar else {return}
        UIView.animate(withDuration: 0.40) { [weak self] in
            self?.middleBtn.transform = tranformX
            circleTabBar.addShape(circleCenter: circleCenterWidth )
        }
    }
    
}




extension CircleTabbarController {
    
    //setup Middle Button
    func setupMiddleButton() {
        
        middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-40, y: -50, width: 80, height: 80))

        //STYLE THE BUTTON YOUR OWN WAY
        
        //
        middleBtn.setBackgroundImage(UIImage(named: "home_bar"), for: .normal)
        //add to the tabbar and add click event
        self.tabBar.addSubview(middleBtn)
        middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)

        self.view.layoutIfNeeded()
        hanldeClick()
    }
    
    //this function for handle clicked on half button that exist outer of tabbar
    func hanldeClick() {
        let menuButton = UIButton(frame: CGRect(x:0, y: 0, width: 120, height: 120))
        
        var menuButtonFrame = menuButton.frame
        let window = CircleTabbar.window
        menuButtonFrame.origin.y = (view.bounds.height - menuButtonFrame.height) - (window?.safeAreaInsets.bottom ?? 0) + 5
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        self.view.addSubview(menuButton)
        self.view.bringSubviewToFront(menuButton)
        
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        middleBtn2 = menuButton
        self.view.layoutIfNeeded()
    }
    
    @objc func menuButtonAction(sender: UIButton) {
        if middleBtn != nil {
            middleBtn.setBackgroundImage(UIImage(named: "home_bar"), for: .normal)
        }

        self.selectedIndex = 1
        
        UIView.animate(withDuration: 0.40) {
            self.middleBtn.transform = .identity
        }
        
        let circleTabBar = tabBar as! CircleTabbar
        circleTabBar.addShape(circleCenter: nil)
        middleBtn.setBackgroundImage(TabBarImages.homeSelected, for: .normal)
        
        tabBar.items?[1].image = nil
        
        let quizeItem = tabBar.items?[2]
        quizeItem?.image = TabBarImages.quizzesUnSelected
        
        let chatITem = tabBar.items?[0]
        chatITem?.image = TabBarImages.chatUnselected

    }
    
    
    //setup Middle Button
     func setupFirstButton() {
        let fullWidth = self.tabBar.frame.width / 3
//        let lang = UserDefaults.standard.object(forKey: "loclz") as? String
         let x = (self.tabBar.frame.size.width - fullWidth)
         //STYLE THE BUTTON YOUR OWN WAY
         let firstBtn = UIButton(frame: CGRect(x: x , y: 0, width: fullWidth, height: 60))
         //add to the tabbar and add click event
        self.tabBar.addSubview(firstBtn)
        self.view.layoutIfNeeded()
        firstBtn.addTarget(self, action: #selector(menuFirstButtonAction(sender:)), for: .touchUpInside)
    }

    @objc func menuFirstButtonAction(sender: UIButton) {
        
//        moreOption()
        
        
     }


}

