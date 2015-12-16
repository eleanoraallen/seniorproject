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
             get-map-animation)
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
                   map-animation)
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
                          #:map-animation [new-map-animation map-animation])
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
           [map-animation new-map-animation]))
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
      (send this clone #:health (- health (if (attack-landed? base-agility attacker-accuracy)
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
             get-map-animation)
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
                   map-animation)
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

;; an inventory is a (make-inventory weapon list-of-equipment list-of-consumables list-of-items)
(define-struct inventory (weapon equiped consumables miscellaneous))

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
(define-struct map-animation (forward-stationary))


;; Combat ---------------------------------------------------------------------------------------------------------
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
(define-struct combat (player npc phase menu loi))

;; render: combat --> image
;; renders a combat as an image
(define (render-combat w)
  (above
   (overlay (if (empty? (combat-loi w)) (square 0 'solid 'white) (first (combat-loi w)))
            (render-npc (send (combat-npc w) get-animation) (combat-phase w))
            (render-player (send (combat-player w) get-animation) (combat-phase w)) 
            (above
             (beside
              (render-data (send (combat-npc w) get-name) 
                           (send (combat-npc w) get-health)
                           (send (combat-npc w) get-max-health))
              (rectangle 550 0 'solid 'white)
              (render-data (send (combat-player w) get-name)
                           (send (combat-player w) get-health)
                           (send (combat-player w) get-max-health)
                           #:mp (send (combat-player w) get-mp)
                           #:max-mp (send (combat-player w) get-max-mp)))
             (rectangle 0 350 'solid 'white))
            (bitmap/file "background.png")
            (rectangle 810 460 'solid 'black))
   (overlay/align "middle" "top"
                  (render-menu (combat-player w) (combat-menu w))
                  (rectangle 810 170 'solid 'black))))

;; render-menu : player symbol --> image
;; takes a player and a symbol and outputs the appropriate menu
(define (render-menu p m)
  (cond  
    ;; main menu
    [(symbol=? m 'm) 
     (overlay 
      (beside 
       (overlay/align 
        "middle" "top" 
        (above (rectangle 0 21 'solid 'black) (text "1: Attack" 13 'black))
        (overlay (scale .17 (rotate 240 (bitmap/file "dagger.png")))
                 (rectangle 190 130 'solid 'gray) (rectangle 200 140 'solid 'black)))
       (rectangle 50 0 'solid 'black)
       (overlay/align 
        "middle" "top" 
        (above (rectangle 0 11 'solid 'black) (text "2: Items" 13 'black))
        (overlay (above (rectangle 0 20 'solid 'black) (scale .3 (bitmap/file "bottle.png")))
                 (rectangle 190 130 'solid 'gray) (rectangle 200 140 'solid 'black)))
       (rectangle 50 0 'solid 'black)
       (overlay/align 
        "middle" "top" 
        (above (rectangle 0 11 'solid 'black) (text "3: Spells" 13 'black))
        (overlay (above (rectangle 0 15 'solid 'black) 
                        (scale .14 (bitmap/file "phlogiston.png")))
                 (rectangle 190 130 'solid 'gray) (rectangle 200 140 'solid 'black))))
      (rectangle 800 165 'solid (make-color 60 60 60)))]
    ;; item menu
    [(symbol=? m 'i) 
     (cond 
       [(empty? (inventory-consumables (send p get-inventory)))
        (overlay (text "No Items Available!" 20 'white)
                 (rectangle 800 165 'solid (make-color 60 60 60)))]
       [(= (length (inventory-consumables (send p get-inventory))) 1)
        (overlay (render-item-block (first (inventory-consumables (send p get-inventory))))
                 (rectangle 800 165 'solid (make-color 60 60 60)))]
       [(= (length (inventory-consumables (send p get-inventory))) 2)
        (overlay 
         (beside 
          (render-item-block (first (inventory-consumables (send p get-inventory))))
          (rectangle 50 0 'solid 'orange)
          (render-item-block (second (inventory-consumables (send p get-inventory)))))
         (rectangle 800 165 'solid (make-color 60 60 60)))]
       [(= (length (inventory-consumables (send p get-inventory))) 3)
        (overlay
         (beside
          (render-item-block (first (inventory-consumables (send p get-inventory))))
          (rectangle 50 0 'solid 'orange)
          (render-item-block (second (inventory-consumables (send p get-inventory))))
          (rectangle 50 0 'solid 'black)
          (render-item-block (third (inventory-consumables (send p get-inventory)))))
         (rectangle 800 165 'solid (make-color 60 60 60)))]
       [else (overlay
              (beside
               (rotate 90 (overlay (isosceles-triangle 30 120 'solid 'white)
                                   (isosceles-triangle 40 120 'solid 'black)))
               (rectangle 15 0 'solid 'black)
               (render-item-block (first (inventory-consumables (send p get-inventory))))
               (rectangle 50 0 'solid 'orange)
               (render-item-block (second (inventory-consumables (send p get-inventory))))
               (rectangle 50 0 'solid 'black)
               (render-item-block (third (inventory-consumables (send p get-inventory))))
               (rectangle 15 0 'solid 'black)
               (rotate 270 (overlay (isosceles-triangle 30 120 'solid 'white)
                                    (isosceles-triangle 40 120 'solid 'black))))
              (rectangle 800 165 'solid (make-color 60 60 60)))])] 
    ;; spell menu
    [(symbol=? m 's)
     (cond 
       [(empty? (send p get-spells))
        (overlay (text "No Spells Available!" 20 'white)
                 (rectangle 800 165 'solid (make-color 60 60 60)))]
       [(= (length (send p get-spells)) 1)
        (overlay (render-spell-block (first (send p get-spells)))
                 (rectangle 800 165 'solid (make-color 60 60 60)))]
       [(= (length (send p get-spells)) 2)
        (overlay 
         (beside (render-spell-block (first (send p get-spells)))
                 (rectangle 50 0 'solid 'black)
                 (render-spell-block (second (send p get-spells))))
         (rectangle 800 165 'solid (make-color 60 60 60)))]
       [(= (length (send p get-spells)) 3)
        (overlay 
         (beside (render-spell-block (first (send p get-spells)))
                 (rectangle 50 0 'solid 'black)
                 (render-spell-block (second (send p get-spells)))
                 (rectangle 50 0 'solid 'black)
                 (render-spell-block (third (send p get-spells))))
         (rectangle 800 165 'solid (make-color 60 60 60)))]
       [else
        (overlay 
         (beside (rotate 90 (overlay (isosceles-triangle 30 120 'solid 'white)
                                     (isosceles-triangle 40 120 'solid 'black)))
                 (rectangle 15 0 'solid 'black)
                 (render-spell-block (first (send p get-spells)))
                 (rectangle 50 0 'solid 'black)
                 (render-spell-block (second (send p get-spells)))
                 (rectangle 50 0 'solid 'black)
                 (render-spell-block (third (send p get-spells)))
                 (rectangle 15 0 'solid 'black)
                 (rotate 270 (overlay (isosceles-triangle 30 120 'solid 'white)
                                      (isosceles-triangle 40 120 'solid 'black))))
         (rectangle 800 165 'solid (make-color 60 60 60)))])]
    [else (rectangle 800 165 'solid (make-color 60 60 60))]))



;; render-spell-block : item --> image
;; renders an spell block for a given spell
(define (render-spell-block s)
  (overlay/align 
   "middle" "top" 
   (above (rectangle 0 11 'solid 'black) 
          (text (spell-name s) 12 'black)
          (text (string-append "MP Cost: " (number->string (spell-cost s))) 10 'black))
   (overlay/align 
    "middle" "bottom"
    (above (text (spell-discription s) 10 'black)
           (rectangle 0 11 'solid 'black))
    (overlay (above (rectangle 0 (image-height (text "I" 12 'black)) 'solid 'black)
                    (spell-image s))
             (rectangle 190 130 'solid 'gray) 
             (rectangle 200 140 'solid 'black)))))

;; render-item-block : item --> image
;; renders an item block for a given image
(define (render-item-block i)
  (overlay/align 
   "middle" "top" 
   (above (rectangle 0 11 'solid 'black) 
          (text (string-append 
                 (send i get-name) ": " 
                 (number->string (send i get-number))) 
                13 'black))
   (overlay/align 
    "middle" "bottom"
    (above (text (send i get-description) 13 'black)
           (rectangle 0 11 'solid 'black))
    (overlay (send i get-image)
             (rectangle 190 130 'solid 'gray) 
             (rectangle 200 140 'solid 'black)))))

;; render-data: string num num #:num #:num --> image
;; renders given character data as an image
(define (render-data name health max-health #:mp [mp -999] #:max-mp [max-mp -999])
  (above
   (text name 13 'white)
   (if (>= 0 health) 
       (text (string-append "Health: 0/" (number->string max-health)) 13 'white) 
       (text (string-append "Health: " (number->string health) "/"
                            (number->string max-health)) 13 'white))
   (if (> 0 mp) 
       (square 0 'solid 'white) 
       (text (string-append "MP: "
                            (number->string mp) "/"
                            (number->string max-mp)) 13 'white))))

;; render-npc animation symbol --> image
;; takes an animation and a phase and outputs appropriate npc animation
(define (render-npc a p)
  (cond
    [(eq? p 'l) (animation-win a)]
    [(eq? p 'w) (animation-loose a)]
    [(eq? p 'ea) (animation-attack a)]
    [(eq? p 'pa) (animation-flinch a)]
    [(eq? p 'ps) (animation-flinch a)]
    [else (animation-standby a)]))

;; render-player animation symbol --> image
;; takes an animation and a phase and outputs appropriate player animation
(define (render-player a p)
  (cond
    [(eq? p 'l) (animation-loose a)]
    [(eq? p 'w) (animation-win a)]
    [(eq? p 'ea) (animation-flinch a)]
    [(eq? p 'pa) (animation-attack a)]
    [(eq? p 'ps) (animation-cast a)]
    [else (animation-standby a)]))

;; npc-action : combat --> combat
;; makes the npc take an action
(define (npc-action w)
  (cond
    [(and (> (/ (send (combat-npc w) get-max-health) 4) (send (combat-npc w) get-health))
          (not (empty? (inventory-consumables (send (combat-npc w) get-inventory)))))
     (make-combat
      (combat-player w)
      (send (send (combat-npc w) 
                  clone #:character-inventory 
                  (make-inventory
                   (inventory-weapon (send (combat-npc w) get-inventory))
                   (inventory-equiped (send (combat-npc w) get-inventory))
                   (if (> (send (first (inventory-consumables (send (combat-npc w) get-inventory))) get-number) 1)
                       (cons (new consumable% 
                                  [image (send (first (inventory-consumables (send (combat-npc w) get-inventory))) get-image)]
                                  [name (send (first (inventory-consumables (send (combat-npc w) get-inventory))) get-name)]
                                  [description (send (first (inventory-consumables (send (combat-npc w) get-inventory))) get-description)]
                                  [effect (send (first (inventory-consumables (send (combat-npc w) get-inventory))) get-effect)]
                                  [animation (send (first (inventory-consumables (send (combat-npc w) get-inventory))) get-animation)]
                                  [number (- (send (first (inventory-consumables (send (combat-npc w) get-inventory))) get-number) 1)])
                             (rest (inventory-consumables (send (combat-npc w) get-inventory))))
                       (rest (inventory-consumables (send (combat-npc w) get-inventory))))
                   (inventory-miscellaneous (send (combat-npc w) get-inventory))))
            use-consumable (first (inventory-consumables (send (combat-npc w) get-inventory)))) 
      'ea 'e (send (first (inventory-consumables (send (combat-npc w) get-inventory))) get-animation))]
    [(= (random 2) 1) (set-up-spell w (list-ref (send (combat-npc w) get-spells) (random (length (send (combat-npc w) get-spells)))))]
    [else
     (make-combat
      (send (combat-player w) apply-attack 
            (send (inventory-weapon (send (combat-npc w) get-inventory)) get-accuracy) 
            (send (combat-npc w) get-damage)
            (send (inventory-weapon (send (combat-npc w) get-inventory)) get-type))
      (combat-npc w)
      'ea
      'e
      (make-list 10 (bitmap/file "blankbackground.png")))]))

;; set-up-spell combat spell --> combat
;; takes a combat and a spell cast by the enemy and outputs updated combat
(define (set-up-spell w s)
  (make-combat
   (send (combat-player w) apply-spell s)
   (combat-npc w)
   'ea
   'e
   (spell-animation s)))

;; HANDLE KEY ---------------------------------------------------------------------------------------------------------------------------------
(define (handle-combat-key w k)
  (if (symbol=? (combat-phase w) 'p)
      (cond
        ;; main menu
        [(symbol=? (combat-menu w) 'm)
         (cond
           [(key=? k "1") 
            (make-combat 
             (combat-player w) 
             (send (combat-npc w) apply-attack 
                   (send (inventory-weapon (send (combat-player w) get-inventory)) get-accuracy)
                   (send (combat-player w) get-damage) 
                   (send (inventory-weapon (send (combat-player w) get-inventory)) get-type))
             'pa 'e (make-list 10 (bitmap/file "blankbackground.png")))]
           [(key=? k "2") 
            (make-combat (combat-player w)
                         (combat-npc w)
                         'p 'i empty)]
           [(key=? k "3") 
            (make-combat (combat-player w)
                         (combat-npc w)
                         'p 's empty)]
           [else w])]
        ;; spell menu
        [(symbol=? (combat-menu w) 's)
         (cond
           [(and (> (length (send (combat-player w) get-spells)) 0) (key=? k "1"))
            (if (>= (send (combat-player w) get-mp) (spell-cost (first (send (combat-player w) get-spells))))
                (if (eq? (spell-target (first (send (combat-player w) get-spells))) 'player)
                    (make-combat 
                     (send (send (combat-player w) 
                                 clone #:mp (- (send (combat-player w) get-mp) 
                                               (spell-cost (first (send (combat-player w) get-spells)))))
                           apply-spell (first (send (combat-player w) get-spells)))
                     (combat-npc w) 'pa 'e (spell-animation (first (send (combat-player w) get-spells))))
                    (make-combat 
                     (send (combat-player w) 
                           clone #:mp (- (send (combat-player w) get-mp) 
                                         (spell-cost (first (send (combat-player w) get-spells)))))
                     (send (combat-npc w) apply-spell (first (send (combat-player w) get-spells)))
                     'pa 'e (spell-animation (first (send (combat-player w) get-spells))))) w)]
           [(and (> (length (send (combat-player w) get-spells)) 1) (key=? k "2"))
            (if (>= (send (combat-player w) get-mp) (spell-cost (second (send (combat-player w) get-spells))))
                (if (eq? (spell-target (second (send (combat-player w) get-spells))) 'player)
                    (make-combat 
                     (send (send (combat-player w) 
                                 clone #:mp (- (send (combat-player w) get-mp) 
                                               (spell-cost (second (send (combat-player w) get-spells)))))
                           apply-spell (second (send (combat-player w) get-spells)))
                     (combat-npc w) 'pa 'e (spell-animation (second (send (combat-player w) get-spells))))
                    (make-combat 
                     (send (combat-player w) 
                           clone #:mp (- (send (combat-player w) get-mp) 
                                         (spell-cost (second (send (combat-player w) get-spells)))))
                     (send (combat-npc w) apply-spell (second (send (combat-player w) get-spells)))
                     'pa 'e (spell-animation (second (send (combat-player w) get-spells))))) w)]
           [(and (> (length (send (combat-player w) get-spells)) 2) (key=? k "3"))
            (if (>= (send (combat-player w) get-mp) (spell-cost (third (send (combat-player w) get-spells))))
                (if (eq? (spell-target (third (send (combat-player w) get-spells))) 'player)
                    (make-combat 
                     (send (send (combat-player w) 
                                 clone #:mp (- (send (combat-player w) get-mp) 
                                               (spell-cost (third (send (combat-player w) get-spells)))))
                           apply-spell (third (send (combat-player w) get-spells)))
                     (combat-npc w) 'pa 'e (spell-animation (third (send (combat-player w) get-spells))))
                    (make-combat 
                     (send (combat-player w) 
                           clone #:mp (- (send (combat-player w) get-mp) 
                                         (spell-cost (third (send (combat-player w) get-spells)))))
                     (send (combat-npc w) apply-spell (third (send (combat-player w) get-spells)))
                     'pa 'e (spell-animation (third (send (combat-player w) get-spells))))) w)]
           [(and (> (length (send (combat-player w) get-spells)) 3) (or (key=? k "right") (key=? k "d")))
            (make-combat
             (send (combat-player w) 
                   clone #:spells (append (rest (rest (rest (send (combat-player w) get-spells))))
                                          (list (first (send (combat-player w) get-spells))
                                                (second (send (combat-player w) get-spells))
                                                (third (send (combat-player w) get-spells)))))
             (combat-npc w) 'p 's empty)]
           [(and (> (length (send (combat-player w) get-spells)) 3) (or (key=? k "left") (key=? k "a")))
            (make-combat
             (send (combat-player w) 
                   clone #:spells (append (list (third (reverse (send (combat-player w) get-spells)))
                                                (second (reverse (send (combat-player w) get-spells)))
                                                (first (reverse (send (combat-player w) get-spells))))
                                          (reverse (rest (rest (rest (reverse (send (combat-player w) get-spells))))))))
             (combat-npc w) 'p 's empty)]
           [(or (key=? k "escape") (key=? k "\b"))
            (make-combat (combat-player w)                                                
                         (combat-npc w)
                         'p 'm empty)]
           [else w])]
        ;; item menu
        [(symbol=? (combat-menu w) 'i)
         (cond
           [(and (> (length (inventory-consumables (send (combat-player w) get-inventory))) 0) (key=? k "1"))
            (make-combat 
             (send (send (combat-player w) clone #:character-inventory
                         (make-inventory
                          (inventory-weapon (send (combat-player w) get-inventory))
                          (inventory-equiped (send (combat-player w) get-inventory))
                          (if (> (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-number) 1)
                              (cons (new consumable% 
                                         [image (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-image)]
                                         [name (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-name)]
                                         [description (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-description)]
                                         [effect (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-effect)]
                                         [animation (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-animation)]
                                         [number (- (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-number) 1)])
                                    (rest (inventory-consumables (send (combat-player w) get-inventory))))
                              (rest (inventory-consumables (send (combat-player w) get-inventory))))
                          (inventory-miscellaneous (send (combat-player w) get-inventory))))
                   use-consumable (first (inventory-consumables (send (combat-player w) get-inventory))))
             (combat-npc w) 'pa 'e (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-animation))]
           [(and (> (length (inventory-consumables (send (combat-player w) get-inventory))) 1) (key=? k "2"))
            (make-combat 
             (send (send (combat-player w) clone #:character-inventory
                         (make-inventory
                          (inventory-weapon (send (combat-player w) get-inventory))
                          (inventory-equiped (send (combat-player w) get-inventory))
                          (if (> (send (second (inventory-consumables (send (combat-player w) get-inventory))) get-number) 1)
                              (append
                               (list (first (inventory-consumables (send (combat-player w) get-inventory)))
                                     (new consumable% 
                                          [image (send (second (inventory-consumables (send (combat-player w) get-inventory))) get-image)]
                                          [name (send (second (inventory-consumables (send (combat-player w) get-inventory))) get-name)]
                                          [description (send (second (inventory-consumables (send (combat-player w) get-inventory))) get-description)]
                                          [effect (send (second (inventory-consumables (send (combat-player w) get-inventory))) get-effect)]
                                          [animation (send (second (inventory-consumables (send (combat-player w) get-inventory))) get-animation)]
                                          [number (- (send (second (inventory-consumables (send (combat-player w) get-inventory))) get-number) 1)]))
                               (rest (rest (inventory-consumables (send (combat-player w) get-inventory)))))
                              (cons (first (inventory-consumables (send (combat-player w) get-inventory))) (rest (rest (inventory-consumables (send (combat-player w) get-inventory))))))
                          (inventory-miscellaneous (send (combat-player w) get-inventory))))
                   use-consumable (second (inventory-consumables (send (combat-player w) get-inventory))))
             (combat-npc w) 'pa 'e (send (second (inventory-consumables (send (combat-player w) get-inventory))) get-animation))]
           [(and (> (length (inventory-consumables (send (combat-player w) get-inventory))) 2) (key=? k "3"))
            (make-combat 
             (send (send (combat-player w) clone #:character-inventory
                         (make-inventory
                          (inventory-weapon (send (combat-player w) get-inventory))
                          (inventory-equiped (send (combat-player w) get-inventory))
                          (if (> (send (third (inventory-consumables (send (combat-player w) get-inventory))) get-number) 1)
                              (append
                               (list (first (inventory-consumables (send (combat-player w) get-inventory)))
                                     (second (inventory-consumables (send (combat-player w) get-inventory)))
                                     (new consumable% 
                                          [image (send (third (inventory-consumables (send (combat-player w) get-inventory))) get-image)]
                                          [name (send (third (inventory-consumables (send (combat-player w) get-inventory))) get-name)]
                                          [description (send (third (inventory-consumables (send (combat-player w) get-inventory))) get-description)]
                                          [effect (send (third (inventory-consumables (send (combat-player w) get-inventory))) get-effect)]
                                          [animation (send (third (inventory-consumables (send (combat-player w) get-inventory))) get-animation)]
                                          [number (- (send (third (inventory-consumables (send (combat-player w) get-inventory))) get-number) 1)]))
                               (rest (rest (rest (inventory-consumables (send (combat-player w) get-inventory))))))
                              (append (list (first (inventory-consumables (send (combat-player w) get-inventory)))
                                            (second (inventory-consumables (send (combat-player w) get-inventory))))
                                      (rest (rest (rest (inventory-consumables (send (combat-player w) get-inventory)))))))
                          (inventory-miscellaneous (send (combat-player w) get-inventory))))
                   use-consumable (third (inventory-consumables (send (combat-player w) get-inventory))))
             (combat-npc w) 'pa 'e (send (third (inventory-consumables (send (combat-player w) get-inventory))) get-animation))]
           [(and (> (length (inventory-consumables (send (combat-player w) get-inventory))) 3) (or (key=? k "right") (key=? k "d")))
            (make-combat
             (send (combat-player w) 
                   clone #:character-inventory
                   (make-inventory
                    (inventory-weapon (send (combat-player w) get-inventory))
                    (inventory-equiped (send (combat-player w) get-inventory))
                    (append (rest (rest (rest (inventory-consumables (send (combat-player w) get-inventory)))))
                            (list (first (inventory-consumables (send (combat-player w) get-inventory)))
                                  (second (inventory-consumables (send (combat-player w) get-inventory)))
                                  (third (inventory-consumables (send (combat-player w) get-inventory)))))
                    (inventory-miscellaneous (send (combat-player w) get-inventory))))
             (combat-npc w) 'p 'i empty)]
           [(and (> (length (inventory-consumables (send (combat-player w) get-inventory))) 3) (or (key=? k "left") (key=? k "a")))
            (make-combat
             (send (combat-player w) 
                   clone #:character-inventory
                   (make-inventory
                    (inventory-weapon (send (combat-player w) get-inventory))
                    (inventory-equiped (send (combat-player w) get-inventory))
                    (append (list (third (reverse (inventory-consumables (send (combat-player w) get-inventory))))
                                  (second (reverse (inventory-consumables (send (combat-player w) get-inventory))))
                                  (first (reverse (inventory-consumables (send (combat-player w) get-inventory)))))
                            (reverse (rest (rest (rest (reverse (inventory-consumables (send (combat-player w) get-inventory))))))))
                    (inventory-miscellaneous (send (combat-player w) get-inventory))))
             (combat-npc w) 'p 'i empty)]
           [(or (key=? k "escape") (key=? k "\b"))
            (make-combat (combat-player w)                                                
                         (combat-npc w)
                         'p 'm empty)]
           [else w])]) w))

