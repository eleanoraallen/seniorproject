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
(define ROOFTR (new tile%
                    [image (bitmap/file "RoofTRC.png")]
                    [passable false]
                    [portal empty]))
(define ROOFTC (new tile%
                    [image (bitmap/file "RoofT.png")]
                    [passable false]
                    [portal empty]))
(define ROOFTL (new tile%
                    [image (bitmap/file "RoofTLC.png")]
                    [passable false]
                    [portal empty]))
(define ROOFML (new tile%
                    [image (bitmap/file "RoofL.png")]
                    [passable false]
                    [portal empty]))
(define ROOFMC (new tile%
                    [image (bitmap/file "RoofM.png")]
                    [passable false]
                    [portal empty]))
(define ROOFMR (new tile%
                    [image (bitmap/file "RoofR.png")]
                    [passable false]
                    [portal empty]))
(define ROOFBR (new tile%
                    [image (bitmap/file "RoofBLC.png")]
                    [passable false]
                    [portal empty]))
(define ROOFBC (new tile%
                    [image (bitmap/file "RoofB.png")]
                    [passable false]
                    [portal empty]))
(define ROOFBL (new tile%
                    [image (bitmap/file "RoofBRC.png")]
                    [passable false]
                    [portal empty]))
(define WALLTL (new tile%
                    [image (bitmap/file "WallL.png")]
                    [passable false]
                    [portal empty]))
(define WALLTC (new tile%
                    [image (bitmap/file "Wall.png")]
                    [passable false]
                    [portal empty]))
(define WALLTR (new tile%
                    [image (bitmap/file "WallR.png")]
                    [passable false]
                    [portal empty]))

;; WALL
(define WALLMR (new tile%
                    [image (bitmap/file "Tile15.png")]
                    [passable false]
                    [portal empty]))
(define WALLMC (new tile%
                    [image (bitmap/file "Tile17.png")]
                    [passable false]
                    [portal empty]))
(define WALLML (new tile%
                    [image (bitmap/file "Tile16.png")]
                    [passable false]
                    [portal empty]))
(define WALLBL (new tile%
                    [image (bitmap/file "BuildingLC.png")]
                    [passable false]
                    [portal empty]))
(define WALLBC (new tile%
                    [image (bitmap/file "BuildingB.png")]
                    [passable false]
                    [portal empty]))
(define WALLBR (new tile%
                    [image (bitmap/file "BuildingRC.png")]
                    [passable false]
                    [portal empty]))

;; Door
(define DOORTR (new tile%
                    [image (bitmap/file "DoorTL.png")]
                    [passable false]
                    [portal empty]))
(define DOORTC (new tile%
                    [image (bitmap/file "DoorT.png")]
                    [passable false]
                    [portal empty]))
(define DOORTL (new tile%
                    [image (bitmap/file "DoorTR.png")]
                    [passable false]
                    [portal empty]))
(define DOORBR (new tile%
                    [image (bitmap/file "DoorLB.png")]
                    [passable false]
                    [portal empty]))
(define DOORBL (new tile%
                    [image (bitmap/file "DoorRB.png")]
                    [passable false]
                    [portal empty]))
(define DOORBC (new tile%
                    [image (bitmap/file "DoorRB.png")]
                    [passable false]
                    [portal empty]))

;; Street
(define STREET (new tile%
                    [image (bitmap/file "Street.png")]
                    [passable true]
                    [portal empty]))

;; Signs
(define HEALER (new tile%
                    [image (bitmap/file "healer.png")]
                    [passable false]
                    [portal empty]))
(define WPNSTO (new tile%
                    [image (bitmap/file "wpnsmith.png")]
                    [passable false]
                    [portal empty]))
(define ITMSTO (new tile%
                    [image (bitmap/file "itemshop.png")]
                    [passable false]
                    [portal empty]))
(define MGUILD (new tile%
                    [image (bitmap/file "mguild.png")]
                    [passable false]
                    [portal empty]))
(define AGUILD (new tile%
                    [image (bitmap/file "aguild.png")]
                    [passable false]
                    [portal empty]))
(define TAVERN (new tile%
                    [image (bitmap/file "tavern.png")]
                    [passable false]
                    [portal empty]))

