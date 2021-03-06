//----------------------//----------------------
import UIKit
//----------------------//----------------------
class ViewController: UIViewController {
    // Label que va garder Bonne Chance e tous les resultats du jue
    @IBOutlet weak var tempLabel: UILabel!
    
    //---
    // Premiere partes des conections imagevew des cartes que aparece na animacao. C'est le found des cartes.
    // Les slots vont recevois tous les autres images qui resterent visible.
    @IBOutlet weak var slot_1: UIImageView!
    @IBOutlet weak var slot_2: UIImageView!
    @IBOutlet weak var slot_3: UIImageView!
    @IBOutlet weak var slot_4: UIImageView!
    @IBOutlet weak var slot_5: UIImageView!
    
    //---
    // Variable qui va créer les images. Images de cartes d'animation. 5 images floues.
    var card_blur_1: UIImage!
    var card_blur_2: UIImage!
    var card_blur_3: UIImage!
    var card_blur_4: UIImage!
    var card_blur_5: UIImage!
    
    //---
    // Conections UIview du background. Ils vont garder tous les autres images a partir du click du bouton. Ils vont disparer les autres commands.
    @IBOutlet weak var bg_1: UIView!
    @IBOutlet weak var bg_2: UIView!
    @IBOutlet weak var bg_3: UIView!
    @IBOutlet weak var bg_4: UIView!
    @IBOutlet weak var bg_5: UIView!
    
    //---
    // Conection UIlabel responsable pour les commands garder les cartes séelectionnées.
    @IBOutlet weak var keep_1: UILabel!
    @IBOutlet weak var keep_2: UILabel!
    @IBOutlet weak var keep_3: UILabel!
    @IBOutlet weak var keep_4: UILabel!
    @IBOutlet weak var keep_5: UILabel!
    
    //---
    // 3 connexions. Le premier est le bouton qui distribuera les mises 25, 100 et tous les paris.
    // Le second est un objet texte de l'étiquette de type qui va combiner les crédits capables d'afficher des crédits.
    // Le 3 betlabel est le bouton distribuer.
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!

    //---
    // Différentes parties des tables de code.
    // Animations des images flou
    var arrOfCardImages: [UIImage]!
    
    //---
    // Animation des imageview slots
    var arrOfSlotImageViews: [UIImageView]!
    
    //---
    // sont les deux tables de lettres vides.
    // Chacun représentera les cartes. 52 lettres.
    // Int represent le chiffre de la carte et string qui represente le sorte de la carte.
    var deckOfCards = [(Int, String)]()
    
    //---
    // Tableaux de arrier plain do UIview des backgrounds.
    // On utilise plusiers tableaux pour reagruper et utilise le boucle pour repeter tous elements du tableaux.
    var arrOfBackgrounds: [UIView]!
    
    //---
    // Label qui represente le mot garder.
    var arrOfKeepLabels: [UILabel]!
    
    //---
    // Methode que va appeler le user defaults manager ----- USER DEFAULTS MANAGER -------------
    let saveScore = UserDefaultsManager()

    //---
    // Variable que va faire la gestion si peux ou no selectioner les cartes.
    var permissionToSelectCards = false
    
    // Variable pour la mise le bet
    var bet = 0
    
   // Variable de crédits. il est défini que la valeur initiale sera 2 mille.
    var credits = 2000
    
    //---
    // La variable Chance est responsable de la gestion quand le joueur peut commencer la partie.
    var chances = 2
    
    // Constante pour instanctiation du objet. Analiser le main
    let pokerHands = PokerHands()
    
    //---
    // Tableaux de Tuple que contain le meme type de element
    var handToAnalyse = [(0, ""), (0, ""), (0, ""), (0, ""), (0, "")]
    
    //---
    // theHand est une variable globale
    var theHand = [(Int, String)]()
    //----------------------//----------------------

