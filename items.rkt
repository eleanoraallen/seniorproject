#lang racket
(require "combat.rkt")
(require 2htdp/image)
(provide (all-defined-out))

;; Functions for item use animation 
(define (use-consumable-1 i)
  (append
   (list
   (place-image i 400 480
  (bitmap/file "blankbackground.png"))
   (place-image i 400 440
  (bitmap/file "blankbackground.png"))
   (place-image i 400 400
  (bitmap/file "blankbackground.png"))
   (place-image i 400 360
  (bitmap/file "blankbackground.png"))
   (place-image i 400 320
  (bitmap/file "blankbackground.png"))
   (place-image i 400 280
  (bitmap/file "blankbackground.png"))
   (place-image i 400 240
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png")))
   (draw-bubble 40 (make-posn 400 225) i)
   (draw-bubble 40 (make-posn 400 225) i)))

(define (use-consumable-2 i)
  (append
   (list
   (place-image i 400 480
  (bitmap/file "blankbackground.png"))
   (place-image i 400 440
  (bitmap/file "blankbackground.png"))
   (place-image i 400 400
  (bitmap/file "blankbackground.png"))
   (place-image i 400 360
  (bitmap/file "blankbackground.png"))
   (place-image i 400 320
  (bitmap/file "blankbackground.png"))
   (place-image i 400 280
  (bitmap/file "blankbackground.png"))
   (place-image i 400 240
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png")))
   (draw-bubble 40 (make-posn 400 225) i)
   (draw-bubble 40 (make-posn 400 225) i)
   (draw-bubble 40 (make-posn 400 225) i)))

(define (use-consumable-3 i)
  (append
   (list
   (place-image i 400 480
  (bitmap/file "blankbackground.png"))
   (place-image i 400 440
  (bitmap/file "blankbackground.png"))
   (place-image i 400 400
  (bitmap/file "blankbackground.png"))
   (place-image i 400 360
  (bitmap/file "blankbackground.png"))
   (place-image i 400 320
  (bitmap/file "blankbackground.png"))
   (place-image i 400 280
  (bitmap/file "blankbackground.png"))
   (place-image i 400 240
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png")))
   (draw-bubble 40 (make-posn 400 225) i)
   (draw-bubble 40 (make-posn 400 225) i)
   (draw-bubble 40 (make-posn 400 225) i)
   (draw-bubble 40 (make-posn 400 225) i)))

(define (npc-use-consumable-1 i)
  (append
   (list
   (place-image i 400 480
  (bitmap/file "blankbackground.png"))
   (place-image i 400 440
  (bitmap/file "blankbackground.png"))
   (place-image i 400 400
  (bitmap/file "blankbackground.png"))
   (place-image i 400 360
  (bitmap/file "blankbackground.png"))
   (place-image i 400 320
  (bitmap/file "blankbackground.png"))
   (place-image i 400 280
  (bitmap/file "blankbackground.png"))
   (place-image i 400 240
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png")))
   (draw-npc-bubble 40 (make-posn 400 225) i)
   (draw-npc-bubble 40 (make-posn 400 225) i)))

(define (npc-use-consumable-2 i)
  (append
   (list
   (place-image i 400 480
  (bitmap/file "blankbackground.png"))
   (place-image i 400 440
  (bitmap/file "blankbackground.png"))
   (place-image i 400 400
  (bitmap/file "blankbackground.png"))
   (place-image i 400 360
  (bitmap/file "blankbackground.png"))
   (place-image i 400 320
  (bitmap/file "blankbackground.png"))
   (place-image i 400 280
  (bitmap/file "blankbackground.png"))
   (place-image i 400 240
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png")))
   (draw-npc-bubble 40 (make-posn 400 225) i)
   (draw-npc-bubble 40 (make-posn 400 225) i)
   (draw-npc-bubble 40 (make-posn 400 225) i)))

(define (npc-use-consumable-3 i)
  (append
   (list
   (place-image i 400 480
  (bitmap/file "blankbackground.png"))
   (place-image i 400 440
  (bitmap/file "blankbackground.png"))
   (place-image i 400 400
  (bitmap/file "blankbackground.png"))
   (place-image i 400 360
  (bitmap/file "blankbackground.png"))
   (place-image i 400 320
  (bitmap/file "blankbackground.png"))
   (place-image i 400 280
  (bitmap/file "blankbackground.png"))
   (place-image i 400 240
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png"))
   (place-image i 400 225
  (bitmap/file "blankbackground.png")))
   (draw-npc-bubble 40 (make-posn 400 225) i)
   (draw-npc-bubble 40 (make-posn 400 225) i)
   (draw-npc-bubble 40 (make-posn 400 225) i)
   (draw-npc-bubble 40 (make-posn 400 225) i)))

(define (draw-bubble n p i)
  (cond
    [(= (posn-x p) 680) empty]
    [else
     (cons
      (place-image i 400 225
      (place-image (scale .5 (bitmap/file "bubble.png"))
                   (posn-x p) (posn-y p)
                   (bitmap/file "blankbackground.png")))
      (draw-bubble n (make-posn
                       (+ (posn-x p) n)
                       (posn-y p)) i))]))

(define (draw-npc-bubble n p i)
  (cond
    [(<= (posn-x p) 120) empty]
    [else
     (cons
      (place-image i 400 225
      (place-image (scale .5 (bitmap/file "bubble.png"))
                   (posn-x p) (posn-y p)
                   (bitmap/file "blankbackground.png")))
      (draw-npc-bubble n (make-posn
                       (- (posn-x p) n)
                       (posn-y p)) i))]))

(define (flip-everything l)
  (cond
    [(empty? l) empty]
    [(cons? l)
     (cons (flip-horizontal (first l))
           (flip-everything (rest l)))]))



;; Consumables -------------------------------------------------------------------------------------------
;; 133.7

;; player ---------------------------------------------
(define HEALING-1
  (new consumable%
       [name "Potion_of_Minor_Healing"] 
       [description "Restores 20 points of HP"]
       [image (scale (/ 1 133.7) (bitmap/file "health1.png"))]
       [value 5]
       [effect (lambda (c)
                 (new player% 
                      [name (send c get-name)] [health (if (>= (+ (send c get-health) 20) (send c get-max-health))
                                                           (send c get-max-health) (+ 2 (send c get-health)))]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)] [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [position (send c get-position)]  [map-animation (send c get-map-animation)]
                      [dir (send c get-dir)] [level (send c get-level)] [max-mp (send c get-max-mp)]
                      [mp (send c get-mp)] [current-xp (send c get-current-xp)]))]
       [animation (use-consumable-1 (scale (/ 1 133.7) (bitmap/file "health1.png")))]
       [number 1]))

(define HEALING-2
  (new consumable%
       [name "Potion_of_Moderate_Healing"] 
       [description "Restores 50 points of HP"]
       [image (scale (/ 1 133.7) (bitmap/file "health2.png"))]
       [value 20]
       [effect (lambda (c)
                 (new player% 
                      [name (send c get-name)] [health (if (>= (+ (send c get-health) 50) (send c get-max-health))
                                                           (send c get-max-health) (+ 50 (send c get-health)))]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)] [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [position (send c get-position)]  [map-animation (send c get-map-animation)]
                      [dir (send c get-dir)] [level (send c get-level)] [max-mp (send c get-max-mp)]
                      [mp (send c get-mp)] [current-xp (send c get-current-xp)]))]
       [animation (use-consumable-2 (scale (/ 1 133.7) (bitmap/file "health2.png")))]
       [number 1]))

(define HEALING-3
  (new consumable%
       [name "Potion_of_Ultimate_Healing"] 
       [description "Fully restores health"]
       [image (scale (/ 1 133.7) (bitmap/file "health3.png"))]
       [value 100]
       [effect (lambda (c)
                 (new player% 
                      [name (send c get-name)] [health (send c get-max-health)]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)] [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [position (send c get-position)]  [map-animation (send c get-map-animation)]
                      [dir (send c get-dir)] [level (send c get-level)] [max-mp (send c get-max-mp)]
                      [mp (send c get-mp)] [current-xp (send c get-current-xp)]))]
       [animation (use-consumable-3 (scale (/ 1 133.7) (bitmap/file "health3.png")))]
       [number 1]))

(define MP-1
  (new consumable%
       [name "Minor_MP_Potion"] 
       [description "Restores 5 points of MP"]
       [image (scale (/ 1 133.7) (bitmap/file "mp1.png"))]
       [value 10]
       [effect (lambda (c)
                 (new player% 
                      [name (send c get-name)] [health (send c get-health)]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)] [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [position (send c get-position)] [map-animation (send c get-map-animation)]
                      [dir (send c get-dir)] [level (send c get-level)] [max-mp (send c get-max-mp)] 
                      [mp (if (>= (+ (send c get-mp) 5) (send c get-max-mp))
                                                           (send c get-max-mp) (+ 5 (send c get-mp)))]
                      [current-xp (send c get-current-xp)]))]
       [animation (use-consumable-1 (scale (/ 1 133.7) (bitmap/file "mp1.png")))]
       [number 1]))

(define MP-2
  (new consumable%
       [name "MP_Potion"] 
       [description "Restores 15 points of MP"]
       [image (scale (/ 1 133.7) (bitmap/file "mp2.png"))]
       [value 40]
       [effect (lambda (c)
                 (new player% 
                      [name (send c get-name)] [health (send c get-health)]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)] [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [position (send c get-position)] [map-animation (send c get-map-animation)]
                      [dir (send c get-dir)] [level (send c get-level)] [max-mp (send c get-max-mp)] 
                      [mp (if (>= (+ (send c get-mp) 15) (send c get-max-mp))
                                                           (send c get-max-mp) (+ 15 (send c get-mp)))]
                      [current-xp (send c get-current-xp)]))]
       [animation (use-consumable-2 (scale (/ 1 133.7) (bitmap/file "mp2.png")))]
       [number 1]))

(define MP-3
  (new consumable%
       [name "MP_Potion"] 
       [description "Fully restores MP"]
       [image (scale (/ 1 133.7) (bitmap/file "mp3.png"))]
       [value 80]
       [effect (lambda (c)
                 (new player% 
                      [name (send c get-name)] [health (send c get-health)]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)] [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [position (send c get-position)] [map-animation (send c get-map-animation)]
                      [dir (send c get-dir)] [level (send c get-level)] [max-mp (send c get-max-mp)] 
                      [mp (send c get-max-mp)]
                      [current-xp (send c get-current-xp)]))]
       [animation (use-consumable-3 (scale (/ 1 133.7) (bitmap/file "mp3.png")))]
       [number 1]))

(define NOB-CURE
  (new consumable%
       [name "Noble_Cure"] 
       [description "Restores 50 points of HP and 15 points of MP"]
       [image (scale (/ 1 133.7) (bitmap/file "cure1.png"))]
       [value 200]
       [effect (lambda (c)
                 (new player% 
                      [name (send c get-name)] [health (if (>= (+ (send c get-health) 50) (send c get-max-health))
                                                           (send c get-max-health) (+ 50 (send c get-health)))]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)] [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [position (send c get-position)] [map-animation (send c get-map-animation)]
                      [dir (send c get-dir)] [level (send c get-level)] [max-mp (send c get-max-mp)] 
                      [mp (if (>= (+ (send c get-mp) 15) (send c get-max-mp))
                                                           (send c get-max-mp) (+ 15 (send c get-mp)))]
                      [current-xp (send c get-current-xp)]))]
       [animation (use-consumable-3 (scale (/ 1 133.7) (bitmap/file "cure1.png")))]
       [number 1]))

(define DIV-CURE
  (new consumable%
       [name "Divine_Cure"] 
       [description "Fully restores HP and MP"]
       [image (scale (/ 1 133.7) (bitmap/file "cure2.png"))]
       [value 500]
       [effect (lambda (c)
                 (new player% 
                      [name (send c get-name)] [health (send c get-max-health)]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)] [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [position (send c get-position)] [map-animation (send c get-map-animation)]
                      [dir (send c get-dir)] [level (send c get-level)] [max-mp (send c get-max-mp)] 
                      [mp (send c get-max-mp)]
                      [current-xp (send c get-current-xp)]))]
       [animation (use-consumable-3 (scale (/ 1 133.7) (bitmap/file "cure2.png")))]
       [number 1]))

(define MYS
  (new consumable%
       [name "Mystery_Liquid"] 
       [description "An unidentifyable liquid in an unmarked bottle... seems safe enough"]
       [image (scale (/ 1 133.7) (bitmap/file "mystery.png"))]
       [value 150]
       [effect (lambda (c)
                 (new player% 
                      [name (send c get-name)] [health (random (send c get-max-health))]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)] [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [position (send c get-position)] [map-animation (send c get-map-animation)]
                      [dir (send c get-dir)] [level (send c get-level)] [max-mp (send c get-max-mp)] 
                      [mp (random (send c get-max-mp))]
                      [current-xp (send c get-current-xp)]))]
       [animation (use-consumable-3 (scale (/ 1 133.7) (bitmap/file "cure2.png")))]
       [number 1]))

(define STRENGTH-P
  (new consumable%
       [name "Strength_Potion"] 
       [description "Temporarily increases your strength"]
       [image (scale (/ 1 133.7) (bitmap/file "strength.png"))]
       [value 100]
       [effect (lambda (c)
                 (new player% 
                      [name (send c get-name)] [health (send c get-health)]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)] [base-strength (send c get-base-strength)]
                      [strength (+ (round (* .1 (send c get-strength))) (send c get-strength))] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [position (send c get-position)] [map-animation (send c get-map-animation)]
                      [dir (send c get-dir)] [level (send c get-level)] [max-mp (send c get-max-mp)] 
                      [mp (send c get-mp)]
                      [current-xp (send c get-current-xp)]))]
       [animation (use-consumable-1 (scale (/ 1 133.7) (bitmap/file "strength.png")))]
       [number 1]))

