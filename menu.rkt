#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(require 2htdp/batch-io)
(require "saves.rkt")
(require "dungeons.rkt")
(require "combat.rkt")
(require "characters.rkt")
(require "spells.rkt")
(require "items.rkt")
(require "dungeons.rkt")
(require "store.rkt")
(require "create.rkt")
(provide (all-defined-out))

;; a main-menu is an int that is one of
;; - 0 : main intro splashscreen
;; - 1 : new/load
;; - 2 : no-save-game

(define (render-main-menu m)
  (cond
    [(eq? m 0) (overlay (above (text "The General's Labyrinth" 50 'black)
                               (text "Press Enter to continue" 30 'black))
                        (overlay (rectangle 800 620 'solid 'gray)
                                 (rectangle 810 630 'solid 'black)))]
    [(eq? m 1) (overlay (above (text "New Game (n)" 50 'black)
                               (rectangle 0 100 'solid 'pink)
                               (text "Load Game (l)" 50 'black))
                        (overlay (rectangle 800 620 'solid 'gray)
                                 (rectangle 810 630 'solid 'black)))]
    [(eq? m 2) (overlay (above (text "There is no saved game!" 50 'black)
                               (rectangle 0 50 'solid 'pink)
                               (text "Press any key to start a new game" 30 'black))
                        (overlay (rectangle 800 620 'solid 'gray)
                                 (rectangle 810 630 'solid 'black)))]))

(define (handle-main-menu-key m k)
  (cond
    [(eq? m 0) 1]
    [(eq? m 1)
     (cond
       [(or (key=? k "n") (key=? k "N")) STARTINGCREATE]
       [(and (key=? k "l")
             (and (not (empty? (read-file "save.txt")))
                  (not (string=? (read-file "save.txt") "")))
             (dungeon? (save->dungeon "save.txt"))) (save->dungeon "save.txt")]
       [(key=? k "l") 2]
       [(key=? k "escape") 0]
       [else m])]
    [else (if (eq? k "escape") 0 STARTINGCREATE)]))