    //------
    // C'est le methode qui dit lorsque le document est prêt dans la interface
    override func viewDidLoad() {

    //---
    super.viewDidLoad()
    
    //---
    // Il va commander le objet du User Defaults Manager.
    // USER DEFAULTS MANAGER POUR GARDER LE CRÉDITS
        
        if !saveScore.doesKeyExist(theKey: "credits") {
            saveScore.setKey(theValue: 2000 as AnyObject, theKey: "credits")
        } else {
            credits = saveScore.getValue(theKey: "credits") as! Int
        }
        
        //---
        // Responsable pour créer les objets a partir des images
        createCardObjectsFromImages()
        
        //---
        // Va remplir tous les tableaux
        fillUpArrays()
        
        //---
        // La méthode pour faire l'animation telle qu'elle sera exécutée.
        prepareAnimations(duration: 0.5, // Dure de l'animation
                          repeating: 5, // Repeat 5 fois
                          cards: arrOfCardImages) // Le tableaux des images
        //---
        // Cette partie du code était réservée à la définition de la partie visuelle des cartes.
        stylizeSlotImageViews(radius: 10, // Dire les styles des cartes
                              borderWidth: 0.5,
                              borderColor: UIColor.black.cgColor,
                              bgColor: UIColor.yellow.cgColor)
        //---
        // C'est la méthode responsable du contrôle des cartes qui apparaissent et disparaissent lors de l'exécution du programme.
        stylizeBackgroundViews(radius: 10,
                               borderWidth: nil,
                               borderColor: UIColor.black.cgColor,
                               bgColor: nil)
        //---
        createDeckOfCards() // La méthode que va créer le jeu de cartes
        //---
    }
    //----------------------//----------------------
    
    //---
    // Methode create deck of cards qui est responsable por le joue de cartes e por gerer tous les 52 cartes.
    // Va controler le jeu avec les repetitions et distribuitions les cartes
    func createDeckOfCards() {
        deckOfCards = [(Int, String)]()
        for a in 0...3 {
            let suits = ["d", "h", "c", "s"]
            for b in 1...13 {
                deckOfCards.append((b, suits[a]))
            }
        }
    }
    
    //----------------------//----------------------
    
    // Méthode du styles des imagesviews slots
    func stylizeSlotImageViews(radius r: CGFloat,
                               borderWidth w: CGFloat,
                               borderColor c: CGColor,
                               bgColor g: CGColor!) {
        for slotImageView in arrOfSlotImageViews {
            slotImageView.clipsToBounds = true
            slotImageView.layer.cornerRadius = r
            slotImageView.layer.borderWidth = w
            slotImageView.layer.borderColor = c
            slotImageView.layer.backgroundColor = g
        }
    }
    //----------------------//----------------------
    
    //---
    // Méthode pour les backgrounds
    func stylizeBackgroundViews(radius r: CGFloat,
                                borderWidth w: CGFloat?,
                                borderColor c: CGColor,
                                bgColor g: CGColor?) {
        for bgView in arrOfBackgrounds {
            bgView.clipsToBounds = true
            bgView.layer.cornerRadius = r
            bgView.layer.borderWidth = w ?? 0
            bgView.layer.borderColor = c
            bgView.layer.backgroundColor = g
        }
    }
    //----------------------//----------------------
    
    //---
    func fillUpArrays() {
        arrOfCardImages = [card_blur_1, card_blur_2, card_blur_3, card_blur_4,
                           card_blur_5]
        arrOfSlotImageViews = [slot_1, slot_2, slot_3, slot_4, slot_5]
        arrOfBackgrounds = [bg_1, bg_2, bg_3, bg_4, bg_5]
        arrOfKeepLabels = [keep_1, keep_2, keep_3, keep_4, keep_5]
    }
    //----------------------//----------------------
    
    //---
    // Va créer les objets dans les cartes flou
    func createCardObjectsFromImages() {
        card_blur_1 = UIImage(named: "blur_1.png")
        card_blur_2 = UIImage(named: "blur_2.png")
        card_blur_3 = UIImage(named: "blur_3.png")
        card_blur_4 = UIImage(named: "blur_4.png")
        card_blur_5 = UIImage(named: "blur_4.png")
    }
    //----------------------//----------------------
    