(define AGILITY-P
  (new consumable%
       [name "Agility_Potion"] 
       [description "Temporarily increases your agility"]
       [image (scale (/ 1 133.7) (bitmap/file "agility.png"))]
       [value 100]
       [effect (lambda (c)
                 (new player% 
                      [name (send c get-name)] [health (send c get-health)]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (+ (round (* .1 (send c get-agility))) (send c get-agility))]
                      [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [position (send c get-position)] [map-animation (send c get-map-animation)]
                      [dir (send c get-dir)] [level (send c get-level)] [max-mp (send c get-max-mp)] 
                      [mp (send c get-mp)]
                      [current-xp (send c get-current-xp)]))]
       [animation (use-consumable-1 (scale (/ 1 133.7) (bitmap/file "agility.png")))]
       [number 1]))



(define MAGIC-POTION
  (new consumable%
       [name "MagicPotion"] 
       [description "Fully restores MP."]
       [image (bitmap/file "magic-potion.gif")]
       [value 10]
       [effect (lambda (c)
                 (new player% 
                      [name (send c get-name)] [health (send c get-health)]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)] [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [position (send c get-position)] [map-animation (send c get-map-animation)]
                      [dir (send c get-dir)] [level (send c get-level)] [max-mp (send c get-max-mp)] 
                      [mp (send c get-max-mp)] [current-xp (send c get-current-xp)]))]
       [animation (use-consumable-1 (bitmap/file "magic-potion.gif"))]
       [number 3]))

