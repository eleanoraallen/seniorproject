#lang racket
(require "combat.rkt")
(require "items.rkt")
(require "spells.rkt")
(require 2htdp/image)
(provide (all-defined-out))

;; Player Characters ------------------------------------------------------------------------------------------------
(define KNIGHT
  (new player%
       [name "Knight"] [health 800] [max-health 800] [base-agility 1]
       [agility 1] [base-strength 10] [strength 10] [spells empty]
       [character-inventory (make-inventory SWORD empty empty empty)]
       [weakness 'none] [resistance 'none]
       [animation (make-animation (flip-horizontal (bitmap/file "knight_standby.png"))
                                  (flip-horizontal (bitmap/file "knight_attack.png"))
                                  (flip-horizontal (bitmap/file "knight_standby.png"))
                                  (flip-horizontal (bitmap/file "knight_flinch.png"))
                                  (flip-horizontal (bitmap/file "knight_standby.png"))
                                  (flip-horizontal (bitmap/file "knight_standby.png")))]
       [position (make-posn 10 10)] [map-animation (make-map-animation (circle 10 'solid 'red))]
       [level 1] [max-mp 0] [mp 0] [current-xp 1500]))

(define MAGE
  (new player%
       [name "Mage"] [health 500] [max-health 500] [base-agility .9]
       [agility .9] [base-strength 1] [strength 1] [spells (list HEAL DOOM-ROCK)]
       [character-inventory (make-inventory STAFF empty (list MAGIC-POTION) empty)]
       [weakness 'none] [resistance 'none]
       [animation (make-animation (flip-horizontal (bitmap/file "knight_standby.png"))
                                  (flip-horizontal (bitmap/file "knight_attack.png"))
                                  (flip-horizontal (bitmap/file "knight_standby.png"))
                                  (flip-horizontal (bitmap/file "knight_flinch.png"))
                                  (flip-horizontal (bitmap/file "knight_standby.png"))
                                  (flip-horizontal (bitmap/file "knight_standby.png")))]
       [position (make-posn 10 10)] [map-animation (make-map-animation (circle 10 'solid 'red))]
       [level 1] [max-mp 50] [mp 50] [current-xp 1500]))

(define SPELLSWORD
  (new player%
       [name "Spellsword"] [health 600] [max-health 600] [base-agility 1]
       [agility 1] [base-strength 5] [strength 5] [spells (list HEAL DOOM-ROCK)]
       [character-inventory (make-inventory SWORD empty (list MAGIC-POTION HEALING-POTION) empty)]
       [weakness 'none] [resistance 'none]
       [animation (make-animation (flip-horizontal (bitmap/file "knight_standby.png"))
                                  (flip-horizontal (bitmap/file "knight_attack.png"))
                                  (flip-horizontal (bitmap/file "knight_standby.png"))
                                  (flip-horizontal (bitmap/file "knight_flinch.png"))
                                  (flip-horizontal (bitmap/file "knight_standby.png"))
                                  (flip-horizontal (bitmap/file "knight_standby.png")))]
       [position (make-posn 10 10)] [map-animation (make-map-animation (circle 10 'solid 'red))] 
       [level 1] [max-mp 20] [mp 20] [current-xp 1500]))

;; NPCs -----------------------------------------------------------------------------------------------------
(define NPC
  (new npc%
       [name "Rogue Knight"] [health 500] [max-health 500] 
       [base-agility .95] [agility 1] [base-strength 5]
       [strength 5] [spells (list EVIL-DOOM-ROCK)]
       [character-inventory (make-inventory STAFF empty (list HEALING-PHILTER) empty)]
       [weakness 'fire] [resistance 'ice]
       [animation (make-animation (bitmap/file "knight_standby.png")
                                  (bitmap/file "knight_attack.png")
                                  (bitmap/file "knight_standby.png")
                                  (bitmap/file "knight_flinch.png")
                                  (bitmap/file "knight_standby.png")
                                  (bitmap/file "knight_standby.png"))]
       [position (make-posn 0 0)] [map-animation (make-map-animation (circle 10 'solid 'black))] 
       [xp-award 20]))