#lang racket
(require "combat.rkt")
(require "items.rkt")
(require 2htdp/image)
(provide (all-defined-out))

;; functions for animating spells
(define (draw-throw p1 p2 n i)
  (cond
    [(and (= 0 (- (posn-x p1) (posn-x p2)))
          (= 0 (- (posn-y p1) (posn-y p2)))) empty]
    [else
     (append (draw-throw (make-posn (cond
                                      [(> (posn-x p1) (posn-x p2)) (- (posn-x p1) n)]
                                      [(< (posn-x p1) (posn-x p2)) (+ (posn-x p1) n)]
                                      [else (posn-x p1)])
                                    (cond
                                      [(> (posn-y p1) (posn-y p2)) (- (posn-y p1) n)]
                                      [(< (posn-y p1) (posn-y p2)) (+ (posn-y p1) n)]
                                      [else (posn-y p1)])) p2 n i)
                                     (list (place-image i (posn-x p1) (posn-y p1) (bitmap/file "blankbackground.png"))))]))

(define (seal-release i)
  (list
   (overlay (scale 6 i) (bitmap/file "blankbackground.png"))
   (overlay (scale 5.5 i) (bitmap/file "blankbackground.png"))
   (overlay (scale 5 i) (bitmap/file "blankbackground.png"))
   (overlay (scale 4.5 i) (bitmap/file "blankbackground.png"))
   (overlay (scale 4 i) (bitmap/file "blankbackground.png"))
   (overlay (scale 3.5 i) (bitmap/file "blankbackground.png"))
   (overlay (scale 3 i) (bitmap/file "blankbackground.png"))
   (overlay (scale 2.5 i) (bitmap/file "blankbackground.png"))
   (overlay (scale 2 i) (bitmap/file "blankbackground.png"))
   (overlay (scale 2 i) (bitmap/file "blankbackground.png"))
   (overlay (scale 2 i) (bitmap/file "blankbackground.png"))
   (overlay (scale 2 i) (bitmap/file "blankbackground.png"))
   (overlay (scale 2 i) (bitmap/file "blankbackground.png"))
   (overlay (scale 2 i) (bitmap/file "blankbackground.png"))
   (overlay (scale 2 i) (bitmap/file "blankbackground.png"))))

;; Heal
(define HEAL
  (make-spell
   'player
   "Magic_Healing" "Restore 100 HP"
   (lambda (c) (send c clone #:health (if (>= (+ 100 (send c get-health)) (send c get-max-health))
                      (send c get-max-health) (+ 100 (send c get-health)))))
   (append (seal-release (bitmap/file "heal.png")) 
           (list (circle 10 'solid 'green) (circle 9 'solid 'green) (circle 8 'solid 'green) 
         (circle 7 'solid 'green) (circle 6 'solid 'green) (circle 5 'solid 'green)))
   1
   (bitmap/file "heal.png")))

;; Doom Rock
(define DOOM-ROCK
  (make-spell
   'npc
   "Magic_Meteor"
   "Deal 250 rock damage"
   (lambda (c)
     (send c clone #:health (if (>= 125 (send c get-health)) 0 (- (send c get-health)))))
   (append (seal-release (bitmap/file "doom-rock.png")) 
           (reverse (draw-throw (make-posn 480 -40) (make-posn -60 520) 20 (scale .5 (bitmap/file "doomrock.png")))))
   3
   (bitmap/file "doom-rock.png")))

;; Gambler's Gambit
(define GAMBLERS-GAMBIT
  (make-spell
   'player
   "Gambler's_Gambit"
   "x2 Strength, 1/2 Health"
   (lambda (c)
     (send c clone #:health (if (= (send c get-health) 1) 0
                      (round (/ (send c get-health) 2)))
           #:strength (round (* 2 (send c get-strength)))))
   (append (seal-release (bitmap/file "gamblers_gambit.png"))
           (list (circle 10 'solid 'green) (circle 9 'solid 'green) (circle 8 'solid 'green) 
         (circle 7 'solid 'green) (circle 6 'solid 'green) (circle 5 'solid 'green)))
   1
   (bitmap/file "gamblers_gambit.png")))

(define LIGHTNING
  (make-spell
   'npc
   "Lightning"
   "Deal 150 electric damage"
   (lambda (c) (send c apply-attack 10000 150 'electric))
   (append (seal-release (bitmap/file "lightning.png"))
           (make-list 25 (bitmap/file "lightning-attack.png")))
   5
   (bitmap/file "lightning.png")))


;; a list of lists of player spells and their prequisit levels
(define SPELL-LIST (list (list 3 HEAL)
                         (list 5 DOOM-ROCK)
                         (list 6 GAMBLERS-GAMBIT)
                         (list 10 LIGHTNING)))

(define SPELL-DIRECTORY (list HEAL
                              DOOM-ROCK
                              GAMBLERS-GAMBIT
                              LIGHTNING))


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
   (append (seal-release (bitmap/file "doom-rock.png"))
           (reverse (draw-throw (make-posn 320 -40) (make-posn 860 520) 20 (scale .5 (bitmap/file "doomrock.png")))))
   10
   (bitmap/file "doom-rock.png")))