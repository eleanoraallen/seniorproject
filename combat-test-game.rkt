#lang racket

(require "combat.rkt")
;; XXX consider moving the spells out into a different file if you're going
;; to use them in your finished game as well.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TEST COMBAT

(require 2htdp/image)
(require 2htdp/universe)

;; a world is a (make-world player npc symbol string string) where
;; the player is the player
;; the npc is an enemy
;; the symbol is one of:
;; - 'p
;; - 'e
;; - 'w
;; - 'l
;; the second string is a thing the player is typing
(define-struct world (player npc phase text))

;; spells
(define HEAL
  (make-spell
   "heal"
   "+ 50 health"
   (lambda (c)
     (new player%
          [name (send c get-name)]
          [health (if (>= (+ 50 (send c get-health)) (send c get-max-health))
                      (send c get-max-health)
                      (+ 50 (send c get-health)))]
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)]
          [agility (send c get-agility)]
          [base-strength (send c get-base-strength)]
          [strength (send c get-strength)]
          [spells (send c get-spells)]
          [character-inventory (send c get-inventory)]
          [weakness (send c get-weakness)]
          [resistance (send c get-resistance)]
          [level (send c get-level)]
          [max-mp (send c get-max-mp)]
          [mp (send c get-mp)]
          [current-xp (send c get-current-xp)]))))
;; Agilify
(define AGILIFY
  (make-spell
   "agilify"
   "agility goes up"
   (lambda (c)
     (new player%
          [name (send c get-name)]
          [health (send c get-health)]
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)]
          [agility .5]
          [base-strength (send c get-base-strength)]
          [strength (send c get-strength)]
          [spells (send c get-spells)]
          [character-inventory (send c get-inventory)]
          [weakness (send c get-weakness)]
          [resistance (send c get-resistance)]
          [level (send c get-level)]
          [max-mp (send c get-max-mp)]
          [mp (send c get-mp)]
          [current-xp (send c get-current-xp)]))))

;; strongify
(define STRONGIFY
  (make-spell
   "strongify"
   "you gain the streignth of ten yous"
   (lambda (c)
     (new player%
          [name (send c get-name)]
          [health (send c get-health)]
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)]
          [agility (send c get-agility)]
          [base-strength (send c get-base-strength)]
          [strength (* 10 (send c get-strength))]
          [spells (send c get-spells)]
          [character-inventory (send c get-inventory)]
          [weakness (send c get-weakness)]
          [resistance (send c get-resistance)]
          [level (send c get-level)]
          [max-mp (send c get-max-mp)]
          [mp (send c get-mp)]
          [current-xp (send c get-current-xp)]))))

;; Iceify weapon
(define ICEIFY-weapon
  (make-spell
   "icefy weapon"
   "coats your weapon in a sheet of ice"
   (lambda (c)
     (new player%
          [name (send c get-name)]
          [health (send c get-health)]
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)]
          [agility (send c get-agility)]
          [base-strength (send c get-base-strength)]
          [strength (send c get-strength)]
          [spells (send c get-spells)]
          [character-inventory (make-inventory
                                (new weapon%
                                     [name (string-append (send (inventory-weapon (send c get-inventory)) get-name) " (icey)")]
                                     [description (send (inventory-weapon (send c get-inventory)) get-description)]
                                     [weapon-damage (send (inventory-weapon (send c get-inventory)) get-damage)]
                                     [weapon-accuracy (send (inventory-weapon (send c get-inventory)) get-accuracy)]
                                     [type 'ice])
                                (inventory-equiped (send c get-inventory))
                                (inventory-consumables (send c get-inventory))
                                (inventory-miscellaneous (send c get-inventory)))]
          [weakness (send c get-weakness)]
          [resistance (send c get-resistance)]
          [level (send c get-level)]
          [max-mp (send c get-max-mp)]
          [mp (send c get-mp)]
          [current-xp (send c get-current-xp)]))))

;; Iceify weapon
(define FLAMEIFY-weapon
  (make-spell
   "icefy weapon"
   "coats your weapon in a sheet of ice"
   (lambda (c)
     (new player%
          [name (send c get-name)]
          [health (send c get-health)]
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)]
          [agility (send c get-agility)]
          [base-strength (send c get-base-strength)]
          [strength (send c get-strength)]
          [spells (send c get-spells)]
          [character-inventory (make-inventory
                                (new weapon%
                                     [name (string-append (send (inventory-weapon (send c get-inventory)) get-name) " (flamey)")]
                                     [description (send (inventory-weapon (send c get-inventory)) get-description)]
                                     [weapon-damage (send (inventory-weapon (send c get-inventory)) get-damage)]
                                     [weapon-accuracy (send (inventory-weapon (send c get-inventory)) get-accuracy)]
                                     [type 'fire])
                                (inventory-equiped (send c get-inventory))
                                (inventory-consumables (send c get-inventory))
                                (inventory-miscellaneous (send c get-inventory)))]
          [weakness (send c get-weakness)]
          [resistance (send c get-resistance)]
          [level (send c get-level)]
          [max-mp (send c get-max-mp)]
          [mp (send c get-mp)]
          [current-xp (send c get-current-xp)]))))

