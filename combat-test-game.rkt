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
;; - 'pa
;; - 'ps
;; - 'e
;; - 'ea
;; - 'w
;; - 'l
;; the second string is a thing the player is typing
;; the list of images are the images in the animation queue
(define-struct world (player npc phase text loi))

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
          [animation (send c get-animation)]
          [level (send c get-level)]
          [max-mp (send c get-max-mp)]
          [mp (send c get-mp)]
          [current-xp (send c get-current-xp)]))
   (list (circle 10 'solid 'green) (circle 9 'solid 'green)
         (circle 8 'solid 'green) (circle 7 'solid 'green)
         (circle 6 'solid 'green) (circle 5 'solid 'green))))


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
          [animation (send c get-animation)]
          [xp-award (send c get-xp-award)]))
   empty))

;; consumables
(define MAGIC-POTION
  (new consumable%
       [name "magic potion"]
       [description "A potion restores the users magic"]
       [image (square 20 'solid 'white)]
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
                      [animation (send c get-animation)]
                      [level (send c get-level)]
                      [max-mp (send c get-max-mp)]
                      [mp (send c get-max-mp)]
                      [current-xp (send c get-current-xp)]))]
       [animation (list (circle 10 'solid 'orange) (circle 9 'solid 'orange)
                        (circle 8 'solid 'orange) (circle 7 'solid 'orange)
                        (circle 6 'solid 'orange) (circle 5 'solid 'orange))]))


