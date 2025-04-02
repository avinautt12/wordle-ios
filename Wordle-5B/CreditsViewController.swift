//
//  CreditsViewController.swift
//  Wordle-5B
//
//  Created by mac on 26/03/25.
//

import UIKit

class CreditsViewController: UIViewController {
    
    @IBOutlet weak var infoTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        infoTextView.text = """
        📌 **Información del Proyecto**  

        👨‍🎓 **Nombres de los Alumnos**  
        - Carlos Enrique Centeno Avalos - 22170028  
        - Andre Luciano Aviña Padilla - 23170123  

        📚 **Materia**  
        Desarrollo Móvil Multiplataforma  

        👨‍🏫 **Profesor**  
        M.C. Burciaga Pérez Jesús Adrián  
        """
        
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