;; light ray
(define LIGHT-RAY
  (make-spell
   "light ray"
   "fire a ray of darkness"
   (lambda (c)
     (new npc%
          [name (send c get-name)]
          [health (if (>= 100 (send c get-health))
                      0
                      (- (send c get-health) 100))]
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)]
          [agility (send c get-agility)]
          [base-strength (send c get-base-strength)]
          [strength (send c get-strength)]
          [spells (send c get-spells)]
          [character-inventory (send c get-inventory)]
          [weakness (send c get-weakness)]
          [resistance (send c get-resistance)]
          [xp-award (send c get-xp-award)]))))

;; consumables
(define MAGIC-POTION
  (new consumable%
       [name "magic potion"]
       [description "A potion restores the users magic"]
       [effect (lambda (c)
                 (new player%
                      [name (send c get-name)]
                      [health (send c get-health)]
                      [max-health (send c get-max-health)]
                      [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)]
                      [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)]
                      [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)]
                      [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)]
                      [level (send c get-level)]
                      [max-mp (send c get-max-mp)]
                      [mp (send c get-max-mp)]
                      [current-xp (send c get-current-xp)]))]))


;; weapons
(define SWORD
  (new weapon%
       [name "Steel Sword"]
       [description "A sturdy steel sword."]
       [weapon-damage 10]
       [weapon-accuracy .95]
       [type 'metal]))
(define STAFF
  (new weapon%
       [name "Wood Staff"]
       [description "A flimsy wooden quarterstaff."]
       [weapon-damage 5]
       [weapon-accuracy 1]
       [type 'metal]))
;; player
(define PLAYER
  (new player%
       [name "You"]
       [health 500]
       [max-health 500]
       [base-agility 1]
       [agility 1]
       [base-strength 5]
       [strength 5]
       [spells empty]
       [character-inventory (make-inventory SWORD empty empty empty)]
       [weakness 'none]
       [resistance 'none]
       [level 5]
       [max-mp 20]
       [mp 20]
       [current-xp 1500]))
;; npc
(define NPC
  (new npc%
       [name "Evil Knight"]
       [health 500]
       [max-health 500]
       [base-agility .95]
       [agility 1]
       [base-strength 5]
       [strength 5]
       [spells empty]
       [character-inventory (make-inventory STAFF empty empty empty)]
       [weakness 'fire]
       [resistance 'ice]
       [xp-award 20]))

;; world
(define WORLD (make-world PLAYER NPC 'p ""))

;; render: world --> image
(define (render w)
  (above
   (overlay
    (beside
     (above/align "left"
                  (text (string-append "Player: " (send (world-player w) get-name)) 13 'black)
                  (text " " 12 'white)
                  (text (string-append
                         "Health: "
                         (number->string (send (world-player w) get-health))
                         "/"
                         (number->string (send (world-player w) get-max-health))) 12 'black)
                  (text (string-append
                         "Agility: "
                         (number->string (round (* 100 (- 1 (send (world-player w) get-agility)))))) 12 'black)
                  (text (string-append
                         "Strength: "
                         (number->string (send (world-player w) get-strength))) 12 'black)
                  (text (string-append
                         "MP: "
                         (number->string (send (world-player w) get-mp))
                         "/"
                         (number->string (send (world-player w) get-max-mp))) 12 'black)
                  (text " " 12 'white)
                  (text (string-append
                         "Weapon: " (send (inventory-weapon (send (world-player w) get-inventory)) get-name)) 12 'black)
                  (text (string-append
                         "Accuracy: " (number->string (* 100 (send (inventory-weapon (send (world-player w) get-inventory)) get-accuracy)))) 12 'black)
                  (text (string-append
                         "Damage: " (number->string (send (inventory-weapon (send (world-player w) get-inventory)) get-damage))) 12 'black)
                  (text (string-append
                         "Type: " (symbol->string (send (inventory-weapon (send (world-player w) get-inventory)) get-type))) 12 'black))
     (rectangle 10 0 'solid 'white)
     (above/align "left"
                  (text (string-append "Enemy: " (send (world-npc w) get-name)) 13 'black)
                  (text " " 12 'white)
                  (text (string-append
                         "Health: "
                         (number->string (send (world-npc w) get-health))
                         "/"
                         (number->string (send (world-npc w) get-max-health))) 12 'black)
                  (text (string-append
                         "Agility: "
                         (number->string (round (* 100 (- 1 (send (world-npc w) get-agility)))))) 12 'black)
                  (text (string-append
                         "Strength: "
                         (number->string (send (world-npc w) get-strength))) 12 'black)
                  (text " " 12 'white)
                  (text " " 12 'white)
                  (text (string-append
                         "Weakness: "
                         (symbol->string (send (world-npc w) get-weakness))) 12 'black)
                  (text (string-append
                         "Resistance: "
                         (symbol->string (send (world-npc w) get-resistance))) 12 'black)
                  (text " " 12 'white)
                  (text " " 12 'white)))
    (overlay (rectangle 300 175 'solid 'white) (rectangle 302 177 'solid 'black)))
   (overlay/align "left" "middle" (text (string-append " " (world-text w)) 12 'black) (overlay (rectangle 300 20 'solid 'white)
                                                                                               (rectangle 302 22 'solid 'black)))))

;; tock: world --> world
(define (tock w)
  (cond
    [(send (world-player w) dead?) (make-world (world-player w) (world-npc w) 'l "YOU LOOSE!")]
    [(send (world-npc w) dead?) (make-world (world-player w) (world-npc w) 'w "YOU WIN!")]
    [else
     (if (symbol=? (world-phase w) 'e)
         (make-world
          (send (world-player w) apply-attack 
                (send (inventory-weapon (send (world-npc w) get-inventory)) get-accuracy) 
                (send (world-npc w) get-damage)
                (send (inventory-weapon (send (world-npc w) get-inventory)) get-type))
          (world-npc w)
          'p
          "")
         w)]))

;; handle-key : world --> world
(define (handle-key w k)
  (cond
    [(key=? k "escape") WORLD]
    [(and (not (string=? "" (world-text w))) (eq? (world-phase w) 'p) (key=? k "\b"))
     (make-world (world-player w) (world-npc w) (world-phase w)
                 (substring (world-text w) 0 (- (string-length (world-text w)) 1)))]
    [(and (symbol=? (world-phase w) 'p) (key=? k "\r"))
     (cond
       ;; attack
       [(or (string=? (world-text w) "attack")
            (string=? (world-text w) "a"))
        (make-world (world-player w) (send (world-npc w) apply-attack
                                           (send (inventory-weapon (send (world-player w) get-inventory)) get-accuracy)
                                           (send (world-player w) get-damage)
                                           (send (inventory-weapon (send (world-player w) get-inventory)) get-type)) 'e "")]
       ;; heal
       [(string=? (world-text w) "heal") (if (< (send (world-player w) get-mp) 5) w
                                             (make-world (send (send (world-player w) apply-spell HEAL) remove-mp 5)
                                                         (world-npc w) 'e ""))]
       ;; agilify
       [(string=? (world-text w) "agilify") (if (< (send (world-player w) get-mp) 5) w
                                                (make-world (send (send (world-player w) apply-spell AGILIFY) remove-mp 5)
                                                            (world-npc w) 'e ""))]
       ;; strongify
       [(string=? (world-text w) "strongify") (if (< (send (world-player w) get-mp) 5) w
                                                  (make-world (send (send (world-player w) apply-spell STRONGIFY) remove-mp 5)
                                                              (world-npc w) 'e ""))]
       [(string=? (world-text w) "iceify weapon") (if (< (send (world-player w) get-mp) 10) w
                                                     (make-world (send (send (world-player w) apply-spell ICEIFY-weapon) remove-mp 10)
                                                                 (world-npc w) 'e ""))]
       [(string=? (world-text w) "flameify weapon") (if (< (send (world-player w) get-mp) 10) w
                                                       (make-world (send (send (world-player w) apply-spell FLAMEIFY-weapon) remove-mp 10)
                                                                   (world-npc w) 'e ""))]
       ;; light ray
       [(string=? (world-text w) "light ray") (if (< (send (world-player w) get-mp) 10) w
                                                  (make-world (send (world-player w) remove-mp 10)
                                                              (send (world-npc w) apply-spell LIGHT-RAY) 'e ""))]
       ;; use magic potion
       [(string=? (world-text w) "use magic potion") (make-world (send (world-player w) use-consumable MAGIC-POTION)
                                                                 (world-npc w) 'e "")]
       [else w])]
    [(and (symbol=? (world-phase w) 'p) (key=? k "right"))
     (make-world (world-player w)(world-npc w) 'e "")]
    [(symbol=? (world-phase w) 'p)
     (make-world (world-player w) (world-npc w) 'p (string-append (world-text w) k))]
    [else w]))

;; main
(define (main w)
  (big-bang w
            [to-draw render]
            [on-tick tock]
            [on-key handle-key]))

;; run
(main WORLD)
