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

;; ROOF
(define RTL (new tile%
                    [image (scale .5 (bitmap/file "RoofTL.png"))]
                    [passable false]
                    [portal empty]))
(define RTC (new tile%
                    [image (scale .5 (bitmap/file "RoofTC.png"))]
                    [passable false]
                    [portal empty]))
(define RTR (new tile%
                    [image (scale .5 (bitmap/file "RoofTR.png"))]
                    [passable false]
                    [portal empty]))
(define RML (new tile%
                    [image (scale .5 (bitmap/file "RoofML.png"))]
                    [passable false]
                    [portal empty]))
(define RMC (new tile%
                    [image (scale .5 (bitmap/file "RoofMC.png"))]
                    [passable false]
                    [portal empty]))
(define RMR (new tile%
                    [image (scale .5 (bitmap/file "RoofMR.png"))]
                    [passable false]
                    [portal empty]))
(define RBL (new tile%
                    [image (scale .5 (bitmap/file "RoofBL.png"))]
                    [passable false]
                    [portal empty]))
(define RBC (new tile%
                    [image (scale .5 (bitmap/file "RoofBC.png"))]
                    [passable false]
                    [portal empty]))
(define RBR (new tile%
                    [image (scale .5 (bitmap/file "RoofBR.png"))]
                    [passable false]
                    [portal empty]))
;; Wall
(define WML (new tile%
                    [image (scale .5 (bitmap/file "WallML.png"))]
                    [passable false]
                    [portal empty]))
(define WMC (new tile%
                    [image (scale .5 (bitmap/file "WallMC.png"))]
                    [passable false]
                    [portal empty]))
(define WMR (new tile%
                    [image (scale .5 (bitmap/file "WallMR.png"))]
                    [passable false]
                    [portal empty]))
(define WBL (new tile%
                    [image (scale .5 (bitmap/file "WallBL.png"))]
                    [passable false]
                    [portal empty]))
(define WBC (new tile%
                    [image (scale .5 (bitmap/file "WallBC.png"))]
                    [passable false]
                    [portal empty]))
(define WBR (new tile%
                    [image (scale .5 (bitmap/file "WallBR.png"))]
                    [passable false]
                    [portal empty]))
;; Street
(define STR (new tile%
                    [image (scale .5 (bitmap/file "Street.png"))]
                    [passable true]
                    [portal empty]))
;; Signs
(define HEL (new tile%
                    [image (scale .5 (bitmap/file "healer.png"))]
                    [passable false]
                    [portal empty]))
(define WPN (new tile%
                    [image (scale .5 (bitmap/file "wpnsmith.png"))]
                    [passable false]
                    [portal empty]))
(define ITM (new tile%
                    [image (scale .5 (bitmap/file "itemshop.png"))]
                    [passable false]
                    [portal empty]))
(define MGU (new tile%
                    [image (scale .5 (bitmap/file "mguild.png"))]
                    [passable false]
                    [portal empty]))
(define AGU (new tile%
                    [image (scale .5 (bitmap/file "aguild.png"))]
                    [passable false]
                    [portal empty]))
(define TAV (new tile%
                    [image (scale .5 (bitmap/file "tavern.png"))]
                    [passable false]
                    [portal empty]))
;; Door
(define DOO (new tile%
                    [image (scale .5 (bitmap/file "Door.png"))]
                    [passable false]
                    [portal empty]))

