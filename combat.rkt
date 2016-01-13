#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(provide (struct-out spell) item%
         (struct-out posn)
         character%
         player%
         npc%
         (struct-out inventory)
         weapon%
         consumable%
         (struct-out animation)
         (struct-out combat)
         (struct-out map-animation)
         (all-defined-out))

;; CHARACTERS -----------------------------------------------------------
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
    get-position ;; gets player's position
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
     position ;; a posn that is the player's position
     map-animation ;; a map-animation that is the characters map animation
     dir ;; a symbol that is the character's direction
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
    (define/public (get-position) position)
    (define/public (get-map-animation) map-animation)
    (define/public (get-dir) dir)
    (define/public (get-damage)
      (+ (send (inventory-weapon character-inventory) get-damage) strength))
    (define/public (dead?) (<= health 0))))

(define-struct posn (x y))

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
             get-inventory
             get-spells
             get-weakness
             get-resistance
             get-animation
             get-damage
             dead?
             get-position
             get-map-animation
             get-dir)
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
                   animation
                   position
                   map-animation
                   dir)
    (define/public (clone #:name [new-name name]
                          #:health [new-health health]
                          #:max-health [new-max-health max-health]
                          #:base-agility [new-base-agility base-agility]
                          #:agility [new-agility agility]
                          #:base-strength [new-base-strength base-strength]
                          #:strength [new-strength strength]
                          #:character-inventory [new-character-inventory character-inventory]
                          #:spells [new-spells spells]
                          #:weakness [new-weakness weakness]
                          #:resistance [new-resistance resistance]
                          #:animation [new-animation animation]
                          #:level [new-level level]
                          #:max-mp [new-max-mp max-mp]
                          #:mp [new-mp mp]
                          #:current-xp [new-current-xp current-xp]
                          #:position [new-position position]
                          #:map-animation [new-map-animation map-animation]
                          #:dir [new-dir dir])
      (new this%
           [name new-name]
           [health new-health]
           [max-health new-max-health]
           [base-agility new-base-agility]
           [agility new-agility]
           [base-strength new-base-strength]
           [strength new-strength]
           [character-inventory new-character-inventory]
           [spells new-spells]
           [weakness new-weakness]
           [resistance new-resistance]
           [animation new-animation]
           [level new-level]
           [max-mp new-max-mp]
           [mp new-mp]
           [current-xp new-current-xp]
           [position new-position]
           [map-animation new-map-animation]
           [dir new-dir]))
    (define/public (get-level) level) ;; produces player's level
    (define/public (get-max-mp) max-mp) ;; produces player's max mp
    (define/public (get-mp) mp) ;; produces player's level
    (define/public (get-current-xp) current-xp) ;; produces player's level
    (define/public (remove-mp n)
      (send this clone #:mp (- mp n)))
    (define/public (add-xp xp-award) ;; adds xp-award to player's current xp
      (send this clone #:current-xp (+ current-xp xp-award)))
    (define/public (apply-spell spell)
      ((spell-effect spell) this))
    (define/public (use-consumable c)
      ((send c get-effect) this))
    (define/public (apply-attack attacker-accuracy attacker-damage weapon-type)
      (send this clone #:health (- health (if (attack-landed? agility attacker-accuracy)
                                              (damage-character this attacker-damage weapon-type) 0))))))

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
             dead?
             get-position
             get-map-animation
             get-dir)
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
                   animation
                   position
                   map-animation
                   dir)
    (define/public (clone #:name [new-name name]
                          #:health [new-health health]
                          #:max-health [new-max-health max-health]
                          #:base-agility [new-base-agility base-agility]
                          #:agility [new-agility agility]
                          #:base-strength [new-base-strength base-strength]
                          #:strength [new-strength strength]
                          #:character-inventory [new-character-inventory character-inventory]
                          #:spells [new-spells spells]
                          #:weakness [new-weakness weakness]
                          #:resistance [new-resistance resistance]
                          #:animation [new-animation animation]
                          #:position [new-position position]
                          #:map-animation [new-map-animation map-animation]
                          #:dir [new-dir dir]
                          #:xp-award [new-xp-award xp-award])
      (new this%
           [name new-name]
           [health new-health]
           [max-health new-max-health]
           [base-agility new-base-agility]
           [agility new-agility]
           [base-strength new-base-strength]
           [strength new-strength]
           [character-inventory new-character-inventory]
           [spells new-spells]
           [weakness new-weakness]
           [resistance new-resistance]
           [animation new-animation]
           [position new-position]
           [dir new-dir]
           [map-animation new-map-animation]
           [xp-award new-xp-award]))
    (define/public (get-xp-award) xp-award)
    (define/public (apply-spell spell)
      ((spell-effect spell) this))
    (define/public (use-consumable c)
      ((send c get-effect) this))
    (define/public (apply-attack attacker-accuracy attacker-damage weapon-type)
      (send this clone #:health (- health (if (attack-landed? base-agility attacker-accuracy)
                                              (damage-character this attacker-damage weapon-type) 0))))))
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
    (inherit 
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
      type)
    (define/public (clone #:name [new-name name] #:description [new-description description]
                          #:weapon-accuracy [new-weapon-accuracy weapon-accuracy]
                          #:weapon-damage [new-weapon-damage weapon-damage] #:type [new-type type])
      (new this%
           [name new-name]
           [description new-description]
           [weapon-accuracy new-weapon-accuracy]
           [weapon-damage new-weapon-damage]
           [type new-type]))))

