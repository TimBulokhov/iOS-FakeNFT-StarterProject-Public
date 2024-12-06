import UIKit

final class TabBarController: UITabBarController {

    private var servicesAssembly: ServicesAssembly
    
    private let profileTabBarItem = UITabBarItem(
        title: "Профиль",
        image: UIImage(named: "profileItem"),
        selectedImage: nil)
    
    private let catalogueTabBarItem = UITabBarItem(
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
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPWhite")
        tabBar.backgroundColor = UIColor(named: "YPWhite")
        tabBar.unselectedItemTintColor = UIColor(named: "YPBlack")
        tabBar.tintColor = UIColor(named: "YPBlue")
        addTabBarItems()
    }
    
    private func addTabBarItems(){
        
        let profileViewController = ProfileViewController(servicesAssembly: servicesAssembly)
        profileViewController.tabBarItem = profileTabBarItem
        
        let catalogueViewController = CatalogueViewController(servicesAssembly: servicesAssembly)
        catalogueViewController.tabBarItem = catalogueTabBarItem
        
        let cartViewController = CartViewController(servicesAssembly: servicesAssembly)
        cartViewController.tabBarItem = cartTabBarItem
        
        let statisticViewController = StatisticViewController(servicesAssembly: servicesAssembly)
        statisticViewController.tabBarItem = statisticTabBarItem
        
        self.viewControllers = [profileViewController, catalogueViewController, cartViewController, statisticViewController]
    }
}
