import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var btnJugar: UIButton!
    @IBOutlet weak var btnRecords: UIButton!
    @IBOutlet weak var btnInstrucciones: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Asignamos acciones a los botones
        btnJugar.addTarget(self, action: #selector(irAJugar), for: .touchUpInside)
        btnRecords.addTarget(self, action: #selector(irARecords), for: .touchUpInside)
    }

    @objc func irAJugar() {
        navegarA(pantalla: "PlayVC")
    }

    @objc func irARecords() {
        navegarA(pantalla: "RecordsVC")
    }

    func navegarA(pantalla: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: pantalla)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }


}
