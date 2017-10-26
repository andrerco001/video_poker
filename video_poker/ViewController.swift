//----------------------//----------------------
import UIKit
//----------------------//----------------------
class ViewController: UIViewController {
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
    //variable que va creer les images. images des cartes de l'animation. 5 images flour.
    var card_blur_1: UIImage!
    var card_blur_2: UIImage!
    var card_blur_3: UIImage!
    var card_blur_4: UIImage!
    var card_blur_5: UIImage!
    
    //---
    //Conections UIview du background. Ils vont garder tous les autres images a partir du click du bouton. Ils vont disparer les autres commands.
    @IBOutlet weak var bg_1: UIView!
    @IBOutlet weak var bg_2: UIView!
    @IBOutlet weak var bg_3: UIView!
    @IBOutlet weak var bg_4: UIView!
    @IBOutlet weak var bg_5: UIView!
    
    //---
    //conection UIlabel responsable pour les commands garder les cartes.
    @IBOutlet weak var keep_1: UILabel!
    @IBOutlet weak var keep_2: UILabel!
    @IBOutlet weak var keep_3: UILabel!
    @IBOutlet weak var keep_4: UILabel!
    @IBOutlet weak var keep_5: UILabel!
    
    //---
    //3 conection. Le premiere c'est les boutons miser 25, 100 et tout. Le deuxieme est un objet text du type label qui va aparecer nos credits capable de afficher les credits. Le 3 betlabelc'est le bouton distribuer.
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    

    //---
    //Partes des differents tableaux du code.
    //animations des images blur/flour
    var arrOfCardImages: [UIImage]!
    //---
    //animation des imageview slots
    var arrOfSlotImageViews: [UIImageView]!
    //---
    //cest le tableaux de two paus. sain vide. chaque teow poaus va representer les cartes. 52 cartes 2 pous. Int represent le chiffre de la carte et string qui represente le sorte de la carte.
    var deckOfCards = [(Int, String)]()
    //---
    // Tableaux de arrier plain do UIview des backgrounds. Utilise plusierstableaux pour reagruper et utilise le boucle pour repeter tous elements du tanleaux.
    var arrOfBackgrounds: [UIView]!
    //---
    //label qui represente le mot garder.
    var arrOfKeepLabels: [UILabel]!
    
    
    
    
    let saveScore = UserDefaultsManager() //methode que va appeler le user defaults manager ///////////// USER DEFAULTS MANAGER //////////////////
    
   
    
    
    //---
    //Variable que va faire le gestion si peux ou no selectioner les cartes.
    var permissionToSelectCards = false
    //variable pour la mise le bet
    var bet = 0
    //variable des credits. on defini que l'arjant initiale sera 2 mille.
    var credits = 2000
    