;; weapons
(define SWORD
  (new weapon%
       [name "Steel Sword"]
       [description "A sturdy steel sword."]
       [weapon-damage 10]
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
       [animation (make-animation (overlay (square 50 'outline 'black)
                                           (text "standby" 12 'black))
                                  (overlay (square 50 'outline 'black)
                                           (text "attack" 12 'black))
                                  (overlay (square 50 'outline 'black)
                                           (text "cast" 12 'black))
                                  (overlay (square 50 'outline 'black)
                                           (text "flinch" 12 'black))
                                  (overlay (square 50 'outline 'black)
                                           (text "win" 12 'black))
                                  (overlay (square 50 'outline 'black)
                                           (text "loose" 12 'black)))]
       [level 5]
       [max-mp 20]
       [mp 20]
       [current-xp 1500]))
;; npc
(define NPC
  (new npc%
       [name "Rogue Knight"]
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
       [animation (make-animation (overlay (circle 50 'outline 'black)
                                           (text "standby" 12 'black))
                                  (overlay (circle 50 'outline 'black)
                                           (text "attack" 12 'black))
                                  (overlay (circle 50 'outline 'black)
                                           (text "cast" 12 'black))
                                  (overlay (circle 50 'outline 'black)
                                           (text "flinch" 12 'black))
                                  (overlay (circle 50 'outline 'black)
                                           (text "win" 12 'black))
                                  (overlay (circle 50 'outline 'black)
                                           (text "loose" 12 'black)))]
       [xp-award 20]))

;; world
(define WORLD (make-world PLAYER NPC 'p "" empty))

;; render: world --> image
(define (render w)
  (overlay (if (empty? (world-loi w)) (square 0 'solid 'white) (first (world-loi w)))
           (overlay/align "middle" "bottom"
                          (text (world-text w) 12 'black)
                          (overlay/align "left" "top"
                                         (above
                                          (beside
                                           (text (string-append (send (world-npc w) get-name) ": ") 13 'black)
                                           (text " " 12 'white)
                                           (text (string-append
                                                  "Health: "
                                                  (number->string (send (world-npc w) get-health))
                                                  "/"
                                                  (number->string (send (world-npc w) get-max-health))) 12 'black))
                                          (rectangle 0 100 'solid 'white)
                                          (render-npc (send (world-npc w) get-animation) (world-phase w)))
                                         (overlay/align "right" "top"
                                                        (above/align "right"
                                                                     (beside
                                                                      (text (string-append (send (world-player w) get-name) ": ") 13 'black)
                                                                      (text " " 12 'white)
                                                                      (text (string-append
                                                                             "Health: "
                                                                             (number->string (send (world-player w) get-health))
                                                                             "/"
                                                                             (number->string (send (world-player w) get-max-health))) 12 'black))
                                                                     (text (string-append
                                                                            "MP: "
                                                                            (number->string (send (world-player w) get-mp))
                                                                            "/"
                                                                            (number->string (send (world-player w) get-max-mp))) 12 'black)
                                                                     (rectangle 0 100 'solid 'white)
                                                                     (render-player (send (world-player w) get-animation) (world-phase w)))
                                                        (rectangle 500 400 'solid 'white))))))
(define (render-npc a p)
  (cond
    [(eq? p 'l) (animation-win a)]
    [(eq? p 'w) (animation-loose a)]
    [(eq? p 'ea) (animation-attack a)]
    [(eq? p 'pa) (animation-flinch a)]
    [(eq? p 'ps) (animation-flinch a)]
    [else (animation-standby a)]))

(define (render-player a p)
  (cond
    [(eq? p 'l) (animation-loose a)]
    [(eq? p 'w) (animation-win a)]
    [(eq? p 'ea) (animation-flinch a)]
    [(eq? p 'pa) (animation-attack a)]
    [(eq? p 'ps) (animation-cast a)]
    [else (animation-standby a)]))

;; tock: world --> world
(define (tock w)
  (cond
    [(not (empty? (world-loi w))) (make-world (world-player w) (world-npc w) (world-phase w) "" (rest (world-loi w)))]
    [(send (world-player w) dead?) (make-world (world-player w) (world-npc w) 'l "YOU LOOSE!" empty)]
    [(send (world-npc w) dead?) (make-world (world-player w) (world-npc w) 'w "YOU WIN!" empty)]
    [(symbol=? (world-phase w) 'e) (make-world
                                    (send (world-player w) apply-attack 
                                          (send (inventory-weapon (send (world-npc w) get-inventory)) get-accuracy) 
                                          (send (world-npc w) get-damage)
                                          (send (inventory-weapon (send (world-npc w) get-inventory)) get-type))
                                    (world-npc w)
                                    'ea
                                    ""
                                    (list (square 20 'solid 'red) (square 17 'solid 'red) (square 15 'solid 'red)
                                          (square 13 'solid 'red) (square 11 'solid 'red) (square 9 'solid 'red)))]
    [(and (symbol=? (world-phase w) 'ea) (empty? (world-loi w))) (make-world (world-player w) (world-npc w) 'p "" empty)]
    [(and (symbol=? (world-phase w) 'pa) (empty? (world-loi w))) (make-world (world-player w) (world-npc w) 'e "" empty)]
    [(and (symbol=? (world-phase w) 'ps) (empty? (world-loi w))) (make-world (world-player w) (world-npc w) 'e "" empty)]
    [else w]))

;; handle-key : world --> world
(define (handle-key w k)
  (cond
    [(key=? k "escape") WORLD]
    [(and (not (string=? "" (world-text w))) (eq? (world-phase w) 'p) (key=? k "\b"))
     (make-world (world-player w) (world-npc w) (world-phase w)
                 (substring (world-text w) 0 (- (string-length (world-text w)) 1)) empty)]
    [(and (symbol=? (world-phase w) 'p) (key=? k "\r"))
     (cond
       ;; attack
       [(or (string=? (world-text w) "attack")
            (string=? (world-text w) "a"))
        (make-world (world-player w) (send (world-npc w) apply-attack
                                                         (send (inventory-weapon (send (world-player w) get-inventory)) get-accuracy)
                                                         (send (world-player w) get-damage)
                                                         (send (inventory-weapon (send (world-player w) get-inventory)) get-type))
                    'pa "" 
                    (list (square 20 'solid 'black) (square 17 'solid 'black) (square 15 'solid 'black)
                          (square 13 'solid 'black) (square 11 'solid 'black) (square 9 'solid 'black)))]
       ;; heal
       [(string=? (world-text w) "heal") (if (< (send (world-player w) get-mp) 5) w
                                             (make-world (send (send (world-player w) apply-spell HEAL) remove-mp 5)
                                                         (world-npc w) 'ps "" (spell-animation HEAL)))]
       ;; light ray
       [(string=? (world-text w) "light ray") (if (< (send (world-player w) get-mp) 10) w
                                                  (make-world (send (world-player w) remove-mp 10)
                                                              (send (world-npc w) apply-spell LIGHT-RAY) 'ps "" (spell-animation LIGHT-RAY)))]
       ;; use magic potion
       [(string=? (world-text w) "use magic potion") (make-world (send (world-player w) use-consumable MAGIC-POTION)
                                                                 (world-npc w) 'ps "" (send MAGIC-POTION get-animation))]
       [else w])]
    
    [(symbol=? (world-phase w) 'p)
     (make-world (world-player w) (world-npc w) 'p (string-append (world-text w) k) empty)]
    [else w]))

;; main
(define (main w)
  (big-bang w
            [to-draw render]
            [on-tick tock]
            [on-key handle-key]))

;; run
(main WORLD)
