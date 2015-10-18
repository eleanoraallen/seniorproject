#lang racket

;; ITEMS ----------------------------------------------------------------
(define base-item<%>
  (interface ()))

(define item%
  (class* object% (base-item<%>)
    (super-new)
    (init-field
     name ;; string that is the items name
     description ;; string that is the description of the item
     )
    (define/public (get-name) name)
    (define/public (get-description) description)))

(define wepon%
  (class* item% (base-item<%>)
    (super-new)
    (init-field
     wepon-damage ;; a nat that is the wepons damage
     wepon-accuracy ;; a nat between 0 and 1 that is the proboblity that the wepon will hit
     type;; a symbol that is the wepon's type
     )
    (inherit
      get-name
      get-description)
    (inherit-field
     name
     description)
    (define/public (get-accuracy) ;; produces wepon's accuracy
      wepon-accuracy)
    (define/public (get-damage) ;; produces wepon's damage
      wepon-damage)
    (define/public (get-type) ;; produces wepon's type
      type)))

(define equipment%
  (class* item% (base-item<%>)
    (super-new)
    (init-field
     defence ;; a nat that is the equipments defence
     equipment-portion ;; a symbol that is the portion of the body the equipment goes on
     )
    (define/public (get-defence) ;; produces the equipment's defence
      defence)
    (define/public (get-portion) ;; produces the equipment's portion
      equipment-portion)))

(define consumable%
  (class* item% (base-item<%>)
    (super-new)
    (init-field
     effect ;; a function that takes a character and produces a character
     )
    (define/public (get-effect) effect) ;; gets items effect
    ))

;; an invintory is a (make-invintory wepon list-of-equipment list-of-consumables list-of-items)
(define-struct invintory (wepon equiped consumables miscellaneous))

;; a spell is a (make-spell string string effect)
(define-struct spell (name discription effect))

;; CHARACTERS ----------------------------------------------------------------
(define base-character<%>
  (interface ()
    get-name ;; gets character's name
    get-health ;; gets character's health
    get-base-agility ;; gets character's base-agility
    get-agility ;; gets character's agility
    get-base-strength ;; gets characters base strength
    get-strength ;; gets character's strength
    get-invintory ;; gets the character's invintory
    get-spells ;; gets the spells a character knows
    get-weakness ;; gets character's weakness
    get-resistance ;; gets character's resistance
    get-damage ;; gets the damage a character can enflict
    dead? ;; true iff character is dead
    ))

(define character%
  (class* object% (base-character<%>)
    (super-new)
    (init-field
     name ;; a string that is the character's name
     health ;; a nat that is the character's current health
     max-health ;; a nat that is the character's max health
     base-agility ;; a nat between 0 and 1 which is the base probibility that a character will be hit by any given attack
     agility ;; a nat between 0 and 1 which is the current probibility that a character will be hit by any given attack
     base-strength ;; a nat that is the character's base-strength
     strength ;; a nat that is the character's current strength
     character-invintory ;; the character's invintory
     spells ;; the spells the character knows
     weakness ;; a symbol that is the characters weakness. 'none if they have no weakness
     resistance ;; a symbol that is the charactars resistance. 'none if they have no resistances
     )
    (define/public (get-name) name)
    (define/public (get-health) health)
    (define/public (get-max-health) max-health)
    (define/public (get-base-agility) base-agility)
    (define/public (get-agility) agility)
    (define/public (get-base-strength) base-strength)
    (define/public (get-strength) strength)
    (define/public (get-invintory) character-invintory)
    (define/public (get-spells) spells)
    (define/public (get-weakness) weakness)
    (define/public (get-resistance) resistance)
    (define/public (get-damage) 
      (+ (send (invintory-wepon character-invintory) get-damage) strength))
    (define/public (dead?) (<= health 0))))