    //---
    // Va préparer l'animation du jeu
    func prepareAnimations(duration d: Double,
                           repeating r: Int,
                           cards c: [UIImage]) {
        for slotAnimation in arrOfSlotImageViews {
            slotAnimation.animationDuration = d
            slotAnimation.animationRepeatCount = r
            slotAnimation.animationImages = returnRandomBlurCards(arrBlurCards: c)
            // ArrayBlurCards c'est le tableaux de 5 images flou. Le slotanimation = arrBlurCards c'est comme 5 animations.
        }
    }
    //----------------------//----------------------
    
    //---
    // Cette methode va faire le melange le tableaux de cartes flou avec 5 animations differents.
    func returnRandomBlurCards(arrBlurCards: [UIImage]) -> [UIImage] {
        var arrToReturn = [UIImage]()
        var arrOriginal = arrBlurCards
        for _ in 0..<arrBlurCards.count {
            let randomIndex = Int(arc4random_uniform(UInt32(arrOriginal.count)))
            arrToReturn.append(arrOriginal[randomIndex])
            arrOriginal.remove(at: randomIndex)
        }
        return arrToReturn
    }
    //----------------------//----------------------
    
    //---
    // La méthode du bouton distribuer.
    @IBAction func play(_ sender: UIButton) {
        
        //---
        // Se chance == 0 il va commencer le jouer en 0.5
        if chances == 0 || dealButton.alpha == 0.5 {
            return
        } else {
            chances = chances - 1
        }
        
        //---
        // Quand click sur le bouton play va selectioner tous les cartes
        // Le allSelected chercher les cartes e executer les slot animation
        var allSelected = true
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1.0 {
                allSelected = false
                break
            }
        }
        if allSelected {
            displayRandomCards() //
            return
        }
        
