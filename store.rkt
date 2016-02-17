#lang racket
(require "combat.rkt")
(require "characters.rkt")
(require "spells.rkt")
(require "items.rkt")
(require "dungeons.rkt")
(require 2htdp/image)
(require 2htdp/universe)

;; a store is a (make-store player inventory number symbol string string)
(define-struct store (player inventory num sym dungeon room))

(define (render-store s)
  (cond
    [(= (store-num s) 1) (overlay (rectangle 810 630 'solid 'gray)
                                  (text "Buy (1), Sell (2), Exit (3)" 30 'black))]
    [else (square 0 'solid 'black)]))

(define (handle-store-key s k)
  (cond
    [(= (store-num s) 0)
     (cond
       [(key=? k "3") (make-dungeon (store-player s)
                (cons (get-room (get-dungeon (store-dungeon s)) (store-room s))
                      (filter (lambda (x) (not (string=? (room-name x) (store-room s))))
                              (dungeon-rooms (get-dungeon (store-dungeon s)))))
                empty (store-dungeon s) 'empty)]
       [(key=? "2") (make-store (store-player s) (store-inventory s) 2 (store-sym s) (store-dungeon s) (store-room s))]
       [(key=? "1") (make-store (store-player s) (store-inventory s) 1 (store-sym s) (store-dungeon s) (store-room s))]
       [else s])]))
    


    
    