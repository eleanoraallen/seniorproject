#lang racket

(provide (struct-out spell)
         player% npc%
         (struct-out inventory)
         weapon%
         consumable%)

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

(define weapon%
  (class item%
    (super-new)
    (init-field
     weapon-damage ;; a nat that is the weapons damage
     weapon-accuracy ;; a nat between 0 and 1 that is the proboblity that the weapon will hit
     type;; a symbol that is the weapon's type
     )
    (inherit ;; TODO remove unused inherits and inherit-fields
      get-name
      get-description)
    (inherit-field
     name
     description)
    (define/public (get-accuracy) ;; produces weapon's accuracy
      weapon-accuracy)
    (define/public (get-damage) ;; produces weapon's damage
      weapon-damage)
    (define/public (get-type) ;; produces weapon's type
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

;; an inventory is a (make-inventory weapon list-of-equipment list-of-consumables list-of-items)
(define-struct inventory (weapon equiped consumables miscellaneous)
  #:transparent)

;; a spell is a (make-spell string string effect)
(define-struct spell (name discription effect)
  #:transparent)

;; CHARACTERS ----------------------------------------------------------------
(define base-character<%>
  (interface ()
    get-name ;; gets character's name
    get-health ;; gets character's health
    get-base-agility ;; gets character's base-agility
    get-agility ;; gets character's agility
    get-base-strength ;; gets characters base strength
    get-strength ;; gets character's strength
    get-inventory ;; gets the character's inventory
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
     character-inventory ;; the character's inventory
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
    (define/public (get-inventory) character-inventory)
    (define/public (get-spells) spells)
    (define/public (get-weakness) weakness)
    (define/public (get-resistance) resistance)
    (define/public (get-damage) 
      (+ (send (inventory-weapon character-inventory) get-damage) strength))
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
    (inherit get-name   ;; TODO: remove unused inherits
             get-health
             get-base-agility
             get-agility
             get-base-strength
             get-strength
             get-inventory
             get-spells
             get-weakness
             get-resistance
             get-damage
             dead?)
    (inherit-field name   ;; TODO remove unused inherits (after using `this` below)
                   health
                   max-health
                   base-agility
                   agility
                   base-strength
                   strength
                   character-inventory
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
           [character-inventory character-inventory]
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
           [character-inventory character-inventory]
           [spells spells]
           [weakness weakness]
           [resistance resistance]
           [level level]
           [max-mp max-mp]
           [mp mp]
           [current-xp (+ current-xp xp-award)]))
    (define/public (apply-spell spell)
      ((spell-effect spell) this)) ;; FIXED
    (define/public (use-consumable c)
      ((send c get-effect) (new player% ;; TODO use `this` as on line 184
                                [name name]
                                [health health]
                                [max-health max-health]
                                [base-agility base-agility]
                                [agility agility]
                                [base-strength base-strength]
                                [strength strength]
                                [character-inventory character-inventory]
                                [spells spells]
                                [weakness weakness]
                                [resistance resistance]
                                [level level]
                                [max-mp max-mp]
                                [mp mp]
                                [current-xp current-xp])))
    (define/public (apply-attack attacker-accuracy
                                 attacker-damage
                                 weapon-type)
      (new player%
           [name name]
           ;; TODO lift damage calculation out into a helper function that
           ;; npc% can also use, OR move the function into superclass
           ;; TODO split new health calculation into cohesive helpers:
           ;;   - did the attack succeed? : (attack-landed? agility accuracy)
           ;;   - how much damage it did
           [health (- health (if (< (* (* (get-agility) attacker-accuracy) 100) (random 100))
                                 0
                                 (local 
                                   [(define (get-armor-defense e) ;; gets the defensive bonus from all character's equiped armor
                                      (cond [(empty? e) 0]
                                            [(cons? e) (+ (send (first e) get-defence) (get-armor-defense (rest e)))]))
                                    (define (apply-damage attack-power) ;; amount of damage to be applied for an attack of a given power
                                     (if (>= (get-armor-defense (inventory-equiped character-inventory)) attack-power)
                                         1 (- attack-power (get-armor-defense (inventory-equiped character-inventory)))))
                                    ]
                                   (cond
                                     [(and (eq? weapon-type weakness) (not (eq? weakness 'none)))
                                      (apply-damage (round (* attacker-damage 2)))]
                                     [(and (eq? weapon-type resistance) (not (eq? resistance 'none)))
                                      (apply-damage (round (* attacker-damage .5)))]
                                     [else (apply-damage attacker-damage)]))))]                   
           [max-health max-health]
           [base-agility base-agility]
           [agility agility]
           [base-strength base-strength]
           [strength strength]
           [character-inventory character-inventory]
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
             get-inventory
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
                   character-inventory
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
                                 [character-inventory character-inventory]
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
                                [character-inventory character-inventory]
                                [spells spells]
                                [weakness weakness]
                                [resistance resistance]
                                [xp-award xp-award])))
    (define/public (apply-attack attacker-accuracy
                                 attacker-damage
                                 weapon-type)
      (new npc%
           [name name]
           [health (- health (if (< (* (* (get-agility) attacker-accuracy) 100) (random 100))
                                 0
                                 (local 
                                   [(define (get-armor-defense e) ;; gets the defensive bonus from all character's equiped armor
                                      (cond [(empty? e) 0]
                                            [(cons? e) (+ (send (first e) get-defence) (get-armor-defense (rest e)))]))]
                                   (define (apply-damage attack-power) ;; amount of damage to be applied for an attack of a given power
                                     (if (>= (get-armor-defense (inventory-equiped character-inventory)) attack-power)
                                         1 (- attack-power (get-armor-defense (inventory-equiped character-inventory)))))
                                   (cond
                                     [(and (eq? weapon-type weakness) (not (eq? weakness 'none)))
                                      (apply-damage (round (* attacker-damage 2)))]
                                     [(and (eq? weapon-type resistance) (not (eq? resistance 'none)))
                                      (apply-damage (round (* attacker-damage .5)))]
                                     [else (apply-damage attacker-damage)]))))]                   
           [max-health max-health]
           [base-agility base-agility]
           [agility agility]
           [base-strength base-strength]
           [strength strength]
           [character-inventory character-inventory]
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
            [character-inventory (send c get-inventory)]
            [weakness (send c get-weakness)]
            [resistance (send c get-resistance)]))))
  
  ;; WEAPONS
  (define TESTSWORD
    (new weapon%
         [name "Test Sword"]
         [description "A sword used exclusivly for testing the game."]
         [weapon-damage 50]
         [weapon-accuracy 1]
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
                        [character-inventory (send c get-inventory)]
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
         [character-inventory (make-inventory TESTSWORD (list TESTARMOR) (list TESTSWORD TESTARMOR) (list TESTPOTION))]
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
         [character-inventory (make-inventory TESTSWORD (list TESTARMOR) (list TESTSWORD TESTARMOR) (list TESTPOTION))]
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
         [character-inventory (make-inventory TESTSWORD (list TESTARMOR) (list TESTSWORD TESTARMOR) (list TESTPOTION))]
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
         [character-inventory (make-inventory TESTSWORD (list TESTARMOR) (list TESTSWORD TESTARMOR) (list TESTPOTION))]
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
         [character-inventory (make-inventory TESTSWORD empty empty (list TESTPOTION))]
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
         [character-inventory (make-inventory TESTSWORD (list TESTARMOR) (list TESTSWORD TESTARMOR) (list TESTPOTION))]
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

