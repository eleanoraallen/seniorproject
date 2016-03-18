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
    [(and (symbol? m) (symbol=? m 'player-info))
     (overlay (beside (overlay/align "middle" "bottom" 
                                     (overlay (text "Player Data" 20 'black)
                                              (rectangle 197 50 'solid 'gray))
                                     (rectangle 202 55 'solid 'black))
                      (overlay (text "Items" 20 'black)
                               (rectangle 197 45 'solid (make-color 80 80 80))
                               (rectangle 202 55 'solid 'black))
                      (overlay (text "Equipment" 20 'black)
                               (rectangle 197 45 'solid (make-color 80 80 80))
                               (rectangle 202 55 'solid 'black))
                      (overlay (text "Spells" 20 'black)
                               (rectangle 197 45 'solid (make-color 80 80 80))
                               (rectangle 202 55 'solid 'black)))
              (rectangle 810 55 'solid 'black))]
    [(and (symbol? m) (symbol=? m 'items))
     (overlay (beside (overlay (text "Player Data" 20 'black)
                               (rectangle 197 45 'solid (make-color 80 80 80))
                               (rectangle 202 55 'solid 'black))
                      (overlay/align "middle" "bottom" 
                                     (overlay (text "Items" 20 'black)
                                              (rectangle 197 50 'solid 'gray))
                                     (rectangle 202 55 'solid 'black))
                      (overlay (text "Equipment" 20 'black)
                               (rectangle 197 45 'solid (make-color 80 80 80))
                               (rectangle 202 55 'solid 'black))
                      (overlay (text "Spells" 20 'black)
                               (rectangle 197 45 'solid (make-color 80 80 80))
                               (rectangle 202 55 'solid 'black)))
              (rectangle 810 55 'solid 'black))]
    [(list? m)
     (overlay (beside (overlay (text "Player Data" 20 'black)
                               (rectangle 197 45 'solid (make-color 80 80 80))
                               (rectangle 202 55 'solid 'black))
                      (overlay (text "Items" 20 'black)
                               (rectangle 197 45 'solid (make-color 80 80 80))
                               (rectangle 202 55 'solid 'black))
                      (overlay/align "middle" "bottom" 
                                     (overlay (text "Equipment" 20 'black)
                                              (rectangle 197 50 'solid 'gray))
                                     (rectangle 202 55 'solid 'black))
                      (overlay (text "Spells" 20 'black)
                               (rectangle 197 45 'solid (make-color 80 80 80))
                               (rectangle 202 55 'solid 'black)))
              (rectangle 810 55 'solid 'black))]
    [(and (symbol? m) (symbol=? m 'spells))
     (overlay (beside (overlay (text "Player Data" 20 'black)
                               (rectangle 197 45 'solid (make-color 80 80 80))
                               (rectangle 202 55 'solid 'black))
                      (overlay (text "Items" 20 'black)
                               (rectangle 197 45 'solid (make-color 80 80 80))
                               (rectangle 202 55 'solid 'black))
                      (overlay (text "Equipment" 20 'black)
                               (rectangle 197 45 'solid (make-color 80 80 80))
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
    [(and (symbol? (dungeon-menu d)) (symbol=? (dungeon-menu d) 'player-info))
     (overlay/align "left" "top"
                    (beside (rectangle 40 0 'solid 'red)
                            (above (rectangle 0 30 'solid 'blue)
                                   (beside/align "top"
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
                                                 (rectangle 120 0 'solid 'black)
                                                 (above/align "left"
                                                              (rectangle 0 32 'solid 'black)
                                                              (text (string-append "Location: " (dungeon-name d)) 20 'black)
                                                              (rectangle 0 20 'solid 'black)
                                                              (text (string-append "Gold: " 
                                                                                   (number->string 
                                                                                    (send (first 
                                                                                           (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                   (inventory-miscellaneous (send (dungeon-player d) get-inventory))))
                                                                                          get-number))) 20 'black)
                                                              (rectangle 0 20 'solid 'black)
                                                              (text (string-append "Items: " (number->string
                                                                                              (+ (item-number (inventory-consumables (send (dungeon-player d) get-inventory)))
                                                                                                 (length (filter (lambda (x) (not (string=? (send x get-name) "Gold"))) 
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
    [(and (symbol? (dungeon-menu d)) (symbol=? (dungeon-menu d) 'items))
     (overlay/align "left" "top"
                    (above (rectangle 0 40 'solid 'pink)
                           (beside
                            (rectangle 28 0 'solid 'pink)
                            (above (if (>= (length (inventory-consumables (send (dungeon-player d) get-inventory))) 5)
                                       (beside (rotate 180 (triangle 15 'solid 'black))
                                               (rectangle 7 0 'solid 'pink) 
                                               (text "Consumables" 25 'black) 
                                               (rectangle 7 0 'solid 'pink) 
                                               (triangle 15 'solid 'black))
                                       (text "Consumables" 25 'black))
                                   (rectangle 0 15 'solid 'black)
                                   (if (>= (length (inventory-consumables (send (dungeon-player d) get-inventory))) 1)
                                       (overlay
                                        (overlay/align "left" "middle"
                                                       (beside 
                                                        (rectangle 5 0 'solid 'pink)
                                                        (text "1:" 20 'black)
                                                        (rectangle 10 0 'solid 'pink)
                                                        (send (first (inventory-consumables (send (dungeon-player d) get-inventory))) get-image))
                                                       (place-image
                                                        (above (text (string-append (send (first (inventory-consumables (send (dungeon-player d) get-inventory))) get-name) ": "
                                                                                    (number->string (send (first (inventory-consumables (send (dungeon-player d) get-inventory))) get-number))) 18 'black)
                                                               (text (send (first (inventory-consumables (send (dungeon-player d) get-inventory))) get-description) 15 'black))
                                                        208 45
                                                        (rectangle 340 90 'solid (make-color 90 90 90))))
                                        (rectangle 350 100 'solid 'black))
                                       (overlay
                                        (text "empty" 20 'black)
                                        (rectangle 340 90 'solid (make-color 90 90 90))
                                        (rectangle 350 100 'solid 'black)))
                                   (rectangle 0 15 'solid 'black)
                                   (if (>= (length (inventory-consumables (send (dungeon-player d) get-inventory))) 2)
                                       (overlay
                                        (overlay/align "left" "middle"
                                                       (beside 
                                                        (rectangle 5 0 'solid 'pink)
                                                        (text "2:" 20 'black)
                                                        (rectangle 10 0 'solid 'pink)
                                                        (send (second (inventory-consumables (send (dungeon-player d) get-inventory))) get-image))
                                                       (place-image
                                                        (above (text (string-append (send (second (inventory-consumables (send (dungeon-player d) get-inventory))) get-name) ": "
                                                                                    (number->string (send (second (inventory-consumables (send (dungeon-player d) get-inventory))) get-number))) 18 'black)
                                                               (text (send (second (inventory-consumables (send (dungeon-player d) get-inventory))) get-description) 15 'black))
                                                        208 45
                                                        (rectangle 340 90 'solid (make-color 90 90 90))))
                                        (rectangle 350 100 'solid 'black))
                                       (square 0 'solid 'pink))
                                   (rectangle 0 15 'solid 'black)
                                   (if (>= (length (inventory-consumables (send (dungeon-player d) get-inventory))) 3)
                                       (overlay
                                        (overlay/align "left" "middle"
                                                       (beside 
                                                        (rectangle 5 0 'solid 'pink)
                                                        (text "3:" 20 'black)
                                                        (rectangle 10 0 'solid 'pink)
                                                        (send (third (inventory-consumables (send (dungeon-player d) get-inventory))) get-image))
                                                       (place-image
                                                        (above (text (string-append (send (third (inventory-consumables (send (dungeon-player d) get-inventory))) get-name) ": "
                                                                                    (number->string (send (third (inventory-consumables (send (dungeon-player d) get-inventory))) get-number))) 18 'black)
                                                               (text (send (third (inventory-consumables (send (dungeon-player d) get-inventory))) get-description) 15 'black))
                                                        208 45
                                                        (rectangle 340 90 'solid (make-color 90 90 90))))
                                        (rectangle 350 100 'solid 'black))
                                       (square 0 'solid 'pink))
                                   (rectangle 0 15 'solid 'black)
                                   (if (>= (length (inventory-consumables (send (dungeon-player d) get-inventory))) 4)
                                       (overlay
                                        (overlay/align "left" "middle"
                                                       (beside 
                                                        (rectangle 5 0 'solid 'pink)
                                                        (text "4:" 20 'black)
                                                        (rectangle 10 0 'solid 'pink)
                                                        (send (fourth (inventory-consumables (send (dungeon-player d) get-inventory))) get-image))
                                                       (place-image
                                                        (above (text (string-append (send (fourth (inventory-consumables (send (dungeon-player d) get-inventory))) get-name) ": "
                                                                                    (number->string (send (fourth (inventory-consumables (send (dungeon-player d) get-inventory))) get-number))) 18 'black)
                                                               (text (send (fourth (inventory-consumables (send (dungeon-player d) get-inventory))) get-description) 15 'black))
                                                        208 45
                                                        (rectangle 340 90 'solid (make-color 90 90 90))))
                                        (rectangle 350 100 'solid 'black))
                                       (square 0 'solid 'pink)))))
                    (overlay/align "right" "top"
                                   (above (rectangle 0 40 'solid 'pink)
                                          (beside
                                           (above (if (>= (length (inventory-miscellaneous (send (dungeon-player d) get-inventory))) 5)
                                                      (beside (rotate 180 (triangle 15 'solid 'black))
                                                              (rectangle 7 0 'solid 'pink) 
                                                              (text "Miscellaneous" 25 'black) 
                                                              (rectangle 7 0 'solid 'pink) 
                                                              (triangle 15 'solid 'black))
                                                      (text "Miscellaneous" 25 'black))
                                                  (rectangle 0 15 'solid 'black)
                                                  (if (and (>= (length (inventory-miscellaneous (send (dungeon-player d) get-inventory))) 1)
                                                           (or (not (string=? (send (first (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-name) "Gold"))
                                                               (> (send (first (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-number) 0)))
                                                      (overlay
                                                       (overlay/align "left" "middle"
                                                                      (beside 
                                                                       (rectangle 5 0 'solid 'pink)
                                                                       (rectangle 10 0 'solid 'pink)
                                                                       (send (first (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-image))
                                                                      (place-image
                                                                       (above (text (send (first (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-name) 18 'black)
                                                                              (text (send (first (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-description) 15 'black))
                                                                       208 45
                                                                       (rectangle 340 90 'solid (make-color 80 80 80))))
                                                       (rectangle 350 100 'solid 'black))
                                                      (if (>= (length (inventory-miscellaneous (send (dungeon-player d) get-inventory))) 2)
                                                          (square 0 'solid 'pink)
                                                          (overlay
                                                           (text "empty" 20 'black)
                                                           (rectangle 340 90 'solid (make-color 80 80 80))
                                                           (rectangle 350 100 'solid 'black))))
                                                  (rectangle 0 15 'solid 'black)
                                                  (if (and (>= (length (inventory-miscellaneous (send (dungeon-player d) get-inventory))) 2)
                                                           (or (not (string=? (send (second (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-name) "Gold"))
                                                               (> (send (second (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-number) 0)))
                                                      (overlay
                                                       (overlay/align "left" "middle"
                                                                      (beside 
                                                                       (rectangle 5 0 'solid 'pink)
                                                                       (rectangle 10 0 'solid 'pink)
                                                                       (send (second (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-image))
                                                                      (place-image
                                                                       (above (text (send (second (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-name) 18 'black)
                                                                              (text (send (second (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-description) 15 'black))
                                                                       208 45
                                                                       (rectangle 340 90 'solid (make-color 80 80 80))))
                                                       (rectangle 350 100 'solid 'black))
                                                      (square 0 'solid 'pink))
                                                  (rectangle 0 15 'solid 'black)
                                                  (if (and (>= (length (inventory-miscellaneous (send (dungeon-player d) get-inventory))) 3)
                                                           (or (not (string=? (send (third (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-name) "Gold"))
                                                               (> (send (third (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-number) 0)))
                                                      (overlay
                                                       (overlay/align "left" "middle"
                                                                      (beside 
                                                                       (rectangle 5 0 'solid 'pink)
                                                                       (rectangle 10 0 'solid 'pink)
                                                                       (send (third (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-image))
                                                                      (place-image
                                                                       (above (text (send (third (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-name) 18 'black)
                                                                              (text (send (third (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-description) 15 'black))
                                                                       208 45
                                                                       (rectangle 340 90 'solid (make-color 80 80 80))))
                                                       (rectangle 350 100 'solid 'black))
                                                      (square 0 'solid 'pink))
                                                  (rectangle 0 15 'solid 'black)
                                                  (if (and (>= (length (inventory-miscellaneous (send (dungeon-player d) get-inventory))) 4)
                                                           (or (not (string=? (send (fourth (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-name) "Gold"))
                                                               (> (send (fourth (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-number) 0)))
                                                      (overlay
                                                       (overlay/align "left" "middle"
                                                                      (beside 
                                                                       (rectangle 5 0 'solid 'pink)
                                                                       (rectangle 10 0 'solid 'pink)
                                                                       (send (fourth (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-image))
                                                                      (place-image
                                                                       (above (text (send (fourth (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-name) 18 'black)
                                                                              (text (send (fourth (inventory-miscellaneous (send (dungeon-player d) get-inventory))) get-description) 15 'black))
                                                                       208 45
                                                                       (rectangle 340 90 'solid (make-color 80 80 80))))
                                                       (rectangle 350 100 'solid 'black))
                                                      (square 0 'solid 'pink)))
                                           (rectangle 28 0 'solid 'pink)))
                                   (overlay/align "middle" "top"
                                                  (rectangle 802 570 'solid 'gray) 
                                                  (rectangle 810 575 'solid 'black))))]
    [(and (list? (dungeon-menu d)) (not (empty? (dungeon-menu d))))
     (overlay/align "middle" "top"
                            (above
                                         (rectangle 0 20 'solid 'pink)
                                         (above (text (string-append (send (dungeon-player d) get-name) ":") 25 'black)
                                         (beside (text (string-append "Attack: " (number->string (send (dungeon-player d) get-strength)) " + ") 20 'black)
                                                 (text (if 
                                                        (empty? (inventory-weapon (send (dungeon-player d) get-inventory))) 
                                                        "0" (number->string (send (inventory-weapon (send (dungeon-player d) get-inventory)) get-damage)))
                                                       20 (if (symbol=? (first (dungeon-menu d)) 'w) 'red 'black))
                                                 (text (string-append " = "
                                                                      (number->string (+ (send (dungeon-player d) get-strength)
                                                                                         (if (empty? (inventory-weapon (send (dungeon-player d) get-inventory)))
                                                                                             0
                                                                                             (send (inventory-weapon (send (dungeon-player d) get-inventory)) get-damage))))
                                                                      " (" (if (or (empty? (inventory-weapon (send (dungeon-player d) get-inventory)))
                                                                                   (symbol=? (send (inventory-weapon (send (dungeon-player d) get-inventory)) get-type) 'none))
                                                                               "no type"
                                                                               (symbol->string (send (inventory-weapon (send (dungeon-player d) get-inventory)) get-type)))
                                                                      ")") 20 'black))
                                         (beside (text (string-append "Defense: " (number->string (send (dungeon-player d) get-strength)) " + ") 20 'black)
                                                 (text (number->string (get-armor-defense (inventory-equiped (send (dungeon-player d) get-inventory)))) 20 (if (symbol=? (first (dungeon-menu d)) 'w) 'black 'red))
                                                 (text (string-append " = " (number->string (+ (send (dungeon-player d) get-strength)
                                                                                               (get-armor-defense (inventory-equiped (send (dungeon-player d) get-inventory)))))) 20 'black)))
                                         (rectangle 0 50 'solid 'pink)
                                         (beside/align "top"
                                          (above
                                         (text (string-append "Equiped " (cond
                                                                           [(symbol=? (first (dungeon-menu d)) 'w) "Weapon"]
                                                                           [(symbol=? (first (dungeon-menu d)) 'h) "Helment"]
                                                                           [(symbol=? (first (dungeon-menu d)) 'b) "Body Armor"]
                                                                           [(symbol=? (first (dungeon-menu d)) 'a) "Arm Armor"]
                                                                           [(symbol=? (first (dungeon-menu d)) 'l) "Leg Armor"]) ":") 20 'black)
                                         (rectangle 0 30 'solid 'pink)
                                         (cond
                                           [(symbol=? (first (dungeon-menu d)) 'w) (if (empty? (inventory-weapon (send (dungeon-player d) get-inventory)))
                                                                                       (text "No weapon equiped" 20 'black)
                                                                                       (render-weapon-block
                                                                                    (inventory-weapon (send (dungeon-player d) get-inventory))))]
                                           [(symbol=? (first (dungeon-menu d)) 'h) (if (empty? (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'h))
                                                                                       (text "No helmet equiped" 20 'black)
                                                                                       (render-equipment-block
                                                                                    (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'h))))]
                                           [(symbol=? (first (dungeon-menu d)) 'b) (if (empty? (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'b))
                                                                                       (text "No body armor equiped" 20 'black)
                                                                                       (render-equipment-block
                                                                                    (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'b))))]
                                           [(symbol=? (first (dungeon-menu d)) 'a) (if (empty? (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'a))
                                                                                       (text "No arm armor equiped" 20 'black)
                                                                                       (render-equipment-block
                                                                                    (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'a))))]
                                           [(symbol=? (first (dungeon-menu d)) 'l) (if (empty? (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'l))
                                                                                       (text "No leg armor equiped" 20 'black)
                                                                                       (render-equipment-block
                                                                                    (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'l))))]))
                                          (rectangle 25 0 'solid 'pink)
                            (above
                             (beside
                              (if (or (and (symbol=? (first (dungeon-menu d)) 'w) (> (length (first (inventory-equipment (send (dungeon-player d) get-inventory)))) 3))
                                      (and (symbol=? (first (dungeon-menu d)) 'h) (> (length (second (inventory-equipment (send (dungeon-player d) get-inventory)))) 3))
                                      (and (symbol=? (first (dungeon-menu d)) 'b) (> (length (third (inventory-equipment (send (dungeon-player d) get-inventory)))) 3))
                                      (and (symbol=? (first (dungeon-menu d)) 'a) (> (length (fourth (inventory-equipment (send (dungeon-player d) get-inventory)))) 3))
                                      (and (symbol=? (first (dungeon-menu d)) 'l) (> (length (fifth (inventory-equipment (send (dungeon-player d) get-inventory)))) 3)))
                                  (beside (triangle 15 'solid 'black) (rectangle 3 0 'solid 'pink)) (square 0 'solid 'pink))
                              (text (string-append "Available " (cond
                                                                           [(symbol=? (first (dungeon-menu d)) 'w) "Weapons"]
                                                                           [(symbol=? (first (dungeon-menu d)) 'h) "Helments"]
                                                                           [(symbol=? (first (dungeon-menu d)) 'b) "Body Armor"]
                                                                           [(symbol=? (first (dungeon-menu d)) 'a) "Arm Armor"]
                                                                           [(symbol=? (first (dungeon-menu d)) 'l) "Leg Armor"]) ":") 20 'black)
                              (if (or (and (symbol=? (first (dungeon-menu d)) 'w) (> (length (first (inventory-equipment (send (dungeon-player d) get-inventory)))) 3))
                                      (and (symbol=? (first (dungeon-menu d)) 'h) (> (length (second (inventory-equipment (send (dungeon-player d) get-inventory)))) 3))
                                      (and (symbol=? (first (dungeon-menu d)) 'b) (> (length (third (inventory-equipment (send (dungeon-player d) get-inventory)))) 3))
                                      (and (symbol=? (first (dungeon-menu d)) 'a) (> (length (fourth (inventory-equipment (send (dungeon-player d) get-inventory)))) 3))
                                      (and (symbol=? (first (dungeon-menu d)) 'l) (> (length (fifth (inventory-equipment (send (dungeon-player d) get-inventory)))) 3)))
                                  (beside (rectangle 3 0 'solid 'pink) (rotate 180 (triangle 15 'solid 'black))) (square 0 'solid 'pink)))
                             (rectangle 0 30 'solid 'pink)
                                                  (cond
                              [(symbol=? (first (dungeon-menu d)) 'w) (above
                                                                        (if (<= 1 (length (first (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (render-weapon-block (first (first (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (overlay (text "No Weapons!" 20 'black) (rectangle 350 100 'solid 'gray)))
                                                                        (rectangle 0 25 'solid 'pink)
                                                                        (if (<= 2 (length (first (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (render-weapon-block (second (first (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (square 0 'solid 'pink))
                                                                        (rectangle 0 25 'solid 'pink)
                                                                        (if (<= 3 (length (first (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (render-weapon-block (third (first (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (square 0 'solid 'pink)))]
                              [(symbol=? (first (dungeon-menu d)) 'h) (above
                                                                        (if (<= 1 (length (second (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (render-equipment-block (first (second (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (overlay (text "No Head Armor!" 20 'black) (rectangle 350 100 'solid 'gray)))
                                                                        (rectangle 0 25 'solid 'pink)
                                                                        (if (<= 2 (length (second (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (render-equipment-block (second (second (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (square 0 'solid 'pink))
                                                                        (rectangle 0 25 'solid 'pink)
                                                                        (if (<= 3 (length (second (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (render-equipment-block (third (second (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (square 0 'solid 'pink)))]
                              [(symbol=? (first (dungeon-menu d)) 'b) (above
                                                                        (if (<= 1 (length (third (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (render-equipment-block (first (third (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (overlay (text "No Body Armor!" 20 'black) (rectangle 350 100 'solid 'gray)))
                                                                        (rectangle 0 25 'solid 'pink)
                                                                        (if (<= 2 (length (third (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (render-equipment-block (second (third (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (square 0 'solid 'pink))
                                                                        (rectangle 0 25 'solid 'pink)
                                                                        (if (<= 3 (length (third (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (render-equipment-block (third (third (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (square 0 'solid 'pink)))]
                              [(symbol=? (first (dungeon-menu d)) 'a) (above
                                                                        (if (<= 1 (length (fourth (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (render-equipment-block (first (fourth (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (overlay (text "No Arm Armor!" 20 'black) (rectangle 350 100 'solid 'gray)))
                                                                        (rectangle 0 25 'solid 'pink)
                                                                        (if (<= 2 (length (fourth (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (render-equipment-block (second (fourth (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (square 0 'solid 'pink))
                                                                        (rectangle 0 25 'solid 'pink)
                                                                        (if (<= 3 (length (fourth (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (render-equipment-block (third (fourth (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (square 0 'solid 'pink)))]
                              [(symbol=? (first (dungeon-menu d)) 'l) (above
                                                                        (if (<= 1 (length (fifth (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (render-equipment-block (first (fifth (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (overlay (text "No Leg Armor!" 20 'black) (rectangle 350 100 'solid 'gray)))
                                                                        (rectangle 0 25 'solid 'pink)
                                                                        (if (<= 2 (length (fifth (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (render-equipment-block (second (fifth (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (square 0 'solid 'pink))
                                                                        (rectangle 0 25 'solid 'pink)
                                                                        (if (<= 3 (length (fifth (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (render-equipment-block (third (fifth (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                            (square 0 'solid 'pink)))]))))                         
                    (overlay/align "middle" "top"
                                   (rectangle 802 570 'solid 'gray)
                                   (rectangle 810 575 'solid 'black)))]                                   
    [(and (symbol? (dungeon-menu d)) (symbol=? (dungeon-menu d) 'spells))
     (overlay
      (above
       (beside
        (if (>= (length (send (dungeon-player d) get-spells)) 1)
            (overlay/align "left" "middle"
                           (beside 
                            (rectangle 5 0 'solid 'pink)
                            (rectangle 10 0 'solid 'pink)
                            (spell-image (first (send (dungeon-player d) get-spells)))
                            (rectangle 30 0 'solid 'pink)
                            (above/align "left" (text (spell-name (first (send (dungeon-player d) get-spells))) 18 'black)
                                         (text (string-append "MP cost:" (number->string (spell-cost (first (send (dungeon-player d) get-spells))))) 18 'black)
                                         (text (spell-discription (first (send (dungeon-player d) get-spells))) 15 'black)))
                           (overlay
                            (rectangle 340 90 'solid (make-color 80 80 80))
                            (rectangle 350 100 'solid 'black)))
            (text "No Spells Known!" 40 'black))
        (rectangle 30 0 'solid 'black)
        (if (>= (length (send (dungeon-player d) get-spells)) 2)
            (overlay/align "left" "middle"
                           (beside 
                            (rectangle 5 0 'solid 'pink)
                            (rectangle 10 0 'solid 'pink)
                            (spell-image (second (send (dungeon-player d) get-spells)))
                            (rectangle 30 0 'solid 'pink)
                            (above/align "left" (text (spell-name (second (send (dungeon-player d) get-spells))) 18 'black)
                                         (text (string-append "MP cost:" (number->string (spell-cost (second (send (dungeon-player d) get-spells))))) 18 'black)
                                         (text (spell-discription (second (send (dungeon-player d) get-spells))) 15 'black)))
                           (overlay
                            (rectangle 340 90 'solid (make-color 80 80 80))
                            (rectangle 350 100 'solid 'black)))
            (square 0 'solid 'pink)))
       (rectangle 0 20 'solid 'black)
       (beside
        (if (>= (length (send (dungeon-player d) get-spells)) 3)
            (overlay/align "left" "middle"
                           (beside 
                            (rectangle 5 0 'solid 'pink)
                            (rectangle 10 0 'solid 'pink)
                            (spell-image (third (send (dungeon-player d) get-spells)))
                            (rectangle 30 0 'solid 'pink)
                            (above/align "left" (text (spell-name (third (send (dungeon-player d) get-spells))) 18 'black)
                                         (text (string-append "MP cost:" (number->string (spell-cost (third (send (dungeon-player d) get-spells))))) 18 'black)
                                         (text (spell-discription (third (send (dungeon-player d) get-spells))) 15 'black)))
                           (overlay
                            (rectangle 340 90 'solid (make-color 80 80 80))
                            (rectangle 350 100 'solid 'black)))
            (square 0 'solid 'pink))
        (rectangle 40 0 'solid 'pink)
        (if (>= (length (send (dungeon-player d) get-spells)) 4)
            (overlay/align "left" "middle"
                           (beside 
                            (rectangle 5 0 'solid 'pink)
                            (rectangle 10 0 'solid 'pink)
                            (spell-image (fourth (send (dungeon-player d) get-spells)))
                            (rectangle 30 0 'solid 'pink)
                            (above/align "left" (text (spell-name (fourth (send (dungeon-player d) get-spells))) 18 'black)
                                         (text (string-append "MP cost:" (number->string (spell-cost (fourth (send (dungeon-player d) get-spells))))) 18 'black)
                                         (text (spell-discription (fourth (send (dungeon-player d) get-spells))) 15 'black)))
                           (overlay
                            (rectangle 340 90 'solid (make-color 80 80 80))
                            (rectangle 350 100 'solid 'black)))
            (square 0 'solid 'pink)))
       (rectangle 0 20 'solid 'pink)
       (beside
        (if (>= (length (send (dungeon-player d) get-spells)) 5)
            (overlay/align "left" "middle"
                           (beside 
                            (rectangle 5 0 'solid 'pink)
                            (rectangle 10 0 'solid 'pink)
                            (spell-image (fifth (send (dungeon-player d) get-spells)))
                            (rectangle 30 0 'solid 'pink)
                            (above/align "left" (text (spell-name (fifth (send (dungeon-player d) get-spells))) 18 'black)
                                         (text (string-append "MP cost:" (number->string (spell-cost (fifth (send (dungeon-player d) get-spells))))) 18 'black)
                                         (text (spell-discription (fifth (send (dungeon-player d) get-spells))) 15 'black)))
                           (overlay
                            (rectangle 340 90 'solid (make-color 80 80 80))
                            (rectangle 350 100 'solid 'black)))
            (square 0 'solid 'pink))
        (rectangle 30 0 'solid 'black)
        (if (>= (length (send (dungeon-player d) get-spells)) 6)
            (overlay/align "left" "middle"
                           (beside 
                            (rectangle 5 0 'solid 'pink)
                            (rectangle 10 0 'solid 'pink)
                            (spell-image (sixth (send (dungeon-player d) get-spells)))
                            (rectangle 30 0 'solid 'pink)
                            (above/align "left" (text (spell-name (sixth (send (dungeon-player d) get-spells))) 18 'black)
                                         (text (string-append "MP cost:" (number->string (spell-cost (sixth (send (dungeon-player d) get-spells))))) 18 'black)
                                         (text (spell-discription (sixth (send (dungeon-player d) get-spells))) 15 'black)))
                           (overlay
                            (rectangle 340 90 'solid (make-color 80 80 80))
                            (rectangle 350 100 'solid 'black)))
            (square 0 'solid 'pink)))
       (rectangle 0 20 'solid 'pink)
       (beside
        (if (>= (length (send (dungeon-player d) get-spells)) 7)
            (overlay/align "left" "middle"
                           (beside 
                            (rectangle 5 0 'solid 'pink)
                            (rectangle 10 0 'solid 'pink)
                            (spell-image (seventh (send (dungeon-player d) get-spells)))
                            (rectangle 30 0 'solid 'pink)
                            (above/align "left" (text (spell-name (seventh (send (dungeon-player d) get-spells))) 18 'black)
                                         (text (string-append "MP cost:" (number->string (spell-cost (seventh (send (dungeon-player d) get-spells))))) 18 'black)
                                         (text (spell-discription (seventh (send (dungeon-player d) get-spells))) 15 'black)))
                           (overlay
                            (rectangle 340 90 'solid (make-color 80 80 80))
                            (rectangle 350 100 'solid 'black)))
            (square 0 'solid 'pink))
        (rectangle 30 0 'solid 'black)
        (if (>= (length (send (dungeon-player d) get-spells)) 8)
            (overlay/align "left" "middle"
                           (beside 
                            (rectangle 5 0 'solid 'pink)
                            (rectangle 10 0 'solid 'pink)
                            (spell-image (eighth (send (dungeon-player d) get-spells)))
                            (rectangle 30 0 'solid 'pink)
                            (above/align "left" (text (spell-name (eighth (send (dungeon-player d) get-spells))) 18 'black)
                                         (text (string-append "MP cost:" (number->string (spell-cost (eighth (send (dungeon-player d) get-spells))))) 18 'black)
                                         (text (spell-discription (eighth (send (dungeon-player d) get-spells))) 15 'black)))
                           (overlay
                            (rectangle 340 90 'solid (make-color 80 80 80))
                            (rectangle 350 100 'solid 'black)))
            (square 0 'solid 'pink))))
      (overlay/align "middle" "top"
                     (rectangle 802 570 'solid 'gray)
                     (rectangle 810 575 'solid 'black)))]
    [else (square 1000 'solid 'gray)]))

;; filter-equipment : list-of-equipment symbol --> image
(define (filter-equipment l s)
  (cond
    [(empty? l) empty]
    [(cons? l) (if (symbol=? (send (first l) get-portion) s)
                         (cons (first l) (filter-equipment (rest l) s))
                         (filter-equipment (rest l) s))]))

;; render-weapon-block : weapon --> image
(define (render-weapon-block w)
  (overlay (beside
            (send w get-image)
            (rectangle 25 0 'solid 'pink)
            (above (text (send w get-name) 13 'black)
                   (text (send w get-description) 12 'black)
                   (rectangle 0 10 'solid 'pink)
                   (text (string-append "Damage: " (number->string (send w get-damage))) 12 'black)
                   (text (string-append "Weapon Type: " (symbol->string (send w get-type))) 12 'black)
                   (text (string-append "Value: " (number->string (send w get-value))) 12 'black)))
           (rectangle 340 90 'solid (make-color 80 80 80))
           (rectangle 350 100 'solid 'black)))

;; render-equipment-block : equipment --> image
(define (render-equipment-block e)
  (overlay (beside
            (send e get-image)
            (rectangle 25 0 'solid 'pink)
            (above (text (send e get-name) 13 'black)
                   (text (send e get-description) 12 'black)
                   (rectangle 0 10 'solid 'pink)
                   (text (string-append "Defence: " (number->string (send e get-defence))) 12 'black)
                   (text (string-append "Value: " (number->string (send e get-value))) 12 'black)))
           (rectangle 340 90 'solid (make-color 80 80 80))
           (rectangle 350 100 'solid 'black)))

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
     [(eq? d 'n) (map-animation-north a)]
     [(eq? d 'e) (map-animation-east a)]
     [(eq? d 's) (map-animation-south a)]
     [(eq? d 'w) (map-animation-west a)])
   (place-image
    (place-npcs (room-npcs r) (tiles->image (room-tiles r)))
    (+ 405 (- (/ (image-width (tiles->image (room-tiles r))) 2) (posn-x p)))
    (+ 315 (- (/ (image-height (tiles->image (room-tiles r))) 2) (posn-y p)))
    (overlay/align "left" "bottom" 
                   (text (room-name r) 15 'red) 
                   (rectangle 810 630 'solid 'black)))))

;; place-npcs :list-of-npcs, image --> image
(define (place-npcs l i)
  (cond
    [(empty? l) i]
    [(cons? l) (place-image (map-animation-south (send (first l) get-map-animation))
                            (posn-x (send (first l) get-position))
                            (posn-y (send (first l) get-position))
                            (place-npcs (rest l) i))]))

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
                                (loi->image (append (inventory-miscellaneous (send (combat-npc c) get-inventory))
                                                    (first (inventory-equipment (send (combat-npc c) get-inventory)))
                                                    (second (inventory-equipment (send (combat-npc c) get-inventory)))
                                                    (third (inventory-equipment (send (combat-npc c) get-inventory)))
                                                    (fourth (inventory-equipment (send (combat-npc c) get-inventory)))
                                                    (fifth (inventory-equipment (send (combat-npc c) get-inventory)))))
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
                  (list
                   (append (first (inventory-equipment p))
                           (first (inventory-equipment n)))
                   (append (second (inventory-equipment p))
                           (second (inventory-equipment n)))
                   (append (third (inventory-equipment p))
                           (third (inventory-equipment n)))
                   (append (fourth (inventory-equipment p))
                           (fourth (inventory-equipment n)))
                   (append (fifth (inventory-equipment p))
                           (fifth (inventory-equipment n))))
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
     (if (string=? (send (first l) get-name) "Gold")
         (new-gold (rest l) (+ n (send (first l) get-number)))
         (new-gold (rest l) n))]))

;; remove-gold : l
(define (remove-gold l)
  (cond
    [(empty? l) empty]
    [(cons? l)
     (if (string=? (send (first l) get-name) "Gold")
         (remove-gold (rest l))
         (cons (first l) (remove-gold (rest l))))]))

;; loi->image : loi --> image
(define (loi->image l)
  (cond
    [(empty? l) (square 0 'solid 'white)]
    [(cons? l) (above/align "left"
                            (if (string=? (send (first l) get-name) "Gold")
                                (text (string-append "Gold ["
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
                                         [value (send (first (inventory-consumables (send (combat-player w) get-inventory))) get-value)]
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
    [(and (symbol? (dungeon-menu d)) (symbol=? (dungeon-menu d) 'player-info)) (cond [(key=? k "d") (make-dungeon
                                                                                                     (dungeon-player d)
                                                                                                     (dungeon-rooms d)
                                                                                                     empty
                                                                                                     (dungeon-name d)
                                                                                                     'items)]
                                                                                     [(key=? k "a") (make-dungeon
                                                                                                     (dungeon-player d)
                                                                                                     (dungeon-rooms d)
                                                                                                     empty
                                                                                                     (dungeon-name d)
                                                                                                     'spells)]
                                                                                     [else d])]
    [(and (symbol? (dungeon-menu d)) (symbol=? (dungeon-menu d) 'items)) (cond [(key=? k "d") (make-dungeon
                                                                                               (dungeon-player d)
                                                                                               (dungeon-rooms d)
                                                                                               empty
                                                                                               (dungeon-name d)
                                                                                               (list 'w))]
                                                                               [(key=? k "a") (make-dungeon
                                                                                               (dungeon-player d)
                                                                                               (dungeon-rooms d)
                                                                                               empty
                                                                                               (dungeon-name d)
                                                                                               'player-info)]
                                                                               [(and (>= (length (inventory-consumables (send (dungeon-player d) get-inventory))) 1) (key=? k "1"))
                                                                                (make-dungeon (send (send (dungeon-player d) use-consumable (first (inventory-consumables (send (dungeon-player d) get-inventory)))) clone 
                                                                                                    #:character-inventory
                                                                                                    (make-inventory (inventory-weapon (send (dungeon-player d) get-inventory))
                                                                                                                    (inventory-equiped (send (dungeon-player d) get-inventory))
                                                                                                                    (inventory-equipment (send (dungeon-player d) get-inventory))
                                                                                                                    (if (<= (send (first (inventory-consumables (send (dungeon-player d) get-inventory))) get-number) 1)
                                                                                                                        (rest (inventory-consumables (send (dungeon-player d) get-inventory)))
                                                                                                                        (cons (new consumable% 
                                                                                                                                   [image (send (first (inventory-consumables (send (dungeon-player d) get-inventory))) get-image)]
                                                                                                                                   [name (send (first (inventory-consumables (send (dungeon-player d) get-inventory))) get-name)]
                                                                                                                                   [description (send (first (inventory-consumables (send (dungeon-player d) get-inventory))) get-description)]
                                                                                                                                   [effect (send (first (inventory-consumables (send (dungeon-player d) get-inventory))) get-effect)]
                                                                                                                                   [animation (send (first (inventory-consumables (send (dungeon-player d) get-inventory))) get-animation)]
                                                                                                                                   [number (- (send (first (inventory-consumables (send (dungeon-player d) get-inventory))) get-number) 1)])
                                                                                                                              (rest (inventory-consumables (send (dungeon-player d) get-inventory)))))
                                                                                                                    (inventory-miscellaneous (send (dungeon-player d) get-inventory))))
                                                                                              (dungeon-rooms d)
                                                                                              empty
                                                                                              (dungeon-name d)
                                                                                              'items)]
                                                                               [(and (>= (length (inventory-consumables (send (dungeon-player d) get-inventory))) 2) (key=? k "2"))
                                                                                (make-dungeon (send (send (dungeon-player d) use-consumable (first (inventory-consumables (send (dungeon-player d) get-inventory)))) clone 
                                                                                                    #:character-inventory
                                                                                                    (make-inventory (inventory-weapon (send (dungeon-player d) get-inventory))
                                                                                                                    (inventory-equiped (send (dungeon-player d) get-inventory))
                                                                                                                    (inventory-equipment (send (dungeon-player d) get-inventory))
                                                                                                                    (if (<= (send (second (inventory-consumables (send (dungeon-player d) get-inventory))) get-number) 1)
                                                                                                                        (cons (first (inventory-consumables (send (dungeon-player d) get-inventory)))
                                                                                                                              (rest (rest (inventory-consumables (send (dungeon-player d) get-inventory)))))
                                                                                                                        (append 
                                                                                                                         (list (first (inventory-consumables (send (dungeon-player d) get-inventory)))
                                                                                                                               (new consumable% 
                                                                                                                                    [image (send (second (inventory-consumables (send (dungeon-player d) get-inventory))) get-image)]
                                                                                                                                    [name (send (second (inventory-consumables (send (dungeon-player d) get-inventory))) get-name)]
                                                                                                                                    [description (send (second (inventory-consumables (send (dungeon-player d) get-inventory))) get-description)]
                                                                                                                                    [effect (send (second (inventory-consumables (send (dungeon-player d) get-inventory))) get-effect)]
                                                                                                                                    [animation (send (second (inventory-consumables (send (dungeon-player d) get-inventory))) get-animation)]
                                                                                                                                    [number (- (send (second (inventory-consumables (send (dungeon-player d) get-inventory))) get-number) 1)]))
                                                                                                                         (rest (rest (inventory-consumables (send (dungeon-player d) get-inventory))))))
                                                                                                                    (inventory-miscellaneous (send (dungeon-player d) get-inventory))))
                                                                                              (dungeon-rooms d)
                                                                                              empty
                                                                                              (dungeon-name d)
                                                                                              'items)]
                                                                               [(and (>= (length (inventory-consumables (send (dungeon-player d) get-inventory))) 3) (key=? k "3"))
                                                                                (make-dungeon (send (send (dungeon-player d) use-consumable (first (inventory-consumables (send (dungeon-player d) get-inventory)))) clone 
                                                                                                    #:character-inventory
                                                                                                    (make-inventory (inventory-weapon (send (dungeon-player d) get-inventory))
                                                                                                                    (inventory-equiped (send (dungeon-player d) get-inventory))
                                                                                                                    (inventory-equipment (send (dungeon-player d) get-inventory))
                                                                                                                    (if (<= (send (third (inventory-consumables (send (dungeon-player d) get-inventory))) get-number) 1)
                                                                                                                        (append
                                                                                                                         (list (first (inventory-consumables (send (dungeon-player d) get-inventory)))
                                                                                                                               (second (inventory-consumables (send (dungeon-player d) get-inventory))))
                                                                                                                         (rest (rest (inventory-consumables (send (dungeon-player d) get-inventory)))))
                                                                                                                        (append 
                                                                                                                         (list (first (inventory-consumables (send (dungeon-player d) get-inventory)))
                                                                                                                               (second (inventory-consumables (send (dungeon-player d) get-inventory)))
                                                                                                                               (new consumable% 
                                                                                                                                    [image (send (third (inventory-consumables (send (dungeon-player d) get-inventory))) get-image)]
                                                                                                                                    [name (send (third (inventory-consumables (send (dungeon-player d) get-inventory))) get-name)]
                                                                                                                                    [description (send (third (inventory-consumables (send (dungeon-player d) get-inventory))) get-description)]
                                                                                                                                    [effect (send (third (inventory-consumables (send (dungeon-player d) get-inventory))) get-effect)]
                                                                                                                                    [animation (send (third (inventory-consumables (send (dungeon-player d) get-inventory))) get-animation)]
                                                                                                                                    [number (- (send (third (inventory-consumables (send (dungeon-player d) get-inventory))) get-number) 1)]))
                                                                                                                         (rest (rest (rest (inventory-consumables (send (dungeon-player d) get-inventory)))))))
                                                                                                                    (inventory-miscellaneous (send (dungeon-player d) get-inventory))))
                                                                                              (dungeon-rooms d)
                                                                                              empty
                                                                                              (dungeon-name d)
                                                                                              'items)]
                                                                               [(and (>= (length (inventory-consumables (send (dungeon-player d) get-inventory))) 4) (key=? k "4"))
                                                                                (make-dungeon (send (send (dungeon-player d) use-consumable (first (inventory-consumables (send (dungeon-player d) get-inventory)))) clone 
                                                                                                    #:character-inventory
                                                                                                    (make-inventory (inventory-weapon (send (dungeon-player d) get-inventory))
                                                                                                                    (inventory-equiped (send (dungeon-player d) get-inventory))
                                                                                                                    (inventory-equipment (send (dungeon-player d) get-inventory))
                                                                                                                    (if (<= (send (fourth (inventory-consumables (send (dungeon-player d) get-inventory))) get-number) 1)
                                                                                                                        (append
                                                                                                                         (list (first (inventory-consumables (send (dungeon-player d) get-inventory)))
                                                                                                                               (second (inventory-consumables (send (dungeon-player d) get-inventory)))
                                                                                                                               (third (inventory-consumables (send (dungeon-player d) get-inventory))))
                                                                                                                         (rest (rest (rest (rest (inventory-consumables (send (dungeon-player d) get-inventory)))))))
                                                                                                                        (append 
                                                                                                                         (list (first (inventory-consumables (send (dungeon-player d) get-inventory)))
                                                                                                                               (second (inventory-consumables (send (dungeon-player d) get-inventory)))
                                                                                                                               (third (inventory-consumables (send (dungeon-player d) get-inventory)))
                                                                                                                               (new consumable% 
                                                                                                                                    [image (send (fourth (inventory-consumables (send (dungeon-player d) get-inventory))) get-image)]
                                                                                                                                    [name (send (fourth (inventory-consumables (send (dungeon-player d) get-inventory))) get-name)]
                                                                                                                                    [description (send (fourth (inventory-consumables (send (dungeon-player d) get-inventory))) get-description)]
                                                                                                                                    [effect (send (fourth (inventory-consumables (send (dungeon-player d) get-inventory))) get-effect)]
                                                                                                                                    [animation (send (fourth (inventory-consumables (send (dungeon-player d) get-inventory))) get-animation)]
                                                                                                                                    [number (- (send (fourth (inventory-consumables (send (dungeon-player d) get-inventory))) get-number) 1)]))
                                                                                                                         (rest (rest (rest (rest (inventory-consumables (send (dungeon-player d) get-inventory))))))))
                                                                                                                    (inventory-miscellaneous (send (dungeon-player d) get-inventory))))
                                                                                              (dungeon-rooms d)
                                                                                              empty
                                                                                              (dungeon-name d)
                                                                                              'items)]
                                                                               [(and (>= (length (inventory-consumables (send (dungeon-player d) get-inventory))) 5) (key=? k "w"))
                                                                                (make-dungeon (send (dungeon-player d) clone #:character-inventory (make-inventory
                                                                                                                                                    (inventory-weapon (send (dungeon-player d) get-inventory))
                                                                                                                                                    (inventory-equiped (send (dungeon-player d) get-inventory))
                                                                                                                                                    (inventory-equipment (send (dungeon-player d) get-inventory))
                                                                                                                                                    (append (list (first (reverse (inventory-consumables (send (dungeon-player d) get-inventory)))))
                                                                                                                                                            (reverse (rest (reverse (inventory-consumables (send (dungeon-player d) get-inventory))))))
                                                                                                                                                    (inventory-miscellaneous (send (dungeon-player d) get-inventory))))
                                                                                              (dungeon-rooms d)
                                                                                              empty
                                                                                              (dungeon-name d)
                                                                                              'items)]
                                                                               [(and (>= (length (inventory-consumables (send (dungeon-player d) get-inventory))) 5) (key=? k "s"))
                                                                                (make-dungeon (send (dungeon-player d) clone #:character-inventory (make-inventory
                                                                                                                                                    (inventory-weapon (send (dungeon-player d) get-inventory))
                                                                                                                                                    (inventory-equiped (send (dungeon-player d) get-inventory))
                                                                                                                                                    (inventory-equipment (send (dungeon-player d) get-inventory))
                                                                                                                                                    (append (rest (inventory-consumables (send (dungeon-player d) get-inventory)))
                                                                                                                                                            (list (first (inventory-consumables (send (dungeon-player d) get-inventory)))))
                                                                                                                                                    (inventory-miscellaneous (send (dungeon-player d) get-inventory))))
                                                                                              (dungeon-rooms d)
                                                                                              empty
                                                                                              (dungeon-name d)
                                                                                              'items)]
                                                                               [else d])]
    [(list? (dungeon-menu d)) (cond [(key=? k "d") (make-dungeon
                                                    (dungeon-player d)
                                                    (dungeon-rooms d)
                                                    empty
                                                    (dungeon-name d)
                                                    'spells)]
                                    [(key=? k "a") (make-dungeon
                                                    (dungeon-player d)
                                                    (dungeon-rooms d)
                                                    empty
                                                    (dungeon-name d)
                                                    'items)]
                                    [else (handle-equipment-menu-key d k)])]
    [(and (symbol? (dungeon-menu d)) (symbol=? (dungeon-menu d) 'spells)) (cond [(key=? k "d") (make-dungeon
                                                                                                (dungeon-player d)
                                                                                                (dungeon-rooms d)
                                                                                                empty
                                                                                                (dungeon-name d)
                                                                                                'player-info)]
                                                                                [(key=? k "a") (make-dungeon
                                                                                                (dungeon-player d)
                                                                                                (dungeon-rooms d)
                                                                                                empty
                                                                                                (dungeon-name d)
                                                                                                (list 'w))]
                                                                                [else d])]
    [else d]))

;; handle-equipment-menu-key : dungeon, key --> dungeon
(define (handle-equipment-menu-key d k)
  (cond
    [(key=? k "right") (make-dungeon (dungeon-player d) (dungeon-rooms d) empty (dungeon-name d) 
                                 (cond
                     [(symbol=? (first (dungeon-menu d)) 'w) (list 'h)]
                     [(symbol=? (first (dungeon-menu d)) 'h) (list 'b)]
                     [(symbol=? (first (dungeon-menu d)) 'b) (list 'a)]
                     [(symbol=? (first (dungeon-menu d)) 'a) (list 'l)]
                     [(symbol=? (first (dungeon-menu d)) 'l) (list 'w)]))]
    [(key=? k "left") (make-dungeon (dungeon-player d) (dungeon-rooms d) empty (dungeon-name d) 
                                 (cond
                     [(symbol=? (first (dungeon-menu d)) 'w) (list 'l)]
                     [(symbol=? (first (dungeon-menu d)) 'h) (list 'w)]
                     [(symbol=? (first (dungeon-menu d)) 'b) (list 'h)]
                     [(symbol=? (first (dungeon-menu d)) 'a) (list 'b)]
                     [(symbol=? (first (dungeon-menu d)) 'l) (list 'a)]))]
    [(key=? k "\r") (make-dungeon (send (dungeon-player d) clone #:character-inventory
                                       (cond
                                         [(symbol=? (first (dungeon-menu d)) 'w) (if (not (empty? (first (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                                     (make-inventory (first (first (inventory-equipment (send (dungeon-player d) get-inventory))))
                                                                                                 (inventory-equiped (send (dungeon-player d) get-inventory))
                                                                                                 (append (list (cons (inventory-weapon (send (dungeon-player d) get-inventory))
                                                                                                                     (rest (first (inventory-equipment (send (dungeon-player d) get-inventory))))))
                                                                                                         (rest (inventory-equipment (send (dungeon-player d) get-inventory))))
                                                                                                 (inventory-consumables (send (dungeon-player d) get-inventory))
                                                                                                 (inventory-miscellaneous (send (dungeon-player d) get-inventory)))
                                                                                     (send (dungeon-player d) get-inventory))]
                                         [(symbol=? (first (dungeon-menu d)) 'h) (if (not (empty? (second (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                                     (make-inventory (inventory-weapon (send (dungeon-player d) get-inventory))
                                                                                                     (list 
                                                                                                                     (first (second (inventory-equipment (send (dungeon-player d) get-inventory))))
                                                                                                                     (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'b))
                                                                                                                     (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'a))
                                                                                                                     (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'l)))
                                                                                                 (append 
                                                                                                  (list (first (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                        (cons (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'h))
                                                                                                              (rest (second (inventory-equipment (send (dungeon-player d) get-inventory)))))) 
                                                                                                         (rest (rest (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                                                 (inventory-consumables (send (dungeon-player d) get-inventory))
                                                                                                 (inventory-miscellaneous (send (dungeon-player d) get-inventory)))
                                                                                     (send (dungeon-player d) get-inventory))]
                                         [(symbol=? (first (dungeon-menu d)) 'b) (if (not (empty? (third (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                                     (make-inventory (inventory-weapon (send (dungeon-player d) get-inventory))
                                                                                                     (list 
                                                                                                                     (first (third (inventory-equipment (send (dungeon-player d) get-inventory))))
                                                                                                                     (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'h))
                                                                                                                    (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'a))
                                                                                                                    (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'l)))
                                                                                                 (append 
                                                                                                  (list (first (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                        (second (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                        (cons (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'b))
                                                                                                        (rest (third (inventory-equipment (send (dungeon-player d) get-inventory)))))) 
                                                                                                         (rest (rest (rest (inventory-equipment (send (dungeon-player d) get-inventory))))))
                                                                                                 (inventory-consumables (send (dungeon-player d) get-inventory))
                                                                                                 (inventory-miscellaneous (send (dungeon-player d) get-inventory)))
                                                                                     (send (dungeon-player d) get-inventory))]
                                         [(symbol=? (first (dungeon-menu d)) 'a) (if (not (empty? (fourth (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                                     (make-inventory (inventory-weapon (send (dungeon-player d) get-inventory))
                                                                                                     (list 
                                                                                                                     (first (fourth (inventory-equipment (send (dungeon-player d) get-inventory))))
                                                                                                                     (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'h))
                                                                                                                     (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'b))
                                                                                                                     (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'l)))
                                                                                                 (append 
                                                                                                  (list (first (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                        (second (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                        (third (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                        (cons (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'a))
                                                                                                              (rest (fourth (inventory-equipment (send (dungeon-player d) get-inventory)))))) 
                                                                                                         (rest (rest (rest (rest (inventory-equipment (send (dungeon-player d) get-inventory)))))))
                                                                                                 (inventory-consumables (send (dungeon-player d) get-inventory))
                                                                                                 (inventory-miscellaneous (send (dungeon-player d) get-inventory)))
                                                                                     (send (dungeon-player d) get-inventory))]
                                         [(symbol=? (first (dungeon-menu d)) 'l) (if (not (empty? (fifth (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                                     (make-inventory (inventory-weapon (send (dungeon-player d) get-inventory))
                                                                                                     (list 
                                                                                                                     (first (fifth (inventory-equipment (send (dungeon-player d) get-inventory))))
                                                                                                                     (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'h))
                                                                                                                     (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'b))
                                                                                                                     (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'a)))
                                                                                                 (append 
                                                                                                  (list (first (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                        (second (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                        (third (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                        (fourth (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                        (cons (first (filter-equipment (inventory-equiped (send (dungeon-player d) get-inventory)) 'l))
                                                                                                              (rest (fifth (inventory-equipment (send (dungeon-player d) get-inventory))))))) 
                                                                                                 (inventory-consumables (send (dungeon-player d) get-inventory))
                                                                                                 (inventory-miscellaneous (send (dungeon-player d) get-inventory)))
                                                                                     (send (dungeon-player d) get-inventory))]))
                                                  (dungeon-rooms d) empty (dungeon-name d) (dungeon-menu d))]
    [(or (key=? k "up") (key=?  k "down")) (make-dungeon (send (dungeon-player d) clone #:character-inventory
                                       (cond
                                         [(symbol=? (first (dungeon-menu d)) 'w) (if (not (empty? (first (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                                     (make-inventory (inventory-weapon (send (dungeon-player d) get-inventory))
                                                                                                 (inventory-equiped (send (dungeon-player d) get-inventory))
                                                                                                 (append (list (append (rest (first (inventory-equipment (send (dungeon-player d) get-inventory))))
                                                                                                               (list (first (first (inventory-equipment (send (dungeon-player d) get-inventory)))))))
                                                                                                         (rest (inventory-equipment (send (dungeon-player d) get-inventory))))
                                                                                                 (inventory-consumables (send (dungeon-player d) get-inventory))
                                                                                                 (inventory-miscellaneous (send (dungeon-player d) get-inventory)))
                                                                                     (send (dungeon-player d) get-inventory))]
                                         [(symbol=? (first (dungeon-menu d)) 'h) (if (not (empty? (second (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                                     (make-inventory (inventory-weapon (send (dungeon-player d) get-inventory))
                                                                                                 (inventory-equiped (send (dungeon-player d) get-inventory))
                                                                                                 (append 
                                                                                                  (list (first (inventory-equipment (send (dungeon-player d) get-inventory))))
                                                                                                  (list (append (rest (second (inventory-equipment (send (dungeon-player d) get-inventory))))
                                                                                                               (list (first (second (inventory-equipment (send (dungeon-player d) get-inventory)))))))
                                                                                                         (rest (rest (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                                                 (inventory-consumables (send (dungeon-player d) get-inventory))
                                                                                                 (inventory-miscellaneous (send (dungeon-player d) get-inventory)))
                                                                                     (send (dungeon-player d) get-inventory))]
                                         [(symbol=? (first (dungeon-menu d)) 'b) (if (not (empty? (third (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                                     (make-inventory (inventory-weapon (send (dungeon-player d) get-inventory))
                                                                                                 (inventory-equiped (send (dungeon-player d) get-inventory))
                                                                                                 (append 
                                                                                                  (list (first (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                        (second (inventory-equipment (send (dungeon-player d) get-inventory))))
                                                                                                  (list (append (rest (third (inventory-equipment (send (dungeon-player d) get-inventory))))
                                                                                                               (list (first (third (inventory-equipment (send (dungeon-player d) get-inventory)))))))
                                                                                                         (rest (rest (rest (inventory-equipment (send (dungeon-player d) get-inventory))))))
                                                                                                 (inventory-consumables (send (dungeon-player d) get-inventory))
                                                                                                 (inventory-miscellaneous (send (dungeon-player d) get-inventory)))
                                                                                     (send (dungeon-player d) get-inventory))]
                                         [(symbol=? (first (dungeon-menu d)) 'a) (if (not (empty? (fourth (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                                     (make-inventory (inventory-weapon (send (dungeon-player d) get-inventory))
                                                                                                 (inventory-equiped (send (dungeon-player d) get-inventory))
                                                                                                 (append 
                                                                                                  (list (first (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                        (second (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                        (third (inventory-equipment (send (dungeon-player d) get-inventory))))
                                                                                                  (list (append (rest (fourth (inventory-equipment (send (dungeon-player d) get-inventory))))
                                                                                                               (list (first (fourth (inventory-equipment (send (dungeon-player d) get-inventory)))))))
                                                                                                         (rest (rest (rest (rest (inventory-equipment (send (dungeon-player d) get-inventory)))))))
                                                                                                 (inventory-consumables (send (dungeon-player d) get-inventory))
                                                                                                 (inventory-miscellaneous (send (dungeon-player d) get-inventory)))
                                                                                     (send (dungeon-player d) get-inventory))]
                                         [(symbol=? (first (dungeon-menu d)) 'l) (if (not (empty? (fifth (inventory-equipment (send (dungeon-player d) get-inventory)))))
                                                                                     (make-inventory (inventory-weapon (send (dungeon-player d) get-inventory))
                                                                                                 (inventory-equiped (send (dungeon-player d) get-inventory))
                                                                                                  (list (first (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                        (second (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                        (third (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                        (fourth (inventory-equipment (send (dungeon-player d) get-inventory)))
                                                                                                  (append (rest (fifth (inventory-equipment (send (dungeon-player d) get-inventory))))
                                                                                                               (list (first (fifth (inventory-equipment (send (dungeon-player d) get-inventory)))))))
                                                                                                  (inventory-consumables (send (dungeon-player d) get-consumables))
                                                                                                 (inventory-miscellaneous (send (dungeon-player d) get-inventory)))
                                                                                     (send (dungeon-player d) get-inventory))]))
                                                  (dungeon-rooms d) empty (dungeon-name d) (dungeon-menu d))]
    [else d]))
    

;; enough-space-above? : dungeon --> boolean
(define (enough-space-above? d) 
  (not
   (or (>= (/ (image-height (map-animation-north
                             (send (dungeon-player d) get-map-animation))) 2)
           (posn-y (send (dungeon-player d) get-position))) 
       (not 
        (send (get-tile (make-posn (posn-x (send (dungeon-player d) get-position))
                                   (- (posn-y (send (dungeon-player d) get-position))
                                      (/ (image-height 
                                          (map-animation-east
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
              (/ (image-height (map-animation-south (send (dungeon-player d) get-map-animation))) 2))
           (posn-y (send (dungeon-player d) get-position))) 
       (not (send (get-tile 
                   (make-posn (posn-x (send (dungeon-player d) get-position)) 
                              (+ (posn-y (send (dungeon-player d) get-position))
                                 (/ (image-height (map-animation-east 
                                                   (send (dungeon-player d) get-map-animation))) 2)))
                   (room-tiles (first (dungeon-rooms d)))) passable?)))))

;; enough-space-left? : dungeon --> boolean
(define (enough-space-left? d)
  (not
   (or (>= (/ (image-width (map-animation-west 
                            (send (dungeon-player d) get-map-animation))) 2)
           (posn-x (send (dungeon-player d) get-position))) 
       (not 
        (send (get-tile 
               (make-posn (- (posn-x (send (dungeon-player d) get-position))
                             (/ (image-width 
                                 (map-animation-west 
                                  (send (dungeon-player d) get-map-animation))) 2))
                          (posn-y (send (dungeon-player d) get-position)))
               (room-tiles (first (dungeon-rooms d)))) passable?)))))

;; enough-space-right? : dungeon --> boolean
(define (enough-space-right? d)
  (not
   (or (<= (- (* (image-width (send (first (first (room-tiles (first (dungeon-rooms d))))) get-image))
                 (length (first (room-tiles (first (dungeon-rooms d))))))
              (/ (image-width (map-animation-east (send (dungeon-player d) get-map-animation))) 2))
           (posn-x (send (dungeon-player d) get-position))) 
       (not (send (get-tile (make-posn (+ (posn-x (send (dungeon-player d) get-position))
                                          (/ (image-width (map-animation-east
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
