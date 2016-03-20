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

(define (draw-bubble n p i)
  (cond
    [(= (posn-x p) 680) empty]
    [else
     (cons
      (place-image i 400 225
      (place-image (circle 10 'solid 'white)
                   (posn-x p) (posn-y p)
                   (bitmap/file "blankbackground.png")))
      (draw-bubble n (make-posn
                       (+ (posn-x p) n)
                       (posn-y p)) i))]))

(define (flip-everything l)
  (cond
    [(empty? l) empty]
    [(cons? l)
     (cons (flip-horizontal (first l))
           (flip-everything (rest l)))]))



;; Consumables -------------------------------------------------------------------------------------------
(define MAGIC-POTION
  (new consumable%
       [name "Magic Potion"] 
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
       [name "Health Potion"] 
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

(define HEALING-PHILTER
  (new consumable%
       [name "Healing Philter"] 
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
                      [position (send c get-position)] [dir (send c get-dir)] 
                      [map-animation (send c get-map-animation)] [xp-award (send c get-xp-award)]))]
       [animation (flip-everything (use-consumable-1 (bitmap/file "health-potion.gif")))]
       [number 1]))

;; Weapons ------------------------------------------------------------------------------------------------
(define SWORD
  (new weapon%
       [name "Steel Sword"]
       [description "A sturdy steel sword."]
       [value 10]
       [weapon-damage 10]
       [weapon-accuracy .95]
       [type 'metal]
       [image (square 20 'solid 'white)]))
(define STAFF
  (new weapon%
       [name "Wood Staff"]
       [description "A flimsy wooden quarterstaff."]
       [value 10]
       [weapon-damage 5]
       [weapon-accuracy 1]
       [type 'wood]
       [image (square 20 'solid 'white)]))

;; Armor -------------------------------------------------------------------------------------------------
(define HELMET
  (new equipment%
       [name "Steel Helmet"]
       [description "A sturdy steel helmet"]
       [image (circle 10 'solid 'gray)]
       [value 50]
       [defence 10]
       [equipment-portion 'h]))

(define HAT
  (new equipment%
       [name "Wool Hat"]
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
       [name "Chain Mail"]
       [description "Strong steel chain mail"]
       [image (circle 10 'solid 'gray)]
       [value 100]
       [defence 20]
       [equipment-portion 'b]))

(define BOOTS
  (new equipment%
       [name "Leather Boots"]
       [description "Good for keeping your feet dry"]
       [image (circle 10 'solid 'gray)]
       [value 10]
       [defence 1]
       [equipment-portion 'l]))

(define STEEL-BOOTS
  (new equipment%
       [name "Steel Boots"]
       [description "Surprisingly heavy"]
       [image (circle 10 'solid 'gray)]
       [value 40]
       [defence 10]
       [equipment-portion 'l]))

(define GAUNTLETS
  (new equipment%
       [name "Steel Gauntlets"]
       [description "Protect your arms"]
       [image (circle 10 'solid 'gray)]
       [value 40]
       [defence 10]
       [equipment-portion 'a]))

(define MITTENS
  (new equipment%
       [name "Fuzzy Mittens"]
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
       [value n]
       [number n]))
  