;; City Tiles
(define CITY-TILES
  (list
   (append (list RMC) (make-list 38 RBC) (list RMC))
   (append (list RMR) (make-list 16 STR) (list RTL RTC RTC RTC RTC RTR) (make-list 16 STR) (list RML))
   (append (list RMR) (make-list 16 STR) (list RML RMC RMC RMC RMC RMR) (make-list 16 STR) (list RML))
   (append (list RMR) (make-list 7 STR) (list RTL) (make-list 7 RTC) (list RTR RBL) (make-list 4 RBC) (list RBR RTL) (make-list 7 RTC) (list RTR) (make-list 7 STR) (list RML))
   (append (list RMR) (make-list 7 STR) (list RML) (make-list 7 RMC) (list RMR WML) (make-list 4 WMC) (list WMR RBL) (make-list 7 RBC) (list RBR) (make-list 7 STR) (list RML))
   (append (list RMR) (make-list 7 STR) (list WML) (make-list 7 WMC) (list WMR WML) (make-list 4 WMC) (list WMR WML) (make-list 7 WMC) (list WMR) (make-list 7 STR) (list RML))
   (append (list RMR) (make-list 7 STR) (list WML) (make-list 7 WMC) (list WMR WML) (make-list 4 WMC) (list WMR WML) (make-list 7 WMC) (list WMR) (make-list 7 STR) (list RML))
   (append (list RMR RTR) (make-list 5 RTC) (list RTR WBL WBC DOO) (make-list 3 WBC) (list DOO WBC WBR WBL WBC DOO DOO WBC WBR WBL WBC DOO) (make-list 3 WBC) (list DOO WBC WBR RTL) (make-list 5 RTC) (list RTR RML))
   (append (list RMR RML) (make-list 5 RMC) (list RMR) (make-list 24 STR) (list RML) (make-list 5 RMC) (list RMR RML))
   (append (list RMR RBL) (make-list 5 RBC) (list RBR STR RTL) (make-list 3 RTC) (list RTR RTL) (make-list 3 RTC) (list RTR STR STR RTL) (make-list 3 RTC) (list RTR RTL) (make-list 3 RTC) (list RTR STR RBL) (make-list 5 RBC) (list RBR RML))
   (append (list RMR WML) (make-list 5 WMC) (list WMR STR RBL) (make-list 3 RBC) (list RBR RBL) (make-list 3 RBC) (list RBR STR STR RBL) (make-list 3 RBC) (list RBR RBL) (make-list 3 RBC) (list RBR STR WML) (make-list 5 WMC) (list WMR RML))
   (append (list RMR WML) (make-list 5 WMC) (list WMR STR WML) (make-list 3 WMC) (list WMR WML) (make-list 3 WMC) (list WMR STR STR WML) (make-list 3 WMC) (list WMR WML) (make-list 3 WMC) (list WMR STR WML) (make-list 5 WMC) (list WMR RML))
   (append (list RMR WML) (make-list 5 WMC) (list WMR STR WML) (make-list 3 WMC) (list WMR WML) (make-list 3 WMC) (list WMR STR STR WML) (make-list 3 WMC) (list WMR WML) (make-list 3 WMC) (list WMR STR WML) (make-list 5 WMC) (list WMR RML))
   (list RMR WBL WBC AGU DOO DOO AGU WBR STR WBL WBC DOO WPN WBR WBL WBC DOO WBC WBR STR STR WBL TAV DOO WBC WBR WBL WBC DOO WBC WBR STR WBL MGU DOO DOO MGU WBC WBR RML)
   (append (list RMR) (make-list 38 STR) (list RML))
   (append (list RMR) (make-list 38 STR) (list RML))))
   

;; Test TILESETS
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
               [portal (make-portal "test_dungeon_1" "TestRoom2" (make-posn 20 20))]))
(define Y (new tile%
               [image (overlay (circle 30 'solid 'blue)
                               (bitmap/file "stone.jpg"))]
               [passable true]
               [portal (make-portal "test_dungeon_1" "TestRoom1" (make-posn 3150 2250))]))
(define Z (new tile%
               [image (overlay (circle 30 'solid 'green)
                               (bitmap/file "stone.jpg"))]
               [passable true]
               [portal (make-portal "test_dungeon_2" "TestRoom3" (make-posn 3150 2250))]))

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
(define CITY-OUTSIDE (make-room "City" CITY-TILES 0 empty empty))

;; TESTROOMS
(define TESTROOM1 (make-room "TestRoom1" TILES1 5 (list NPC) (list NPC NPC2)))
(define TESTROOM2 (make-room "TestRoom2" TILES2 10 (list NPC2) (list NPC2)))
(define TESTROOM3 (make-room "TestRoom3" TILES3 10 (list NPC2) (list NPC NPC2)))

;; get-background
(define (get-background s)
  (cond
    [(string=? s "TestRoom1") (bitmap/file "background.png")]
    [else (bitmap/file "blankbackground.png")]))

;; a menu one of:
;; - empty
;; - 'player-info
;; - 'items
;; - 'equipment
;; - 'spells

;; DUNGEONS
(define CITY (make-dungeon (send SPELLSWORD clone #:position (make-posn 2350 1250)) (list CITY-OUTSIDE) empty "City" empty))
;; TEST DUNGEONS
(define TESTDUNGEON1 (make-dungeon SPELLSWORD (list TESTROOM1 TESTROOM2) empty "test_dungeon_1" empty))
(define TESTDUNGEON2 (make-dungeon SPELLSWORD (list TESTROOM3) empty "test_dungeon_2" empty))

;; DUNGEON-DIRECTORY (the list of all the dungeons)
(define DUNGEON-DIRECTORY (list TESTDUNGEON1 TESTDUNGEON2))

(define (get-dungeon s) (first (filter (lambda (x) (string=? (dungeon-name x) s)) DUNGEON-DIRECTORY)))

(define (get-room d s) (first (filter (lambda (x) (string=? (room-name x) s)) (dungeon-rooms d))))