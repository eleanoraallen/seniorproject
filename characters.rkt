#lang racket
(require "combat.rkt")
(require "items.rkt")
(require "spells.rkt")
(require 2htdp/image)
(provide (all-defined-out))

;; Diologue Functions --------------------------------------------------------------------------------------------
(define TAKE (lambda (d)
               (make-dungeon (send (dungeon-player d) clone #:health 1)
                             (dungeon-rooms d) (list "MWAHAHAHAHAHAHAHAHA!"
                                                     "(just buy some health potions from the store, you'll be fine)")
                             (dungeon-name d) (dungeon-menu d))))

;; Player Characters ------------------------------------------------------------------------------------------------
(define SPELLSWORD
  (new player%
       [name "You"] [health 50] [max-health 50] [base-agility 1]
       [agility 1] [base-strength 5] [strength 5] [spells empty]
       [character-inventory (make-inventory STAFF (list HAT COAT BOOTS MITTENS) (list empty empty empty empty empty) (list HEALING-POTION) (list (add-gold 999)))]
       [weakness 'none] [resistance 'none]
       [animation (make-animation (flip-horizontal (bitmap/file "knight_standby.png"))
                                  (flip-horizontal (bitmap/file "knight_attack.png"))
                                  (flip-horizontal (bitmap/file "knight_standby.png"))
                                  (flip-horizontal (bitmap/file "knight_flinch.png"))
                                  (flip-horizontal (bitmap/file "knight_standby.png"))
                                  (flip-horizontal (bitmap/file "knight_standby.png")))]
       [position (make-posn 3150 2250)] [map-animation (make-map-animation (bitmap/file "bolivar3.png")
                                                                           (bitmap/file "bolivar1.png")
                                                                           (bitmap/file "bolivar2.png")
                                                                           (bitmap/file "bolivar4.png"))] 
       [dir 'e] [level 1] [max-mp 5] [mp 5] [current-xp 0]))

;; NPCs -----------------------------------------------------------------------------------------------------
(define NPC
  (new npc%
       [name "Rougish Naive"] [health 25] [max-health 25] 
       [base-agility .95] [agility 1] [base-strength 0]
       [strength 0] [spells (list EVIL-DOOM-ROCK)]
       [character-inventory (make-inventory STAFF empty (list (list SWORD) empty empty empty empty) (list HEALING-PHILTER) (list (add-gold 10)))]
       [weakness 'fire] [resistance 'ice]
       [animation (make-animation (bitmap/file "knight_standby.png")
                                  (bitmap/file "knight_attack.png")
                                  (bitmap/file "knight_standby.png")
                                  (bitmap/file "knight_flinch.png")
                                  (bitmap/file "knight_standby.png")
                                  (bitmap/file "knight_standby.png"))]
       [position (make-posn 3000 2250)] [map-animation (make-map-animation (square 50 'solid 'black)
                                                                     (square 50 'solid 'black)
                                                                     (square 50 'solid 'black)
                                                                     (square 50 'solid 'black))] 
       [dir 'e] [diologue (list "I can say words!"
                                "Words"
                                "But I can do far  more than that"
                                "diologues can lead to any valid gamestate"
                                "for instance, your next click could lead to a boss battle"
                                "or to a compleatly different dungeon"
                                "one that is significantly more unpleasent than this one"
                                "I could even end the game right now"
                                "Don't think I wouldn't"
                                "I'm very evil"
                                "What's that?"
                                "You don't want me to do that?"
                                "Well OK."
                                "I'll let you off easy this time"
                                "Alakasam!"
                                TAKE)] [xp-award 250]))

(define NPC2
  (new npc%
       [name "Naivish Rogue"] [health 40] [max-health 40] 
       [base-agility .95] [agility 1] [base-strength 0]
       [strength 0] [spells (list EVIL-DOOM-ROCK)]
       [character-inventory (make-inventory STAFF empty (list empty (list HELMET) (list MAIL) (list GAUNTLETS) (list STEEL-BOOTS)) (list HEALING-PHILTER) (list (add-gold 10)))]
       [weakness 'ice] [resistance 'fire]
       [animation (make-animation (bitmap/file "knight_standby.png")
                                  (bitmap/file "knight_attack.png")
                                  (bitmap/file "knight_standby.png")
                                  (bitmap/file "knight_flinch.png")
                                  (bitmap/file "knight_standby.png")
                                  (bitmap/file "knight_standby.png"))]
       [position (make-posn 1000 1000)] [map-animation (make-map-animation (square 30 'solid 'black)
                                                                     (square 30 'solid 'black)
                                                                     (square 30 'solid 'black)
                                                                     (square 30 'solid 'black))] 
       [dir 'e] [diologue (list "I can say words!"
                                "Words"
                                "But I can do far  more than that"
                                "diologues can lead to any valid gamestate"
                                "for instance, your next click could lead to a boss battle"
                                "or to a compleatly different dungeon"
                                "one that is significantly more unpleasent than this one"
                                "I could even end the game right now"
                                "Don't think I wouldn't"
                                "I'm very evil"
                                "What's that?"
                                "You don't want me to do that?"
                                "Well OK."
                                "I'll let you off easy this time"
                                "Alakasam!"
                                TAKE)] [xp-award 250]))


;; Player Functions --------------------------------------------------------------------------------------------

;; leveled-up? player, number --> bool
(define (leveled-up? p n)
  (and (not (>= (send p get-level) 100))
       (<= (+ 100 (round (* 10 (expt (send p get-level) 2))))
           (+ (send p get-current-xp) n))))

;; apply-xp : player, number --> player
(define (apply-xp p n)
  (cond
    [(not (leveled-up? p n)) (send p clone #:current-xp (+ (send p get-current-xp) n))]
    [(leveled-up? p n)
     (apply-xp (send p clone
                     #:health (round (+ 50 (round (* 950 (/ (+ (send p get-level) 1) 100)))))
                     #:max-health (round (+ 50 (round (* 950 (/ (+ (send p get-level) 1) 100)))))
                     #:base-agility (round (/ (- 100 (round (* 20 (/ (+ (send p get-level) 1) 100)))) 100))
                     #:agility (round (/ (- 100 (round (* 20 (/ (+ (send p get-level) 1) 100)))) 100))
                     #:base-strength (round (+ 5 (* 95 (/ (+ (send p get-level) 1) 100))))
                     #:strength (round (+ 5 (* 95 (/ (+ (send p get-level) 1) 100))))
                     #:max-mp (round (+ 5 (* 95 (/ (+ (send p get-level) 1) 100))))
                     #:mp (round (+ 5 (* 95 (/ (+ (send p get-level) 1) 100))))
                     #:level (+ (send p get-level) 1)
                     #:current-xp 0)
               (- n (send p get-current-xp)))]))