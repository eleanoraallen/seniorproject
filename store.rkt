#lang racket
(require "combat.rkt")
(require "characters.rkt")
(require "spells.rkt")
(require "items.rkt")
(require "dungeons.rkt")
(require "music.rkt")
(require 2htdp/image)
(require 2htdp/universe)
(provide (all-defined-out))

;; a store is a (make-store player inventory number symbol string string)
;  (define-struct store (player inventory num sym dungeon room))

;; 0 = home
;; 1 = buy
;; 2 = sell

(define (render-store s)
  (cond
    [(not (store? s)) (square 50 'solid 'red)]
    [(= (store-num s) 0) (overlay (text "Buy (1), Sell (2), Exit (3)" 30 'black)
                                  (overlay
                                   (rectangle 800 620 'solid 'gray)
                                   (rectangle 810 630 'solid 'black)))]
    [(= (store-num s) 1)
     (overlay/align "right" "top"
                    (overlay (text (string-append "Gold: "
                                                  (number->string
                                                   (send (first (filter (lambda (x) (string=? (send x get-name) "Gold"))
                                                                        (inventory-miscellaneous (send (store-player s) get-inventory)))) get-number))) 15 'black)
                             (rectangle 100 25 'solid 'gray) (rectangle 110 35 'solid 'black))
                    (overlay (above (cond
                                      [(symbol=? (store-sym s) 'c) (text "Consumables For Sale:" 40 'black)]
                                      [(symbol=? (store-sym s) 'w) (text "Weapons For Sale:" 40 'black)]
                                      [(symbol=? (store-sym s) 'h) (text "Head Equipment For Sale:" 40 'black)]
                                      [(symbol=? (store-sym s) 'b) (text "Body Equipment For Sale:" 40 'black)]
                                      [(symbol=? (store-sym s) 'a) (text "Arm Equipment For Sale:" 40 'black)]
                                      [(symbol=? (store-sym s) 'l) (text "Leg Equipment For Sale:" 40 'black)]
                                      [(symbol=? (store-sym s) 'm) (text "Misc. Items For Sale:" 40 'black)])
                                    (rectangle 0 50 'solid 'pink)
                                    (cond
                                      [(symbol=? (store-sym s) 'w)
                                       (above (if (>= (length (first (inventory-equipment (store-inventory s)))) 5)
                                                  (beside (rotate 180 (triangle 15 'solid 'black))
                                                          (rectangle 7 0 'solid 'pink)  
                                                          (rectangle 7 0 'solid 'pink) 
                                                          (triangle 15 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (first (inventory-equipment (store-inventory s)))) 1)
                                                  (beside (rotate 90 (triangle 40 'solid 'black))
                                                          (overlay
                                                           (overlay/align "left" "middle"
                                                                          (beside 
                                                                           (rectangle 5 0 'solid 'pink)
                                                                           (rectangle 10 0 'solid 'pink)
                                                                           (send (first (first (inventory-equipment (store-inventory s)))) get-image))
                                                                          (place-image
                                                                           (above (text (send (first (first (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                                  (text (send (first (first (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                                  (text (string-append "Value: " (number->string (send (first (first (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                           208 45
                                                                           (rectangle 340 90 'solid (make-color 80 80 80))))
                                                           (rectangle 350 100 'solid 'black))
                                                          (rotate 270 (triangle 40 'solid 'black)))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (first (inventory-equipment (store-inventory s)))) 2)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (second (first (inventory-equipment (store-inventory s)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (second (first (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                          (text (send (second (first (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (second (first (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (first (inventory-equipment (store-inventory s)))) 3)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (first (inventory-equipment (store-inventory s)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (third (first (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                          (text (send (third (first (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (third (first (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (first (inventory-equipment (store-inventory s)))) 4)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (first (inventory-equipment (store-inventory s)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (fourth (first (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                          (text (send (fourth (first (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (fourth (first (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink)))]
                                      [(symbol=? (store-sym s) 'h)
                                       (above (if (>= (length (second (inventory-equipment (store-inventory s)))) 5)
                                                  (beside (rotate 180 (triangle 15 'solid 'black))
                                                          (rectangle 7 0 'solid 'pink)  
                                                          (rectangle 7 0 'solid 'pink) 
                                                          (triangle 15 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (second (inventory-equipment (store-inventory s)))) 1)
                                                  (beside (rotate 90 (triangle 40 'solid 'black))
                                                          (overlay
                                                           (overlay/align "left" "middle"
                                                                          (beside 
                                                                           (rectangle 5 0 'solid 'pink)
                                                                           (rectangle 10 0 'solid 'pink)
                                                                           (send (first (second (inventory-equipment (store-inventory s)))) get-image))
                                                                          (place-image
                                                                           (above (text (send (first (second (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                                  (text (send (first (second (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                                  (text (string-append "Value: " (number->string (send (first (second (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                           208 45
                                                                           (rectangle 340 90 'solid (make-color 80 80 80))))
                                                           (rectangle 350 100 'solid 'black)) (rotate 270 (triangle 40 'solid 'black)))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (second (inventory-equipment (store-inventory s)))) 2)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (second (second (inventory-equipment (store-inventory s)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (second (second (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                          (text (send (second (second (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (second (second (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (second (inventory-equipment (store-inventory s)))) 3)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (second (inventory-equipment (store-inventory s)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (third (second (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                          (text (send (third (second (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (third (second (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (second (inventory-equipment (store-inventory s)))) 4)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (second (inventory-equipment (store-inventory s)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (fourth (second (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                          (text (send (fourth (second (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (fourth (second (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink)))]
                                      [(symbol=? (store-sym s) 'b)
                                       (above (if (>= (length (third (inventory-equipment (store-inventory s)))) 5)
                                                  (beside (rotate 180 (triangle 15 'solid 'black))
                                                          (rectangle 7 0 'solid 'pink)  
                                                          (rectangle 7 0 'solid 'pink) 
                                                          (triangle 15 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (third (inventory-equipment (store-inventory s)))) 1)
                                                  (beside (rotate 90 (triangle 40 'solid 'black))
                                                          (overlay
                                                           (overlay/align "left" "middle"
                                                                          (beside 
                                                                           (rectangle 5 0 'solid 'pink)
                                                                           (rectangle 10 0 'solid 'pink)
                                                                           (send (first (third (inventory-equipment (store-inventory s)))) get-image))
                                                                          (place-image
                                                                           (above (text (send (first (third (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                                  (text (send (first (third (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                                  (text (string-append "Value: " (number->string (send (first (third (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                           208 45
                                                                           (rectangle 340 90 'solid (make-color 80 80 80))))
                                                           (rectangle 350 100 'solid 'black))
                                                          (rotate 270 (triangle 40 'solid 'black)))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (third (inventory-equipment (store-inventory s)))) 2)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (second (third (inventory-equipment (store-inventory s)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (second (third (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                          (text (send (second (third (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (second (third (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (third (inventory-equipment (store-inventory s)))) 3)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (third (inventory-equipment (store-inventory s)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (third (third (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                          (text (send (third (third (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (third (third (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (third (inventory-equipment (store-inventory s)))) 4)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (third (inventory-equipment (store-inventory s)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (fourth (third (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                          (text (send (fourth (third (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (fourth (third (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink)))]
                                      [(symbol=? (store-sym s) 'a)
                                       (above (if (>= (length (fourth (inventory-equipment (store-inventory s)))) 5)
                                                  (beside (rotate 180 (triangle 15 'solid 'black))
                                                          (rectangle 7 0 'solid 'pink)  
                                                          (rectangle 7 0 'solid 'pink) 
                                                          (triangle 15 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (fourth (inventory-equipment (store-inventory s)))) 1)
                                                  (beside (rotate 90 (triangle 40 'solid 'black))
                                                          (overlay
                                                           (overlay/align "left" "middle"
                                                                          (beside 
                                                                           (rectangle 5 0 'solid 'pink)
                                                                           (rectangle 10 0 'solid 'pink)
                                                                           (send (first (fourth (inventory-equipment (store-inventory s)))) get-image))
                                                                          (place-image
                                                                           (above (text (send (first (fourth (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                                  (text (send (first (fourth (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                                  (text (string-append "Value: " (number->string (send (first (fourth (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                           208 45
                                                                           (rectangle 340 90 'solid (make-color 80 80 80))))
                                                           (rectangle 350 100 'solid 'black)) (rotate 270 (triangle 40 'solid 'black)))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (fourth (inventory-equipment (store-inventory s)))) 2)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (second (fourth (inventory-equipment (store-inventory s)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (second (fourth (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                          (text (send (second (fourth (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (second (fourth (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (fourth (inventory-equipment (store-inventory s)))) 3)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (fourth (inventory-equipment (store-inventory s)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (third (fourth (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                          (text (send (third (fourth (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (third (fourth (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (fourth (inventory-equipment (store-inventory s)))) 4)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (fourth (inventory-equipment (store-inventory s)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (fourth (fourth (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                          (text (send (fourth (fourth (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (fourth (fourth (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink)))]
                                      [(symbol=? (store-sym s) 'l)
                                       (above (if (>= (length (fifth (inventory-equipment (store-inventory s)))) 5)
                                                  (beside (rotate 180 (triangle 15 'solid 'black))
                                                          (rectangle 7 0 'solid 'pink)  
                                                          (rectangle 7 0 'solid 'pink) 
                                                          (triangle 15 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (fifth (inventory-equipment (store-inventory s)))) 1)
                                                  (beside (rotate 90 (triangle 40 'solid 'black))
                                                          (overlay
                                                           (overlay/align "left" "middle"
                                                                          (beside 
                                                                           (rectangle 5 0 'solid 'pink)
                                                                           (rectangle 10 0 'solid 'pink)
                                                                           (send (first (fifth (inventory-equipment (store-inventory s)))) get-image))
                                                                          (place-image
                                                                           (above (text (send (first (fifth (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                                  (text (send (first (fifth (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                                  (text (string-append "Value: " (number->string (send (first (fifth (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                           208 45
                                                                           (rectangle 340 90 'solid (make-color 80 80 80))))
                                                           (rectangle 350 100 'solid 'black)) (rotate 270 (triangle 40 'solid 'black)))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (fifth (inventory-equipment (store-inventory s)))) 2)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (second (fifth (inventory-equipment (store-inventory s)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (second (fifth (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                          (text (send (second (fifth (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (second (fifth (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (fifth (inventory-equipment (store-inventory s)))) 3)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (fifth (inventory-equipment (store-inventory s)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (third (fifth (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                          (text (send (third (fifth (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (third (fifth (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (fifth (inventory-equipment (store-inventory s)))) 4)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (fifth (inventory-equipment (store-inventory s)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (fourth (fifth (inventory-equipment (store-inventory s)))) get-name) 18 'black)
                                                                          (text (send (fourth (fifth (inventory-equipment (store-inventory s)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (fourth (fifth (inventory-equipment (store-inventory s)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink)))]
                                      [(symbol=? (store-sym s) 'c)
                                       (above (if (>= (length (inventory-consumables (store-inventory s))) 5)
                                                  (beside (rotate 180 (triangle 15 'solid 'black))
                                                          (rectangle 7 0 'solid 'pink)  
                                                          (rectangle 7 0 'solid 'pink) 
                                                          (triangle 15 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (beside (rotate 90 (triangle 40 'solid 'black))
                                                      (if (>= (length (inventory-consumables (store-inventory s))) 1)
                                                          (overlay
                                                           (overlay/align "left" "middle"
                                                                          (beside 
                                                                           (rectangle 5 0 'solid 'pink)
                                                                           (rectangle 10 0 'solid 'pink)
                                                                           (send (first (inventory-consumables (store-inventory s))) get-image))
                                                                          (place-image
                                                                           (above (text (send (first (inventory-consumables (store-inventory s))) get-name) 18 'black)
                                                                                  (text (send (first (inventory-consumables (store-inventory s))) get-description) 15 'black)
                                                                                  (text (string-append "Value: " (number->string (send (first (inventory-consumables (store-inventory s))) get-value))) 18 'black))
                                                                           208 45
                                                                           (rectangle 340 90 'solid (make-color 80 80 80))))
                                                           (rectangle 350 100 'solid 'black))
                                                          (square 0 'solid 'pink)) (rotate 270 (triangle 40 'solid 'black)))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (inventory-consumables (store-inventory s))) 2)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (second (inventory-consumables (store-inventory s))) get-image))
                                                                  (place-image
                                                                   (above (text (send (second (inventory-consumables (store-inventory s))) get-name) 18 'black)
                                                                          (text (send (second (inventory-consumables (store-inventory s))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (second (inventory-consumables (store-inventory s))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (inventory-consumables (store-inventory s))) 3)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (inventory-consumables (store-inventory s))) get-image))
                                                                  (place-image
                                                                   (above (text (send (third (inventory-consumables (store-inventory s))) get-name) 18 'black)
                                                                          (text (send (third (inventory-consumables (store-inventory s))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (third (inventory-consumables (store-inventory s))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (inventory-consumables (store-inventory s))) 4)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (inventory-consumables (store-inventory s))) get-image))
                                                                  (place-image
                                                                   (above (text (send (fourth (inventory-consumables (store-inventory s))) get-name) 18 'black)
                                                                          (text (send (fourth (inventory-consumables (store-inventory s))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (fourth (inventory-consumables (store-inventory s))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink)))]
                                      [(symbol=? (store-sym s) 'm) 
                                       (above (if (>= (length (inventory-miscellaneous (store-inventory s))) 5)
                                                  (beside (rotate 180 (triangle 15 'solid 'black))
                                                          (rectangle 7 0 'solid 'pink)  
                                                          (rectangle 7 0 'solid 'pink) 
                                                          (triangle 15 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (inventory-miscellaneous (store-inventory s))) 1)
                                                  (beside (rotate 90 (triangle 40 'solid 'black))
                                                          (overlay
                                                           (overlay/align "left" "middle"
                                                                          (beside 
                                                                           (rectangle 5 0 'solid 'pink)
                                                                           (rectangle 10 0 'solid 'pink)
                                                                           (send (first (inventory-miscellaneous (store-inventory s))) get-image))
                                                                          (place-image
                                                                           (above (text (send (first (inventory-miscellaneous (store-inventory s))) get-name) 18 'black)
                                                                                  (text (send (first (inventory-miscellaneous (store-inventory s))) get-description) 15 'black)
                                                                                  (text (string-append "Value: " (number->string (send (first (inventory-miscellaneous (store-inventory s))) get-value))) 18 'black))
                                                                           208 45
                                                                           (rectangle 340 90 'solid (make-color 80 80 80))))
                                                           (rectangle 350 100 'solid 'black)) (rotate 270 (triangle 40 'solid 'black)))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (inventory-miscellaneous (store-inventory s))) 2)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (second (inventory-miscellaneous (store-inventory s))) get-image))
                                                                  (place-image
                                                                   (above (text (send (second (inventory-miscellaneous (store-inventory s))) get-name) 18 'black)
                                                                          (text (send (second (inventory-miscellaneous (store-inventory s))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (second (inventory-miscellaneous (store-inventory s))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (inventory-miscellaneous (store-inventory s))) 3)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (inventory-miscellaneous (store-inventory s))) get-image))
                                                                  (place-image
                                                                   (above (text (send (third (inventory-miscellaneous (store-inventory s))) get-name) 18 'black)
                                                                          (text (send (third (inventory-miscellaneous (store-inventory s))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (third (inventory-miscellaneous (store-inventory s))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (inventory-miscellaneous (store-inventory s))) 4)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (fourth (inventory-miscellaneous (store-inventory s))) get-image))
                                                                  (place-image
                                                                   (above (text (send (fourth (inventory-miscellaneous (store-inventory s))) get-name) 18 'black)
                                                                          (text (send (fourth (inventory-miscellaneous (store-inventory s))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (fourth (inventory-miscellaneous (store-inventory s))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink)))]))
                             (overlay
                              (rectangle 800 620 'solid 'gray)
                              (rectangle 810 630 'solid 'black))))]
    [(= (store-num s) 2)
     (overlay/align "right" "top"
                    (overlay (text (string-append "Gold: "
                                                  (number->string
                                                   (send (first (filter (lambda (x) (string=? (send x get-name) "Gold"))
                                                                        (inventory-miscellaneous (send (store-player s) get-inventory)))) get-number))) 15 'black)
                             (rectangle 100 25 'solid 'gray) (rectangle 110 35 'solid 'black))
                    (overlay (above (cond
                                      [(symbol=? (store-sym s) 'c) (text "Consumables To Sell:" 40 'black)]
                                      [(symbol=? (store-sym s) 'w) (text "Weapons To Sell:" 40 'black)]
                                      [(symbol=? (store-sym s) 'h) (text "Head Equipment To Sell:" 40 'black)]
                                      [(symbol=? (store-sym s) 'b) (text "Body Equipment To Sell:" 40 'black)]
                                      [(symbol=? (store-sym s) 'a) (text "Arm Equipment To Sell:" 40 'black)]
                                      [(symbol=? (store-sym s) 'l) (text "Leg Equipment To Sell:" 40 'black)]
                                      [(symbol=? (store-sym s) 'm) (text "Misc. Items To Sell:" 40 'black)])
                                    (rectangle 0 50 'solid 'pink)
                                    (cond
                                      [(symbol=? (store-sym s) 'w)
                                       (above (if (>= (length (first (inventory-equipment (send (store-player s) get-inventory)))) 5)
                                                  (beside (rotate 180 (triangle 15 'solid 'black))
                                                          (rectangle 7 0 'solid 'pink)  
                                                          (rectangle 7 0 'solid 'pink) 
                                                          (triangle 15 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (first (inventory-equipment (send (store-player s) get-inventory)))) 1)
                                                  (beside (rotate 90 (triangle 40 'solid 'black))
                                                          (overlay
                                                           (overlay/align "left" "middle"
                                                                          (beside 
                                                                           (rectangle 5 0 'solid 'pink)
                                                                           (rectangle 10 0 'solid 'pink)
                                                                           (send (first (first (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                          (place-image
                                                                           (above (text (send (first (first (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                                  (text (send (first (first (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                                  (text (string-append "Value: " (number->string (send (first (first (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                           208 45
                                                                           (rectangle 340 90 'solid (make-color 80 80 80))))
                                                           (rectangle 350 100 'solid 'black))
                                                          (rotate 270 (triangle 40 'solid 'black)))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (first (inventory-equipment (send (store-player s) get-inventory)))) 2)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (second (first (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (second (first (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                          (text (send (second (first (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (second (first (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (first (inventory-equipment (send (store-player s) get-inventory)))) 3)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (first (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (third (first (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                          (text (send (third (first (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (third (first (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (first (inventory-equipment (send (store-player s) get-inventory)))) 4)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (first (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (fourth (first (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                          (text (send (fourth (first (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (fourth (first (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink)))]
                                      [(symbol=? (store-sym s) 'h)
                                       (above (if (>= (length (second (inventory-equipment (send (store-player s) get-inventory)))) 5)
                                                  (beside (rotate 180 (triangle 15 'solid 'black))
                                                          (rectangle 7 0 'solid 'pink)  
                                                          (rectangle 7 0 'solid 'pink) 
                                                          (triangle 15 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (second (inventory-equipment (send (store-player s) get-inventory)))) 1)
                                                  (beside (rotate 90 (triangle 40 'solid 'black))
                                                          (overlay
                                                           (overlay/align "left" "middle"
                                                                          (beside 
                                                                           (rectangle 5 0 'solid 'pink)
                                                                           (rectangle 10 0 'solid 'pink)
                                                                           (send (first (second (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                          (place-image
                                                                           (above (text (send (first (second (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                                  (text (send (first (second (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                                  (text (string-append "Value: " (number->string (send (first (second (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                           208 45
                                                                           (rectangle 340 90 'solid (make-color 80 80 80))))
                                                           (rectangle 350 100 'solid 'black)) (rotate 270 (triangle 40 'solid 'black)))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (second (inventory-equipment (send (store-player s) get-inventory)))) 2)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (second (second (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (second (second (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                          (text (send (second (second (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (second (second (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (second (inventory-equipment (send (store-player s) get-inventory)))) 3)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (second (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (third (second (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                          (text (send (third (second (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (third (second (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (second (inventory-equipment (send (store-player s) get-inventory)))) 4)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (second (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (fourth (second (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                          (text (send (fourth (second (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (fourth (second (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink)))]
                                      [(symbol=? (store-sym s) 'b)
                                       (above (if (>= (length (third (inventory-equipment (send (store-player s) get-inventory)))) 5)
                                                  (beside (rotate 180 (triangle 15 'solid 'black))
                                                          (rectangle 7 0 'solid 'pink)  
                                                          (rectangle 7 0 'solid 'pink) 
                                                          (triangle 15 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (third (inventory-equipment (send (store-player s) get-inventory)))) 1)
                                                  (beside (rotate 90 (triangle 40 'solid 'black))
                                                          (overlay
                                                           (overlay/align "left" "middle"
                                                                          (beside 
                                                                           (rectangle 5 0 'solid 'pink)
                                                                           (rectangle 10 0 'solid 'pink)
                                                                           (send (first (third (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                          (place-image
                                                                           (above (text (send (first (third (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                                  (text (send (first (third (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                                  (text (string-append "Value: " (number->string (send (first (third (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                           208 45
                                                                           (rectangle 340 90 'solid (make-color 80 80 80))))
                                                           (rectangle 350 100 'solid 'black))
                                                          (rotate 270 (triangle 40 'solid 'black)))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (third (inventory-equipment (send (store-player s) get-inventory)))) 2)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (second (third (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (second (third (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                          (text (send (second (third (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (second (third (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (third (inventory-equipment (send (store-player s) get-inventory)))) 3)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (third (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (third (third (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                          (text (send (third (third (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (third (third (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (third (inventory-equipment (send (store-player s) get-inventory)))) 4)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (third (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (fourth (third (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                          (text (send (fourth (third (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (fourth (third (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink)))]
                                      [(symbol=? (store-sym s) 'a)
                                       (above (if (>= (length (fourth (inventory-equipment (send (store-player s) get-inventory)))) 5)
                                                  (beside (rotate 180 (triangle 15 'solid 'black))
                                                          (rectangle 7 0 'solid 'pink)  
                                                          (rectangle 7 0 'solid 'pink) 
                                                          (triangle 15 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (fourth (inventory-equipment (send (store-player s) get-inventory)))) 1)
                                                  (beside (rotate 90 (triangle 40 'solid 'black))
                                                          (overlay
                                                           (overlay/align "left" "middle"
                                                                          (beside 
                                                                           (rectangle 5 0 'solid 'pink)
                                                                           (rectangle 10 0 'solid 'pink)
                                                                           (send (first (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                          (place-image
                                                                           (above (text (send (first (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                                  (text (send (first (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                                  (text (string-append "Value: " (number->string (send (first (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                           208 45
                                                                           (rectangle 340 90 'solid (make-color 80 80 80))))
                                                           (rectangle 350 100 'solid 'black)) (rotate 270 (triangle 40 'solid 'black)))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (fourth (inventory-equipment (send (store-player s) get-inventory)))) 2)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (second (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (second (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                          (text (send (second (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (second (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (fourth (inventory-equipment (send (store-player s) get-inventory)))) 3)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (third (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                          (text (send (third (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (third (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (fourth (inventory-equipment (send (store-player s) get-inventory)))) 4)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (fourth (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                          (text (send (fourth (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (fourth (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink)))]
                                      [(symbol=? (store-sym s) 'l)
                                       (above (if (>= (length (fifth (inventory-equipment (send (store-player s) get-inventory)))) 5)
                                                  (beside (rotate 180 (triangle 15 'solid 'black))
                                                          (rectangle 7 0 'solid 'pink)  
                                                          (rectangle 7 0 'solid 'pink) 
                                                          (triangle 15 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (fifth (inventory-equipment (send (store-player s) get-inventory)))) 1)
                                                  (beside (rotate 90 (triangle 40 'solid 'black))
                                                          (overlay
                                                           (overlay/align "left" "middle"
                                                                          (beside 
                                                                           (rectangle 5 0 'solid 'pink)
                                                                           (rectangle 10 0 'solid 'pink)
                                                                           (send (first (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                          (place-image
                                                                           (above (text (send (first (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                                  (text (send (first (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                                  (text (string-append "Value: " (number->string (send (first (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                           208 45
                                                                           (rectangle 340 90 'solid (make-color 80 80 80))))
                                                           (rectangle 350 100 'solid 'black)) (rotate 270 (triangle 40 'solid 'black)))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (fifth (inventory-equipment (send (store-player s) get-inventory)))) 2)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (second (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (second (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                          (text (send (second (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (second (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (fifth (inventory-equipment (send (store-player s) get-inventory)))) 3)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (third (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                          (text (send (third (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (third (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (fifth (inventory-equipment (send (store-player s) get-inventory)))) 4)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-image))
                                                                  (place-image
                                                                   (above (text (send (fourth (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-name) 18 'black)
                                                                          (text (send (fourth (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (fourth (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink)))]
                                      [(symbol=? (store-sym s) 'c)
                                       (above (if (>= (length (inventory-consumables (send (store-player s) get-inventory))) 5)
                                                  (beside (rotate 180 (triangle 15 'solid 'black))
                                                          (rectangle 7 0 'solid 'pink)  
                                                          (rectangle 7 0 'solid 'pink) 
                                                          (triangle 15 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (inventory-consumables (send (store-player s) get-inventory))) 1)
                                                          (beside (rotate 90 (triangle 40 'solid 'black))
                                                          (overlay
                                                           (overlay/align "left" "middle"
                                                                          (beside 
                                                                           (rectangle 5 0 'solid 'pink)
                                                                           (rectangle 10 0 'solid 'pink)
                                                                           (send (first (inventory-consumables (send (store-player s) get-inventory))) get-image))
                                                                          (place-image
                                                                           (above (text (send (first (inventory-consumables (send (store-player s) get-inventory))) get-name) 18 'black)
                                                                                  (text (send (first (inventory-consumables (send (store-player s) get-inventory))) get-description) 15 'black)
                                                                                  (text (string-append "Value: " (number->string (send (first (inventory-consumables (send (store-player s) get-inventory))) get-value))) 18 'black))
                                                                           208 45
                                                                           (rectangle 340 90 'solid (make-color 80 80 80)))) (rectangle 350 100 'solid 'black))
                                                          (rotate 270 (triangle 40 'solid 'black)))
                                                          (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (inventory-consumables (send (store-player s) get-inventory))) 2)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (second (inventory-consumables (send (store-player s) get-inventory))) get-image))
                                                                  (place-image
                                                                   (above (text (send (second (inventory-consumables (send (store-player s) get-inventory))) get-name) 18 'black)
                                                                          (text (send (second (inventory-consumables (send (store-player s) get-inventory))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (second (inventory-consumables (send (store-player s) get-inventory))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (inventory-consumables (send (store-player s) get-inventory))) 3)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (inventory-consumables (send (store-player s) get-inventory))) get-image))
                                                                  (place-image
                                                                   (above (text (send (third (inventory-consumables (send (store-player s) get-inventory))) get-name) 18 'black)
                                                                          (text (send (third (inventory-consumables (send (store-player s) get-inventory))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (third (inventory-consumables (send (store-player s) get-inventory))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (inventory-consumables (send (store-player s) get-inventory))) 4)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (inventory-consumables (send (store-player s) get-inventory))) get-image))
                                                                  (place-image
                                                                   (above (text (send (fourth (inventory-consumables (send (store-player s) get-inventory))) get-name) 18 'black)
                                                                          (text (send (fourth (inventory-consumables (send (store-player s) get-inventory))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (fourth (inventory-consumables (send (store-player s) get-inventory))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink)))]
                                      [(symbol=? (store-sym s) 'm) 
                                       (above (if (>= (length (inventory-miscellaneous (send (store-player s) get-inventory))) 5)
                                                  (beside (rotate 180 (triangle 15 'solid 'black))
                                                          (rectangle 7 0 'solid 'pink)  
                                                          (rectangle 7 0 'solid 'pink) 
                                                          (triangle 15 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (inventory-miscellaneous (send (store-player s) get-inventory))) 1)
                                                  (beside (rotate 90 (triangle 40 'solid 'black))
                                                          (overlay
                                                           (overlay/align "left" "middle"
                                                                          (beside 
                                                                           (rectangle 5 0 'solid 'pink)
                                                                           (rectangle 10 0 'solid 'pink)
                                                                           (send (first (inventory-miscellaneous (send (store-player s) get-inventory))) get-image))
                                                                          (place-image
                                                                           (above (text (send (first (inventory-miscellaneous (send (store-player s) get-inventory))) get-name) 18 'black)
                                                                                  (text (send (first (inventory-miscellaneous (send (store-player s) get-inventory))) get-description) 15 'black)
                                                                                  (text (string-append "Value: " (number->string (send (first (inventory-miscellaneous (send (store-player s) get-inventory))) get-value))) 18 'black))
                                                                           208 45
                                                                           (rectangle 340 90 'solid (make-color 80 80 80))))
                                                           (rectangle 350 100 'solid 'black)) (rotate 270 (triangle 40 'solid 'black)))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (inventory-miscellaneous (send (store-player s) get-inventory))) 2)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (second (inventory-miscellaneous (send (store-player s) get-inventory))) get-image))
                                                                  (place-image
                                                                   (above (text (send (second (inventory-miscellaneous (send (store-player s) get-inventory))) get-name) 18 'black)
                                                                          (text (send (second (inventory-miscellaneous (send (store-player s) get-inventory))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (second (inventory-miscellaneous (send (store-player s) get-inventory))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (inventory-miscellaneous (send (store-player s) get-inventory))) 3)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (third (inventory-miscellaneous (send (store-player s) get-inventory))) get-image))
                                                                  (place-image
                                                                   (above (text (send (third (inventory-miscellaneous (send (store-player s) get-inventory))) get-name) 18 'black)
                                                                          (text (send (third (inventory-miscellaneous (send (store-player s) get-inventory))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (third (inventory-miscellaneous (send (store-player s) get-inventory))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink))
                                              (rectangle 0 15 'solid 'pink)
                                              (if (>= (length (inventory-miscellaneous (send (store-player s) get-inventory))) 4)
                                                  (overlay
                                                   (overlay/align "left" "middle"
                                                                  (beside 
                                                                   (rectangle 5 0 'solid 'pink)
                                                                   (rectangle 10 0 'solid 'pink)
                                                                   (send (fourth (inventory-miscellaneous (send (store-player s) get-inventory))) get-image))
                                                                  (place-image
                                                                   (above (text (send (fourth (inventory-miscellaneous (send (store-player s) get-inventory))) get-name) 18 'black)
                                                                          (text (send (fourth (inventory-miscellaneous (send (store-player s) get-inventory))) get-description) 15 'black)
                                                                          (text (string-append "Value: " (number->string (send (fourth (inventory-miscellaneous (send (store-player s) get-inventory))) get-value))) 18 'black))
                                                                   208 45
                                                                   (rectangle 340 90 'solid (make-color 80 80 80))))
                                                   (rectangle 350 100 'solid 'black))
                                                  (square 0 'solid 'pink)))]))
                             (overlay
                              (rectangle 800 620 'solid 'gray)
                              (rectangle 810 630 'solid 'black))))]
    [else (square 50 'solid 'red)]))



;; handle-store-key: store, key --> world
(define (handle-store-key s k)
  (cond
    [(= (store-num s) 0)
     (cond
       [(or (key=? k "3")
            (key=? k "escape"))
        (superset dungeon-music)
        (make-dungeon (store-player s)
                      (cons (get-room (get-dungeon (store-dungeon s)) (store-room s))
                            (filter (lambda (x) (not (string=? (room-name x) (store-room s))))
                                    (dungeon-rooms (get-dungeon (store-dungeon s)))))
                      empty (store-dungeon s) empty)]
       [(key=? k "2") (make-store (store-player s) (store-inventory s) 2 (store-sym s) (store-dungeon s) (store-room s))]
       [(key=? k "1") (make-store (store-player s) (store-inventory s) 1 (store-sym s) (store-dungeon s) (store-room s))]
       [else s])]
    [(= (store-num s) 1)
     (cond
       [(key=? k "escape") (make-store (store-player s) (store-inventory s) 0 (store-sym s) (store-dungeon s) (store-room s))]
       [(key=? k "d") (make-store (store-player s) (store-inventory s) 1 (cond
                                                                           [(symbol=? (store-sym s) 'c) 'w]
                                                                           [(symbol=? (store-sym s) 'w) 'h]
                                                                           [(symbol=? (store-sym s) 'h) 'b]
                                                                           [(symbol=? (store-sym s) 'b) 'a]
                                                                           [(symbol=? (store-sym s) 'a) 'l]
                                                                           [(symbol=? (store-sym s) 'l) 'm]
                                                                           [(symbol=? (store-sym s) 'm) 'c]) (store-dungeon s) (store-room s))]
       [(key=? k "a") (make-store (store-player s) (store-inventory s) 1 (cond
                                                                           [(symbol=? (store-sym s) 'c) 'm]
                                                                           [(symbol=? (store-sym s) 'w) 'c]
                                                                           [(symbol=? (store-sym s) 'h) 'w]
                                                                           [(symbol=? (store-sym s) 'b) 'h]
                                                                           [(symbol=? (store-sym s) 'a) 'b]
                                                                           [(symbol=? (store-sym s) 'l) 'a]
                                                                           [(symbol=? (store-sym s) 'm) 'l]) (store-dungeon s) (store-room s))]
       [(key=? k "\r") (make-store (cond
                                     [(symbol=? (store-sym s) 'c)
                                      (if (>= (send (first 
                                                     (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                             (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                    get-number)
                                              (send (first (inventory-consumables (store-inventory s))) get-value))
                                          (send (store-player s) clone
                                                #:character-inventory (make-inventory (inventory-weapon (send (store-player s) get-inventory))
                                                                                      (inventory-equiped (send (store-player s) get-inventory))
                                                                                      (inventory-equipment (send (store-player s) get-inventory))
                                                                                      (if (not (empty? (filter (lambda (x) (string=? (send x get-name)
                                                                                                                                     (send (first (inventory-consumables (store-inventory s))) get-name)))
                                                                                                               (inventory-consumables (send (store-player s) get-inventory)))))
                                                                                          (cons
                                                                                           (send (first (filter (lambda (x) (string=? (send x get-name)
                                                                                                                                      (send (first (inventory-consumables (store-inventory s))) get-name)))
                                                                                                                (inventory-consumables (send (store-player s) get-inventory))))
                                                                                                 clone
                                                                                                 #:number (+ 1 (send (first (filter (lambda (x) (string=? (send x get-name)
                                                                                                                                                          (send (first (inventory-consumables (store-inventory s))) get-name)))
                                                                                                                                    (inventory-consumables (send (store-player s) get-inventory)))) get-number)))
                                                                                           (filter (lambda (x) (not (string=? (send x get-name)
                                                                                                                              (send (first (inventory-consumables (store-inventory s))) get-name))))
                                                                                                   (inventory-consumables (send (store-player s) get-inventory))))
                                                                                          (cons
                                                                                           (send (first (inventory-consumables (store-inventory s))) clone #:number 1)
                                                                                           (inventory-consumables (send (store-player s) get-inventory))))
                                                                                      (cons
                                                                                       (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                            (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                                                             clone #:number (- (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                                                    (inventory-miscellaneous (send (store-player s) get-inventory)))) get-number)
                                                                                                               (send (first (inventory-consumables (store-inventory s))) get-value)))
                                                                                       (filter (lambda (x) (not (string=? (send x get-name) "Gold"))) 
                                                                                               (inventory-miscellaneous (send (store-player s) get-inventory))))))
                                          (store-player s))]
                                     [(symbol=? (store-sym s) 'w)
                                      (if (>= (send (first 
                                                     (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                             (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                    get-number)
                                              (send (first (first (inventory-equipment (store-inventory s)))) get-value))
                                          (send (store-player s) clone
                                                #:character-inventory (make-inventory (inventory-weapon (send (store-player s) get-inventory))
                                                                                      (inventory-equiped (send (store-player s) get-inventory))
                                                                                           (list
                                                                                            (cons (first (first (inventory-equipment (store-inventory s))))     
                                                                                            (first (inventory-equipment (send (store-player s) get-inventory))))
                                                                                            (second (inventory-equipment (send (store-player s) get-inventory)))
                                                                                            (third (inventory-equipment (send (store-player s) get-inventory)))
                                                                                            (fourth (inventory-equipment (send (store-player s) get-inventory)))
                                                                                            (fifth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                           (inventory-consumables (send (store-player s) get-inventory))
                                                                                      (cons
                                                                                       (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                            (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                                                             clone #:number (- (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                                                    (inventory-miscellaneous (send (store-player s) get-inventory)))) get-number)
                                                                                                               (send (first (first (inventory-equipment (store-inventory s)))) get-value)))
                                                                                       (filter (lambda (x) (not (string=? (send x get-name) "Gold")))
                                                                                               (inventory-miscellaneous (send (store-player s) get-inventory))))))
                                          (store-player s))]
                                     [(symbol=? (store-sym s) 'h)
                                      (if (>= (send (first 
                                                     (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                             (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                    get-number)
                                              (send (first (second (inventory-equipment (store-inventory s)))) get-value))
                                          (send (store-player s) clone
                                                #:character-inventory (make-inventory (inventory-weapon (send (store-player s) get-inventory))
                                                                                      (inventory-equiped (send (store-player s) get-inventory))
                                                                                           (list
                                                                                            (first (inventory-equipment (send (store-player s) get-inventory)))
                                                                                            (cons (first (second (inventory-equipment (store-inventory s))))     
                                                                                            (second (inventory-equipment (send (store-player s) get-inventory))))
                                                                                            (third (inventory-equipment (send (store-player s) get-inventory)))
                                                                                            (fourth (inventory-equipment (send (store-player s) get-inventory)))
                                                                                            (fifth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                           (inventory-consumables (send (store-player s) get-inventory))
                                                                                      (cons
                                                                                       (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                            (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                                                             clone #:number (- (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                                                    (inventory-miscellaneous (send (store-player s) get-inventory)))) get-number)
                                                                                                               (send (first (second (inventory-equipment (store-inventory s)))) get-value)))
                                                                                       (filter (lambda (x) (not (string=? (send x get-name) "Gold")))
                                                                                               (inventory-miscellaneous (send (store-player s) get-inventory))))))
                                          (store-player s))]
                                     [(symbol=? (store-sym s) 'b)
                                      (if (>= (send (first 
                                                     (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                             (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                    get-number)
                                              (send (first (third (inventory-equipment (store-inventory s)))) get-value))
                                          (send (store-player s) clone
                                                #:character-inventory (make-inventory (inventory-weapon (send (store-player s) get-inventory))
                                                                                      (inventory-equiped (send (store-player s) get-inventory))
                                                                                           (list
                                                                                            (first (inventory-equipment (send (store-player s) get-inventory)))
                                                                                            (second (inventory-equipment (send (store-player s) get-inventory)))
                                                                                            (cons (first (third (inventory-equipment (store-inventory s))))     
                                                                                            (third (inventory-equipment (send (store-player s) get-inventory))))
                                                                                            (fourth (inventory-equipment (send (store-player s) get-inventory)))
                                                                                            (fifth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                           (inventory-consumables (send (store-player s) get-inventory))
                                                                                      (cons
                                                                                       (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                            (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                                                             clone #:number (- (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                                                    (inventory-miscellaneous (send (store-player s) get-inventory)))) get-number)
                                                                                                               (send (first (third (inventory-equipment (store-inventory s)))) get-value)))
                                                                                       (filter (lambda (x) (not (string=? (send x get-name) "Gold")))
                                                                                               (inventory-miscellaneous (send (store-player s) get-inventory))))))
                                          (store-player s))]
                                     [(symbol=? (store-sym s) 'a)
                                      (if (>= (send (first 
                                                     (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                             (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                    get-number)
                                              (send (first (fourth (inventory-equipment (store-inventory s)))) get-value))
                                          (send (store-player s) clone
                                                #:character-inventory (make-inventory (inventory-weapon (send (store-player s) get-inventory))
                                                                                      (inventory-equiped (send (store-player s) get-inventory))
                                                                                           (list
                                                                                            (first (inventory-equipment (send (store-player s) get-inventory)))
                                                                                            (second (inventory-equipment (send (store-player s) get-inventory)))
                                                                                            (third (inventory-equipment (send (store-player s) get-inventory)))
                                                                                            (cons (first (fourth (inventory-equipment (store-inventory s))))     
                                                                                            (fourth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                            (fifth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                           (inventory-consumables (send (store-player s) get-inventory))
                                                                                      (cons
                                                                                       (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                            (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                                                             clone #:number (- (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                                                    (inventory-miscellaneous (send (store-player s) get-inventory)))) get-number)
                                                                                                               (send (first (fourth (inventory-equipment (store-inventory s)))) get-value)))
                                                                                       (filter (lambda (x) (not (string=? (send x get-name) "Gold")))
                                                                                               (inventory-miscellaneous (send (store-player s) get-inventory))))))
                                          (store-player s))]
                                     [(symbol=? (store-sym s) 'l)
                                      (if (>= (send (first 
                                                     (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                             (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                    get-number)
                                              (send (first (fifth (inventory-equipment (store-inventory s)))) get-value))
                                          (send (store-player s) clone
                                                #:character-inventory (make-inventory (inventory-weapon (send (store-player s) get-inventory))
                                                                                      (inventory-equiped (send (store-player s) get-inventory))
                                                                                           (list
                                                                                            (first (inventory-equipment (send (store-player s) get-inventory)))
                                                                                            (second (inventory-equipment (send (store-player s) get-inventory)))
                                                                                            (third (inventory-equipment (send (store-player s) get-inventory)))
                                                                                            (fourth (inventory-equipment (send (store-player s) get-inventory)))
                                                                                            (cons (first (fifth (inventory-equipment (store-inventory s))))     
                                                                                            (fifth (inventory-equipment (send (store-player s) get-inventory)))))
                                                                                           (inventory-consumables (send (store-player s) get-inventory))
                                                                                      (cons
                                                                                       (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                            (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                                                             clone #:number (- (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                                                    (inventory-miscellaneous (send (store-player s) get-inventory)))) get-number)
                                                                                                               (send (first (fifth (inventory-equipment (store-inventory s)))) get-value)))
                                                                                       (filter (lambda (x) (not (string=? (send x get-name) "Gold")))
                                                                                               (inventory-miscellaneous (send (store-player s) get-inventory))))))
                                          (store-player s))]
                                     [(symbol=? (store-sym s) 'm)
                                      (if (>= (send (first 
                                                     (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                             (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                    get-number)
                                              (send (first (inventory-miscellaneous (store-inventory s))) get-value))
                                          (send (store-player s) clone
                                                #:character-inventory (make-inventory (inventory-weapon (send (store-player s) get-inventory))
                                                                                      (inventory-equiped (send (store-player s) get-inventory))
                                                                                      (inventory-equipment (send (store-player s) get-inventory))
                                                                                      (inventory-consumables (send (store-player s) get-inventory))
                                                                                      (cons
                                                                                       (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                            (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                                                             clone #:number (- (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                                                    (inventory-miscellaneous (send (store-player s) get-inventory)))) get-number)
                                                                                                               (send (first (inventory-miscellaneous (store-inventory s))) get-value)))
                                                                                       (cons
                                                                                        (first (inventory-miscellaneous (store-inventory s)))
                                                                                       (filter (lambda (x) (not (string=? (send x get-name) "Gold")))
                                                                                               (inventory-miscellaneous (send (store-player s) get-inventory)))))))
                                          (store-player s))]
                                     [else (store-player s)])
                                   (store-inventory s) 1 (store-sym s) (store-dungeon s) (store-room s))]
       [(key=? k "s") (make-store (store-player s)  (cond
                                                      [(symbol=? (store-sym s) 'c) (make-inventory empty empty (inventory-equipment (store-inventory s))
                                                                                                   (append (rest (inventory-consumables (store-inventory s)))
                                                                                                           (list (first (inventory-consumables (store-inventory s)))))
                                                                                                   (inventory-miscellaneous (store-inventory s)))]
                                                      [(symbol=? (store-sym s) 'w) (make-inventory empty empty
                                                                                                   (list
                                                                                                    (append (rest (first (inventory-equipment (store-inventory s))))
                                                                                                            (list (first (first (inventory-equipment (store-inventory s))))))
                                                                                                    (second (inventory-equipment (store-inventory s)))
                                                                                                    (third (inventory-equipment (store-inventory s)))
                                                                                                    (fourth (inventory-equipment (store-inventory s)))
                                                                                                    (fifth (inventory-equipment (store-inventory s))))
                                                                                                   (inventory-consumables (store-inventory s))
                                                                                                   (inventory-miscellaneous (store-inventory s)))]
                                                      [(symbol=? (store-sym s) 'h) (make-inventory empty empty
                                                                                                   (list
                                                                                                    (first (inventory-equipment (store-inventory s)))
                                                                                                    (append (rest (second (inventory-equipment (store-inventory s))))
                                                                                                            (list (first (second (inventory-equipment (store-inventory s))))))
                                                                                                    (third (inventory-equipment (store-inventory s)))
                                                                                                    (fourth (inventory-equipment (store-inventory s)))
                                                                                                    (fifth (inventory-equipment (store-inventory s))))
                                                                                                   (inventory-consumables (store-inventory s))
                                                                                                   (inventory-miscellaneous (store-inventory s)))]
                                                      [(symbol=? (store-sym s) 'b) (make-inventory empty empty
                                                                                                   (list
                                                                                                    (first (inventory-equipment (store-inventory s)))
                                                                                                    (second (inventory-equipment (store-inventory s)))
                                                                                                    (append (rest (third (inventory-equipment (store-inventory s))))
                                                                                                            (list (first (third (inventory-equipment (store-inventory s))))))
                                                                                                    (fourth (inventory-equipment (store-inventory s)))
                                                                                                    (fifth (inventory-equipment (store-inventory s))))
                                                                                                   (inventory-consumables (store-inventory s))
                                                                                                   (inventory-miscellaneous (store-inventory s)))]
                                                      [(symbol=? (store-sym s) 'a) (make-inventory empty empty
                                                                                                   (list
                                                                                                    (first (inventory-equipment (store-inventory s)))
                                                                                                    (second (inventory-equipment (store-inventory s)))
                                                                                                    (third (inventory-equipment (store-inventory s)))
                                                                                                    (append (rest (fourth (inventory-equipment (store-inventory s))))
                                                                                                            (list (first (fourth (inventory-equipment (store-inventory s))))))
                                                                                                    (fifth (inventory-equipment (store-inventory s))))
                                                                                                   (inventory-consumables (store-inventory s))
                                                                                                   (inventory-miscellaneous (store-inventory s)))]
                                                      [(symbol=? (store-sym s) 'l) (make-inventory empty empty
                                                                                                   (list
                                                                                                    (first (inventory-equipment (store-inventory s)))
                                                                                                    (second (inventory-equipment (store-inventory s)))
                                                                                                    (third (inventory-equipment (store-inventory s)))
                                                                                                    (fourth (inventory-equipment (store-inventory s)))
                                                                                                    (append (rest (fifth (inventory-equipment (store-inventory s))))
                                                                                                            (list (first (fifth (inventory-equipment (store-inventory s)))))))
                                                                                                   (inventory-consumables (store-inventory s))
                                                                                                   (inventory-miscellaneous (store-inventory s)))]
                                                      [(symbol=? (store-sym s) 'm) (make-inventory empty empty
                                                                                                   (inventory-equipment (store-inventory s))
                                                                                                   (inventory-consumables (store-inventory s))
                                                                                                   (append
                                                                                                    (rest (inventory-miscellaneous (store-inventory s)))
                                                                                                    (list (first (inventory-miscellaneous (store-inventory s))))))])
                                  1 (store-sym s) (store-dungeon s) (store-room s))]
       [(key=? k "w") (make-store (store-player s)  (cond
                                                      [(symbol=? (store-sym s) 'c) (make-inventory empty empty (inventory-equipment (store-inventory s))
                                                                                                   (append (list (first (reverse (inventory-consumables (store-inventory s)))))
                                                                                                           (reverse (rest (reverse (inventory-consumables (store-inventory s))))))
                                                                                                   (inventory-miscellaneous (store-inventory s)))]
                                                      [(symbol=? (store-sym s) 'w) (make-inventory empty empty
                                                                                                   (list
                                                                                                    (append
                                                                                                     (list (first (reverse (first (inventory-equipment (store-inventory s))))))
                                                                                                     (reverse (rest (reverse (first (inventory-equipment (store-inventory s)))))))
                                                                                                    (second (inventory-equipment (store-inventory s)))
                                                                                                    (third (inventory-equipment (store-inventory s)))
                                                                                                    (fourth (inventory-equipment (store-inventory s)))
                                                                                                    (fifth (inventory-equipment (store-inventory s))))
                                                                                                   (inventory-consumables (store-inventory s))
                                                                                                   (inventory-miscellaneous (store-inventory s)))]
                                                      [(symbol=? (store-sym s) 'h) (make-inventory empty empty
                                                                                                   (list
                                                                                                    (first (inventory-equipment (store-inventory s)))
                                                                                                    (append
                                                                                                     (list (first (reverse (second (inventory-equipment (store-inventory s))))))
                                                                                                     (reverse (rest (reverse (second (inventory-equipment (store-inventory s)))))))
                                                                                                    (third (inventory-equipment (store-inventory s)))
                                                                                                    (fourth (inventory-equipment (store-inventory s)))
                                                                                                    (fifth (inventory-equipment (store-inventory s))))
                                                                                                   (inventory-consumables (store-inventory s))
                                                                                                   (inventory-miscellaneous (store-inventory s)))]
                                                      [(symbol=? (store-sym s) 'b) (make-inventory empty empty
                                                                                                   (list
                                                                                                    (first (inventory-equipment (store-inventory s)))
                                                                                                    (second (inventory-equipment (store-inventory s)))
                                                                                                    (append
                                                                                                     (list (first (reverse (third (inventory-equipment (store-inventory s))))))
                                                                                                     (reverse (rest (reverse (third (inventory-equipment (store-inventory s)))))))
                                                                                                    (fourth (inventory-equipment (store-inventory s)))
                                                                                                    (fifth (inventory-equipment (store-inventory s))))
                                                                                                   (inventory-consumables (store-inventory s))
                                                                                                   (inventory-miscellaneous (store-inventory s)))]
                                                      [(symbol=? (store-sym s) 'a) (make-inventory empty empty
                                                                                                   (list
                                                                                                    (first (inventory-equipment (store-inventory s)))
                                                                                                    (second (inventory-equipment (store-inventory s)))
                                                                                                    (third (inventory-equipment (store-inventory s)))
                                                                                                    (append
                                                                                                     (list (first (reverse (fourth (inventory-equipment (store-inventory s))))))
                                                                                                     (reverse (rest (reverse (fourth (inventory-equipment (store-inventory s)))))))
                                                                                                    (fifth (inventory-equipment (store-inventory s))))
                                                                                                   (inventory-consumables (store-inventory s))
                                                                                                   (inventory-miscellaneous (store-inventory s)))]
                                                      [(symbol=? (store-sym s) 'l) (make-inventory empty empty
                                                                                                   (list
                                                                                                    (first (inventory-equipment (store-inventory s)))
                                                                                                    (second (inventory-equipment (store-inventory s)))
                                                                                                    (third (inventory-equipment (store-inventory s)))
                                                                                                    (fourth (inventory-equipment (store-inventory s)))
                                                                                                    (append
                                                                                                     (list (first (reverse (fifth (inventory-equipment (store-inventory s))))))
                                                                                                     (reverse (rest (reverse (fifth (inventory-equipment (store-inventory s))))))))
                                                                                                   (inventory-consumables (store-inventory s))
                                                                                                   (inventory-miscellaneous (store-inventory s)))]
                                                      [(symbol=? (store-sym s) 'm) (make-inventory empty empty
                                                                                                   (inventory-equipment (store-inventory s))
                                                                                                   (inventory-consumables (store-inventory s))
                                                                                                   (append
                                                                                                    (list (first (reverse (inventory-miscellaneous (store-inventory s)))))
                                                                                                    (reverse (rest (reverse (inventory-miscellaneous (store-inventory s)))))))])
                                  1 (store-sym s) (store-dungeon s) (store-room s))]
       [else s])]
    [(= (store-num s) 2)
     (cond
       [(key=? k "escape") (make-store (store-player s) (store-inventory s) 0 (store-sym s) (store-dungeon s) (store-room s))]
       [(key=? k "d") (make-store (store-player s) (store-inventory s) 2 (cond
                                                                           [(symbol=? (store-sym s) 'c) 'w]
                                                                           [(symbol=? (store-sym s) 'w) 'h]
                                                                           [(symbol=? (store-sym s) 'h) 'b]
                                                                           [(symbol=? (store-sym s) 'b) 'a]
                                                                           [(symbol=? (store-sym s) 'a) 'l]
                                                                           [(symbol=? (store-sym s) 'l) 'm]
                                                                           [(symbol=? (store-sym s) 'm) 'c]) (store-dungeon s) (store-room s))]
       [(key=? k "a") (make-store (store-player s) (store-inventory s) 2 (cond
                                                                           [(symbol=? (store-sym s) 'c) 'm]
                                                                           [(symbol=? (store-sym s) 'w) 'c]
                                                                           [(symbol=? (store-sym s) 'h) 'w]
                                                                           [(symbol=? (store-sym s) 'b) 'h]
                                                                           [(symbol=? (store-sym s) 'a) 'b]
                                                                           [(symbol=? (store-sym s) 'l) 'a]
                                                                           [(symbol=? (store-sym s) 'm) 'l]) (store-dungeon s) (store-room s))]
       [(key=? k "\r") (make-store (cond
                                     [(symbol=? (store-sym s) 'c)
                                          (if (not (empty? (inventory-consumables (send (store-player s) get-inventory))))
                                              (send (store-player s) clone
                                                #:character-inventory (make-inventory (inventory-weapon (send (store-player s) get-inventory))
                                                                                      (inventory-equiped (send (store-player s) get-inventory))
                                                                                      (inventory-equipment (send (store-player s) get-inventory))
                                                                                      (if (> (send (first (inventory-consumables (send (store-player s) get-inventory))) get-number) 1)
                                                                                          (cons
                                                                                           (send (first (inventory-consumables (send (store-player s) get-inventory)))
                                                                                                 clone
                                                                                                 #:number (- (send (first (inventory-consumables (send (store-player s) get-inventory))) get-number) 1))
                                                                                           (rest (inventory-consumables (send (store-player s) get-inventory))))
                                                                                          (rest (inventory-consumables (send (store-player s) get-inventory))))
                                                                                      (cons
                                                                                       (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                            (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                                                             clone #:number (+ (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                                                    (inventory-miscellaneous (send (store-player s) get-inventory)))) get-number)
                                                                                                               (send (first (inventory-consumables (send (store-player s) get-inventory))) get-value)))
                                                                                       (filter (lambda (x) (not (string=? (send x get-name) "Gold"))) 
                                                                                               (inventory-miscellaneous (send (store-player s) get-inventory))))))
                                              (store-player s))]
                                     [(symbol=? (store-sym s) 'w)
                                      (if (not (empty? (first (inventory-equipment (send (store-player s) get-inventory)))))
                                          (send (store-player s) clone
                                                #:character-inventory (make-inventory (inventory-weapon (send (store-player s) get-inventory))
                                                                                      (inventory-equiped (send (store-player s) get-inventory))
                                                                                      (cons
                                                                                       (rest (first (inventory-equipment (send (store-player s) get-inventory))))
                                                                                       (rest (inventory-equipment (send (store-player s) get-inventory))))
                                                                                      (inventory-consumables (send (store-player s) get-inventory))
                                                                                      (cons
                                                                                       (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                            (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                                                             clone #:number (+ (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                                                    (inventory-miscellaneous (send (store-player s) get-inventory)))) get-number)
                                                                                                               (send (first (first (inventory-equipment (send (store-player s) get-inventory)))) get-value)))
                                                                                       (filter (lambda (x) (not (string=? (send x get-name) "Gold"))) 
                                                                                               (inventory-miscellaneous (send (store-player s) get-inventory))))))
                                          (store-player s))]
                                     [(symbol=? (store-sym s) 'h)
                                      (if (not (empty? (second (inventory-equipment (send (store-player s) get-inventory)))))
                                          (send (store-player s) clone
                                                #:character-inventory (make-inventory (inventory-weapon (send (store-player s) get-inventory))
                                                                                      (inventory-equiped (send (store-player s) get-inventory))
                                                                                      (append
                                                                                       (list (first (inventory-equipment (send (store-player s) get-inventory)))
                                                                                             (rest (second (inventory-equipment (send (store-player s) get-inventory)))))
                                                                                       (rest (rest (inventory-equipment (send (store-player s) get-inventory)))))
                                                                                      (inventory-consumables (send (store-player s) get-inventory))
                                                                                      (cons
                                                                                       (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                            (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                                                             clone #:number (+ (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                                                    (inventory-miscellaneous (send (store-player s) get-inventory)))) get-number)
                                                                                                               (send (first (second (inventory-equipment (send (store-player s) get-inventory)))) get-value)))
                                                                                       (filter (lambda (x) (not (string=? (send x get-name) "Gold"))) 
                                                                                               (inventory-miscellaneous (send (store-player s) get-inventory))))))
                                          (store-player s))]
                                     [(symbol=? (store-sym s) 'b)
                                      (if (not (empty? (third (inventory-equipment (send (store-player s) get-inventory)))))
                                          (send (store-player s) clone
                                                #:character-inventory (make-inventory (inventory-weapon (send (store-player s) get-inventory))
                                                                                      (inventory-equiped (send (store-player s) get-inventory))
                                                                                       (list (first (inventory-equipment (send (store-player s) get-inventory)))
                                                                                             (second (inventory-equipment (send (store-player s) get-inventory)))
                                                                                             (rest (third (inventory-equipment (send (store-player s) get-inventory))))
                                                                                             (fourth (inventory-equipment (send (store-player s) get-inventory)))
                                                                                             (fifth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                      (inventory-consumables (send (store-player s) get-inventory))
                                                                                      (cons
                                                                                       (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                            (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                                                             clone #:number (+ (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                                                    (inventory-miscellaneous (send (store-player s) get-inventory)))) get-number)
                                                                                                               (send (first (third (inventory-equipment (send (store-player s) get-inventory)))) get-value)))
                                                                                       (filter (lambda (x) (not (string=? (send x get-name) "Gold"))) 
                                                                                               (inventory-miscellaneous (send (store-player s) get-inventory))))))
                                          (store-player s))]
                                     [(symbol=? (store-sym s) 'a)
                                      (if (not (empty? (fourth (inventory-equipment (send (store-player s) get-inventory)))))
                                          (send (store-player s) clone
                                                #:character-inventory (make-inventory (inventory-weapon (send (store-player s) get-inventory))
                                                                                      (inventory-equiped (send (store-player s) get-inventory))
                                                                                       (list (first (inventory-equipment (send (store-player s) get-inventory)))
                                                                                             (second (inventory-equipment (send (store-player s) get-inventory)))
                                                                                             (third (inventory-equipment (send (store-player s) get-inventory)))
                                                                                             (rest (fourth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                             (fifth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                      (inventory-consumables (send (store-player s) get-inventory))
                                                                                      (cons
                                                                                       (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                            (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                                                             clone #:number (+ (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                                                    (inventory-miscellaneous (send (store-player s) get-inventory)))) get-number)
                                                                                                               (send (first (fourth (inventory-equipment (send (store-player s) get-inventory)))) get-value)))
                                                                                       (filter (lambda (x) (not (string=? (send x get-name) "Gold"))) 
                                                                                               (inventory-miscellaneous (send (store-player s) get-inventory))))))
                                          (store-player s))]
                                     [(symbol=? (store-sym s) 'l)
                                      (if (not (empty? (fifth (inventory-equipment (send (store-player s) get-inventory)))))
                                          (send (store-player s) clone
                                                #:character-inventory (make-inventory (inventory-weapon (send (store-player s) get-inventory))
                                                                                      (inventory-equiped (send (store-player s) get-inventory))
                                                                                       (list (first (inventory-equipment (send (store-player s) get-inventory)))
                                                                                             (second (inventory-equipment (send (store-player s) get-inventory)))
                                                                                             (third (inventory-equipment (send (store-player s) get-inventory)))
                                                                                             (fourth (inventory-equipment (send (store-player s) get-inventory)))
                                                                                             (rest (fifth (inventory-equipment (send (store-player s) get-inventory)))))
                                                                                      (inventory-consumables (send (store-player s) get-inventory))
                                                                                      (cons
                                                                                       (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                            (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                                                             clone #:number (+ (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                                                    (inventory-miscellaneous (send (store-player s) get-inventory)))) get-number)
                                                                                                               (send (first (fifth (inventory-equipment (send (store-player s) get-inventory)))) get-value)))
                                                                                       (filter (lambda (x) (not (string=? (send x get-name) "Gold"))) 
                                                                                               (inventory-miscellaneous (send (store-player s) get-inventory))))))
                                          (store-player s))]
                                     [(symbol=? (store-sym s) 'm)
                                      (if (and
                                           (not (empty? (rest (inventory-miscellaneous (send (store-player s) get-inventory)))))
                                           (not (string=? (send (first (inventory-miscellaneous (send (store-player s) get-inventory))) get-name) "Gold")))
                                          (send (store-player s) clone
                                                #:character-inventory (make-inventory (inventory-weapon (send (store-player s) get-inventory))
                                                                                      (inventory-equiped (send (store-player s) get-inventory))
                                                                                       (inventory-equipment (send (store-player s) get-inventory))
                                                                                       (inventory-consumables (send (store-player s) get-inventory))
                                                                                      (append
                                                                                       (list (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                            (inventory-miscellaneous (send (store-player s) get-inventory))))
                                                                                             clone #:number (+ (send (first (filter (lambda (x) (string=? (send x get-name) "Gold")) 
                                                                                                                                    (inventory-miscellaneous (send (store-player s) get-inventory)))) get-number)
                                                                                                               (send (first (inventory-miscellaneous (send (store-player s) get-inventory))) get-value))))
                                                                                       (filter (lambda (x) (not (string=? (send x get-name) "Gold"))) 
                                                                                               (rest (inventory-miscellaneous (send (store-player s) get-inventory)))))))
                                          (store-player s))]
                                     
                                     [else (store-player s)])
                                   (store-inventory s) 2 (store-sym s) (store-dungeon s) (store-room s))]
       [(key=? k "s") (make-store (send (store-player s)
                                        clone #:character-inventory
                                        (cond
                                                      [(symbol=? (store-sym s) 'c) (make-inventory (inventory-weapon (send (store-player s) get-inventory)) (inventory-equiped (send (store-player s) get-inventory)) (inventory-equipment (send (store-player s) get-inventory))
                                                                                                   (append (rest (inventory-consumables (send (store-player s) get-inventory)))
                                                                                                           (list (first (inventory-consumables (send (store-player s) get-inventory)))))
                                                                                                   (inventory-miscellaneous (send (store-player s) get-inventory)))]
                                                      [(symbol=? (store-sym s) 'w) (make-inventory (inventory-weapon (send (store-player s) get-inventory)) (inventory-equiped (send (store-player s) get-inventory))
                                                                                                   (list
                                                                                                    (append (rest (first (inventory-equipment (send (store-player s) get-inventory))))
                                                                                                            (list (first (first (inventory-equipment (send (store-player s) get-inventory))))))
                                                                                                    (second (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (third (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (fourth (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (fifth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                                   (inventory-consumables (send (store-player s) get-inventory))
                                                                                                   (inventory-miscellaneous (send (store-player s) get-inventory)))]
                                                      [(symbol=? (store-sym s) 'h) (make-inventory (inventory-weapon (send (store-player s) get-inventory)) (inventory-equiped (send (store-player s) get-inventory))
                                                                                                   (list
                                                                                                    (first (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (append (rest (second (inventory-equipment (send (store-player s) get-inventory))))
                                                                                                            (list (first (second (inventory-equipment (send (store-player s) get-inventory))))))
                                                                                                    (third (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (fourth (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (fifth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                                   (inventory-consumables (send (store-player s) get-inventory))
                                                                                                   (inventory-miscellaneous (send (store-player s) get-inventory)))]
                                                      [(symbol=? (store-sym s) 'b) (make-inventory (inventory-weapon (send (store-player s) get-inventory)) (inventory-equiped (send (store-player s) get-inventory))
                                                                                                   (list
                                                                                                    (first (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (second (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (append (rest (third (inventory-equipment (send (store-player s) get-inventory))))
                                                                                                            (list (first (third (inventory-equipment (send (store-player s) get-inventory))))))
                                                                                                    (fourth (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (fifth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                                   (inventory-consumables (send (store-player s) get-inventory))
                                                                                                   (inventory-miscellaneous (send (store-player s) get-inventory)))]
                                                      [(symbol=? (store-sym s) 'a) (make-inventory (inventory-weapon (send (store-player s) get-inventory)) (inventory-equiped (send (store-player s) get-inventory))
                                                                                                   (list
                                                                                                    (first (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (second (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (third (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (append (rest (fourth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                                            (list (first (fourth (inventory-equipment (send (store-player s) get-inventory))))))
                                                                                                    (fifth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                                   (inventory-consumables (send (store-player s) get-inventory))
                                                                                                   (inventory-miscellaneous (send (store-player s) get-inventory)))]
                                                      [(symbol=? (store-sym s) 'l) (make-inventory (inventory-weapon (send (store-player s) get-inventory)) (inventory-equiped (send (store-player s) get-inventory))
                                                                                                   (list
                                                                                                    (first (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (second (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (third (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (fourth (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (append (rest (fifth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                                            (list (first (fifth (inventory-equipment (send (store-player s) get-inventory)))))))
                                                                                                   (inventory-consumables (send (store-player s) get-inventory))
                                                                                                   (inventory-miscellaneous (send (store-player s) get-inventory)))]
                                                      [(symbol=? (store-sym s) 'm) (make-inventory (inventory-weapon (send (store-player s) get-inventory)) (inventory-equiped (send (store-player s) get-inventory))
                                                                                                   (inventory-equipment (send (store-player s) get-inventory))
                                                                                                   (inventory-consumables (send (store-player s) get-inventory))
                                                                                                   (append
                                                                                                    (rest (inventory-miscellaneous (send (store-player s) get-inventory)))
                                                                                                    (list (first (inventory-miscellaneous (send (store-player s) get-inventory))))))]))
                                  (store-inventory s) 2 (store-sym s) (store-dungeon s) (store-room s))]
       [(key=? k "w") (make-store (send (store-player s)
                                        clone #:character-inventory
                                        (cond
                                                      [(symbol=? (store-sym s) 'c) (make-inventory (inventory-weapon (send (store-player s) get-inventory)) (inventory-equiped (send (store-player s) get-inventory)) (inventory-equipment (send (store-player s) get-inventory))
                                                                                                   (append (list (first (reverse (inventory-consumables (send (store-player s) get-inventory)))))
                                                                                                           (reverse (rest (reverse (inventory-consumables (send (store-player s) get-inventory))))))
                                                                                                   (inventory-miscellaneous (send (store-player s) get-inventory)))]
                                                      [(symbol=? (store-sym s) 'w) (make-inventory (inventory-weapon (send (store-player s) get-inventory)) (inventory-equiped (send (store-player s) get-inventory))
                                                                                                   (list
                                                                                                    (append
                                                                                                     (list (first (reverse (first (inventory-equipment (send (store-player s) get-inventory))))))
                                                                                                     (reverse (rest (reverse (first (inventory-equipment (send (store-player s) get-inventory)))))))
                                                                                                    (second (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (third (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (fourth (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (fifth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                                   (inventory-consumables (send (store-player s) get-inventory))
                                                                                                   (inventory-miscellaneous (send (store-player s) get-inventory)))]
                                                      [(symbol=? (store-sym s) 'h) (make-inventory (inventory-weapon (send (store-player s) get-inventory)) (inventory-equiped (send (store-player s) get-inventory))
                                                                                                   (list
                                                                                                    (first (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (append
                                                                                                     (list (first (reverse (second (inventory-equipment (send (store-player s) get-inventory))))))
                                                                                                     (reverse (rest (reverse (second (inventory-equipment (send (store-player s) get-inventory)))))))
                                                                                                    (third (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (fourth (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (fifth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                                   (inventory-consumables (send (store-player s) get-inventory))
                                                                                                   (inventory-miscellaneous (send (store-player s) get-inventory)))]
                                                      [(symbol=? (store-sym s) 'b) (make-inventory (inventory-weapon (send (store-player s) get-inventory)) (inventory-equiped (send (store-player s) get-inventory))
                                                                                                   (list
                                                                                                    (first (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (second (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (append
                                                                                                     (list (first (reverse (third (inventory-equipment (send (store-player s) get-inventory))))))
                                                                                                     (reverse (rest (reverse (third (inventory-equipment (send (store-player s) get-inventory)))))))
                                                                                                    (fourth (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (fifth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                                   (inventory-consumables (send (store-player s) get-inventory))
                                                                                                   (inventory-miscellaneous (send (store-player s) get-inventory)))]
                                                      [(symbol=? (store-sym s) 'a) (make-inventory (inventory-weapon (send (store-player s) get-inventory)) (inventory-equiped (send (store-player s) get-inventory))
                                                                                                   (list
                                                                                                    (first (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (second (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (third (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (append
                                                                                                     (list (first (reverse (fourth (inventory-equipment (send (store-player s) get-inventory))))))
                                                                                                     (reverse (rest (reverse (fourth (inventory-equipment (send (store-player s) get-inventory)))))))
                                                                                                    (fifth (inventory-equipment (send (store-player s) get-inventory))))
                                                                                                   (inventory-consumables (send (store-player s) get-inventory))
                                                                                                   (inventory-miscellaneous (send (store-player s) get-inventory)))]
                                                      [(symbol=? (store-sym s) 'l) (make-inventory (inventory-weapon (send (store-player s) get-inventory)) (inventory-equiped (send (store-player s) get-inventory))
                                                                                                   (list
                                                                                                    (first (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (second (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (third (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (fourth (inventory-equipment (send (store-player s) get-inventory)))
                                                                                                    (append
                                                                                                     (list (first (reverse (fifth (inventory-equipment (send (store-player s) get-inventory))))))
                                                                                                     (reverse (rest (reverse (fifth (inventory-equipment (send (store-player s) get-inventory))))))))
                                                                                                   (inventory-consumables (send (store-player s) get-inventory))
                                                                                                   (inventory-miscellaneous (send (store-player s) get-inventory)))]
                                                      [(symbol=? (store-sym s) 'm) (make-inventory (inventory-weapon (send (store-player s) get-inventory)) (inventory-equiped (send (store-player s) get-inventory))
                                                                                                   (inventory-equipment (send (store-player s) get-inventory))
                                                                                                   (inventory-consumables (send (store-player s) get-inventory))
                                                                                                   (append
                                                                                                    (list (first (reverse (inventory-miscellaneous (send (store-player s) get-inventory)))))
                                                                                                    (reverse (rest (reverse (inventory-miscellaneous (send (store-player s) get-inventory)))))))]))
                                  (send (store-player s) get-inventory) 2 (store-sym s) (store-dungeon s) (store-room s))]
       [else s])]
    [else s]))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; store inventories
(define STORE-INVENTORY1 (make-inventory empty empty (list (list SWORD STAFF) (list HAT HELMET) (list COAT MAIL) (list GAUNTLETS) (list STEEL-BOOTS))
                                         (list HEALING-1 HEALING-2 HEALING-3 MP-1 MP-2 MP-3 AGILITY-P STRENGTH-P MYS NOB-CURE DIV-CURE) (list STAFF SWORD GAUNTLETS COAT COAT)))

(define STORE1 (make-store SPELLSWORD STORE-INVENTORY1 0 'c "Strind" "gjkd"))