(define player%
  (class* character% (base-character<%>)
    (super-new)
    (init-field
     level ;; a nat that is the player's level
     max-mp ;; a nat that is the players max mp
     mp ;; a nat that is the players mp
     current-xp ;; a nat that is the player's xp
     )
    (inherit get-name 
             get-health
             get-base-agility
             get-agility
             get-base-strength
             get-strength
             get-invintory
             get-spells
             get-weakness
             get-resistance
             get-damage
             dead?)
    (inherit-field name
                   health
                   max-health
                   base-agility
                   agility
                   base-strength
                   strength
                   character-invintory
                   spells
                   weakness
                   resistance)
    (define/public (get-level) level) ;; produces player's level
    (define/public (get-max-mp) max-mp) ;; produces player's max mp
    (define/public (get-mp) mp) ;; produces player's level
    (define/public (get-current-xp) current-xp) ;; produces player's level
    (define/public (remove-mp n)
      (new player%
           [name name]
           [health health]
           [max-health max-health]
           [base-agility base-agility]
           [agility agility]
           [base-strength base-strength]
           [strength strength]
           [character-invintory character-invintory]
           [spells spells]
           [weakness weakness]
           [resistance resistance]
           [level level]
           [max-mp max-mp]
           [mp (- mp n)]
           [current-xp current-xp]))
    (define/public (add-xp xp-award) ;; adds xp-award to player's current xp
      (new player%
           [name name]
           [health health]
           [max-health max-health]
           [base-agility base-agility]
           [agility agility]
           [base-strength base-strength]
           [strength strength]
           [character-invintory character-invintory]
           [spells spells]
           [weakness weakness]
           [resistance resistance]
           [level level]
           [max-mp max-mp]
           [mp mp]
           [current-xp (+ current-xp xp-award)]))
    (define/public (apply-spell spell)
      ((spell-effect spell) (new player%
                                 [name name]
                                 [health health]
                                 [max-health max-health]
                                 [base-agility base-agility]
                                 [agility agility]
                                 [base-strength base-strength]
                                 [strength strength]
                                 [character-invintory character-invintory]
                                 [spells spells]
                                 [weakness weakness]
                                 [resistance resistance]
                                 [level level]
                                 [max-mp max-mp]
                                 [mp mp]
                                 [current-xp current-xp])))
    (define/public (use-consumable c)
      ((send c get-effect) (new player%
                                [name name]
                                [health health]
                                [max-health max-health]
                                [base-agility base-agility]
                                [agility agility]
                                [base-strength base-strength]
                                [strength strength]
                                [character-invintory character-invintory]
                                [spells spells]
                                [weakness weakness]
                                [resistance resistance]
                                [level level]
                                [max-mp max-mp]
                                [mp mp]
                                [current-xp current-xp])))
    (define/public (apply-attack attacker-accuracy
                                 attacker-damage
                                 wepon-type)
      (new player%
           [name name]
           [health (- health (if (< (* (* (get-agility) attacker-accuracy) 100) (random 100))
                                 0
                                 (local 
                                   [(define (get-armor-defense e) ;; gets the defensive bonus from all character's equiped armor
                                      (cond [(empty? e) 0]
                                            [(cons? e) (+ (send (first e) get-defence) (get-armor-defense (rest e)))]))]
                                   (define (apply-damage attack-power) ;; amount of damage to be applied for an attack of a given power
                                     (if (>= (get-armor-defense (invintory-equiped character-invintory)) attack-power)
                                         1 (- attack-power (get-armor-defense (invintory-equiped character-invintory)))))
                                   (cond
                                     [(and (eq? wepon-type weakness) (not (eq? weakness 'none)))
                                      (apply-damage (round (* attacker-damage 2)))]
                                     [(and (eq? wepon-type resistance) (not (eq? resistance 'none)))
                                      (apply-damage (round (* attacker-damage .5)))]
                                     [else (apply-damage attacker-damage)]))))]                   
           [max-health max-health]
           [base-agility base-agility]
           [agility agility]
           [base-strength base-strength]
           [strength strength]
           [character-invintory character-invintory]
           [spells spells]
           [weakness weakness]
           [resistance resistance]
           [level level]
           [max-mp max-mp]
           [mp mp]
           [current-xp current-xp]))))

(define npc%
  (class* character% (base-character<%>)
    (super-new)
    (init-field
     xp-award ;; the xp award you get for defeating the enemy
     )
    (inherit get-name
             get-health
             get-base-agility
             get-agility
             get-base-strength
             get-strength
             get-invintory
             get-spells
             get-weakness
             get-resistance
             get-damage
             dead?)
    (inherit-field name
                   health
                   max-health
                   base-agility
                   agility
                   base-strength
                   strength
                   character-invintory
                   spells
                   weakness
                   resistance)
    (define/public (get-xp-award) xp-award)
    (define/public (apply-spell spell)
      ((spell-effect spell) (new npc%
                                 [name name]
                                 [health health]
                                 [max-health max-health]
                                 [base-agility base-agility]
                                 [agility agility]
                                 [base-strength base-strength]
                                 [strength strength]
                                 [character-invintory character-invintory]
                                 [spells spells]
                                 [weakness weakness]
                                 [resistance resistance]
                                 [xp-award xp-award])))
    (define/public (use-consumable c)
      ((send c get-effect) (new npc%
                                [name name]
                                [health health]
                                [max-health max-health]
                                [base-agility base-agility]
                                [agility agility]
                                [base-strength base-strength]
                                [strength strength]
                                [character-invintory character-invintory]
                                [spells spells]
                                [weakness weakness]
                                [resistance resistance]
                                [xp-award xp-award])))
    (define/public (apply-attack attacker-accuracy
                                 attacker-damage
                                 wepon-type)
      (new npc%
           [name name]
           [health (- health (if (< (* (* (get-agility) attacker-accuracy) 100) (random 100))
                                 0
                                 (local 
                                   [(define (get-armor-defense e) ;; gets the defensive bonus from all character's equiped armor
                                      (cond [(empty? e) 0]
                                            [(cons? e) (+ (send (first e) get-defence) (get-armor-defense (rest e)))]))]
                                   (define (apply-damage attack-power) ;; amount of damage to be applied for an attack of a given power
                                     (if (>= (get-armor-defense (invintory-equiped character-invintory)) attack-power)
                                         1 (- attack-power (get-armor-defense (invintory-equiped character-invintory)))))
                                   (cond
                                     [(and (eq? wepon-type weakness) (not (eq? weakness 'none)))
                                      (apply-damage (round (* attacker-damage 2)))]
                                     [(and (eq? wepon-type resistance) (not (eq? resistance 'none)))
                                      (apply-damage (round (* attacker-damage .5)))]
                                     [else (apply-damage attacker-damage)]))))]                   
           [max-health max-health]
           [base-agility base-agility]
           [agility agility]
           [base-strength base-strength]
           [strength strength]
           [character-invintory character-invintory]
           [spells spells]
           [weakness weakness]
           [resistance resistance]
           [xp-award xp-award]))))

(module+ test
  (require rackunit)
  ;; SPELLS
  (define TESTSPELL1
    (make-spell
     "magic bomb"
     "bomb of fire"
     (lambda (c)
       (send c apply-attack 1 75 'fire))))
  (define TESTSPELL2
    (make-spell
     "heal"
     "+ 50 health"
     (lambda (c)
       (new character%
            [name (send c get-name)]
            [health (if (>= (+ 50 (send c get-health)) (send c get-max-health))
                        (send c get-max-health)
                        (+ 50 (send c get-health)))]
            [max-health (send c get-max-health)]
            [base-agility (send c get-base-agility)]
            [agility (send c get-agility)]
            [base-strength (send c get-base-strength)]
            [strength (send c get-strength)]
            [spells (send c get-spells)]
            [character-invintory (send c get-invintory)]
            [weakness (send c get-weakness)]
            [resistance (send c get-resistance)]))))
  
  ;; WEPONS
  (define TESTSWORD
    (new wepon%
         [name "Test Sword"]
         [description "A sword used exclusivly for testing the game."]
         [wepon-damage 50]
         [wepon-accuracy 1]
         [type 'metal]))
  
  ;; ARMOR
  (define TESTARMOR
    (new equipment%
         [name "Test Armor"]
         [description "Armor used exclusivly for testing the game"]
         [defence 20]
         [equipment-portion 'body]))
  
  ;; CONSUMABLES
  (define TESTPOTION
    (new consumable%
         [name "Test Potion"]
         [description "A potion used exclusivly for testing the game"]
         [effect (lambda (c)
                   (new character%
                        [name (send c get-name)]
                        [health (if (>= (+ 10 (send c get-health)) (send c get-max-health))
                                    (send c get-max-health)
                                    (+ 10 (send c get-health)))]
                        [max-health (send c get-max-health)]
                        [base-agility (send c get-base-agility)]
                        [agility (send c get-agility)]
                        [base-strength (send c get-base-strength)]
                        [strength (send c get-strength)]
                        [spells (send c get-spells)]
                        [character-invintory (send c get-invintory)]
                        [weakness (send c get-weakness)]
                        [resistance (send c get-resistance)]))]))
  
  ;; PLAYERS
  (define TESTPLAYER1
    (new player%
         [name "Al"]
         [health 100]
         [max-health 100]
         [base-agility 1]
         [agility 1]
         [base-strength 5]
         [strength 5]
         [spells empty]
         [character-invintory (make-invintory TESTSWORD (list TESTARMOR) (list TESTSWORD TESTARMOR) (list TESTPOTION))]
         [weakness 'none]
         [resistance 'none]
         [level 5]
         [max-mp 20]
         [mp 20]
         [current-xp 1500]))
  
  (define TESTPLAYER2
    (new player%
         [name "Bob"]
         [health 25]
         [max-health 100]
         [base-agility 1]
         [agility 1]
         [base-strength 5]
         [strength 5]
         [spells (list TESTSPELL1 TESTSPELL2)]
         [character-invintory (make-invintory TESTSWORD (list TESTARMOR) (list TESTSWORD TESTARMOR) (list TESTPOTION))]
         [weakness 'none]
         [resistance 'none]
         [level 5]
         [max-mp 20]
         [mp 20]
         [current-xp 1500]))
  (define TESTPLAYER3
    (new player%
         [name "C"]
         [health 0]
         [max-health 100]
         [base-agility 1]
         [agility 1]
         [base-strength 5]
         [strength 5]
         [spells (list TESTSPELL1 TESTSPELL2)]
         [character-invintory (make-invintory TESTSWORD (list TESTARMOR) (list TESTSWORD TESTARMOR) (list TESTPOTION))]
         [weakness 'none]
         [resistance 'none]
         [level 5]
         [max-mp 20]
         [mp 20]
         [current-xp 1500]))
  
  ;; NPCs
  (define TESTNPC1
    (new npc%
         [name "Adam"]
         [health 100]
         [max-health 100]
         [base-agility 1]
         [agility 1]
         [base-strength 5]
         [strength 5]
         [spells empty]
         [character-invintory (make-invintory TESTSWORD (list TESTARMOR) (list TESTSWORD TESTARMOR) (list TESTPOTION))]
         [weakness 'none]
         [resistance 'none]
         [xp-award 20]))
  (define TESTNPC2
    (new npc%
         [name "Brian Master of the Flames"]
         [health 50]
         [max-health 100]
         [base-agility 1]
         [agility 1]
         [base-strength 5]
         [strength 5]
         [spells (list TESTSPELL1 TESTSPELL2)]
         [character-invintory (make-invintory TESTSWORD empty empty (list TESTPOTION))]
         [weakness 'water]
         [resistance 'fire]
         [xp-award 20]))
  (define TESTNPC3
    (new npc%
         [name "CC"]
         [health 0]
         [max-health 100]
         [base-agility 1]
         [agility 1]
         [base-strength 5]
         [strength 5]
         [spells (list TESTSPELL1 TESTSPELL2)]
         [character-invintory (make-invintory TESTSWORD (list TESTARMOR) (list TESTSWORD TESTARMOR) (list TESTPOTION))]
         [weakness 'none]
         [resistance 'none]
         [xp-award 20]))
  
  ;; TESTS
  (and
   ;; dead?
   (not (send TESTPLAYER1 dead?))
   (send TESTPLAYER3 dead?)
   (not (send TESTNPC1 dead?))
   (send TESTNPC3 dead?)
   ;; apply-attack
   (= (send (send TESTPLAYER1 apply-attack 1 50 'none) get-health) 70)
   (= (send (send TESTNPC1 apply-attack 1 50 'none) get-health) 70)
   (= (send (send TESTNPC2 apply-attack 1 10 'water) get-health) 30)
   (= (send (send TESTNPC2 apply-attack 1 10 'fire) get-health) 45)
   ;; apply-spell
   (= (send (send TESTPLAYER1 apply-spell TESTSPELL1) get-health) 45)
   (= (send (send TESTPLAYER1 apply-spell TESTSPELL2) get-health) 100)
   (= (send (send TESTPLAYER2 apply-spell TESTSPELL2) get-health) 75)
   ;; use-consumable
   (= (send (send TESTPLAYER1 use-consumable TESTPOTION) get-health) 100)
   (= (send (send TESTPLAYER2 use-consumable TESTPOTION) get-health) 35)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TEST COMBAT

(require 2htdp/image)
(require 2htdp/universe)

;; a world is a (make-world player npc symbol string string) where
;; the player is the player
;; the npc is an enemy
;; the symbol is one of:
;; - 'p
;; - 'e
;; - 'w
;; - 'l
;; the second string is a thing the player is typing
(define-struct world (player npc phase text))

;; spells
(define HEAL
  (make-spell
   "heal"
   "+ 50 health"
   (lambda (c)
     (new player%
          [name (send c get-name)]
          [health (if (>= (+ 50 (send c get-health)) (send c get-max-health))
                      (send c get-max-health)
                      (+ 50 (send c get-health)))]
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)]
          [agility (send c get-agility)]
          [base-strength (send c get-base-strength)]
          [strength (send c get-strength)]
          [spells (send c get-spells)]
          [character-invintory (send c get-invintory)]
          [weakness (send c get-weakness)]
          [resistance (send c get-resistance)]
          [level (send c get-level)]
          [max-mp (send c get-max-mp)]
          [mp (send c get-mp)]
          [current-xp (send c get-current-xp)]))))
;; Agilify
(define AGILIFY
  (make-spell
   "agilify"
   "agility goes up"
   (lambda (c)
     (new player%
          [name (send c get-name)]
          [health (send c get-health)]
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)]
          [agility .5]
          [base-strength (send c get-base-strength)]
          [strength (send c get-strength)]
          [spells (send c get-spells)]
          [character-invintory (send c get-invintory)]
          [weakness (send c get-weakness)]
          [resistance (send c get-resistance)]
          [level (send c get-level)]
          [max-mp (send c get-max-mp)]
          [mp (send c get-mp)]
          [current-xp (send c get-current-xp)]))))

;; strongify
(define STRONGIFY
  (make-spell
   "strongify"
   "you gain the streignth of ten yous"
   (lambda (c)
     (new player%
          [name (send c get-name)]
          [health (send c get-health)]
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)]
          [agility (send c get-agility)]
          [base-strength (send c get-base-strength)]
          [strength (* 10 (send c get-strength))]
          [spells (send c get-spells)]
          [character-invintory (send c get-invintory)]
          [weakness (send c get-weakness)]
          [resistance (send c get-resistance)]
          [level (send c get-level)]
          [max-mp (send c get-max-mp)]
          [mp (send c get-mp)]
          [current-xp (send c get-current-xp)]))))

;; Iceify Wepon
(define ICEIFY-WEPON
  (make-spell
   "icefy wepon"
   "coats your wepon in a sheet of ice"
   (lambda (c)
     (new player%
          [name (send c get-name)]
          [health (send c get-health)]
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)]
          [agility (send c get-agility)]
          [base-strength (send c get-base-strength)]
          [strength (send c get-strength)]
          [spells (send c get-spells)]
          [character-invintory (make-invintory
                                (new wepon%
                                     [name (string-append (send (invintory-wepon (send c get-invintory)) get-name) " (icey)")]
                                     [description (send (invintory-wepon (send c get-invintory)) get-description)]
                                     [wepon-damage (send (invintory-wepon (send c get-invintory)) get-damage)]
                                     [wepon-accuracy (send (invintory-wepon (send c get-invintory)) get-accuracy)]
                                     [type 'ice])
                                (invintory-equiped (send c get-invintory))
                                (invintory-consumables (send c get-invintory))
                                (invintory-miscellaneous (send c get-invintory)))]
          [weakness (send c get-weakness)]
          [resistance (send c get-resistance)]
          [level (send c get-level)]
          [max-mp (send c get-max-mp)]
          [mp (send c get-mp)]
          [current-xp (send c get-current-xp)]))))

;; Iceify Wepon
(define FLAMEIFY-WEPON
  (make-spell
   "icefy wepon"
   "coats your wepon in a sheet of ice"
   (lambda (c)
     (new player%
          [name (send c get-name)]
          [health (send c get-health)]
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)]
          [agility (send c get-agility)]
          [base-strength (send c get-base-strength)]
          [strength (send c get-strength)]
          [spells (send c get-spells)]
          [character-invintory (make-invintory
                                (new wepon%
                                     [name (string-append (send (invintory-wepon (send c get-invintory)) get-name) " (flamey)")]
                                     [description (send (invintory-wepon (send c get-invintory)) get-description)]
                                     [wepon-damage (send (invintory-wepon (send c get-invintory)) get-damage)]
                                     [wepon-accuracy (send (invintory-wepon (send c get-invintory)) get-accuracy)]
                                     [type 'fire])
                                (invintory-equiped (send c get-invintory))
                                (invintory-consumables (send c get-invintory))
                                (invintory-miscellaneous (send c get-invintory)))]
          [weakness (send c get-weakness)]
          [resistance (send c get-resistance)]
          [level (send c get-level)]
          [max-mp (send c get-max-mp)]
          [mp (send c get-mp)]
          [current-xp (send c get-current-xp)]))))

;; light ray
(define LIGHT-RAY
  (make-spell
   "light ray"
   "fire a ray of darkness"
   (lambda (c)
     (new npc%
          [name (send c get-name)]
          [health (if (>= 100 (send c get-health))
                      0
                      (- (send c get-health) 100))]
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)]
          [agility (send c get-agility)]
          [base-strength (send c get-base-strength)]
          [strength (send c get-strength)]
          [spells (send c get-spells)]
          [character-invintory (send c get-invintory)]
          [weakness (send c get-weakness)]
          [resistance (send c get-resistance)]
          [xp-award (send c get-xp-award)]))))

;; consumables
(define MAGIC-POTION
  (new consumable%
       [name "magic potion"]
       [description "A potion restores the users magic"]
       [effect (lambda (c)
                 (new player%
                      [name (send c get-name)]
                      [health (send c get-health)]
                      [max-health (send c get-max-health)]
                      [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)]
                      [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)]
                      [spells (send c get-spells)]
                      [character-invintory (send c get-invintory)]
                      [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)]
                      [level (send c get-level)]
                      [max-mp (send c get-max-mp)]
                      [mp (send c get-max-mp)]
                      [current-xp (send c get-current-xp)]))]))


;; wepons
(define SWORD
  (new wepon%
       [name "Steel Sword"]
       [description "A sturdy steel sword."]
       [wepon-damage 10]
       [wepon-accuracy .95]
       [type 'metal]))
(define STAFF
  (new wepon%
       [name "Wood Staff"]
       [description "A flimsy wooden quarterstaff."]
       [wepon-damage 5]
       [wepon-accuracy 1]
       [type 'metal]))
;; player
(define PLAYER
  (new player%
       [name "You"]
       [health 500]
       [max-health 500]
       [base-agility 1]
       [agility 1]
       [base-strength 5]
       [strength 5]
       [spells empty]
       [character-invintory (make-invintory SWORD empty empty empty)]
       [weakness 'none]
       [resistance 'none]
       [level 5]
       [max-mp 20]
       [mp 20]
       [current-xp 1500]))
;; npc
(define NPC
  (new npc%
       [name "Evil Knight"]
       [health 500]
       [max-health 500]
       [base-agility .95]
       [agility 1]
       [base-strength 5]
       [strength 5]
       [spells empty]
       [character-invintory (make-invintory STAFF empty empty empty)]
       [weakness 'fire]
       [resistance 'ice]
       [xp-award 20]))

;; world
(define WORLD (make-world PLAYER NPC 'p ""))

;; render: world --> image
(define (render w)
  (above
   (overlay
    (beside
     (above/align "left"
                  (text (string-append "Player: " (send (world-player w) get-name)) 13 'black)
                  (text " " 12 'white)
                  (text (string-append
                         "Health: "
                         (number->string (send (world-player w) get-health))
                         "/"
                         (number->string (send (world-player w) get-max-health))) 12 'black)
                  (text (string-append
                         "Agility: "
                         (number->string (round (* 100 (- 1 (send (world-player w) get-agility)))))) 12 'black)
                  (text (string-append
                         "Strength: "
                         (number->string (send (world-player w) get-strength))) 12 'black)
                  (text (string-append
                         "MP: "
                         (number->string (send (world-player w) get-mp))
                         "/"
                         (number->string (send (world-player w) get-max-mp))) 12 'black)
                  (text " " 12 'white)
                  (text (string-append
                         "Weapon: " (send (invintory-wepon (send (world-player w) get-invintory)) get-name)) 12 'black)
                  (text (string-append
                         "Accuracy: " (number->string (* 100 (send (invintory-wepon (send (world-player w) get-invintory)) get-accuracy)))) 12 'black)
                  (text (string-append
                         "Damage: " (number->string (send (invintory-wepon (send (world-player w) get-invintory)) get-damage))) 12 'black)
                  (text (string-append
                         "Type: " (symbol->string (send (invintory-wepon (send (world-player w) get-invintory)) get-type))) 12 'black))
     (rectangle 10 0 'solid 'white)
     (above/align "left"
                  (text (string-append "Enemy: " (send (world-npc w) get-name)) 13 'black)
                  (text " " 12 'white)
                  (text (string-append
                         "Health: "
                         (number->string (send (world-npc w) get-health))
                         "/"
                         (number->string (send (world-npc w) get-max-health))) 12 'black)
                  (text (string-append
                         "Agility: "
                         (number->string (round (* 100 (- 1 (send (world-npc w) get-agility)))))) 12 'black)
                  (text (string-append
                         "Strength: "
                         (number->string (send (world-npc w) get-strength))) 12 'black)
                  (text " " 12 'white)
                  (text " " 12 'white)
                  (text (string-append
                         "Weakness: "
                         (symbol->string (send (world-npc w) get-weakness))) 12 'black)
                  (text (string-append
                         "Resistance: "
                         (symbol->string (send (world-npc w) get-resistance))) 12 'black)
                  (text " " 12 'white)
                  (text " " 12 'white)))
    (overlay (rectangle 300 175 'solid 'white) (rectangle 302 177 'solid 'black)))
   (overlay/align "left" "middle" (text (string-append " " (world-text w)) 12 'black) (overlay (rectangle 300 20 'solid 'white)
                                                                                               (rectangle 302 22 'solid 'black)))))

;; tock: world --> world
(define (tock w)
  (cond
    [(send (world-player w) dead?) (make-world (world-player w) (world-npc w) 'l "YOU LOOSE!")]
    [(send (world-npc w) dead?) (make-world (world-player w) (world-npc w) 'w "YOU WIN!")]
    [else
     (if (symbol=? (world-phase w) 'e)
         (make-world
          (send (world-player w) apply-attack 
                (send (invintory-wepon (send (world-npc w) get-invintory)) get-accuracy) 
                (send (world-npc w) get-damage)
                (send (invintory-wepon (send (world-npc w) get-invintory)) get-type))
          (world-npc w)
          'p
          "")
         w)]))

;; handle-key : world --> world
(define (handle-key w k)
  (cond
    [(key=? k "escape") WORLD]
    [(and (not (string=? "" (world-text w))) (eq? (world-phase w) 'p) (key=? k "\b"))
     (make-world (world-player w) (world-npc w) (world-phase w)
                 (substring (world-text w) 0 (- (string-length (world-text w)) 1)))]
    [(and (symbol=? (world-phase w) 'p) (key=? k "\r"))
     (cond
       ;; attack
       [(or (string=? (world-text w) "attack")
            (string=? (world-text w) "a"))
        (make-world (world-player w) (send (world-npc w) apply-attack
                                           (send (invintory-wepon (send (world-player w) get-invintory)) get-accuracy)
                                           (send (world-player w) get-damage)
                                           (send (invintory-wepon (send (world-player w) get-invintory)) get-type)) 'e "")]
       ;; heal
       [(string=? (world-text w) "heal") (if (< (send (world-player w) get-mp) 5) w
                                             (make-world (send (send (world-player w) apply-spell HEAL) remove-mp 5)
                                                         (world-npc w) 'e ""))]
       ;; agilify
       [(string=? (world-text w) "agilify") (if (< (send (world-player w) get-mp) 5) w
                                                (make-world (send (send (world-player w) apply-spell AGILIFY) remove-mp 5)
                                                            (world-npc w) 'e ""))]
       ;; strongify
       [(string=? (world-text w) "strongify") (if (< (send (world-player w) get-mp) 5) w
                                                  (make-world (send (send (world-player w) apply-spell STRONGIFY) remove-mp 5)
                                                              (world-npc w) 'e ""))]
       [(string=? (world-text w) "iceify wepon") (if (< (send (world-player w) get-mp) 10) w
                                                     (make-world (send (send (world-player w) apply-spell ICEIFY-WEPON) remove-mp 10)
                                                                 (world-npc w) 'e ""))]
       [(string=? (world-text w) "flameify wepon") (if (< (send (world-player w) get-mp) 10) w
                                                       (make-world (send (send (world-player w) apply-spell FLAMEIFY-WEPON) remove-mp 10)
                                                                   (world-npc w) 'e ""))]
       ;; light ray
       [(string=? (world-text w) "light ray") (if (< (send (world-player w) get-mp) 10) w
                                                  (make-world (send (world-player w) remove-mp 10)
                                                              (send (world-npc w) apply-spell LIGHT-RAY) 'e ""))]
       ;; use magic potion
       [(string=? (world-text w) "use magic potion") (make-world (send (world-player w) use-consumable MAGIC-POTION)
                                                                 (world-npc w) 'e "")]
       [else w])]
    [(and (symbol=? (world-phase w) 'p) (key=? k "right"))
     (make-world (world-player w)(world-npc w) 'e "")]
    [(symbol=? (world-phase w) 'p)
     (make-world (world-player w) (world-npc w) 'p (string-append (world-text w) k))]
    [else w]))

;; main
(define (main w)
  (big-bang w
            [to-draw render]
            [on-tick tock]
            [on-key handle-key]))

;; run
(main WORLD)
