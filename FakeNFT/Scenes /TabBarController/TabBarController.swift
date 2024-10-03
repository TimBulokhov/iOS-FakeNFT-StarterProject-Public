import UIKit

final class TabBarController: UITabBarController {
    private var servicesAssembly: ServicesAssembly
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
    }
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beenn implementad")
    }
    
    private func createTabBar() {
        view.backgroundColor = .systemBackground
        let catalogueVC = UINavigationController(rootViewController: CatalogueViewController(servicesAssembly: servicesAssembly))
        catalogueVC.tabBarItem = UITabBarItem(
            title: "Каталог",
            image: UIImage(named: "Catalogue"),
            selectedImage: UIImage(named: "CatalogueSelected")
        )
        
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(named: "Profile"),
            selectedImage:  UIImage(named: "ProfileSelected")
        )
        
        
        let basketVC = UINavigationController(rootViewController: BasketViewController())
        basketVC.tabBarItem = UITabBarItem(
            title: "Корзина" ,
            image: UIImage(named: "Basket"),
            selectedImage: UIImage(named: "BasketSelected")
        )
        
        let statisticVC = UINavigationController(rootViewController: StatisticViewController())
        statisticVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "Statistic"),
            selectedImage: UIImage(named: "StatisticSelected")
        )
        
        
        viewControllers = [profileVC, catalogueVC, basketVC, statisticVC]
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .black
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .white
    }
}
