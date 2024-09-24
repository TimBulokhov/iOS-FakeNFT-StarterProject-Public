import UIKit

final class TabBarController: UITabBarController {
    
    private let catalogTabBarItem = UITabBarItem(title: NSLocalizedString("Tab.catalog", comment: ""), image: UIImage(systemName: "rectangle.stack.fill"), tag: 0)
    private let profileTabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.crop.circle.fill"), tag: 0)
    private let cartTabBarItem = UITabBarItem(title: "Корзина", image: UIImage(named:"basketTabIcon"), tag: 0)
    private let statisticTabBarItem = UITabBarItem(title: "Статистика", image: UIImage(systemName: "flag.2.crossed.fill"), tag: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.unselectedItemTintColor = .black
        profileController.tabBarItem = profileTabBarItem
        catalogController.tabBarItem = catalogTabBarItem
        cartController.tabBarItem = cartTabBarItem
        statisticController.tabBarItem = statisticTabBarItem
        viewControllers = [profileController, catalogController, cartController, statisticController]
        
        view.backgroundColor = .systemBackground
    }
    
    let catalogController = TestCatalogViewController()
    let profileController = ProfileVC()
    let cartController = CartVC()
    let statisticController = StatisticVC()
}