(define HEALING-POTION
  (new consumable%
       [name "HealthPotion"] 
       [description "+ 25 health"]
       [image (bitmap/file "health-potion.gif")]
       [value 10]
       [effect (lambda (c)
                 (new player% 
                      [name (send c get-name)] [health (if (>= (+ (send c get-health) 25) (send c get-max-health))
                                                           (send c get-max-health) (+ 25 (send c get-health)))]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)] [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [position (send c get-position)]  [map-animation (send c get-map-animation)]
                      [dir (send c get-dir)] [level (send c get-level)] [max-mp (send c get-max-mp)]
                      [mp (send c get-mp)] [current-xp (send c get-current-xp)]))]
       [animation (use-consumable-1 (bitmap/file "health-potion.gif"))]
       [number 3]))

;; npc ---------------------------------------------
(define HEALING-PHILTER
  (new consumable%
       [name "HealingPhilter"] 
       [description "Fully restores health"]
       [image (square 20 'solid 'white)]
       [value 10]
       [effect (lambda (c)
                 (new npc% 
                      [name (send c get-name)] [health (send c get-max-health)]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)] [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [position (send c get-position)] [dir (send c get-dir)] [diologue (send c get-diologue)]
                      [map-animation (send c get-map-animation)] [xp-award (send c get-xp-award)]))]
       [animation (npc-use-consumable-3 (bitmap/file "health-potion.gif"))]
       [number 1]))

