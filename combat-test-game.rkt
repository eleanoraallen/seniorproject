#lang racket
(require "combat.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TEST COMBAT
(require 2htdp/image)
(require 2htdp/universe)

;; Spells -------------------------------------------------------------------------------------------
(define HEAL
  (make-spell
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
          [level (send c get-level)] [max-mp (send c get-max-mp)]
          [mp (send c get-mp)] [current-xp (send c get-current-xp)]))
   (list (circle 10 'solid 'green) (circle 9 'solid 'green) (circle 8 'solid 'green) 
         (circle 7 'solid 'green) (circle 6 'solid 'green) (circle 5 'solid 'green))))

(define DOOM-ROCK
  (make-spell
   "Doom Rock" "summon a rock of doom"
   (lambda (c)
     (new npc%
          [name (send c get-name)] 
          [health (if (>= 100 (send c get-health)) 0 (- (send c get-health) 100))] 
          [max-health (send c get-max-health)]
          [base-agility (send c get-base-agility)] [agility (send c get-agility)]
          [base-strength (send c get-base-strength)] [strength (send c get-strength)]
          [spells (send c get-spells)] [character-inventory (send c get-inventory)]
          [weakness (send c get-weakness)] [resistance (send c get-resistance)]
          [animation (send c get-animation)] [xp-award (send c get-xp-award)]))
   (list (bitmap/file "doomrock1.png") (bitmap/file "doomrock2.png")
         (bitmap/file "doomrock3.png") (bitmap/file "doomrock4.png")
         (bitmap/file "doomrock5.png") (bitmap/file "doomrock6.png")
         (bitmap/file "doomrock7.png") (bitmap/file "doomrock8.png")
         (bitmap/file "doomrock9.png") (bitmap/file "doomrock10.png")
         (bitmap/file "doomrock11.png") (bitmap/file "doomrock12.png")
         (bitmap/file "doomrock13.png") (bitmap/file "doomrock14.png")
         (bitmap/file "doomrock15.png") (bitmap/file "doomrock16.png")
         (bitmap/file "doomrock17.png") (bitmap/file "doomrock18.png")
         (bitmap/file "doomrock19.png") (bitmap/file "doomrock20.png"))))

;; Consumables -------------------------------------------------------------------------------------------
(define MAGIC-POTION
  (new consumable%
       [name "magic potion"] 
       [description "A potion restores the users magic"]
       [image (square 20 'solid 'white)]
       [effect (lambda (c)
                 (new player% 
                      [name (send c get-name)] [health (send c get-health)]
                      [max-health (send c get-max-health)] [base-agility (send c get-base-agility)]
                      [agility (send c get-agility)] [base-strength (send c get-base-strength)]
                      [strength (send c get-strength)] [spells (send c get-spells)]
                      [character-inventory (send c get-inventory)] [weakness (send c get-weakness)]
                      [resistance (send c get-resistance)] [animation (send c get-animation)]
                      [level (send c get-level)] [max-mp (send c get-max-mp)] [mp (send c get-max-mp)]
                      [current-xp (send c get-current-xp)]))]
       [animation (list (circle 10 'solid 'orange) (circle 9 'solid 'orange) (circle 8 'solid 'orange) 
                        (circle 7 'solid 'orange) (circle 6 'solid 'orange) (circle 5 'solid 'orange))]
       [number 1]))

;; Weapons ------------------------------------------------------------------------------------------------
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

;; Characters ------------------------------------------------------------------------------------------------
(define PLAYER
  (new player%
       [name "You"] [health 500] [max-health 500] [base-agility 1]
       [agility 1] [base-strength 5] [strength 5] [spells empty]
       [character-inventory (make-inventory SWORD empty empty empty)]
       [weakness 'none] [resistance 'none]
       [animation (make-animation (flip-horizontal (bitmap/file "knight_standby.png"))
                                  (flip-horizontal (bitmap/file "knight_attack.png"))
                                  (flip-horizontal (bitmap/file "knight_standby.png"))
                                  (flip-horizontal (bitmap/file "knight_flinch.png"))
                                  (flip-horizontal (bitmap/file "knight_standby.png"))
                                  (flip-horizontal (bitmap/file "knight_standby.png")))]
       [level 5] [max-mp 20] [mp 20] [current-xp 1500]))

