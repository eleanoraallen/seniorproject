#lang racket
(require "combat.rkt")
(require "items.rkt")
(require 2htdp/image)
(provide (all-defined-out))

;; Heal
(define HEAL
  (make-spell
   'player
   "heal" "+ 50 health"
   (lambda (c)
     (new player%
          [name (send c get-name)]
          [health (if (>= (+ 50 (send c get-health)) (send c get-max-health))
                      (send c get-max-health) (+ 50 (send c get-health)))]
          [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
          [agility (send c get-agility)] [base-strength (send c get-base-strength)]
          [strength (send c get-strength)] [spells (send c get-spells)]
          [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
          [resistance (send c get-resistance)] [animation (send c get-animation)]
          [position (send c get-position)] [map-animation (send c get-map-animation)]
          [level (send c get-level)] [max-mp (send c get-max-mp)]
          [mp (send c get-mp)] [current-xp (send c get-current-xp)]))
   (list (circle 10 'solid 'green) (circle 9 'solid 'green) (circle 8 'solid 'green) 
         (circle 7 'solid 'green) (circle 6 'solid 'green) (circle 5 'solid 'green))
   5
   (bitmap/file "heal.png")))

;; Doom Rock
(define DOOM-ROCK
  (make-spell
   'npc
   "Doom Rock"
   "Deal 100 rock damage"
   (lambda (c)
     (new npc%
          [name (send c get-name)] 
          [health (if (>= 100 (send c get-health)) 0 (- (send c get-health) 100))] 
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)] [agility (send c get-agility)]
          [base-strength (send c get-base-strength)] [strength (send c get-strength)]
          [spells (send c get-spells)] [character-inventory (send c get-inventory)]
          [weakness (send c get-weakness)] [resistance (send c get-resistance)]
          [animation (send c get-animation)] [position (send c get-position)] 
          [map-animation (send c get-map-animation)] [xp-award (send c get-xp-award)]))
   (list (bitmap/file "doomrock1.png") (bitmap/file "doomrock2.png")
         (bitmap/file "doomrock3.png") (bitmap/file "doomrock4.png")
         (bitmap/file "doomrock5.png") (bitmap/file "doomrock6.png")
         (bitmap/file "doomrock7.png") (bitmap/file "doomrock8.png")
         (bitmap/file "doomrock9.png") (bitmap/file "doomrock10.png")
         (bitmap/file "doomrock11.png") (bitmap/file "doomrock12.png")
         (bitmap/file "doomrock13.png") (bitmap/file "doomrock14.png")
         (bitmap/file "doomrock15.png") (bitmap/file "doomrock16.png")
         (bitmap/file "doomrock17.png") (bitmap/file "doomrock18.png")
         (bitmap/file "doomrock19.png") (bitmap/file "doomrock20.png"))
   10
   (bitmap/file "doom-rock.png")))

;; Evil Doom Rock
(define EVIL-DOOM-ROCK
  (make-spell
   'player
   "Doom Rock"
   "-100 spell damage"
   (lambda (c)
     (new player%
          [name (send c get-name)] 
          [health (if (>= 50 (send c get-health)) 0 (- (send c get-health) 50))] 
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)] [agility (send c get-agility)]
          [base-strength (send c get-base-strength)] [strength (send c get-strength)]
          [spells (send c get-spells)] [character-inventory (send c get-inventory)]
          [weakness (send c get-weakness)] [resistance (send c get-resistance)]
          [animation (send c get-animation)] [position (send c get-position)]
          [map-animation (send c get-map-animation)] [level (send c get-level)] 
          [max-mp (send c get-max-mp)] [mp (send c get-mp)]
          [current-xp (send c get-current-xp)]))
   (list (flip-horizontal (bitmap/file "doomrock1.png"))
         (flip-horizontal (bitmap/file "doomrock2.png"))
         (flip-horizontal (bitmap/file "doomrock3.png"))
         (flip-horizontal (bitmap/file "doomrock4.png"))
         (flip-horizontal (bitmap/file "doomrock5.png"))
         (flip-horizontal (bitmap/file "doomrock6.png"))
         (flip-horizontal (bitmap/file "doomrock7.png"))
         (flip-horizontal (bitmap/file "doomrock8.png"))
         (flip-horizontal (bitmap/file "doomrock9.png"))
         (flip-horizontal (bitmap/file "doomrock10.png"))
         (flip-horizontal (bitmap/file "doomrock11.png"))
         (flip-horizontal (bitmap/file "doomrock12.png"))
         (flip-horizontal (bitmap/file "doomrock13.png"))
         (flip-horizontal (bitmap/file "doomrock14.png"))
         (flip-horizontal (bitmap/file "doomrock15.png"))
         (flip-horizontal (bitmap/file "doomrock16.png"))
         (flip-horizontal (bitmap/file "doomrock17.png"))
         (flip-horizontal (bitmap/file "doomrock18.png"))
         (flip-horizontal (bitmap/file "doomrock19.png"))
         (flip-horizontal (bitmap/file "doomrock20.png")))
   10
   (bitmap/file "doom-rock.png")))