;; Weapons ------------------------------------------------------------------------------------------------
(define SWORD
  (new weapon%
       [name "SteelSword"]
       [description "A sturdy steel sword."]
       [value 10]
       [weapon-damage 10]
       [weapon-accuracy .95]
       [type 'metal]
       [image (square 20 'solid 'white)]))
(define STAFF
  (new weapon%
       [name "WoodStaff"]
       [description "A flimsy wooden quarterstaff."]
       [value 10]
       [weapon-damage 5]
       [weapon-accuracy 1]
       [type 'wood]
       [image (square 20 'solid 'white)]))

;; Armor -------------------------------------------------------------------------------------------------
(define HELMET
  (new equipment%
       [name "SteelHelmet"]
       [description "A sturdy steel helmet"]
       [image (circle 10 'solid 'gray)]
       [value 50]
       [defence 10]
       [equipment-portion 'h]))

(define HAT
  (new equipment%
       [name "WoolHat"]
       [description "A warm woolen hat"]
       [image (circle 10 'solid 'gray)]
       [value 5]
       [defence 1]
       [equipment-portion 'h]))

(define COAT
  (new equipment%
       [name "Trenchcoat"]
       [description "Now you look like a detective"]
       [image (circle 10 'solid 'gray)]
       [value 20]
       [defence 1]
       [equipment-portion 'b]))

(define MAIL
  (new equipment%
       [name "ChainMail"]
       [description "Strong steel chain mail"]
       [image (circle 10 'solid 'gray)]
       [value 100]
       [defence 20]
       [equipment-portion 'b]))

(define BOOTS
  (new equipment%
       [name "LeatherBoots"]
       [description "Good for keeping your feet dry"]
       [image (circle 10 'solid 'gray)]
       [value 10]
       [defence 1]
       [equipment-portion 'l]))

(define STEEL-BOOTS
  (new equipment%
       [name "SteelBoots"]
       [description "Surprisingly heavy"]
       [image (circle 10 'solid 'gray)]
       [value 40]
       [defence 10]
       [equipment-portion 'l]))

(define GAUNTLETS
  (new equipment%
       [name "SteelGauntlets"]
       [description "Protect your arms"]
       [image (circle 10 'solid 'gray)]
       [value 40]
       [defence 10]
       [equipment-portion 'a]))

(define MITTENS
  (new equipment%
       [name "FuzzyMittens"]
       [description "Good for snowball fights"]
       [image (circle 10 'solid 'gray)]
       [value 5]
       [defence 1]
       [equipment-portion 'a]))

;; Gold --------------------------------------------------------------------------------------------------
;; add-gold number --> makes n many gold
(define (add-gold n)
  (new gold%
       [name "Gold"]
       [description "The coin of the relm."]
       [image (circle 10 'solid 'gold)]
       [value 0]
       [number n]))

;; --------------------------------------------------------------------------------------------------------
(define ITEM-DIRECTORY
  (list
   ;; weapons
   SWORD
   STAFF
   ;; consumables
   MAGIC-POTION
   HEALING-POTION
   ;; head armor
   HAT
   HELMET
   ;; body armor
   COAT
   MAIL
   ;; arm armor
   GAUNTLETS
   MITTENS
   ;; leg armor
   BOOTS
   STEEL-BOOTS
   ;; misc (not gold)
   ))
  