import UIKit

final class TabBarController: UITabBarController {

    
    private let profileTabBarItem = UITabBarItem(
        title: "Профиль",
        image: UIImage(named: "profileItem"),
        selectedImage: nil)
    
    private let catalogTabBarItem = UITabBarItem(
        title: "Каталог",
        image: UIImage(named: "catalogItem"),
        selectedImage: nil)
    
    private let cartTabBarItem = UITabBarItem(
        title: "Корзина",
        image: UIImage(named: "cartItem"),
        selectedImage: nil)
    
    private let statisticTabBarItem = UITabBarItem(
        title: "Статистика",
        image: UIImage(named: "statisticItem"),
        selectedImage: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        tabBar.backgroundColor = UIColor(named: "YPWhite")
        tabBar.unselectedItemTintColor = UIColor(named: "YPBlack")
        tabBar.tintColor = UIColor(named: "YPBlue")
        addTabBarItems()
    }
    
    private func addTabBarItems(){
        
        let profileViewController = ProfileViewController()

        profileViewController.tabBarItem = profileTabBarItem
        
        self.viewControllers = [profileViewController]
    }
}
