//
//  InstruccionesViewController.swift
//  Wordle-5B
//
//  Created by mac on 27/03/25.
//

import UIKit

class InstruccionesViewController: UIViewController {

    @IBOutlet weak var instruccionesTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        instruccionesTextView.text = """
        📜 Instrucciones del Juego Wordle

        🔹 Objetivo del Juego
        Adivina la palabra oculta en un máximo de 6 intentos.

        🔹 Cómo Jugar
        1. Escribe una palabra válida con la cantidad correcta de letras.
        2. Presiona Enter para validar tu intento.
        3. Los colores de las letras te ayudarán:
           🟩 Verde: Letra en la posición correcta.
           🟨 Amarillo: Letra en la palabra, pero en otra posición.
           ⬜ Gris: Letra no está en la palabra.
        4. Usa la retroalimentación para mejorar tus intentos.

        🔹 Consejos
        - Comienza con palabras que usen vocales y consonantes comunes.
        - Observa las pistas de colores para reducir posibilidades.
        - Prueba diferentes combinaciones si te quedas atascado.

        ¡Buena suerte! 🎉
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
