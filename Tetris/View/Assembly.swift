final class Assembly {
    func assemble() -> ViewController {
        var gameCoordinator = GameAssembly().assemble()
        
        let presenter = Presenter(gameCoordinator: gameCoordinator)
        gameCoordinator.delegate = presenter
        
        let viewController = ViewController()
        presenter.view = viewController
        viewController.output = presenter
        
        return viewController
    }
}