(define equipment%
  (class* item% (base-item<%>)
    (super-new)
    (inherit-field
     name
     description
     image)
    (init-field
     defence ;; a nat that is the equipments defence
     equipment-portion ;; a symbol that is the portion of the body the equipment goes on
     )
    (define/public (get-defence) ;; produces the equipment's defence
      defence)
    (define/public (get-portion) ;; produces the equipment's portion
      equipment-portion)
    (define/public (clone #:name [new-name name] #:description [new-description description]
                          #:image [new-image image] #:defence [new-defence defence] 
                          #:equipment-portion [new-equipment-portion equipment-portion])
      (new this%
           [name new-name]
           [description new-description]
           [image new-image]
           [defence new-defence]
           [equipment-portion new-equipment-portion]))))

(define consumable%
  (class* item% (base-item<%>)
    (super-new)
    (inherit-field image
                   name
                   description)
    (inherit get-image
             get-name)
    (init-field
     effect ;; a function that takes a character and produces a character
     animation ;; a list of images that is the consumable's animation
     number ;; an int that is the number of this item the player has
     )
    (define/public (get-effect) effect) ;; gets items effect
    (define/public (get-animation) animation) ;; gets items animation
    (define/public (get-number) number) ;; gets the number of this item player has
    ))

(define gold%
  (class* item% (base-item<%>)
    (super-new)
    (inherit-field name
                   image
                   description)
    (inherit get-image
             get-name)
    (init-field
     number ;; an int that is the number of this item the player has
     )
    (define/public (get-number) number) ;; gets the number of this item player has
    ))

;; an inventory is a (make-inventory weapon list-of-equipment list-of-consumables list-of-items)
(define-struct inventory (weapon equiped equipment consumables miscellaneous))

;; a spell is a (make-spell target string string effect list-of-images int image)
(define-struct spell (target name discription effect animation cost image))

;; an animation is a (make-animation image image image image image) where:
;; the first image is the characers standby image
;; the second is the character's attack image
;; the third is the character's cast image
;; the fourth is the character's flinch animation
;; the fifth is the character's win image
;; the sixth is the characetr's loose image
(define-struct animation (standby attack cast flinch win loose))

;; a map-animation is a (make-map-animation image)
(define-struct map-animation (north-stationary
                              east-stationary
                              south-stationary
                              west-stationary))

;; Combat ----------------------------------------------------------------------------------
;; a combat is a (make-combat player npc symbol symbol loi) where
;; the player is the player
;; the npc is an enemy
;; the first symbol is one of:
;; - 'p
;; - 'pa
;; - 'ps
;; - 'e
;; - 'ea
;; - 'w
;; - 'l
;; the second symbol is one of
;; - 'm
;; - 's
;; - 'i
;; - 'e
;; the list of images are the images in the animation queue
(define-struct combat (player npc phase menu loi dungeon-name room-name))