;; City Tiles
(define CITY-TILES
  (list
   (append (make-list 17 STREET) (list ROOFTL ROOFTC ROOFTC ROOFTC ROOFTC ROOFTR) (make-list 17 STREET))
   (append (make-list 17 STREET) (list ROOFML ROOFMC ROOFMC ROOFMC ROOFMC ROOFMR) (make-list 17 STREET))
   (append (make-list 8 STREET) (list ROOFTL) (list 7 ROOFTC) (list ROOFTR) (list ROOFBL) (make-list 4 ROOFBC) (list ROOFBR)
           (list ROOFTR) (make-list 7 ROOFTC) (list ROOFTR) (make-list 8 STREET))
   (append (make-list 8 STREET) (list ROOFBL) (make-list 7 ROOFBC) (list ROOFBR WALLTL) (make-list 4 WALLTC) (list WALLTR ROOFBL)
           (make-list 7 ROOFBC) (list ROOFBR) (make-list 8 STREET))
   (append (list ROOFTR) (make-list 7 STREET) (list WALLTL) (make-list 7 WALLMC) (list WALLTR WALLML DOORTL) (make-list 2 DOORTC)
           (list DOORTR WALLMR WALLTL) (make-list 7 WALLTC) (list WALLTR) (make-list 7 STREET) (list WALLTR))
   (append (list WALLMR) (make-list 7 STREET) (list WALLML DOORTL DOORTC DOORTR WALLMC DOORTL DOORTC DOORTR WALLMR DOORTL)
           (make-list 2 DOORTC) (list DOORTR WALLMR WALLML DOORTL DOORTC DOORTR WALLMC DOORTL DOORTC DOORTR WALLMR) (make-list 7 STREET) (list ROOFML))
   (append (make-list 7 WALLTC) (list WALLTR WALLML DOORBL DOORBC DOORBR WALLBC DOORBL DOORBC DOORBR WALLBR WALLBL DOORBL DOORBC DOORBC DOORBR WALLBR
                                      WALLBL DOORBL DOORBC DOORBR WALLBC DOORBL DOORBC DOORBR WALLBR ROOFTL) (make-list 7 ROOFTC))
   (append (make-list 7 ROOFMC) (list ROOFMR) (make-list 24 STREET) (list ROOFML) (make-list 7 ROOFMC))
   (append (make-list 7 ROOFBC) (list ROOFBR STREET ROOFTL) (make-list 3 ROOFTC) (list ROOFTR ROOFTL) (make-list 3 ROOFTC)
           (list ROOFTR STREET STREET ROOFTL) (make-list 3 ROOFTC) (list ROOFTR ROOFTL) (make-list 3 ROOFTC) (list ROOFTR STREET ROOFBL) (make-list 7 ROOFBC))
   (append (make-list 7 ROOFTC) (list ROOFTR STREET ROOFBL) (make-list 3 ROOFBC) (list ROOFBR ROOFBL) (make-list 3 ROOFBC) (list ROOFBL STREET STREET ROOFBL)
           (make-list 3 ROOFBC) (list ROOFBR STREET ROOFTL) (make-list 7 ROOFMC))
   (append (list ROOFMR WALLML) (make-list 5 WALLMC) (list WALLMR STREET WALLTL) (make-list 3 WALLTC) (list WALLTR WALLTL) (make-list 3 WALLTC) (list WALLTR STREET STREET WALLTL)
           (make-list 3 WALLTC) (list WALLTR WALLTL) (make-list 3 WALLTC) (list WALLMC STREET WALLML) (make-list 6 WALLMC) (list ROOFML))
   (list ROOFMR WALLML WALLMC DOORTL DOORTC DOORTC DOORTR WALLMR STREET WALLML DOORTL DOORTC DOORTR WALLMR WALLML DOORTL DOORTC DOORTR WALLMR STREET STREET
                 WALLML DOORTL DOORTC DOORTR WALLMR WALLML DOORTL DOORTC DOORTR WALLMR STREET WALLML DOORTL DOORTC DOORTC DOORTR WALLMC WALLMR ROOFML)
   (list ROOFMR WALLBL WALLBC DOORBL DOORBC DOORBC AGUILD WALLBR STREET WALLBL DOORBL DOORBC WPNSTO WALLBR WALLBL DOORBL DOORBC DOORBR WALLBR STREET STREET
                 WALLBL TAVERN DOORBC DOORBR WALLBR WALLBL DOORBL DOORBC DOORBR WALLBR STREET WALLBL MGUILD DOORBC DOORBC DOORBR WALLBC WALLBR ROOFML)
   (append (list ROOFMR) (make-list 38 STREET) (list ROOFML))
   (append (list ROOFMR) (make-list 38 STREET) (list ROOFML))))
   

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
(define CITY (make-dungeon (send SPELLSWORD clone #:position (make-posn 6150 4350)) (list CITY-OUTSIDE) empty "City" empty))
;; TEST DUNGEONS
(define TESTDUNGEON1 (make-dungeon SPELLSWORD (list TESTROOM1 TESTROOM2) empty "test_dungeon_1" empty))
(define TESTDUNGEON2 (make-dungeon SPELLSWORD (list TESTROOM3) empty "test_dungeon_2" empty))

;; DUNGEON-DIRECTORY (the list of all the dungeons)
(define DUNGEON-DIRECTORY (list TESTDUNGEON1 TESTDUNGEON2))

(define (get-dungeon s) (first (filter (lambda (x) (string=? (dungeon-name x) s)) DUNGEON-DIRECTORY)))

(define (get-room d s) (first (filter (lambda (x) (string=? (room-name x) s)) (dungeon-rooms d))))