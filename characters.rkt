#lang racket
(require "combat.rkt")
(require "items.rkt")
(require "spells.rkt")
(require 2htdp/image)
(provide (all-defined-out))

;; Player Characters ------------------------------------------------------------------------------------------------
(define SPELLSWORD
  (new player%
       [name "You"] [health 1000] [max-health 1000] [base-agility 1]
       [agility 1] [base-strength 10] [strength 10] [spells (list HEAL DOOM-ROCK)]
       [character-inventory (make-inventory SWORD empty (list MAGIC-POTION HEALING-POTION) (list (add-gold 0)))]
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
       [dir 'e] [level 1] [max-mp 40] [mp 40] [current-xp 1500]))

;; NPCs -----------------------------------------------------------------------------------------------------
(define NPC
  (new npc%
       [name "Enemy"] [health 500] [max-health 500] 
       [base-agility .95] [agility 1] [base-strength 5]
       [strength 5] [spells (list EVIL-DOOM-ROCK)]
       [character-inventory (make-inventory STAFF empty (list HEALING-PHILTER) (list (add-gold 10) SWORD STAFF))]
       [weakness 'fire] [resistance 'ice]
       [animation (make-animation (bitmap/file "knight_standby.png")
                                  (bitmap/file "knight_attack.png")
                                  (bitmap/file "knight_standby.png")
                                  (bitmap/file "knight_flinch.png")
                                  (bitmap/file "knight_standby.png")
                                  (bitmap/file "knight_standby.png"))]
       [position (make-posn 0 0)] [map-animation (make-map-animation (circle 10 'solid 'black)
                                                                     (circle 10 'solid 'black)
                                                                     (circle 10 'solid 'black)
                                                                     (circle 10 'solid 'black))] 
       [dir 'e] [xp-award 20]))