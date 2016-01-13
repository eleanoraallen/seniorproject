#lang racket
(require "combat.rkt")
(require "items.rkt")
(require 2htdp/image)
(provide (all-defined-out))

;; Heal
(define HEAL
  (make-spell
   'player
   "heal" "+ 100 health"
   (lambda (c)
     (new player%
          [name (send c get-name)]
          [health (if (>= (+ 100 (send c get-health)) (send c get-max-health))
                      (send c get-max-health) (+ 100 (send c get-health)))]
          [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
          [agility (send c get-agility)] [base-strength (send c get-base-strength)]
          [strength (send c get-strength)] [spells (send c get-spells)]
          [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
          [resistance (send c get-resistance)] [animation (send c get-animation)]
          [position (send c get-position)] [map-animation (send c get-map-animation)]
          [dir (send c get-dir)] [level (send c get-level)] [max-mp (send c get-max-mp)]
          [mp (send c get-mp)] [current-xp (send c get-current-xp)]))
   (list (circle 10 'solid 'green) (circle 9 'solid 'green) (circle 8 'solid 'green) 
         (circle 7 'solid 'green) (circle 6 'solid 'green) (circle 5 'solid 'green))
   1
   (bitmap/file "heal.png")))

;; Doom Rock
(define DOOM-ROCK
  (make-spell
   'npc
   "Doom Rock"
   "Deal 250 rock damage"
   (lambda (c)
     (new npc%
          [name (send c get-name)] 
          [health (if (>= 125 (send c get-health)) 0 (- (send c get-health) 250))] 
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)] [agility (send c get-agility)]
          [base-strength (send c get-base-strength)] [strength (send c get-strength)]
          [spells (send c get-spells)] [character-inventory (send c get-inventory)]
          [weakness (send c get-weakness)] [resistance (send c get-resistance)]
          [animation (send c get-animation)] [position (send c get-position)] 
          [map-animation (send c get-map-animation)] [dir (send c get-dir)] 
          [xp-award (send c get-xp-award)]))
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
   3
   (bitmap/file "doom-rock.png")))

;; Gambler's Gambit
(define GAMBLERS-GAMBIT
  (make-spell
   'player
   "Gambler's Gambit"
   "x2 Strength, 1/2 Health"
   (lambda (c)
     (new player%
          [name (send c get-name)]
          [health (if (= (send c get-health) 1) 0
                      (round (/ (send c get-health) 2)))]
          [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
          [agility (send c get-agility)] [base-strength (send c get-base-strength)]
          [strength (round (* 2 (send c get-strength)))] [spells (send c get-spells)]
          [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
          [resistance (send c get-resistance)] [animation (send c get-animation)]
          [position (send c get-position)] [map-animation (send c get-map-animation)]
          [dir (send c get-dir)] [level (send c get-level)] [max-mp (send c get-max-mp)]
          [mp (send c get-mp)] [current-xp (send c get-current-xp)]))
   (list (circle 10 'solid 'green) (circle 9 'solid 'green) (circle 8 'solid 'green) 
         (circle 7 'solid 'green) (circle 6 'solid 'green) (circle 5 'solid 'green))
   1
   (bitmap/file "gamblers_gambit.png")))


;; a list of lists of player spells and their prequisit levels
(define SPELL-LIST (list (list 3 HEAL)
                         (list 5 DOOM-ROCK)
                         (list 6 GAMBLERS-GAMBIT)))


;; ENIMY SPELLS ---------------------------------------------------------------------
(define EVIL-DOOM-ROCK
  (make-spell
   'player
   "Evil Doom Rock"
   "-15 spell damage"
   (lambda (c)
     (new player%
          [name (send c get-name)] 
          [health (if (>= 15 (send c get-health)) 0 (- (send c get-health) 15))] 
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)] [agility (send c get-agility)]
          [base-strength (send c get-base-strength)] [strength (send c get-strength)]
          [spells (send c get-spells)] [character-inventory (send c get-inventory)]
          [weakness (send c get-weakness)] [resistance (send c get-resistance)]
          [animation (send c get-animation)] [position (send c get-position)]
          [map-animation (send c get-map-animation)] [dir (send c get-dir)] 
          [level (send c get-level)] [max-mp (send c get-max-mp)] [mp (send c get-mp)]
          [current-xp (send c get-current-xp)]))
   (make-list 5 (text "Evil Spell" 10 'black))
   10
   (bitmap/file "doom-rock.png")))