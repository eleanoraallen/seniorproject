#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(require "combat.rkt")
(require "items.rkt")
(require "spells.rkt")
(require "characters.rkt")
(provide (all-defined-out))

(define PLAYER-SPEED 20)
;; ----------------------------------------------------------------------------

(define W (new tile%
                   [image (bitmap/file "dirt.jpg")]
                   [passable true]
                   [portal empty]))

(define B (new tile%
                   [image (bitmap/file "stone.jpg")]
                   [passable false]
                   [portal empty]))
(define X (new tile%
                   [image (overlay (circle 30 'solid 'red)
                                   (bitmap/file "stone.jpg"))]
                   [passable true]
                   [portal (make-portal "test_dungeon_1" "test room 2" (make-posn 20 20))]))
(define Y (new tile%
                   [image (overlay (circle 30 'solid 'blue)
                                   (bitmap/file "stone.jpg"))]
                   [passable true]
                   [portal (make-portal "test_dungeon_1" "test room 1" (make-posn 3150 2250))]))
(define Z (new tile%
                   [image (overlay (circle 30 'solid 'green)
                                   (bitmap/file "stone.jpg"))]
                   [passable true]
                   [portal (make-portal "test_dungeon_2" "test room 3" (make-posn 3150 2250))]))

(define TILES1 (list
                (list B B B B B B B B B B B B B B B B B B B B B B B B)
                (list B W W B W W W W B W W W B W W W W B B B W W W B)
                (list B W B B W B B W W W B W B W B B W W W W W B W B)
                (list B W B B W W B B B B B W W W W W W B W B B B W B)
                (list B W B B B W B W W W W W B W B B B B W B W B W B)
                (list B W W W W W B W B B W B B W B W W W W W W W W B)
                (list B B B B B W W W B W X B B W B W B B B B W B B B)
                (list B W W W W W B W W W W W W W W W W W W W W W W B)
                (list B B B B B W B W B W W B B W B B W B B B W B W B)
                (list B W W W B W B W B B W B B W B B W B W W W B W B)
                (list B W B W B W B W B B W B B W B B W B W B B B W B)
                (list B W B W B W W W W W W W W W W W W B W B W W W B)
                (list B W B B B W B B B B W B B W B B W B B B W B B B)
                (list B W W W W W W W W W W B W W W B W W W W W B B B)
                (list B B B B B B B B B B B B B B B B B B B B B B B B)))
(define TILES2 (list
                (list W W W W)
                (list W W W W)
                (list W X Y Z)))
(define TILES3 (list
                (list B B B B B B B B B B B B B B B B B B B B B B B B)
                (list B W W B W W W W B W W W B W W W W B B B W W W B)
                (list B W B B W B B W W W B W B W B B W W W W W B W B)
                (list B W B B W W B B B B B W W W W W W B W B B B W B)
                (list B W B B B W B W W W W W B W B B B B W B W B W B)
                (list B W W W W W B W B B W B B W B W W W W W W W W B)
                (list B B B B B W W W B B W B B W B W B B B B W B B B)
                (list B W W W W W B W W W W W W W W W W W W W W W W B)
                (list B B B B B W B W B B X B B W B B W B B B W B W B)
                (list B W W W B W B W B B W B B W B B W B W W W B W B)
                (list B W B W B W B W B B W B B W B B W B W B B B W B)
                (list B W B W B W W W W W W W W W W W W B W B W W W B)
                (list B W B B B W B B B B W B B W B B W B B B W B B B)
                (list B W W W W W W W W W W B W W W B W W W W W B B B)
                (list B B B B B B B B B B B B B B B B B B B B B B B B)))
                


;; ROOMS

(define TESTROOM1 (make-room "test room 1" TILES1 5 (list NPC) (list NPC NPC2)))
(define TESTROOM2 (make-room "test room 2" TILES2 10 (list NPC2) (list NPC2)))
(define TESTROOM3 (make-room "test room 3" TILES3 10 (list NPC2) (list NPC NPC2)))

;; get-background
(define (get-background s)
  (cond
    [(string=? s "test room 1") (bitmap/file "background.png")]
    [else (bitmap/file "blankbackground.png")]))

;; a menu one of:
;; - empty
;; - 'player-info
;; - 'items
;; - 'equipment
;; - 'spells

(define TESTDUNGEON1 (make-dungeon SPELLSWORD (list TESTROOM1 TESTROOM2) empty "test_dungeon_1" empty))
(define TESTDUNGEON2 (make-dungeon SPELLSWORD (list TESTROOM3) empty "test_dungeon_2" empty))

;; DUNGEON-DIRECTORY (the list of all the dungeons)
(define DUNGEON-DIRECTORY (list TESTDUNGEON1 TESTDUNGEON2))

(define (get-dungeon s) (first (filter (lambda (x) (string=? (dungeon-name x) s)) DUNGEON-DIRECTORY)))

(define (get-room d s) (first (filter (lambda (x) (string=? (room-name x) s)) (dungeon-rooms d))))