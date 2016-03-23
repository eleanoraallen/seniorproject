#lang racket
(require "combat.rkt")
(require "characters.rkt")
(require "spells.rkt")
(require "items.rkt")
(require "dungeons.rkt")
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
    [(not (store? s)) (square 50 'solid 'orange)]
    [(= (store-num s) 0) (overlay (text "Buy (1), Sell (2), Exit (3)" 30 'black)
                                  (rectangle 810 630 'solid 'gray))]
    [(= (store-num s) 1)
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
                                                       (rectangle 350 100 'solid 'black))
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
                                                       (rectangle 350 100 'solid 'black))
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
                                                       (rectangle 350 100 'solid 'black))
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
                                                      (square 0 'solid 'pink))
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
                                                       (rectangle 350 100 'solid 'black))
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
              (rectangle 810 630 'solid 'gray))]
    [else (square 50 'solid 'red)]))



;; handle-store-key: store, key --> world
(define (handle-store-key s k)
  (cond
    [(= (store-num s) 0)
     (cond
       [(key=? k "3") (make-dungeon (store-player s)
                (cons (get-room (get-dungeon (store-dungeon s)) (store-room s))
                      (filter (lambda (x) (not (string=? (room-name x) (store-room s))))
                              (dungeon-rooms (get-dungeon (store-dungeon s)))))
                empty (store-dungeon s) 'empty)]
       [(key=? k "2") (make-store (store-player s) (store-inventory s) 2 (store-sym s) (store-dungeon s) (store-room s))]
       [(key=? k "1") (make-store (store-player s) (store-inventory s) 1 (store-sym s) (store-dungeon s) (store-room s))]
       [else s])]
    [(= (store-num s) 1)
     (cond
       [(key=? k "escape") (make-store (store-player s) (store-inventory s) 0 (store-sym s) (store-dungeon s) (store-room s))]
       [(key=? k "right") (make-store (store-player s) (store-inventory s) 1 (cond
                       [(symbol=? (store-sym s) 'c) 'w]
                       [(symbol=? (store-sym s) 'w) 'h]
                       [(symbol=? (store-sym s) 'h) 'b]
                       [(symbol=? (store-sym s) 'b) 'a]
                       [(symbol=? (store-sym s) 'a) 'l]
                       [(symbol=? (store-sym s) 'l) 'm]
                       [(symbol=? (store-sym s) 'm) 'c]) (store-dungeon s) (store-room s))]
       [(key=? k "left") (make-store (store-player s) (store-inventory s) 1 (cond
                       [(symbol=? (store-sym s) 'c) 'm]
                       [(symbol=? (store-sym s) 'w) 'c]
                       [(symbol=? (store-sym s) 'h) 'w]
                       [(symbol=? (store-sym s) 'b) 'h]
                       [(symbol=? (store-sym s) 'a) 'b]
                       [(symbol=? (store-sym s) 'l) 'a]
                       [(symbol=? (store-sym s) 'm) 'l]) (store-dungeon s) (store-room s))]
       [else s])]
    [(= (store-num s) 2) (make-store (store-player s) (store-inventory s) 0 (store-sym s) (store-dungeon s) (store-room s))]
    [else s]))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; store inventories
(define STORE-INVENTORY1 (make-inventory empty empty (list (list SWORD STAFF) (list HAT HELMET) (list COAT MAIL) (list GAUNTLETS) (list STEEL-BOOTS))
                                         (list HEALING-POTION MAGIC-POTION) (list STAFF SWORD GAUNTLETS COAT COAT)))

(define STORE1 (make-store SPELLSWORD STORE-INVENTORY1 0 'c "Strind" "gjkd"))
    


    
    