//
//  SplashScreenViewController.swift
//  Wordle-5B
//
//  Created by mac on 26/03/25.
//

import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var logoImageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageview.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height)

        UIView.animate(withDuration: 2.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.logoImageview.transform = .identity
        }) { _ in
            self.goToGameScreen()
        }
    }
    
    func goToGameScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let gameVC = storyboard.instantiateViewController(withIdentifier: "GameVC") as? GameViewController {
            gameVC.modalTransitionStyle = .crossDissolve
            gameVC.modalPresentationStyle = .fullScreen
            self.present(gameVC, animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
