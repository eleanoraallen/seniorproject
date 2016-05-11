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


;; player ---------------------------------------------
(define HEALING-1
  (new consumable%
       [name "Potion_of_Minor_Healing"] 
       [description "Restores 20 points of HP"]
       [image (scale .7 (bitmap/file "health1.png"))]
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
       [animation (use-consumable-1 (scale .7 (bitmap/file "health1.png")))]
       [number 1]))

(define HEALING-2
  (new consumable%
       [name "Potion_of_Moderate_Healing"] 
       [description "Restores 50 points of HP"]
       [image (scale .7 (bitmap/file "health2.png"))]
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
       [animation (use-consumable-2 (scale .7 (bitmap/file "health2.png")))]
       [number 1]))

(define HEALING-3
  (new consumable%
       [name "Potion_of_Ultimate_Healing"] 
       [description "Fully restores health"]
       [image (scale .7 (bitmap/file "health3.png"))]
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
       [animation (use-consumable-3 (scale .7 (bitmap/file "health3.png")))]
       [number 1]))

(define MP-1
  (new consumable%
       [name "Minor_MP_Potion"] 
       [description "Restores 5 points of MP"]
       [image (scale .7 (bitmap/file "mp1.png"))]
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
       [animation (use-consumable-1 (scale .7 (bitmap/file "mp1.png")))]
       [number 1]))

(define MP-2
  (new consumable%
       [name "MP_Potion"] 
       [description "Restores 15 points of MP"]
       [image (scale .7 (bitmap/file "mp2.png"))]
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
       [animation (use-consumable-2 (scale .7 (bitmap/file "mp2.png")))]
       [number 1]))

(define MP-3
  (new consumable%
       [name "MP_Potion"] 
       [description "Fully restores MP"]
       [image (scale .7 (bitmap/file "mp3.png"))]
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
       [animation (use-consumable-3 (scale .7 (bitmap/file "mp3.png")))]
       [number 1]))

(define NOB-CURE
  (new consumable%
       [name "Noble_Cure"] 
       [description "Restores 50 HP and 15 MP"]
       [image (scale .7 (bitmap/file "cure1.png"))]
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
       [animation (use-consumable-3 (scale .7 (bitmap/file "cure1.png")))]
       [number 1]))

(define DIV-CURE
  (new consumable%
       [name "Divine_Cure"] 
       [description "Fully restores HP and MP"]
       [image (scale .7 (bitmap/file "cure2.png"))]
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
       [animation (use-consumable-3 (scale .7 (bitmap/file "cure2.png")))]
       [number 1]))

(define MYS
  (new consumable%
       [name "Mystery_Liquid"] 
       [description "???"]
       [image (scale .7 (bitmap/file "mystery.png"))]
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
       [animation (use-consumable-3 (scale .7 (bitmap/file "cure2.png")))]
       [number 1]))

(define STRENGTH-P
  (new consumable%
       [name "Strength_Potion"] 
       [description "Temporarily increases your strength"]
       [image (scale .7 (bitmap/file "strength.png"))]
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
       [animation (use-consumable-1 (scale .7 (bitmap/file "strength.png")))]
       [number 1]))

