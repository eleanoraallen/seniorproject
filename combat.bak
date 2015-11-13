#lang racket

(require 2htdp/image)

(provide (struct-out spell)
         character% item%
         player% npc%
         (struct-out inventory)
         weapon%
         consumable%
         (struct-out animation))

;; ITEMS ----------------------------------------------------------------
(define base-item<%>
  (interface ()))

(define item%
  (class* object% (base-item<%>)
    (super-new)
    (init-field
     name ;; string that is the items name
     description ;; string that is the description of the item
     image ;; an image of the item
     )
    (define/public (get-name) name)
    (define/public (get-description) description)
    (define/public (get-image) image)))

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
    (inherit-field image)
    (inherit get-image)
    (init-field
     effect ;; a function that takes a character and produces a character
     animation ;; a list of images that is the consumable's animation
     )
    (define/public (get-effect) effect) ;; gets items effect
    (define/public (get-animation) animation) ;; gets items animation
    ))

;; an inventory is a (make-inventory weapon list-of-equipment list-of-consumables list-of-items)
(define-struct inventory (weapon equiped consumables miscellaneous))

;; a spell is a (make-spell string string effect list-of-images)
(define-struct spell (name discription effect animation))

;; an animation is a (make-animation image image image image image) where:
;; the first image is the characers standby image
;; the second is the character's attack image
;; the third is the character's cast image
;; the fourth is the character's flinch animation
;; the fifth is the character's win image
;; the sixth is the characetr's loose image
(define-struct animation (standby attack cast flinch win loose))


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
    get-animation ;; gets character's animation
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
     animation ;; the character's animation
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
    (define/public (get-animation) animation)
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
             get-animation
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
                   resistance
                   animation)
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
           [animation animation]
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
           [animation animation]
           [level level]
           [max-mp max-mp]
           [mp mp]
           [current-xp (+ current-xp xp-award)]))
    (define/public (apply-spell spell)
      ((spell-effect spell) this))
    (define/public (use-consumable c)
      ((send c get-effect) this))
    (define/public (apply-attack attacker-accuracy attacker-damage weapon-type)
      (new player%
           [name name]
           [health (- health (if (attack-landed? base-agility attacker-accuracy)
                                 (damage-character this attacker-damage weapon-type) 0))]                   
           [max-health max-health]
           [base-agility base-agility]
           [agility agility]
           [base-strength base-strength]
           [strength strength]
           [character-inventory character-inventory]
           [spells spells]
           [weakness weakness]
           [resistance resistance]
           [animation animation]
           [level level]
           [max-mp max-mp]
           [mp mp]
           [current-xp current-xp]))))

;; attack-landed? : num num --> bool
;; true iff attack landed
(define (attack-landed? agi acc) (> (* (* agi acc) 100) (random 100)))

;; damage-character : character num symbol --> num
;; takes a character, attacker damage, and wepon type, and produces amount of damage to be applied
(define (damage-character c dmg type)
  (local 
    [(define (get-armor-defense e) 
       (cond [(empty? e) 0]
             [(cons? e) (+ (send (first e) get-defence) (get-armor-defense (rest e)))]))
     (define (apply-damage attack-power)
       (if (>= (get-armor-defense (inventory-equiped (send c get-inventory))) attack-power)
           1 (- attack-power (get-armor-defense (inventory-equiped (send c get-inventory))))))]
    (cond
      [(and (eq? type (send c get-weakness)) (not (eq? (send c get-weakness) 'none)))
       (apply-damage (round (* dmg 2)))]
      [(and (eq? type (send c get-resistance)) (not (eq? (send c get-resistance) 'none)))
       (apply-damage (round (* dmg .5)))]
      [else (apply-damage dmg)])))

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
                   resistance
                   animation)
    (define/public (get-xp-award) xp-award)
    (define/public (apply-spell spell)
      ((spell-effect spell) this))
    (define/public (use-consumable c)
      ((send c get-effect) this))
    (define/public (apply-attack attacker-accuracy attacker-damage weapon-type)
      (new npc%
           [name name]
           [health (- health (if (attack-landed? base-agility attacker-accuracy)
                                 (damage-character this attacker-damage weapon-type) 0))]                     
           [max-health max-health]
           [base-agility base-agility]
           [agility agility]
           [base-strength base-strength]
           [strength strength]
           [character-inventory character-inventory]
           [spells spells]
           [weakness weakness]
           [resistance resistance]
           [animation animation]
           [xp-award xp-award]))))

(module+ test
  (require rackunit)
  ;; SPELLS
  (define TESTSPELL1
    (make-spell
     "magic bomb"
     "bomb of fire"
     (lambda (c)
       (send c apply-attack 1 75 'fire))
     empty))
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
            [resistance (send c get-resistance)]
            [animation (send c get-animation)]))
     empty))
  
  ;; WEAPONS
  (define TESTSWORD
    (new weapon%
         [name "Test Sword"]
         [description "A sword used exclusivly for testing the game."]
         [image (square 20 'solid 'white)]
         [weapon-damage 50]
         [weapon-accuracy 1]
         [type 'metal]))
  
  ;; ARMOR
  (define TESTARMOR
    (new equipment%
         [name "Test Armor"]
         [description "Armor used exclusivly for testing the game"]
         [image (square 20 'solid 'green)]
         [defence 20]
         [equipment-portion 'body]))
  
  ;; CONSUMABLES
  (define TESTPOTION
    (new consumable%
         [name "Test Potion"]
         [description "A potion used exclusivly for testing the game"]
         [image (square 20 'solid 'blue)]
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
                        [resistance (send c get-resistance)]
                        [animation (send c get-animation)]))]
         [animation empty]))
  
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
         [animation (make-animation (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white))]
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
         [animation (make-animation (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white))]
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
         [animation (make-animation (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white))]
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
         [animation (make-animation (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white))]
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
         [animation (make-animation (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white))]
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
         [animation (make-animation (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white) (square 50 'solid 'white))]
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
