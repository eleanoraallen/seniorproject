#lang racket
(require "combat.rkt")
(require 2htdp/image)
(provide (all-defined-out))
;; Consumables -------------------------------------------------------------------------------------------
(define MAGIC-POTION
  (new consumable%
       [name "Magic Potion"] 
       [description "Fully restores MP."]
       [image (bitmap/file "magic-potion.gif")]
       [effect (lambda (c)
                 (new player% 
                      [name (send c get-name)] [health (send c get-health)]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)] [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [position (send c get-position)] [map-animation (send c get-map-animation)]
                      [level (send c get-level)] [max-mp (send c get-max-mp)] 
                      [mp (send c get-max-mp)] [current-xp (send c get-current-xp)]))]
       [animation (list (circle 10 'solid 'orange) (circle 9 'solid 'orange) (circle 8 'solid 'orange) 
                        (circle 7 'solid 'orange) (circle 6 'solid 'orange) (circle 5 'solid 'orange))]
       [number 3]))

(define HEALING-POTION
  (new consumable%
       [name "Health Potion"] 
       [description "+ 25 health"]
       [image (bitmap/file "health-potion.gif")]
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
                      [level (send c get-level)] [max-mp (send c get-max-mp)]
                      [mp (send c get-mp)] [current-xp (send c get-current-xp)]))]
       [animation (list (circle 10 'solid 'green) (circle 9 'solid 'green) (circle 8 'solid 'green) 
                        (circle 7 'solid 'green) (circle 6 'solid 'green) (circle 5 'solid 'green))]
       [number 3]))

(define HEALING-PHILTER
  (new consumable%
       [name "Healing Philter"] 
       [description "Fully restores health"]
       [image (square 20 'solid 'white)]
       [effect (lambda (c)
                 (new npc% 
                      [name (send c get-name)] [health (send c get-max-health)]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)] [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [position (send c get-position)] [map-animation (send c get-map-animation)] 
                      [xp-award (send c get-xp-award)]))]
       [animation (list (circle 10 'solid 'orange) (circle 9 'solid 'orange) (circle 8 'solid 'orange) 
                        (circle 7 'solid 'orange) (circle 6 'solid 'orange) (circle 5 'solid 'orange))]
       [number 1]))

;; Weapons ------------------------------------------------------------------------------------------------
(define SWORD
  (new weapon%
       [name "Steel Sword"]
       [description "A sturdy steel sword."]
       [weapon-damage 100]
       [weapon-accuracy .95]
       [type 'metal]
       [image (square 20 'solid 'white)]))
(define STAFF
  (new weapon%
       [name "Wood Staff"]
       [description "A flimsy wooden quarterstaff."]
       [weapon-damage 5]
       [weapon-accuracy 1]
       [type 'wood]
       [image (square 20 'solid 'white)]))