(define AGILITY-P
  (new consumable%
       [name "Agility_Potion"] 
       [description "Temporarily increases your agility"]
       [image (scale .7 (bitmap/file "agility.png"))]
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
       [animation (use-consumable-1 (scale .7 (bitmap/file "agility.png")))]
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
(define WALKING-STICK
  (new weapon%
       [name "Walking_Stick"]
       [description "Not really a weapon"]
       [value 1]
       [weapon-damage 1]
       [weapon-accuracy .95]
       [type 'wood]
       [image (square 20 'solid 'white)]))
(define PRACTICE-SWORD
  (new weapon%
       [name "Practice_Sword"]
       [description "A wooden practice sword"]
       [value 10]
       [weapon-damage 5]
       [weapon-accuracy .95]
       [type 'wood]
       [image (square 20 'solid 'white)]))
(define OASIS-BLADE
  (new weapon%
       [name "Oasis_Blade"]
       [description "A dagger forged from a farming implement"]
       [value 25]
       [weapon-damage 10]
       [weapon-accuracy .95]
       [type 'metal]
       [image (square 20 'solid 'white)]))
(define JANBIYA
  (new weapon%
       [name "Janbiya"]
       [description "A deadly curved dagger"]
       [value 50]
       [weapon-damage 15]
       [weapon-accuracy .95]
       [type 'metal]
       [image (square 20 'solid 'white)]))
(define SWORD-CANE
  (new weapon%
       [name "Sword-Cane"]
       [description "A small sword hidden in a cane"]
       [value 150]
       [weapon-damage 25]
       [weapon-accuracy .95]
       [type 'metal]
       [image (square 20 'solid 'white)]))
(define MACHETE
  (new weapon%
       [name "Machete"]
       [description "A heavy steel machete"]
       [value 250]
       [weapon-damage 35]
       [weapon-accuracy .8]
       [type 'metal]
       [image (square 20 'solid 'white)]))
(define SWORD
  (new weapon%
       [name "Steel_Sword"]
       [description "A sturdy one-handed steel sword."]
       [value 500]
       [weapon-damage 50]
       [weapon-accuracy .9]
       [type 'metal]
       [image (square 20 'solid 'white)]))
(define KATANA
  (new weapon%
       [name "Katana"]
       [description "A long curved sword"]
       [value 750]
       [weapon-damage 70]
       [weapon-accuracy .85]
       [type 'metal]
       [image (square 20 'solid 'white)]))
(define CLAYMORE
  (new weapon%
       [name "Claymore"]
       [description "A really big sword"]
       [value 1000]
       [weapon-damage 100]
       [weapon-accuracy .8]
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
(define PLAIN-HAT
  (new equipment%
       [name "Plain_Hat"]
       [description "An unasuming felt hat"]
       [image (circle 20 'solid 'white)]
       [value 5]
       [defence 1]
       [equipment-portion 'h]))
(define FANCY-HAT
  (new equipment%
       [name "Fancy_Hat"]
       [description "An fancy hat with a fether"]
       [image (circle 20 'solid 'white)]
       [value 100]
       [defence 20]
       [equipment-portion 'h]))
(define RUSTY-HELM
  (new equipment%
       [name "Rusty_Helm"]
       [description "An old, rusty greathelm"]
       [image (scale .7 (bitmap/file "steel-helm.png"))]
       [value 500]
       [defence 30]
       [equipment-portion 'h]))
(define STEEL-HELM
  (new equipment%
       [name "Steel_Helm"]
       [description "A heavy steel greathelm"]
       [image (scale .7 (bitmap/file "steel-helm.png"))]
       [value 750]
       [defence 50]
       [equipment-portion 'h]))

(define SMILING-MASK
  (new equipment%
       [name "Smiling_Mask"]
       [description "A wooden mask with a smiling face"]
       [image (square 20 'solid 'black)]
       [value 5]
       [defence 1]
       [equipment-portion 'h]))
(define NEUTRAL-MASK
  (new equipment%
       [name "Neutral_Mask"]
       [description "A wooden mask with a neutral face"]
       [image (square 20 'solid 'black)]
       [value 5]
       [defence 1]
       [equipment-portion 'h]))
(define FROWNING-MASK
  (new equipment%
       [name "Scowling_Mask"]
       [description "A wooden mask with a frowning face"]
       [image (scale .7 (bitmap/file "mask1.png"))]
       [value 5]
       [defence 1]
       [equipment-portion 'h]))


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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define COAT
  (new equipment%
       [name "Fantasy_Trenchcoat"]
       [description "Now you look like a detective"]
       [image (scale .7 (bitmap/file "coat.png"))]
       [value 20]
       [defence 1]
       [equipment-portion 'b]))
(define DRESS
  (new equipment%
       [name "Fancy_Dress"]
       [description "A fancy and expensive dress"]
       [image (circle 10 'solid 'gray)]
       [value 200]
       [defence 5]
       [equipment-portion 'b]))
(define RUSTY-MAIL
  (new equipment%
       [name "Chain_Mail"]
       [description "Old, rusty chain mail"]
       [image (scale .7 (bitmap/file "mail.png"))]
       [value 250]
       [defence 25]
       [equipment-portion 'b]))
(define MAIL
  (new equipment%
       [name "Chain_Mail"]
       [description "Strong steel chain mail"]
       [image (scale .7 (bitmap/file "mail.png"))]
       [value 500]
       [defence 50]
       [equipment-portion 'b]))
(define RUSTY-BRESTPLATE
  (new equipment%
       [name "Rusty_Brestplate"]
       [description "An old, rusty brestplate"]
       [image (scale .7 (bitmap/file "steel-brestplate.png"))]
       [value 750]
       [defence 70]
       [equipment-portion 'b]))
(define STEEL-BRESTPLATE
  (new equipment%
       [name "Steel_Brestplate"]
       [description "A sturdy steel brestplate"]
       [image (scale .7 (bitmap/file "steel-brestplate.png"))]
       [value 1000]
       [defence 100]
       [equipment-portion 'b]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define BOOTS
  (new equipment%
       [name "Leather_Boots"]
       [description "Good for keeping your feet dry"]
       [image (circle 10 'solid 'gray)]
       [value 20]
       [defence 1]
       [equipment-portion 'l]))
(define MAGIC-SHOES
  (new equipment%
       [name "Magic_Shoes"]
       [description "They defend your feet with magic"]
       [image (scale .7 (bitmap/file "shoe.png"))]
       [value 100]
       [defence 15]
       [equipment-portion 'l]))
(define RUSTY-GRIEVES
  (new equipment%
       [name "Rusty_Iron_Grieves"]
       [description "Rusty grieves made of iron"]
       [image (scale .7 (bitmap/file "grievs.png"))]
       [value 200]
       [defence 20]
       [equipment-portion 'l]))
(define IRON-GRIEVES
  (new equipment%
       [name "Iron_Grieves"]
       [description "Grieves made of iron"]
       [image (scale .7 (bitmap/file "grievs.png"))]
       [value 300]
       [defence 30]
       [equipment-portion 'l]))
(define STEEL-BOOTS
  (new equipment%
       [name "SteelBoots"]
       [description "Surprisingly heavy"]
       [image (scale .7 (bitmap/file "steel-boots.png"))]
       [value 500]
       [defence 40]
       [equipment-portion 'l]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define MITTENS
  (new equipment%
       [name "Fuzzy_Mittens"]
       [description "Good for snowball fights"]
       [image (scale .7 (bitmap/file "mittens.png"))]
       [value 20]
       [defence 1]
       [equipment-portion 'a]))
(define GLOVES
  (new equipment%
       [name "Leather_Gloves"]
       [description "Thick leather gloves"]
       [image (scale .7 (bitmap/file "gloves.png"))]
       [value 50]
       [defence 5]
       [equipment-portion 'a]))
(define RUSTY-GAUNTLETS
  (new equipment%
       [name "Rusty_Gauntlets"]
       [description "Old, rusty steel gauntlets"]
       [image (scale .7 (bitmap/file "gauntlets.png"))]
       [value 300]
       [defence 25]
       [equipment-portion 'a]))
(define GAUNTLETS
  (new equipment%
       [name "Steel_Gauntlets"]
       [description "Sturdy steel gauntlets"]
       [image (scale .7 (bitmap/file "gauntlets.png"))]
       [value 500]
       [defence 40]
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
   WALKING-STICK
   PRACTICE-SWORD
   OASIS-BLADE
   JANBIYA
   SWORD-CANE
   MACHETE
   SWORD
   KATANA
   CLAYMORE
   STAFF
   ;; consumables
   HEALING-1
   HEALING-2
   HEALING-3
   MP-1
   MP-2
   MP-3
   AGILITY-P
   STRENGTH-P
   MYS
   NOB-CURE
   DIV-CURE
   MAGIC-POTION
   HEALING-POTION
   ;; head armor
   PLAIN-HAT
   FANCY-HAT
   RUSTY-HELM
   STEEL-HELM
   HAT
   HELMET
   SMILING-MASK
   NEUTRAL-MASK
   FROWNING-MASK
   ;; body armor
   COAT
   DRESS
   RUSTY-MAIL
   MAIL
   RUSTY-BRESTPLATE
   STEEL-BRESTPLATE
   ;; arm armor
   MITTENS
   GLOVES
   RUSTY-GAUNTLETS
   GAUNTLETS
   ;; leg armor
   BOOTS
   MAGIC-SHOES
   RUSTY-GRIEVES
   IRON-GRIEVES
   STEEL-BOOTS
   ;; misc (not gold)
   ))