        //---
        // Responsable de l'initiation de toutes les cartes d'animation.
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1.0 {
                slotAnimation.startAnimating()
            }
        }

        //---
        // Délai de 2,75 secondes.
        // J'ai augmenté le temps pour éviter les problèmes lors de l'exécution du programme.
        Timer.scheduledTimer(timeInterval: 2.75,
                             target: self,
                             selector: #selector(displayRandomCards),
                             userInfo: nil,
                             repeats: false)
    }
    //----------------------//----------------------
    
    // Méthode uniquement pour afficher des cartes aléatoires ------------
    @objc func displayRandomCards() {
        
        //---
        theHand = returnRandomHand()
        
        //---
        let arrOfCards = createCards(theHand: theHand)
        
        //---
        displayCards(arrOfCards: arrOfCards)
        
        //---
        // Cliquez sur le bouton pour distribuer la première fois et faire des animations
        permissionToSelectCards = true
        
        //---
        prepareForNextHand()
        //---
    }
    //----------------------//----------------------
    
    // Juste pour préparer pour la prochaine Hand
    func prepareForNextHand() {
        
        //---
        // Le createDeckOfCards va recreer tous les paches de cartes de la même precedant
        if chances == 0 {
            permissionToSelectCards = false
            dealButton.alpha = 0.5
            resetCards()
            createDeckOfCards()
            handToAnalyse = [(0, ""), (0, ""), (0, ""), (0, ""), (0, "")]
            chances = 2
            bet = 0
            betLabel.text = "MISE : 0"
        }
        //---
    }
    //----------------------//----------------------
    
    //---
    // Fonction qui organise les cartes aux tableaux arrOfCards et les animations
    func displayCards(arrOfCards: [String]) {
        
        //---
        var counter = 0
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1 {
                if chances == 0 {
                    handToAnalyse = removeEmptySlotsAndReturnArray()
                    handToAnalyse.append(theHand[counter])
                }
                //---
                slotAnimation.image = UIImage(named: arrOfCards[counter])
            }
            counter = counter + 1
        }
        //---
        if chances == 0 {
            verifyHand(hand: handToAnalyse) //
        }
        //---
    }
    //----------------------//----------------------
    
    //---
    // Méthode capable de trouver les cartes vide
    func removeEmptySlotsAndReturnArray() -> [(Int, String)] {
        var arrToReturn = [(Int, String)]()
        for card in handToAnalyse {
            if card != (0, "") {
                arrToReturn.append(card)
            }
        }
        return arrToReturn
    }
    //----------------------//----------------------
    
    //---
    // Fonction responsable pour créer et organiser des cartes
    func createCards(theHand: [(Int, String)]) -> [String] {
        //---
        let card_1 = "\(theHand[0].0)\(theHand[0].1).png"
        let card_2 = "\(theHand[1].0)\(theHand[1].1).png"
        let card_3 = "\(theHand[2].0)\(theHand[2].1).png"
        let card_4 = "\(theHand[3].0)\(theHand[3].1).png"
        let card_5 = "\(theHand[4].0)\(theHand[4].1).png"
        return [card_1, card_2, card_3, card_4, card_5]
        //---
    }
    //----------------------//----------------------
    // Fonction qui renvoie la distribution aléatoire des cartes
    func returnRandomHand() -> [(Int, String)] {
        //---
        var arrToReturn = [(Int, String)]()
        //---
        for _ in 1...5 {
            let randomIndex = Int(arc4random_uniform(UInt32(deckOfCards.count)))
            arrToReturn.append(deckOfCards[randomIndex])
            deckOfCards.remove(at: randomIndex)
        }
        //---
        return arrToReturn
        //---
    }
    //----------------------//----------------------
    // Méthode que va analyser les cartes et sera responsable pour les joues du poker
    func verifyHand(hand: [(Int, String)]) {
        if pokerHands.royalFlush(hand: hand) {
            calculateHand(times: 250, handToDisplay: "QUINTE FLUSH ROYALE")
        } else if pokerHands.straightFlush(hand: hand) {
            calculateHand(times: 50, handToDisplay: "QUINTE FLUSH")
        } else if pokerHands.fourKind(hand: hand) {
            calculateHand(times: 25, handToDisplay: "CARRÉ")
        } else if pokerHands.fullHouse(hand: hand) {
            calculateHand(times: 9, handToDisplay: "FULL")
        } else if pokerHands.flush(hand: hand) {
            calculateHand(times: 6, handToDisplay: "COULEUR")
        } else if pokerHands.straight(hand: hand) {
            calculateHand(times: 4, handToDisplay: "QUINTE")
        } else if pokerHands.threeKind(hand: hand) {
            calculateHand(times: 3, handToDisplay: "BRELAN")
        } else if pokerHands.twoPairs(hand: hand) {
            calculateHand(times: 2, handToDisplay: "DEUX PAIRES")
        } else if pokerHands.onePair(hand: hand) {
            calculateHand(times: 1, handToDisplay: "PAIRE")
        } else {
            calculateHand(times: 0, handToDisplay: "RIEN...")
        }
    }
    //----------------------//----------------------
    
    //---
    // Va calculer les valeurs des joues
    // Le tempLabel.text va afficher les mesages
    func calculateHand(times: Int, handToDisplay: String) {
        credits += (times * bet)
        tempLabel.text = handToDisplay
        creditsLabel.text = "CRÉDITS: \(credits)"
    }
    //----------------------//----------------------
    
    //---
    // C'est le bouton pour selecioner les cartes.
    @IBAction func cardsToHold(_ sender: UIButton) {
        //---
        if !permissionToSelectCards { // ---- Se pas vrai
            return
        }
        
        //---
        // Utilisé pour abaisser les cartes. ce comme OF
        if arrOfBackgrounds[sender.tag].layer.borderWidth == 0.5 {
            arrOfSlotImageViews[sender.tag].layer.borderWidth = 0.5
            arrOfBackgrounds[sender.tag].layer.borderWidth = 0.0
            arrOfBackgrounds[sender.tag].layer.backgroundColor = nil
            arrOfKeepLabels[sender.tag].isHidden = true
            
            //---
            // Va envoyer commes les arguments les tags des boutons
            manageSelectedCards(theTag: sender.tag, shouldAdd: false)
        } else {
            // Pour afficher les cartes. Ce comme ON
            arrOfSlotImageViews[sender.tag].layer.borderWidth = 1.0
            arrOfBackgrounds[sender.tag].layer.borderWidth = 0.5
            arrOfBackgrounds[sender.tag].layer.borderColor = UIColor.blue.cgColor
            arrOfBackgrounds[sender.tag].layer.backgroundColor = UIColor(red: 0.0,
                                                                         green: 0.0, blue: 1.0, alpha: 0.5).cgColor
            arrOfKeepLabels[sender.tag].isHidden = false
            //---
            manageSelectedCards(theTag: sender.tag, shouldAdd: true)
        }
    }
    //----------------------//----------------------
    
    //---
    // Va analyser les tags des cartes
    // Le handToAnalyse va porter les cartes du tableaux dans cette position
    func manageSelectedCards(theTag: Int, shouldAdd: Bool) {
        if shouldAdd {
            handToAnalyse[theTag] = theHand[theTag]
        } else {
            handToAnalyse[theTag] = (0, "")
        }
    }
    //----------------------//----------------------
    
    //---
    // Méthode pour les boutons miser 25, 100 et tout.
    // Il va contoler les credits, le miser des labels.
    @IBAction func betButtons(_ sender: UIButton) {
        
        //---
        if chances <= 1 {
            return
        }
        
        //---
        // La message va effacer après cliquer sur les options mise
        tempLabel.text = ""
        
        //---
        if sender.tag == 1000 {
            bet = credits
            betLabel.text = "MISE : \(bet)"
            credits = 0
            creditsLabel.text = "CRÉDITS : \(credits)"
            dealButton.alpha = 1.0
            resetBackOfCards()
            return
        }
        //---
        
        //---
        // Constante que s'appelle theBet qui recevra les jeux choisis 25, 100 et tous
        let theBet = sender.tag
        
        //---
        // Si la variable crédit est plus grand ou égal que bet podera continuer
        if credits >= theBet {
            bet += theBet // Incrément de la fonction
            credits -= theBet // Décrémentation de la fonction
            betLabel.text = "MISE : \(bet)" // Label pour mise
            creditsLabel.text = "CRÉDITS : \(credits)" // Label pour les crédits
            dealButton.alpha = 1.0 // Bouton distribuer distribuera en 1.0 secondes
        }
       
        //---
        // Méthode pour préparer les cartes pour jouer
        resetBackOfCards()
        //---
    }
    //----------------------//----------------------
    
    //---
    func resetBackOfCards() {
        for back in arrOfSlotImageViews { // Boucle avec la variable back que va chercher le solde des tableaux
            back.image = UIImage(named: "back.png") // Lorsque cliquer sur le bouton, pla carte apparaît à l'extérieur
        }
    }
    //----------------------//----------------------
    
    //---
    // Tous les cartes que sélectionné von descelectioner avec cette fonction.
    func resetCards() {
        //---
        for index in 0...4 {
            arrOfSlotImageViews[index].layer.borderWidth = 0.5
            arrOfBackgrounds[index].layer.borderWidth = 0.0
            arrOfBackgrounds[index].layer.backgroundColor = nil
            arrOfKeepLabels[index].isHidden = true
        }
        //---
        chances = 2
        //---
    }
    //----------------------//----------------------
    
    // ------- BOUTON RECOMMENCER -------
    // Connexion du bouton recommencer qui sera responsable pour redémarrage du jeu.
    
    @IBAction func recommencer(sender: UIButton) {
     
        if sender.tag == 500 {
            bet = 0
            betLabel.text = "MISE : \(bet)"
            credits = 2000
            creditsLabel.text = "CRÉDITS : \(credits)"
            dealButton.alpha = 1.0
            tempLabel.text = "BONNE CHANCE"
            resetBackOfCards()
            return
        }
    }
}
//----------------------//----------------------