    //--- variable chance est responsable pour gerer a quel momment le jouer pour est-il donner la partida
    var chances = 2
    
    
    //--- No était pas dans les commentaires \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    let pokerHands = PokerHands()
    //---
    var handToAnalyse = [(0, ""), (0, ""), (0, ""), (0, ""), (0, "")]
    //---
    var theHand = [(Int, String)]()
    //----------------------//----------------------
    
    
    
    
    //------
    // cest le methode qui dit lorsque le documente est pret, la interface
    override func viewDidLoad() {
        //---
        super.viewDidLoad()

        
        // il commander le objet du User Defaults Manager /////////////////////// USER DEFAULTS MANAGER POUR GARDER LE CREDITS
        
        if !saveScore.doesKeyExist(theKey: "credits") {
            saveScore.setKey(theValue: 2000 as AnyObject, theKey: "credits")
        } else {
            credits = saveScore.getValue(theKey: "credits") as! Int
        }
        
        
        //---
        //va creer les objets a partur des images
        createCardObjectsFromImages()
        //---
        //va ramplir tous les tableaux
        fillUpArrays()
        //---
        //la methode pour dire la amimation comme ela va faire
        prepareAnimations(duration: 0.5, //dure de l'animation
                          repeating: 5, //repeat 5 fois
                          cards: arrOfCardImages) // le tableaux des images
        //---
        //
        stylizeSlotImageViews(radius: 10, //dire les styles des cartes
                              borderWidth: 0.5,
                              borderColor: UIColor.black.cgColor,
                              bgColor: UIColor.yellow.cgColor)
        //---
        stylizeBackgroundViews(radius: 10, // cets la methode pour controler les cartes que aparecercem e desaparecem
                               borderWidth: nil,
                               borderColor: UIColor.black.cgColor,
                               bgColor: nil)
        //---
        createDeckOfCards() // la methode que creer le joue de cartes
        //---
    }
    //----------------------//----------------------
    //methode create deck of cards qui est responsable por le joue de cartes e por gerer tous les 52 cartes et va controle le joue avec les repetitions et distribuitions des cartes
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
    //Methode du styles des imagesviews slots
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
    //Methode pour les backgrounds
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
    //
    func fillUpArrays() {
        arrOfCardImages = [card_blur_1, card_blur_2, card_blur_3, card_blur_4,
                           card_blur_5]
        arrOfSlotImageViews = [slot_1, slot_2, slot_3, slot_4, slot_5]
        arrOfBackgrounds = [bg_1, bg_2, bg_3, bg_4, bg_5]
        arrOfKeepLabels = [keep_1, keep_2, keep_3, keep_4, keep_5]
    }
    //----------------------//----------------------
    func createCardObjectsFromImages() { //va creer les objets dans les cartes blur
        card_blur_1 = UIImage(named: "blur_1.png")
        card_blur_2 = UIImage(named: "blur_2.png")
        card_blur_3 = UIImage(named: "blur_3.png")
        card_blur_4 = UIImage(named: "blur_4.png")
        card_blur_5 = UIImage(named: "blur_4.png")
    }
    //----------------------//----------------------
    //Va preparer l'animation
    func prepareAnimations(duration d: Double,
                           repeating r: Int,
                           cards c: [UIImage]) {
        for slotAnimation in arrOfSlotImageViews {
            slotAnimation.animationDuration = d
            slotAnimation.animationRepeatCount = r
            slotAnimation.animationImages = returnRandomBlurCards(arrBlurCards: c)
            //arrBlourCards cest le tableaux de 5 images blur. slotanimation = arrBlurCards cest comme 5 animations pareille.
        }
    }
    //----------------------//----------------------
    //cette methode va faire le melange pour le tableux de cartes blur avexc 5 animations differents.
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
    //La methode du bouton distribuer
    @IBAction func play(_ sender: UIButton) {
        //---
        if chances == 0 || dealButton.alpha == 0.5 {
            return // se chance == 0 il va commencer le joue en 0.5 ////////
        } else {
            chances = chances - 1 //
        }

        
        
        
        //---
        var allSelected = true
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1.0 { /////////////////////////
                allSelected = false
                break
            }
        }
        if allSelected {
            displayRandomCards()
            return
        }
        
        
        
        
        //---
        // en ce moment commence tous les cartes de l'animmation.
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1.0 {
                slotAnimation.startAnimating()
            }
        }
        //---
        Timer.scheduledTimer(timeInterval: 2.55, //temp de delay de 2.55 segonde.
                             target: self,
                             selector: #selector(displayRandomCards),
                             userInfo: nil,
                             repeats: false)
    }
    //----------------------//----------------------
    //methode que pour faire afficher les cartes au azar //////////////////////////
    @objc func displayRandomCards() {
        
        //---
        theHand = returnRandomHand()
        //---
        let arrOfCards = createCards(theHand: theHand)
        //---
        displayCards(arrOfCards: arrOfCards)
        //---
        permissionToSelectCards = true // on clique sur le bouton distribuir la premire fois et fais uns animations ///////////////////////////////
        //---
        prepareForNextHand()
        //---
    }
    //----------------------//----------------------
    func prepareForNextHand() {
        //---
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
            verifyHand(hand: handToAnalyse)
        }
        //---
    }
    //----------------------//----------------------
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
    func calculateHand(times: Int, handToDisplay: String) {
        credits += (times * bet)
        tempLabel.text = handToDisplay
        creditsLabel.text = "CRÉDITS: \(credits)"
    }
    //----------------------//----------------------
    //cest le bouton pour selecioner les cartes.
    @IBAction func cardsToHold(_ sender: UIButton) {
        //---
        if !permissionToSelectCards { //se nao e verdadeiro //////////// OBS /////////////
            return
        }
        //---
        //Serve para descelecionar as cartas. ce comme OF////////
        if arrOfBackgrounds[sender.tag].layer.borderWidth == 0.5 {
            arrOfSlotImageViews[sender.tag].layer.borderWidth = 0.5
            arrOfBackgrounds[sender.tag].layer.borderWidth = 0.0
            arrOfBackgrounds[sender.tag].layer.backgroundColor = nil
            arrOfKeepLabels[sender.tag].isHidden = true
            //---
            manageSelectedCards(theTag: sender.tag, shouldAdd: false)
        } else { // para afficher les cartes ///// ce comme ON  ////////
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
    func manageSelectedCards(theTag: Int, shouldAdd: Bool) {
        if shouldAdd {
            handToAnalyse[theTag] = theHand[theTag]
        } else {
            handToAnalyse[theTag] = (0, "")
        }
    }
    //----------------------//----------------------
    //methode pour les noutons miser
    @IBAction func betButtons(_ sender: UIButton) {
        //--- /////////////////////// finir pour continuer temp video 00:30:00 **********
        if chances <= 1 {
            return
        }
        //---
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
        let theBet = sender.tag
        //---
        if credits >= theBet {
            bet += theBet
            credits -= theBet
            betLabel.text = "MISE : \(bet)"
            creditsLabel.text = "CRÉDITS : \(credits)"
            dealButton.alpha = 1.0
        }
       //---
        resetBackOfCards()
        //---
    }
    
    //--------------------//------------------------
    // BOUTON RECOMMENCER ////////////////////////////////////////
    
    @IBAction func recommencer(sender: UIButton) {
   
        if sender.tag == 500 {
         bet = 0
         betLabel.text = "MISE : \(bet)"
         credits = 2000
         creditsLabel.text = "CRÉDITS : \(credits)"
         dealButton.alpha = 1.0
         resetBackOfCards()
         return
         }
        
    }
    /////////////////////////////////////////////////////////////
    
    //----------------------//----------------------
    func resetBackOfCards() {
        for back in arrOfSlotImageViews {
            back.image = UIImage(named: "back.png")
        }
    }
    //----------------------//----------------------
    // tous les cartes que selectione von descelectione. /////////////////////////////
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
}
//----------------------//----------------------
