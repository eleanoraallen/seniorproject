#lang racket
(require "combat.rkt")
(require "characters.rkt")
(require "spells.rkt")
(require "items.rkt")
(require "dungeons.rkt")
(require 2htdp/image)
(require 2htdp/universe)

;; ------------------------------------------------------------------------------------------------------
;; game

;; a game is one of:
;; - combat
;; - dungeon
;; - image (splash screen/end screen)

;; RENDER --------------------------------------------------------------------------------------------------------

;; render: game --> image
;; renders the combat as an image
(define (render w)
  (cond
    [(image? w) w]
    [(combat? w) (render-combat w)]
    [(dungeon? w) (render-dungeon w)]))

;; render-combat: combat --> image
;; renders a combat as an image
(define (render-combat w)
  (above
   (overlay (if (empty? (combat-loi w)) (square 0 'solid 'white) (first (combat-loi w)))
            (render-npc (send (combat-npc w) get-animation) (combat-phase w))
            (render-player (send (combat-player w) get-animation) (combat-phase w)) 
            (above
             (beside
              (render-data (send (combat-npc w) get-name) 
                           (send (combat-npc w) get-health)
                           (send (combat-npc w) get-max-health))
              (rectangle 550 0 'solid 'white)
              (render-data (send (combat-player w) get-name)
                           (send (combat-player w) get-health)
                           (send (combat-player w) get-max-health)
                           #:mp (send (combat-player w) get-mp)
                           #:max-mp (send (combat-player w) get-max-mp)
                           #:level (send (combat-player w) get-level)))
             (rectangle 0 350 'solid 'white))
            (bitmap/file "background.png")
            (rectangle 810 460 'solid 'black))
   (overlay/align "middle" "top"
                  (render-menu (combat-player w) (combat-menu w))
                  (rectangle 810 170 'solid 'black))))

;; render-menu : player symbol --> image
;; takes a player and a symbol and outputs the appropriate menu
(define (render-menu p m)
  (cond  
    ;; main menu
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
        (overlay (above (rectangle 0 15 'solid 'black) 
                        (scale .14 (bitmap/file "phlogiston.png")))
                 (rectangle 190 130 'solid 'gray) (rectangle 200 140 'solid 'black))))
      (rectangle 800 165 'solid (make-color 60 60 60)))]
    ;; item menu
    [(symbol=? m 'i) 
     (cond 
       [(empty? (inventory-consumables (send p get-inventory)))
        (overlay (text "No Items Available!" 20 'white)
                 (rectangle 800 165 'solid (make-color 60 60 60)))]
       [(= (length (inventory-consumables (send p get-inventory))) 1)
        (overlay (render-item-block (first (inventory-consumables (send p get-inventory))))
                 (rectangle 800 165 'solid (make-color 60 60 60)))]
       [(= (length (inventory-consumables (send p get-inventory))) 2)
        (overlay 
         (beside 
          (render-item-block (first (inventory-consumables (send p get-inventory))))
          (rectangle 50 0 'solid 'orange)
          (render-item-block (second (inventory-consumables (send p get-inventory)))))
         (rectangle 800 165 'solid (make-color 60 60 60)))]
       [(= (length (inventory-consumables (send p get-inventory))) 3)
        (overlay
         (beside
          (render-item-block (first (inventory-consumables (send p get-inventory))))
          (rectangle 50 0 'solid 'orange)
          (render-item-block (second (inventory-consumables (send p get-inventory))))
          (rectangle 50 0 'solid 'black)
          (render-item-block (third (inventory-consumables (send p get-inventory)))))
         (rectangle 800 165 'solid (make-color 60 60 60)))]
       [else (overlay
              (beside
               (rotate 90 (overlay (isosceles-triangle 30 120 'solid 'white)
                                   (isosceles-triangle 40 120 'solid 'black)))
               (rectangle 15 0 'solid 'black)
               (render-item-block (first (inventory-consumables (send p get-inventory))))
               (rectangle 50 0 'solid 'orange)
               (render-item-block (second (inventory-consumables (send p get-inventory))))
               (rectangle 50 0 'solid 'black)
               (render-item-block (third (inventory-consumables (send p get-inventory))))
               (rectangle 15 0 'solid 'black)
               (rotate 270 (overlay (isosceles-triangle 30 120 'solid 'white)
                                    (isosceles-triangle 40 120 'solid 'black))))
              (rectangle 800 165 'solid (make-color 60 60 60)))])] 
    ;; spell menu
    [(symbol=? m 's)
     (cond 
       [(empty? (send p get-spells))
        (overlay (text "No Spells Available!" 20 'white)
                 (rectangle 800 165 'solid (make-color 60 60 60)))]
       [(= (length (send p get-spells)) 1)
        (overlay (render-spell-block (first (send p get-spells)))
                 (rectangle 800 165 'solid (make-color 60 60 60)))]
       [(= (length (send p get-spells)) 2)
        (overlay 
         (beside (render-spell-block (first (send p get-spells)))
                 (rectangle 50 0 'solid 'black)
                 (render-spell-block (second (send p get-spells))))
         (rectangle 800 165 'solid (make-color 60 60 60)))]
       [(= (length (send p get-spells)) 3)
        (overlay 
         (beside (render-spell-block (first (send p get-spells)))
                 (rectangle 50 0 'solid 'black)
                 (render-spell-block (second (send p get-spells)))
                 (rectangle 50 0 'solid 'black)
                 (render-spell-block (third (send p get-spells))))
         (rectangle 800 165 'solid (make-color 60 60 60)))]
       [else
        (overlay 
         (beside (rotate 90 (overlay (isosceles-triangle 30 120 'solid 'white)
                                     (isosceles-triangle 40 120 'solid 'black)))
                 (rectangle 15 0 'solid 'black)
                 (render-spell-block (first (send p get-spells)))
                 (rectangle 50 0 'solid 'black)
                 (render-spell-block (second (send p get-spells)))
                 (rectangle 50 0 'solid 'black)
                 (render-spell-block (third (send p get-spells)))
                 (rectangle 15 0 'solid 'black)
                 (rotate 270 (overlay (isosceles-triangle 30 120 'solid 'white)
                                      (isosceles-triangle 40 120 'solid 'black))))
         (rectangle 800 165 'solid (make-color 60 60 60)))])]
    [else (rectangle 800 165 'solid (make-color 60 60 60))]))

;; render-spell-block : item --> image
;; renders an spell block for a given spell
(define (render-spell-block s)
  (overlay/align 
   "middle" "top" 
   (above (rectangle 0 11 'solid 'black) 
          (text (spell-name s) 12 'black)
          (text (string-append "MP Cost: " (number->string (spell-cost s))) 10 'black))
   (overlay/align 
    "middle" "bottom"
    (above (text (spell-discription s) 10 'black)
           (rectangle 0 11 'solid 'black))
    (overlay (above (rectangle 0 (image-height (text "I" 12 'black)) 'solid 'black)
                    (spell-image s))
             (rectangle 190 130 'solid 'gray) 
             (rectangle 200 140 'solid 'black)))))

;; render-item-block : item --> image
;; renders an item block for a given image
(define (render-item-block i)
  (overlay/align 
   "middle" "top" 
   (above (rectangle 0 11 'solid 'black) 
          (text (string-append 
                 (send i get-name) ": " 
                 (number->string (send i get-number))) 
                13 'black))
   (overlay/align 
    "middle" "bottom"
    (above (text (send i get-description) 13 'black)
           (rectangle 0 11 'solid 'black))
    (overlay (send i get-image)
             (rectangle 190 130 'solid 'gray) 
             (rectangle 200 140 'solid 'black)))))

;; render-data: string num num #:num #:num --> image
;; renders given character data as an image
(define (render-data name health max-health #:mp [mp -999] #:max-mp [max-mp -999] #:level [level -1])
  (above
   (beside (text name 13 'white)
           (if (= level -1) (square 0 'solid 'white)
               (text (string-append ": Lvl. " (number->string level)) 13 'white)))
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

;; render-dungeon : dungeon --> image
;; renders a dungeon as an image
(define (render-dungeon d)
  (if (empty? (dungeon-menu d))
      (overlay
       (if (empty? (dungeon-images d)) (square 0 'solid 'blue) 
           (if (= (image-height (first (dungeon-images d))) 1)
               (rectangle 810 630 'solid 'black)
               (first (dungeon-images d))))
       (render-room (send (dungeon-player d) get-position)
                    (send (dungeon-player d) get-dir)
                    (send (dungeon-player d) get-map-animation)
                    (first (dungeon-rooms d))))
      (render-dungeon-menu d)))

;; render-dungeon-menu : dungeon --> image
(define (render-dungeon-menu d)
  (above (render-tabs (dungeon-menu d))
         (render-menu-data d)))

;; render-tabs : symbol --> image
(define (render-tabs m) 
  (cond
    [(symbol=? m 'player-info)
     (overlay (beside (overlay/align "middle" "bottom" 
                                     (overlay (text "Player Data" 20 'black)
                                              (rectangle 197 50 'solid 'gray))
                                     (rectangle 202 55 'solid 'black))
                      (overlay (text "Items" 20 'black)
                               (rectangle 197 45 'solid (make-color 60 60 60))
                               (rectangle 202 55 'solid 'black))
                      (overlay (text "Equipment" 20 'black)
                               (rectangle 197 45 'solid (make-color 60 60 60))
                               (rectangle 202 55 'solid 'black))
                      (overlay (text "Spells" 20 'black)
                               (rectangle 197 45 'solid (make-color 60 60 60))
                               (rectangle 202 55 'solid 'black)))
              (rectangle 810 55 'solid 'black))]
    [(symbol=? m 'items)
     (overlay (beside (overlay (text "Player Data" 20 'black)
                               (rectangle 197 45 'solid (make-color 60 60 60))
                               (rectangle 202 55 'solid 'black))
                      (overlay/align "middle" "bottom" 
                                     (overlay (text "Items" 20 'black)
                                              (rectangle 197 50 'solid 'gray))
                                     (rectangle 202 55 'solid 'black))
                      (overlay (text "Equipment" 20 'black)
                               (rectangle 197 45 'solid (make-color 60 60 60))
                               (rectangle 202 55 'solid 'black))
                      (overlay (text "Spells" 20 'black)
                               (rectangle 197 45 'solid (make-color 60 60 60))
                               (rectangle 202 55 'solid 'black)))
              (rectangle 810 55 'solid 'black))]
    [(symbol=? m 'equipment)
     (overlay (beside (overlay (text "Player Data" 20 'black)
                               (rectangle 197 45 'solid (make-color 60 60 60))
                               (rectangle 202 55 'solid 'black))
                      (overlay (text "Items" 20 'black)
                               (rectangle 197 45 'solid (make-color 60 60 60))
                               (rectangle 202 55 'solid 'black))
                      (overlay/align "middle" "bottom" 
                                     (overlay (text "Equipment" 20 'black)
                                              (rectangle 197 50 'solid 'gray))
                                     (rectangle 202 55 'solid 'black))
                      (overlay (text "Spells" 20 'black)
                               (rectangle 197 45 'solid (make-color 60 60 60))
                               (rectangle 202 55 'solid 'black)))
              (rectangle 810 55 'solid 'black))]
    [(symbol=? m 'spells)
     (overlay (beside (overlay (text "Player Data" 20 'black)
                               (rectangle 197 45 'solid (make-color 60 60 60))
                               (rectangle 202 55 'solid 'black))
                      (overlay (text "Items" 20 'black)
                               (rectangle 197 45 'solid (make-color 60 60 60))
                               (rectangle 202 55 'solid 'black))
                      (overlay (text "Equipment" 20 'black)
                               (rectangle 197 45 'solid (make-color 60 60 60))
                               (rectangle 202 55 'solid 'black))
                      (overlay/align "middle" "bottom" 
                                     (overlay (text "Spells" 20 'black)
                                              (rectangle 197 50 'solid 'gray))
                                     (rectangle 202 55 'solid 'black)))
              (rectangle 810 55 'solid 'black))]
    [else (rectangle 810 55 'solid 'black)]))

;; render-menu-data : dungeon --> image
(define (render-menu-data d)
  (cond
    [(symbol=? (dungeon-menu d) 'player-info)
     (overlay/align "left" "top"
                    (beside (rectangle 40 0 'solid 'red)
                            (above (rectangle 0 30 'solid 'blue)
                                   (beside
                                    (above
                                    (above/align "left"
                                                 (beside (text (send (dungeon-player d) get-name) 20 'black)
                                                         (rectangle (- 260 (image-width (text (send (dungeon-player d) get-name) 20 'black))
                                                                       (image-width (text (string-append "Lvl. " (number->string (send (dungeon-player d) get-level))) 20 'black))) 0 'solid 'black)
                                                         (text (string-append "Lvl. " (number->string (send (dungeon-player d) get-level))) 20 'black))
                                                 (rectangle 0 5 'solid 'black)
                                                 (overlay (bitmap/file "portrait.jpg") (square 260 'solid 'black)))
                                    (rectangle 0 44 'solid 'black)
                                                 (text (string-append "Health: " (number->string (send (dungeon-player d) get-health))
                                                                      "/" (number->string (send (dungeon-player d) get-max-health))) 20 'black)
                                                 (rectangle 0 20 'solid 'black)
                                                 (text (string-append "MP: " (number->string (send (dungeon-player d) get-mp))
                                                                      "/" (number->string (send (dungeon-player d) get-max-mp))) 20 'black)
                                                 (rectangle 0 20 'solid 'black)
                                                 (text (string-append "Strength: " (number->string (send (dungeon-player d) get-strength))) 20 'black)
                                                 (rectangle 0 20 'solid 'black)
                                                 (text (string-append "Agility: " (number->string (send (dungeon-player d) get-agility))) 20 'black))
                                    (rectangle 100 0 'solid 'black)
                                    (above/align "left"
                                                 (text (string-append "Location: " (dungeon-name d)) 20 'black)
                                                 (rectangle 0 20 'solid 'black)
                                                 (text (string-append "Gold: " 
                                                                      (number->string 
                                                                       (send (first 
                                                                              (filter (lambda (x) (string=? (send x get-name) "gold")) 
                                                                                      (inventory-miscellaneous (send (dungeon-player d) get-inventory))))
                                                                             get-number))) 20 'black)
                                                 (rectangle 0 20 'solid 'black)
                                                 (text (string-append "Items: " (number->string
                                                                                 (+ (item-number (inventory-consumables (send (dungeon-player d) get-inventory)))
                                                                                    (length (filter (lambda (x) (not (string=? (send x get-name) "gold"))) 
                                                                                      (inventory-miscellaneous (send (dungeon-player d) get-inventory)))))))
                                                       20 'black)
                                                 (rectangle 0 20 'solid 'black)
                                                 (text (string-append "Equipment: " (number->string (+ (length (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                       (length (inventory-equiped (send (dungeon-player d) get-inventory)))
                                                                                                       (if (empty? (inventory-weapon (send (dungeon-player d) get-inventory))) 0 1)))) 20 'black)
                                                 (rectangle 0 20 'solid 'black)
                                                 (text (string-append "Spells: " (number->string (length (send (dungeon-player d) get-spells)))) 20 'black)
                                                 ))))
                    (overlay/align "middle" "top"
                                   (rectangle 802 570 'solid 'gray)
                                   (rectangle 810 575 'solid 'black)))]
    [else (overlay/align "middle" "top"
                         (rectangle 802 570 'solid 'gray)
                         (rectangle 810 575 'solid 'black))]))

;; item-number : list --> number
(define (item-number l)
  (cond
    [(empty? l) 0]
    [(cons? l) (+ (send (first l) get-number) (item-number (rest l)))]))


;; render-room : position dir animation room --> image
;; takes the player's position, direction animation, and the room
;; they are in and renders the apropriate image
(define (render-room p d a r)
  (overlay
   (cond
     [(eq? d 'n) (map-animation-north-stationary a)]
     [(eq? d 'e) (map-animation-east-stationary a)]
     [(eq? d 's) (map-animation-south-stationary a)]
     [(eq? d 'w) (map-animation-west-stationary a)])
   (place-image
    (tiles->image (room-tiles r))
    (+ 405 (- (/ (image-width (tiles->image (room-tiles r))) 2) (posn-x p)))
    (+ 315 (- (/ (image-height (tiles->image (room-tiles r))) 2) (posn-y p)))
    (overlay/align "left" "bottom" 
                   (text (room-name r) 15 'red) 
                   (rectangle 810 630 'solid 'black)))))

;; tiles->image: lolot --> image
;; takes a list of lists of tiles and renders them as an image
(define (tiles->image t)
  (cond
    [(empty? t) (square 0 'solid 'gold)]
    [(cons? t) (above (render-tile-row (first t))
                      (tiles->image (rest t)))]))

;; render-tile-row : list-of-tiles --> image
;; renders a list of tiles as one image by putting them beside eachother
(define (render-tile-row r)
  (cond
    [(empty? r) (square 0 'solid 'red)]
    [(cons? r) (beside (send (first r) get-image)
                       (render-tile-row (rest r)))]))

;; TOCK -----------------------------------------------------------------------------------------

;; tock: game --> game
(define (tock w) 
  (cond
    [(or (image? w)) w]
    [(combat? w) (combat-tock w)]
    [(dungeon? w) (dungeon-tock w)]))

;; combat-tock : combat --> combat
;; preforms necessary opperations for every tick when in combat
(define (combat-tock w)
  (cond
    [(not (empty? (combat-loi w))) 
     (make-combat (combat-player w) 
                  (combat-npc w) 
                  (combat-phase w) 
                  'e 
                  (rest (combat-loi w))
                  (combat-dungeon-name w)
                  (combat-room-name w))]
    [(send (combat-player w) dead?) 
     (overlay (above (text "'Damn it, how will I ever get out of this labyrinth?'" 30 'black)
                     (text "- Simon Bolivar" 30 'black))
              (rectangle 810 630 'solid 'gray))]
    [(send (combat-npc w) dead?) 
     (construct-dungeon w)]
    [(symbol=? (combat-phase w) 'e) (npc-action w)]
    [(and (symbol=? (combat-phase w) 'ea) (empty? (combat-loi w)))
     (make-combat (combat-player w) (combat-npc w) 'p 'm empty (combat-dungeon-name w) (combat-room-name w))]
    [(and (symbol=? (combat-phase w) 'pa) (empty? (combat-loi w)))
     (make-combat (combat-player w) (combat-npc w) 'e 'e empty (combat-dungeon-name w) (combat-room-name w))]
    [(and (symbol=? (combat-phase w) 'ps) (empty? (combat-loi w)))
     (make-combat (combat-player w) (combat-npc w) 'e 'e empty (combat-dungeon-name w) (combat-room-name w))]
    [else w]))

;; construct-dungeon : combat --> dungeon
(define (construct-dungeon c)
  (make-dungeon (send (apply-xp (combat-player c) (send (combat-npc c) get-xp-award)) clone 
                      #:character-inventory (merge-inventories (send (combat-player c) get-inventory)
                                                               (send (combat-npc c) get-inventory))
                      #:spells (get-player-spells (apply-xp (combat-player c) (send (combat-npc c) get-xp-award)))
                      #:agility (send (combat-player c) get-base-agility)
                      #:strength (send (combat-player c) get-base-strength))
                (cons (get-room (get-dungeon (combat-dungeon-name c)) (combat-room-name c))
                      (filter (lambda (x) (not (string=? (room-name x) (combat-room-name c))))
                              (dungeon-rooms (get-dungeon (combat-dungeon-name c)))))
                (make-list 50 (overlay
                               (above
                                (text "You defeated your foe!" 30 'black)
                                (text " " 20 'black)
                                (text (string-append "You gained: "
                                                     (number->string (send (combat-npc c) get-xp-award))
                                                     " XP") 20 'black)
                                (text " " 20 'black)
                                (text "Loot Gained:" 30 'black)
                                (loi->image (inventory-miscellaneous (send (combat-npc c) get-inventory)))
                                (if (leveled-up? (combat-player c) (send (combat-npc c) get-xp-award))
                                    (above 
                                     (text "" 20 'black)
                                     (text "Leveled Up!" 30 'black)
                                     (text (string-append "Lvl. " (number->string (send (combat-player c) get-level))
                                                          " --> Lvl. " (number->string (send (apply-xp (combat-player c) (send (combat-npc c) get-xp-award)) get-level))) 20 'black))
                                    (square 0 'solid 'blue))
                                (if (learned-spell? (combat-player c) (apply-xp (combat-player c) (send (combat-npc c) get-xp-award)))
                                    (above 
                                     (text "" 20 'black)
                                     (text "Learned New Spell(s)!" 30 'black)
                                     (spell-text (subtract-lists (get-player-spells (apply-xp (combat-player c) (send (combat-npc c) get-xp-award)))
                                                                 (get-player-spells (combat-player c)))))
                                    (square 0 'solid 'blue)))
                               (rectangle 810 630 'solid 'gray))) (combat-dungeon-name c) 'empty))

;; spell-text : list-of-spells --> image
(define (spell-text l)
  (cond
    [(empty? l) (circle 0 'solid 'gold)]
    [(cons? l) (above
                (text (spell-name (first l)) 20 'black)
                (spell-text (rest l)))]))

;; subtract-lists : list list --> list
(define (subtract-lists l1 l2)
  (cond
    [(empty? l2) l1]
    [(cons? l2) (subtract-lists (rest l1) (rest l2))]))

;; learned-spell? player player --> bool
;; true iff player1 knows a spell player2 doesn't
(define (learned-spell? p1 p2) (< (length (get-player-spells p1)) (length (get-player-spells p2))))

;; get-player-spells : player --> list
(define (get-player-spells p) (get-spell-list (send p get-level) SPELL-LIST))

;; get-spell-list : number list --> list
(define (get-spell-list n l)
  (cond
    [(empty? l) empty]
    [(cons? l)
     (if (>= n (first (first l)))
         (cons (second (first l))
               (get-spell-list n (rest l)))
         (get-spell-list n (rest l)))]))

;; merge-invintories : invintory invintory --> invintory
(define (merge-inventories p n)
  (make-inventory (inventory-weapon p)
                  (inventory-equiped p)
                  (inventory-equipment p)
                  (inventory-consumables p)
                  (merge-gold
                   (append (inventory-miscellaneous p)
                           (inventory-miscellaneous n)))))

;; merge-gold : loi --> loi
(define (merge-gold l)
  (cons (new-gold l 0)
        (remove-gold l)))

;; new-gold : l n --> l
(define (new-gold l n)
  (cond
    [(empty? l) (add-gold n)]
    [(cons? l)
     (if (string=? (send (first l) get-name) "gold")
         (new-gold (rest l) (+ n (send (first l) get-number)))
         (new-gold (rest l) n))]))

;; remove-gold : l
(define (remove-gold l)
  (cond
    [(empty? l) empty]
    [(cons? l)
     (if (string=? (send (first l) get-name) "gold")
         (remove-gold (rest l))
         (cons (first l) (remove-gold (rest l))))]))

;; loi->image : loi --> image
(define (loi->image l)
  (cond
    [(empty? l) (square 0 'solid 'white)]
    [(cons? l) (above/align "left"
                            (if (string=? (send (first l) get-name) "gold")
                                (text (string-append "gold ["
                                                     (number->string (send (first l) get-number))
                                                     "]") 20 'black)
                                (text (send (first l) get-name) 20 'black))
                            (loi->image (rest l)))]))

;; npc-action : combat --> combat
;; makes the npc take an action
(define (npc-action w)
  (cond
    [(and (> (/ (send (combat-npc w) get-max-health) 4) (send (combat-npc w) get-health))
          (not (empty? (inventory-consumables (send (combat-npc w) get-inventory)))))
     (make-combat
      (combat-player w)
      (send (send (combat-npc w) 
                  clone #:character-inventory 
                  (make-inventory
                   (inventory-weapon (send (combat-npc w) get-inventory))
                   (inventory-equiped (send (combat-npc w) get-inventory))
                   (inventory-equipment (send (combat-npc w) get-inventory))
                   (if (> (send 
                           (first (inventory-consumables (send (combat-npc w) get-inventory))) get-number) 1)
                       (cons (new consumable% 
                                  [image (send (first (inventory-consumables (send (combat-npc w) get-inventory))) get-image)]
                                  [name (send (first (inventory-consumables (send (combat-npc w) get-inventory))) get-name)]
                                  [description (send (first (inventory-consumables (send (combat-npc w) get-inventory))) get-description)]
                                  [effect (send (first (inventory-consumables (send (combat-npc w) get-inventory))) get-effect)]
                                  [animation (send (first (inventory-consumables (send (combat-npc w) get-inventory))) get-animation)]
                                  [number (- (send (first (inventory-consumables (send (combat-npc w) get-inventory))) get-number) 1)])
                             (rest (inventory-consumables (send (combat-npc w) get-inventory))))
                       (rest (inventory-consumables (send (combat-npc w) get-inventory))))
                   (inventory-miscellaneous (send (combat-npc w) get-inventory))))
            use-consumable (first (inventory-consumables (send (combat-npc w) get-inventory)))) 
      'ea 'e (send (first (inventory-consumables (send (combat-npc w) get-inventory))) get-animation) (combat-dungeon-name w) (combat-room-name w))]
    [(= (random 2) 1) (set-up-spell w (list-ref (send (combat-npc w) get-spells) (random (length (send (combat-npc w) get-spells)))))]
    [else
     (make-combat
      (send (combat-player w) apply-attack 
            (send (inventory-weapon (send (combat-npc w) get-inventory)) get-accuracy) 
            (send (combat-npc w) get-damage)
            (send (inventory-weapon (send (combat-npc w) get-inventory)) get-type))
      (combat-npc w)
      'ea
      'e
      (make-list 10 (bitmap/file "blankbackground.png"))
      (combat-dungeon-name w) (combat-room-name w))]))

;; set-up-spell combat spell --> combat
;; takes a combat and a spell cast by the enemy and outputs updated combat
(define (set-up-spell w s)
  (make-combat
   (send (combat-player w) apply-spell s)
   (combat-npc w)
   'ea
   'e
   (spell-animation s)
   (combat-dungeon-name w) 
   (combat-room-name w)))

;; dungeon-tock : dungeon --> dungeon
;; preforms actions that should happen every tick when in a dungeon
(define (dungeon-tock d)
  (cond
    [(empty? (dungeon-images d)) d]
    [(= 1 (image-height (first (dungeon-images d))))
     (make-combat (dungeon-player d)
                  (list-ref (room-possible-encounters (first (dungeon-rooms d)))
                            (random (length (room-possible-encounters (first (dungeon-rooms d))))))
                  'p
                  'm
                  empty (dungeon-name d) (room-name (first (dungeon-rooms d))))]
    [else (make-dungeon (dungeon-player d)
                        (dungeon-rooms d)
                        (rest (dungeon-images d))
                        (dungeon-name d)
                        empty)]))

;; HANDLE-KEY -------------------------------------------------------------------------------------------------------------------------

;; handle-key : game --> game
;; takes a game and a keystroke and alters game if necessary
(define (handle-key w k)
  (cond
    [(image? w)
     (if (or (key=? k "escape")
             (key=? k "\r")) TESTDUNGEON1 w)]
    [(combat? w) (handle-combat-key w k)]
    [(dungeon? w) (handle-dungeon-key w k)]))

;; handle-combat-key : combat --> combat
(define (handle-combat-key w k)
  (if (symbol=? (combat-phase w) 'p)
      (cond
        ;; main menu
        [(symbol=? (combat-menu w) 'm)
         (cond
           [(key=? k "1") 
            (make-combat 
             (combat-player w)
             (if 
              (empty? (inventory-weapon (send (combat-player w) get-inventory)))
              (send (combat-npc w) apply-attack 
                   1
                   (send (combat-player w) get-strength) 
                   'none)
             (send (combat-npc w) apply-attack 
                   (send (inventory-weapon (send (combat-player w) get-inventory)) get-accuracy)
                   (send (combat-player w) get-damage) 
                   (send (inventory-weapon (send (combat-player w) get-inventory)) get-type)))
             'pa 'e (make-list 10 (bitmap/file "blankbackground.png")) (combat-dungeon-name w) (combat-room-name w))]
           [(key=? k "2") 
            (make-combat (combat-player w)
                         (combat-npc w)
                         'p 'i empty (combat-dungeon-name w) (combat-room-name w))]
           [(key=? k "3") 
            (make-combat (combat-player w)
                         (combat-npc w)
                         'p 's empty (combat-dungeon-name w) (combat-room-name w))]
           [else w])]
        ;; spell menu
        [(symbol=? (combat-menu w) 's)
         (cond
           [(and (> (length (send (combat-player w) get-spells)) 0) (key=? k "1"))
            (if (>= (send (combat-player w) get-mp) (spell-cost (first (send (combat-player w) get-spells))))
                (if (eq? (spell-target (first (send (combat-player w) get-spells))) 'player)
                    (make-combat 
                     (send (send (combat-player w) 
                                 clone #:mp (- (send (combat-player w) get-mp) 
                                               (spell-cost (first (send (combat-player w) get-spells)))))
                           apply-spell (first (send (combat-player w) get-spells)))
                     (combat-npc w) 'pa 'e (spell-animation (first (send (combat-player w) get-spells)))
                     (combat-dungeon-name w) (combat-room-name w))
                    (make-combat 
                     (send (combat-player w) 
                           clone #:mp (- (send (combat-player w) get-mp) 
                                         (spell-cost (first (send (combat-player w) get-spells)))))
                     (send (combat-npc w) apply-spell (first (send (combat-player w) get-spells)))
                     'pa 'e (spell-animation (first (send (combat-player w) get-spells)))
                     (combat-dungeon-name w) (combat-room-name w))) w)]
           [(and (> (length (send (combat-player w) get-spells)) 1) (key=? k "2"))
            (if (>= (send (combat-player w) get-mp) (spell-cost (second (send (combat-player w) get-spells))))
                (if (eq? (spell-target (second (send (combat-player w) get-spells))) 'player)
                    (make-combat 
                     (send (send (combat-player w) 
                                 clone #:mp (- (send (combat-player w) get-mp) 
                                               (spell-cost (second (send (combat-player w) get-spells)))))
                           apply-spell (second (send (combat-player w) get-spells)))
                     (combat-npc w) 'pa 'e (spell-animation (second (send (combat-player w) get-spells)))
                     (combat-dungeon-name w) (combat-room-name w))
                    (make-combat 
                     (send (combat-player w) 
                           clone #:mp (- (send (combat-player w) get-mp) 
                                         (spell-cost (second (send (combat-player w) get-spells)))))
                     (send (combat-npc w) apply-spell (second (send (combat-player w) get-spells)))
                     'pa 'e (spell-animation (second (send (combat-player w) get-spells)))
                     (combat-dungeon-name w) (combat-room-name w))) w)]
           [(and (> (length (send (combat-player w) get-spells)) 2) (key=? k "3"))
            (if (>= (send (combat-player w) get-mp) (spell-cost (third (send (combat-player w) get-spells))))
                (if (eq? (spell-target (third (send (combat-player w) get-spells))) 'player)
                    (make-combat 
                     (send (send (combat-player w) 
                                 clone #:mp (- (send (combat-player w) get-mp) 
                                               (spell-cost (third (send (combat-player w) get-spells)))))
                           apply-spell (third (send (combat-player w) get-spells)))
                     (combat-npc w) 'pa 'e (spell-animation (third (send (combat-player w) get-spells)))
                     (combat-dungeon-name w) (combat-room-name w))
                    (make-combat 
                     (send (combat-player w) 
                           clone #:mp (- (send (combat-player w) get-mp) 
                                         (spell-cost (third (send (combat-player w) get-spells)))))
                     (send (combat-npc w) apply-spell (third (send (combat-player w) get-spells)))
                     'pa 'e (spell-animation (third (send (combat-player w) get-spells)))
                     (combat-dungeon-name w) (combat-room-name w))) w)]
           [(and (> (length (send (combat-player w) get-spells)) 3) (or (key=? k "right") (key=? k "d")))
            (make-combat
             (send (combat-player w) 
                   clone #:spells (append (rest (send (combat-player w) get-spells))
                                          (list (first (send (combat-player w) get-spells)))))
             (combat-npc w) 'p 's empty (combat-dungeon-name w) (combat-room-name w))]
           [(and (> (length (send (combat-player w) get-spells)) 3) (or (key=? k "left") (key=? k "a")))
            (make-combat
             (send (combat-player w) 
                   clone #:spells (append (list (first (reverse (send (combat-player w) get-spells))))
                                          (reverse (rest (send (combat-player w) get-spells)))))
             (combat-npc w) 'p 's empty (combat-dungeon-name w) (combat-room-name w))]
           [(or (key=? k "escape") (key=? k "\b"))
            (make-combat (combat-player w)                                                
                         (combat-npc w)
                         'p 'm empty (combat-dungeon-name w) (combat-room-name w))]
           [else w])]
        ;; item menu
        [(symbol=? (combat-menu w) 'i)
         (cond
           [(and (> (length (inventory-consumables (send (combat-player w) get-inventory))) 0) (key=? k "1"))
            (make-combat 
             (send (send (combat-player w) clone #:character-inventory
                         (make-inventory
                          (inventory-weapon (send (combat-player w) get-inventory))
                          (inventory-equiped (send (combat-player w) get-inventory))
                           (inventory-equipment (send (combat-player w) get-inventory))
                          (if (> (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-number) 1)
                              (cons (new consumable% 
                                         [image (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-image)]
                                         [name (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-name)]
                                         [description (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-description)]
                                         [effect (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-effect)]
                                         [animation (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-animation)]
                                         [number (- (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-number) 1)])
                                    (rest (inventory-consumables (send (combat-player w) get-inventory))))
                              (rest (inventory-consumables (send (combat-player w) get-inventory))))
                          (inventory-miscellaneous (send (combat-player w) get-inventory))))
                   use-consumable (first (inventory-consumables (send (combat-player w) get-inventory))))
             (combat-npc w) 'pa 'e (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-animation)
             (combat-dungeon-name w) (combat-room-name w))]
           [(and (> (length (inventory-consumables (send (combat-player w) get-inventory))) 1) (key=? k "2"))
            (make-combat 
             (send (send (combat-player w) clone #:character-inventory
                         (make-inventory
                          (inventory-weapon (send (combat-player w) get-inventory))
                          (inventory-equiped (send (combat-player w) get-inventory))
                          (inventory-equipment (send (combat-player w) get-inventory))
                          (if (> (send (second (inventory-consumables (send (combat-player w) get-inventory))) get-number) 1)
                              (append
                               (list (first (inventory-consumables (send (combat-player w) get-inventory)))
                                     (new consumable% 
                                          [image (send (second (inventory-consumables (send (combat-player w) get-inventory))) get-image)]
                                          [name (send (second (inventory-consumables (send (combat-player w) get-inventory))) get-name)]
                                          [description (send (second (inventory-consumables (send (combat-player w) get-inventory))) get-description)]
                                          [effect (send (second (inventory-consumables (send (combat-player w) get-inventory))) get-effect)]
                                          [animation (send (second (inventory-consumables (send (combat-player w) get-inventory))) get-animation)]
                                          [number (- (send (second (inventory-consumables (send (combat-player w) get-inventory))) get-number) 1)]))
                               (rest (rest (inventory-consumables (send (combat-player w) get-inventory)))))
                              (cons (first (inventory-consumables (send (combat-player w) get-inventory))) 
                                    (rest (rest (inventory-consumables (send (combat-player w) get-inventory))))))
                          (inventory-miscellaneous (send (combat-player w) get-inventory))))
                   use-consumable (second (inventory-consumables (send (combat-player w) get-inventory))))
             (combat-npc w) 'pa 'e (send (second (inventory-consumables (send (combat-player w) get-inventory))) get-animation)
             (combat-dungeon-name w) (combat-room-name w))]
           [(and (> (length (inventory-consumables (send (combat-player w) get-inventory))) 2) (key=? k "3"))
            (make-combat 
             (send (send (combat-player w) clone #:character-inventory
                         (make-inventory
                          (inventory-weapon (send (combat-player w) get-inventory))
                          (inventory-equiped (send (combat-player w) get-inventory))
                           (inventory-equipment (send (combat-player w) get-inventory))
                          (if (> (send (third (inventory-consumables (send (combat-player w) get-inventory))) get-number) 1)
                              (append
                               (list (first (inventory-consumables (send (combat-player w) get-inventory)))
                                     (second (inventory-consumables (send (combat-player w) get-inventory)))
                                     (new consumable% 
                                          [image (send (third (inventory-consumables (send (combat-player w) get-inventory))) get-image)]
                                          [name (send (third (inventory-consumables (send (combat-player w) get-inventory))) get-name)]
                                          [description (send (third (inventory-consumables (send (combat-player w) get-inventory))) get-description)]
                                          [effect (send (third (inventory-consumables (send (combat-player w) get-inventory))) get-effect)]
                                          [animation (send (third (inventory-consumables (send (combat-player w) get-inventory))) get-animation)]
                                          [number (- (send (third (inventory-consumables (send (combat-player w) get-inventory))) get-number) 1)]))
                               (rest (rest (rest (inventory-consumables (send (combat-player w) get-inventory))))))
                              (append (list (first (inventory-consumables (send (combat-player w) get-inventory)))
                                            (second (inventory-consumables (send (combat-player w) get-inventory))))
                                      (rest (rest (rest (inventory-consumables (send (combat-player w) get-inventory)))))))
                          (inventory-miscellaneous (send (combat-player w) get-inventory))))
                   use-consumable (third (inventory-consumables (send (combat-player w) get-inventory))))
             (combat-npc w) 'pa 'e (send (third (inventory-consumables (send (combat-player w) get-inventory))) get-animation)
             (combat-dungeon-name w) (combat-room-name w))]
           [(and (> (length (inventory-consumables (send (combat-player w) get-inventory))) 3) (or (key=? k "right") (key=? k "d")))
            (make-combat
             (send (combat-player w) 
                   clone #:character-inventory
                   (make-inventory
                    (inventory-weapon (send (combat-player w) get-inventory))
                    (inventory-equiped (send (combat-player w) get-inventory))
                     (inventory-equipment (send (combat-player w) get-inventory))
                    (append (rest (inventory-consumables (send (combat-player w) get-inventory)))
                            (list (first (inventory-consumables (send (combat-player w) get-inventory)))))
                    (inventory-miscellaneous (send (combat-player w) get-inventory))))
             (combat-npc w) 'p 'i empty (combat-dungeon-name w) (combat-room-name w))]
           [(and (> (length (inventory-consumables (send (combat-player w) get-inventory))) 3) (or (key=? k "left") (key=? k "a")))
            (make-combat
             (send (combat-player w) 
                   clone #:character-inventory
                   (make-inventory
                    (inventory-weapon (send (combat-player w) get-inventory))
                    (inventory-equiped (send (combat-player w) get-inventory))
                     (inventory-equipment (send (combat-player w) get-inventory))
                    (append (list (first (reverse (inventory-consumables (send (combat-player w) get-inventory)))))
                            (reverse (rest (reverse (inventory-consumables (send (combat-player w) get-inventory))))))
                    (inventory-miscellaneous (send (combat-player w) get-inventory))))
             (combat-npc w) 'p 'i empty (combat-dungeon-name w) (combat-room-name w))]
           [(or (key=? k "escape") (key=? k "\b"))
            (make-combat (combat-player w)                                                
                         (combat-npc w)
                         'p 'm empty (combat-dungeon-name w) (combat-room-name w))]
           [else w])]) w))

;; handle-dungeon-key : dungeon --> dungeon
(define (handle-dungeon-key d k)
  (cond
    [(send (get-tile (send (dungeon-player d) get-position) (room-tiles (first (dungeon-rooms d)))) portal?)
     (make-dungeon
      (send (dungeon-player d) clone #:position (portal-position (send (get-tile (send (dungeon-player d) get-position) (room-tiles (first (dungeon-rooms d)))) get-portal)))
      (cons (get-room (get-dungeon (portal-dungeon (send (get-tile (send (dungeon-player d) get-position) (room-tiles (first (dungeon-rooms d)))) get-portal)))
                      (portal-room (send (get-tile (send (dungeon-player d) get-position) (room-tiles (first (dungeon-rooms d)))) get-portal)))
            (filter (lambda (x) (not (string=? (room-name x) (portal-room (send (get-tile (send (dungeon-player d) get-position) (room-tiles (first (dungeon-rooms d)))) get-portal)))))
                    (dungeon-rooms (get-dungeon (portal-dungeon (send (get-tile (send (dungeon-player d) get-position) (room-tiles (first (dungeon-rooms d)))) get-portal))))))
      empty
      (portal-dungeon (send (get-tile (send (dungeon-player d) get-position) (room-tiles (first (dungeon-rooms d)))) get-portal)) empty)]
    [(and (not (empty? (dungeon-images d))) (or (key=? k "\r") (key=? k " ")))
     (make-dungeon (dungeon-player d) (dungeon-rooms d) empty (dungeon-name d) empty)]
    [(not (empty? (dungeon-menu d))) (handle-menu-key d k)]
    [(key=? k "escape") (make-dungeon (dungeon-player d) (dungeon-rooms d) empty (dungeon-name d) 'player-info)]
    [(or
      (not (empty? (dungeon-images d)))
      (not (or (key=? k "w") (key=? k "s")
               (key=? k "a") (key=? k "d")))) d]
    [else
     (cond
       [(> (room-encounter-probability (first (dungeon-rooms d))) (random 1000))
        (make-dungeon (dungeon-player d)
                      (dungeon-rooms d)
                      (append
                       (make-list 20 (overlay
                                      (text "An enemy appears!" 30 'black)
                                      (rectangle 810 630 'solid 'gray)))
                       (list (square 1 'solid 'blue))) (dungeon-name d) empty)]
       [(and (key=? k "w") (enough-space-above? d))
        (make-dungeon 
         (send (dungeon-player d) clone #:position 
               (make-posn
                (posn-x (send (dungeon-player d) get-position))
                (- (posn-y (send (dungeon-player d) get-position)) PLAYER-SPEED))
               #:dir 'n)
         (dungeon-rooms d) (dungeon-images d) (dungeon-name d) empty)]
       [(and (key=? k "s") (enough-space-below? d))
        (make-dungeon 
         (send (dungeon-player d) clone #:position 
               (make-posn
                (posn-x (send (dungeon-player d) get-position))
                (+ (posn-y (send (dungeon-player d) get-position)) PLAYER-SPEED))
               #:dir 's)
         (dungeon-rooms d) (dungeon-images d) (dungeon-name d) empty)]
       [(and (key=? k "a") (enough-space-left? d))
        (make-dungeon 
         (send (dungeon-player d) clone #:position 
               (make-posn
                (- (posn-x (send (dungeon-player d) get-position)) PLAYER-SPEED)
                (posn-y (send (dungeon-player d) get-position)))
               #:dir 'w)
         (dungeon-rooms d) (dungeon-images d) (dungeon-name d) empty)]
       [(and (key=? k "d") (enough-space-right? d))
        (make-dungeon 
         (send (dungeon-player d) clone #:position 
               (make-posn
                (+ (posn-x (send (dungeon-player d) get-position)) PLAYER-SPEED)
                (posn-y (send (dungeon-player d) get-position)))
               #:dir 'e)
         (dungeon-rooms d) (dungeon-images d) (dungeon-name d) empty)]
       [else d])]))

;; handle-menu-key : dungeon, keyevent --> dungeon
(define (handle-menu-key d k)
  (cond
    [(key=? k "escape") (make-dungeon (dungeon-player d) (dungeon-rooms d) empty (dungeon-name d) empty)]
    [(symbol=? (dungeon-menu d) 'player-info) (cond [(key=? k "right") (make-dungeon
                                                                        (dungeon-player d)
                                                                        (dungeon-rooms d)
                                                                        empty
                                                                        (dungeon-name d)
                                                                        'items)]
                                                    [(key=? k "left") (make-dungeon
                                                                       (dungeon-player d)
                                                                       (dungeon-rooms d)
                                                                       empty
                                                                       (dungeon-name d)
                                                                       'spells)]
                                                    [else d])]
    [(symbol=? (dungeon-menu d) 'items) (cond [(key=? k "right") (make-dungeon
                                                                  (dungeon-player d)
                                                                  (dungeon-rooms d)
                                                                  empty
                                                                  (dungeon-name d)
                                                                  'equipment)]
                                              [(key=? k "left") (make-dungeon
                                                                 (dungeon-player d)
                                                                 (dungeon-rooms d)
                                                                 empty
                                                                 (dungeon-name d)
                                                                 'player-info)]
                                              [else d])]
    [(symbol=? (dungeon-menu d) 'equipment) (cond [(key=? k "right") (make-dungeon
                                                                      (dungeon-player d)
                                                                      (dungeon-rooms d)
                                                                      empty
                                                                      (dungeon-name d)
                                                                      'spells)]
                                                  [(key=? k "left") (make-dungeon
                                                                     (dungeon-player d)
                                                                     (dungeon-rooms d)
                                                                     empty
                                                                     (dungeon-name d)
                                                                     'items)]
                                                  [else d])]
    [(symbol=? (dungeon-menu d) 'spells) (cond [(key=? k "right") (make-dungeon
                                                                   (dungeon-player d)
                                                                   (dungeon-rooms d)
                                                                   empty
                                                                   (dungeon-name d)
                                                                   'player-info)]
                                               [(key=? k "left") (make-dungeon
                                                                  (dungeon-player d)
                                                                  (dungeon-rooms d)
                                                                  empty
                                                                  (dungeon-name d)
                                                                  'equipment)]
                                               [else d])]
    [else d]))

;; enough-space-above? : dungeon --> boolean
(define (enough-space-above? d) 
  (not
   (or (>= (/ (image-height (map-animation-north-stationary 
                             (send (dungeon-player d) get-map-animation))) 2)
           (posn-y (send (dungeon-player d) get-position))) 
       (not 
        (send (get-tile (make-posn (posn-x (send (dungeon-player d) get-position))
                                   (- (posn-y (send (dungeon-player d) get-position))
                                      (/ (image-height 
                                          (map-animation-east-stationary 
                                           (send (dungeon-player d) get-map-animation))) 2)))
                        (room-tiles (first (dungeon-rooms d)))) passable?)))))

;; get-tile : posn lolot --> tile
(define (get-tile p l)
  (list-ref 
   (list-ref l (round-down (/ (posn-y p) (image-height (send (first (first l)) get-image)))))
   (round-down (/ (posn-x p) (image-width (send (first (first l)) get-image))))))

;; round-down
(define (round-down n)
  (cond
    [(> 1 n) 0]
    [else (+ 1 (round-down (- n 1)))]))

;; enough-space-below? : dungeon --> boolean
(define (enough-space-below? d)
  (not
   (or (<= (- (* (image-height (send (first (first (room-tiles (first (dungeon-rooms d))))) get-image))
                 (length (room-tiles (first (dungeon-rooms d)))))
              (/ (image-height (map-animation-south-stationary (send (dungeon-player d) get-map-animation))) 2))
           (posn-y (send (dungeon-player d) get-position))) 
       (not (send (get-tile 
                   (make-posn (posn-x (send (dungeon-player d) get-position)) 
                              (+ (posn-y (send (dungeon-player d) get-position))
                                 (/ (image-height (map-animation-east-stationary 
                                                   (send (dungeon-player d) get-map-animation))) 2)))
                   (room-tiles (first (dungeon-rooms d)))) passable?)))))

;; enough-space-left? : dungeon --> boolean
(define (enough-space-left? d)
  (not
   (or (>= (/ (image-width (map-animation-west-stationary 
                            (send (dungeon-player d) get-map-animation))) 2)
           (posn-x (send (dungeon-player d) get-position))) 
       (not 
        (send (get-tile 
               (make-posn (- (posn-x (send (dungeon-player d) get-position))
                             (/ (image-width 
                                 (map-animation-west-stationary 
                                  (send (dungeon-player d) get-map-animation))) 2))
                          (posn-y (send (dungeon-player d) get-position)))
               (room-tiles (first (dungeon-rooms d)))) passable?)))))

;; enough-space-right? : dungeon --> boolean
(define (enough-space-right? d)
  (not
   (or (<= (- (* (image-width (send (first (first (room-tiles (first (dungeon-rooms d))))) get-image))
                 (length (first (room-tiles (first (dungeon-rooms d))))))
              (/ (image-width (map-animation-east-stationary (send (dungeon-player d) get-map-animation))) 2))
           (posn-x (send (dungeon-player d) get-position))) 
       (not (send (get-tile (make-posn (+ (posn-x (send (dungeon-player d) get-position))
                                          (/ (image-width (map-animation-east-stationary 
                                                           (send (dungeon-player d) get-map-animation))) 2))
                                       (posn-y (send (dungeon-player d) get-position)))
                            (room-tiles (first (dungeon-rooms d)))) passable?)))))

;; MAIN -------------------------------------------------------------------------------------------------------------------------

(define (main w)
  (big-bang w
            [to-draw render]
            [on-tick tock]
            [on-key handle-key]))

;; run
(main (overlay (above (text "The General's Labyrinth" 50 'black) (text "Press Enter to play" 30 'black)) (rectangle 810 630 'solid 'gray)))