(define NPC
  (new npc%
       [name "Rogue Knight"] [health 500] [max-health 500] 
       [base-agility .95] [agility 1] [base-strength 5]
       [strength 5] [spells empty]
       [character-inventory (make-inventory STAFF empty empty empty)]
       [weakness 'fire] [resistance 'ice]
       [animation (make-animation (bitmap/file "knight_standby.png")
                                  (bitmap/file "knight_attack.png")
                                  (bitmap/file "knight_standby.png")
                                  (bitmap/file "knight_flinch.png")
                                  (bitmap/file "knight_standby.png")
                                  (bitmap/file "knight_standby.png"))]
       [xp-award 20]))

;; World ------------------------------------------------------------------------------------------------

;; a world is a (make-world player npc symbol symbol loi) where
;; the player is the player
;; the npc is an enemy
;; the first symbol is one of:
;; - 'p
;; - 'pa
;; - 'ps
;; - 'e
;; - 'ea
;; - 'w
;; - 'l
;; the second symbol is one of
;; - 'm
;; - 's
;; - 'i
;; the list of images are the images in the animation queue
(define-struct world (player npc phase menu loi))
(define DEFAULT-WORLD (make-world PLAYER NPC 'p 'm empty))

;; Render ------------------------------------------------------------------------------------------------ 

;; render: world --> image
;; renders the world as an image
(define (render w)
  (above
   (overlay (if (empty? (world-loi w)) (square 0 'solid 'white) (first (world-loi w)))
            (render-npc (send (world-npc w) get-animation) (world-phase w))
            (render-player (send (world-player w) get-animation) (world-phase w)) 
            (above
             (beside
              (render-data (send (world-npc w) get-name) 
                           (send (world-npc w) get-health)
                           (send (world-npc w) get-max-health))
              (rectangle 550 0 'solid 'white)
              (render-data (send (world-player w) get-name)
                           (send (world-player w) get-health)
                           (send (world-player w) get-max-health)
                           #:mp (send (world-player w) get-mp)
                           #:max-mp (send (world-player w) get-max-mp)))
             (rectangle 0 350 'solid 'white))
            (bitmap/file "background.png")
            (rectangle 810 460 'solid 'black))
   (overlay/align "middle" "top"
                  (render-menu (world-player w) (world-menu w))
                  (rectangle 810 170 'solid 'black))))

;; render-menu : player symbol --> image
;; takes a player and a symbol and outputs the appropriate menu
(define (render-menu p m)
  (cond
    
    [(symbol=? m 'm) 
     (overlay 
      (beside 
       (overlay/align 
        "middle" "top" 
        (above (rectangle 0 21 'solid 'black) (text "1: Attack" 13 'black))
        (overlay (scale .17 (rotate 240 (bitmap/file "dagger.png")))
                 (rectangle 190 130 'solid 'gray) (rectangle 200 140 'solid 'black)))
       (rectangle 50 0 'solid 'black)
       (overlay/align 
        "middle" "top" 
        (above (rectangle 0 11 'solid 'black) (text "2: Items" 13 'black))
        (overlay (above (rectangle 0 20 'solid 'black) (scale .3 (bitmap/file "bottle.png")))
                 (rectangle 190 130 'solid 'gray) (rectangle 200 140 'solid 'black)))
       (rectangle 50 0 'solid 'black)
       (overlay/align 
        "middle" "top" 
        (above (rectangle 0 11 'solid 'black) (text "3: Spells" 13 'black))
        (overlay 
         (above (rectangle 0 15 'solid 'black) 
                (scale .14 (bitmap/file "phlogiston.png")))
         (rectangle 190 130 'solid 'gray) (rectangle 200 140 'solid 'black))))
      (rectangle 800 165 'solid (make-color 60 60 60)))]
    
    
    [(symbol=? m 'i)
     (cond
       [(empty? (inventory-consumables (send p get-invintory)))
        (rectangle 800 165 'solid (make-color 60 60 60))]
       [(= 1 1)
        (overlay
         (overlay/align 
        "middle" "top" 
        (above (rectangle 0 11 'solid 'black) 
               (text (send (first (invintory-consumables (send p get-invintory))) get-name) 13 'black))
        (overlay (above (rectangle 0 20 'solid 'black) (send (first (invintory-consumables (send p get-invintory))) get-image))
                 (rectangle 190 130 'solid 'gray) (rectangle 200 140 'solid 'black)))
        (rectangle 800 165 'solid (make-color 60 60 60)))]
       [else (rectangle 800 165 'solid (make-color 60 60 60))])]
    [else (rectangle 800 165 'solid (make-color 60 60 60))]))


;; render-data: string num num #:num #:num --> image
;; renders given character data as an image
(define (render-data name health max-health #:mp [mp -999] #:max-mp [max-mp -999])
  (above
   (text name 13 'white)
   (if (>= 0 health) 
       (text (string-append "Health: 0/" (number->string max-health)) 13 'white) 
       (text (string-append "Health: " (number->string health) "/"
                            (number->string max-health)) 13 'white))
   (if (> 0 mp) 
       (square 0 'solid 'white) 
       (text (string-append "MP: "
                            (number->string mp) "/"
                            (number->string max-mp)) 13 'white))))

;; render-npc animation symbol --> image
;; takes an animation and a phase and outputs appropriate npc animation
(define (render-npc a p)
  (cond
    [(eq? p 'l) (animation-win a)]
    [(eq? p 'w) (animation-loose a)]
    [(eq? p 'ea) (animation-attack a)]
    [(eq? p 'pa) (animation-flinch a)]
    [(eq? p 'ps) (animation-flinch a)]
    [else (animation-standby a)]))

;; render-player animation symbol --> image
;; takes an animation and a phase and outputs appropriate player animation
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
    [(not (empty? (world-loi w))) (make-world (world-player w) (world-npc w) (world-phase w) 'm (rest (world-loi w)))]
    [(send (world-player w) dead?) (make-world (world-player w) (world-npc w) 'l 'm empty)]
    [(send (world-npc w) dead?) (make-world (world-player w) (world-npc w) 'w 'm empty)]
    [(symbol=? (world-phase w) 'e) (make-world
                                    (send (world-player w) apply-attack 
                                          (send (inventory-weapon (send (world-npc w) get-inventory)) get-accuracy) 
                                          (send (world-npc w) get-damage)
                                          (send (inventory-weapon (send (world-npc w) get-inventory)) get-type))
                                    (world-npc w)
                                    'ea
                                    'm
                                    (make-list 20 (bitmap/file "blankbackground.png")))]
    [(and (symbol=? (world-phase w) 'ea) (empty? (world-loi w))) (make-world (world-player w) (world-npc w) 'p 'm empty)]
    [(and (symbol=? (world-phase w) 'pa) (empty? (world-loi w))) (make-world (world-player w) (world-npc w) 'e 'm empty)]
    [(and (symbol=? (world-phase w) 'ps) (empty? (world-loi w))) (make-world (world-player w) (world-npc w) 'e 'm empty)]
    [else w]))

;; handle-key : world --> world
(define (handle-key w k)
  (if (symbol=? (world-phase w) 'p)
      (cond
        [(symbol=? (world-menu w) 'm)
         (cond
           [(key=? k "1") (make-world (world-player w) 
                                      (send (world-npc w) apply-attack
                                            (send (inventory-weapon (send (world-player w) get-inventory)) get-accuracy)
                                            (send (world-player w) get-damage)
                                            (send (inventory-weapon (send (world-player w) get-inventory)) get-type))
                                      'pa 'm 
                                      (make-list 20 (bitmap/file "blankbackground.png")))]
           [(key=? k "2") (make-world (world-player w)
                                      (world-npc w)
                                      'p 'i empty)]
           [(key=? k "3") (make-world (world-player w)
                                      (world-npc w)
                                      'p 's empty)]
           [else w])]
        [(symbol=? (world-menu w) 'i) w]
        [(symbol=? (world-menu w) 's) w])
      w))



;; main
(define (main w)
  (big-bang w
            [to-draw render]
            [on-tick tock]
            [on-key handle-key]))

;; run
(main DEFAULT-WORLD)
