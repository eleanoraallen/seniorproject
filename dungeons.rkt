#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(require "combat.rkt")
(require "items.rkt")
(require "spells.rkt")
(require "characters.rkt")
(provide (all-defined-out))

(define PLAYER-SPEED 30)
;; ----------------------------------------------------------------------------

(define DIRT (new tile%
                 [name "Dirt"]
                 [image (scale .5 (bitmap/file "dirt.jpg"))]
                 [passable true]
                 [portal empty]))
(define CON (new tile%
                 [name "Concrete"]
                 [image (scale .5 (bitmap/file "concrete.jpg"))]
                 [passable false]
                 [portal empty]))
(define SAND-FLOOR (new tile%
                 [name "Sand-floor"]
                 [image (scale .5 (bitmap/file "sand-floor.jpg"))]
                 [passable true]
                 [portal empty]))
(define FANCY-FLOOR (new tile%
                 [name "fancy-floor"]
                 [image (scale .5 (bitmap/file "fancy-floor.jpg"))]
                 [passable true]
                 [portal empty]))
(define GRASS (new tile%
                 [name "grass"]
                 [image (scale .5 (bitmap/file "grass.jpg"))]
                 [passable true]
                 [portal empty]))
(define WOOD-FLOOR (new tile%
                 [name "Wood-Floor"]
                 [image (scale .5 (bitmap/file "wood-floor.jpg"))]
                 [passable true]
                 [portal empty]))
(define COBLELSTONES (new tile%
                 [name "Cobelstones"]
                 [image (scale .5 (bitmap/file "cobelstones.png"))]
                 [passable true]
                 [portal empty]))
(define WOOD (new tile%
                 [name "Wood"]
                 [image (scale .5 (bitmap/file "wood.jpg"))]
                 [passable false]
                 [portal empty]))
(define THATCH (new tile%
                 [name "Thatch"]
                 [image (scale .5 (bitmap/file "thatch.jpg"))]
                 [passable false]
                 [portal empty]))
(define ROOFC (new tile%
                 [name "Roof-Center"]
                 [image (scale .5 (bitmap/file "roof.jpg"))]
                 [passable false]
                 [portal empty]))
(define ROOFT (new tile%
                 [name "Roof-Top"]
                 [image (scale .5 (bitmap/file "rooft.jpg"))]
                 [passable false]
                 [portal empty]))
(define ROOFL (new tile%
                 [name "Roof-Left"]
                 [image (scale .5 (bitmap/file "roofl.jpg"))]
                 [passable false]
                 [portal empty]))
(define ROOFR (new tile%
                 [name "Roof-Right"]
                 [image (scale .5 (bitmap/file "roofr.jpg"))]
                 [passable false]
                 [portal empty]))
(define ROOFTL (new tile%
                 [name "Roof-Top-Left"]
                 [image (scale .5 (bitmap/file "rooftl.jpg"))]
                 [passable false]
                 [portal empty]))
(define ROOFTR (new tile%
                 [name "Roof-Top-Right"]
                 [image (scale .5 (bitmap/file "rooftr.jpg"))]
                 [passable false]
                 [portal empty]))
(define STONEC (new tile%
                 [name "Stone-Center"]
                 [image (scale .5 (bitmap/file "stone.jpg"))]
                 [passable false]
                 [portal empty]))
(define STONEES (new tile%
                 [name "Stone-East-Side"]
                 [image (scale .5 (bitmap/file "stoner.jpg"))]
                 [passable false]
                 [portal empty]))
(define STONEWS (new tile%
                 [name "Stone-West-Side"]
                 [image (scale .5 (bitmap/file "stonel.jpg"))]
                 [passable false]
                 [portal empty]))
(define STONENS (new tile%
                 [name "Stone-North-Side"]
                 [image (scale .5 (bitmap/file "stonet.jpg"))]
                 [passable false]
                 [portal empty]))
(define STONESS (new tile%
                 [name "Stone-South-Side"]
                 [image (scale .5 (bitmap/file "stoneb.jpg"))]
                 [passable false]
                 [portal empty]))
(define STONETRC (new tile%
                 [name "Stone-Top-Right-Corner"]
                 [image (scale .5 (bitmap/file "stonetr.jpg"))]
                 [passable false]
                 [portal empty]))
(define STONEBRC (new tile%
                 [name "Stone-Bottom-Right-Corner"]
                 [image (scale .5 (bitmap/file "stonebr.jpg"))]
                 [passable false]
                 [portal empty]))
(define STONEBLC (new tile%
                 [name "Stone-Bottom-Left-Corner"]
                 [image (scale .5 (bitmap/file "stonebl.jpg"))]
                 [passable false]
                 [portal empty]))
(define STONETLC (new tile%
                 [name "Stone-Top-Left-Corner"]
                 [image (scale .5 (bitmap/file "stonetl.jpg"))]
                 [passable false]
                 [portal empty]))


(define DOOR (new tile%
                 [name "Door"]
                 [image (scale .5 (bitmap/file "door.jpg"))]
                 [passable false]
                 [portal empty]))


;; TILE-DIRECTORY
(define TILE-DIRECTORY (list
                        DIRT
                        GRASS
                        SAND-FLOOR
                        FANCY-FLOOR
                        COBLELSTONES
                        WOOD-FLOOR
                        WOOD
                        THATCH
                        ROOFC
                        ROOFR
                        ROOFL
                        ROOFTR
                        ROOFTL
                        ROOFT
                        STONEC
                        STONEES
                        STONEWS
                        STONENS
                        STONESS
                        STONETRC
                        STONEBRC
                        STONETLC
                        STONEBLC
                        DOOR
                        CON))

(define (lolos->lolot l)
  (cond
    [(empty? l) empty]
    [else (cons (los->lot (first l))
                (lolos->lolot (rest l)))]))

(define (los->lot l)
  (cond
    [(empty? l) empty]
    [(cons? l) (cons (string->tile (first l) TILE-DIRECTORY) (los->lot (rest l)))]))

(define (string->tile s l)
  (cond
    [(string=? (send (first l) get-name) s) (first l)]
    [else (string->tile s (rest l))]))

(define (lolot->lolos l)
  (cond
    [(empty? l) empty]
    [else (cons (lot->los (first l))
                (lolot->lolos (rest l)))]))

(define (lot->los l)
  (cond
    [(empty? l) empty]
    [(cons? l) (cons (send (first l) get-name) (lot->los (rest l)))]))

(define CITY-TILES '(("grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Cobelstones"
   "Thatch"
   "Thatch"
   "Thatch"
   "Cobelstones"
   "Thatch"
   "Thatch"
   "Thatch"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Roof-Top-Left"
   "Roof-Top"
   "Roof-Top"
   "Roof-Top"
   "Roof-Top"
   "Roof-Top"
   "Roof-Top-Right"
   "Cobelstones"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Cobelstones"
   "Thatch"
   "Thatch"
   "Thatch"
   "Cobelstones"
   "Thatch"
   "Thatch"
   "Thatch"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Roof-Left"
   "Roof-Center"
   "Roof-Center"
   "Roof-Center"
   "Roof-Center"
   "Roof-Center"
   "Roof-Right"
   "Cobelstones"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Cobelstones"
   "Wood"
   "Wood"
   "Wood"
   "Cobelstones"
   "Wood"
   "Wood"
   "Wood"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Roof-Left"
   "Roof-Center"
   "Roof-Center"
   "Roof-Center"
   "Roof-Center"
   "Roof-Center"
   "Roof-Right"
   "Cobelstones"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Cobelstones"
   "Wood"
   "Door"
   "Wood"
   "Cobelstones"
   "Wood"
   "Door"
   "Wood"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Stone-Top-Left-Corner"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-Top-Right-Corner"
   "Cobelstones"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Stone-West-Side"
   "Stone-Center"
   "Stone-Center"
   "Stone-Center"
   "Stone-Center"
   "Stone-Center"
   "Stone-East-Side"
   "Cobelstones"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Cobelstones"
   "Thatch"
   "Thatch"
   "Thatch"
   "Cobelstones"
   "Thatch"
   "Thatch"
   "Thatch"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Stone-Bottom-Left-Corner"
   "Stone-South-Side"
   "Stone-South-Side"
   "Door"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-Bottom-Right-Corner"
   "Cobelstones"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Cobelstones"
   "Thatch"
   "Thatch"
   "Thatch"
   "Cobelstones"
   "Thatch"
   "Thatch"
   "Thatch"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Cobelstones"
   "Wood"
   "Wood"
   "Wood"
   "Cobelstones"
   "Wood"
   "Wood"
   "Wood"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Roof-Top-Left"
   "Roof-Top"
   "Roof-Top"
   "Roof-Top"
   "Roof-Top"
   "Roof-Top"
   "Roof-Top-Right"
   "Cobelstones"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Cobelstones"
   "Wood"
   "Door"
   "Wood"
   "Cobelstones"
   "Wood"
   "Door"
   "Wood"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Roof-Left"
   "Roof-Center"
   "Roof-Center"
   "Roof-Center"
   "Roof-Center"
   "Roof-Center"
   "Roof-Right"
   "Cobelstones"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Roof-Left"
   "Roof-Center"
   "Roof-Center"
   "Roof-Center"
   "Roof-Center"
   "Roof-Center"
   "Roof-Right"
   "Cobelstones"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Cobelstones"
   "Thatch"
   "Thatch"
   "Thatch"
   "Cobelstones"
   "Thatch"
   "Thatch"
   "Thatch"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Stone-Top-Left-Corner"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-Top-Right-Corner"
   "Cobelstones"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Cobelstones"
   "Thatch"
   "Thatch"
   "Thatch"
   "Cobelstones"
   "Thatch"
   "Thatch"
   "Thatch"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Stone-West-Side"
   "Stone-Center"
   "Stone-Center"
   "Stone-Center"
   "Stone-Center"
   "Stone-Center"
   "Stone-East-Side"
   "Cobelstones"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Cobelstones"
   "Wood"
   "Wood"
   "Wood"
   "Cobelstones"
   "Wood"
   "Wood"
   "Wood"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Stone-Bottom-Left-Corner"
   "Stone-South-Side"
   "Stone-South-Side"
   "Door"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-Bottom-Right-Corner"
   "Cobelstones"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Cobelstones"
   "Wood"
   "Door"
   "Wood"
   "Cobelstones"
   "Wood"
   "Door"
   "Wood"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Cobelstones"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "Concrete"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Stone-Top-Left-Corner"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-North-Side"
   "Stone-Top-Right-Corner"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "Stone-Bottom-Left-Corner"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-South-Side"
   "Stone-Bottom-Right-Corner"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass")
  ("grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass"
   "grass")))

;; ROOMS
(define CITY-OUTSIDE (make-room "City" CITY-TILES 10 (list NPC NPC2) (list NPC NPC2)))

;; get-background
(define (get-background s) (bitmap/file "background.png"))

;; a menu one of:
;; - empty
;; - 'player-info
;; - 'items
;; - 'equipment
;; - 'spells

;; DUNGEONS
(define CITY (make-dungeon (send SPELLSWORD clone #:position (make-posn 2350 1250)) (list CITY-OUTSIDE) empty "City" empty))


;; DUNGEON-DIRECTORY (the list of all the dungeons)
(define DUNGEON-DIRECTORY (list CITY))

(define (get-dungeon s) (first (filter (lambda (x) (string=? (dungeon-name x) s)) DUNGEON-DIRECTORY)))

(define (get-room d s) (first (filter (lambda (x) (string=? (room-name x) s)) (dungeon-rooms d))))

#|




;; ROOF
(define RTL (new tile%
                 [name "RTL"]
                 [image (scale .5 (bitmap/file "RoofTL.png"))]
                 [passable false]
                 [portal empty]))
(define RTC (new tile%
                 [name "RTC"]
                 [image (scale .5 (bitmap/file "RoofTC.png"))]
                 [passable false]
                 [portal empty]))
(define RTR (new tile%
                 [name "RTR"]
                 [image (scale .5 (bitmap/file "RoofTR.png"))]
                 [passable false]
                 [portal empty]))
(define RML (new tile%
                 [name "RML"]
                 [image (scale .5 (bitmap/file "RoofML.png"))]
                 [passable false]
                 [portal empty]))
(define RMC (new tile%
                 [name "RMC"]
                 [image (scale .5 (bitmap/file "RoofMC.png"))]
                 [passable false]
                 [portal empty]))
(define RMR (new tile%
                 [name "RMR"]
                 [image (scale .5 (bitmap/file "RoofMR.png"))]
                 [passable false]
                 [portal empty]))
(define RBL (new tile%
                 [name "RBL"]
                 [image (scale .5 (bitmap/file "RoofBL.png"))]
                 [passable false]
                 [portal empty]))
(define RBC (new tile%
                 [name "RBC"]
                 [image (scale .5 (bitmap/file "RoofBC.png"))]
                 [passable false]
                 [portal empty]))
(define RBR (new tile%
                 [name "RBR"]
                 [image (scale .5 (bitmap/file "RoofBR.png"))]
                 [passable false]
                 [portal empty]))
;; Wall
(define WML (new tile%
                 [name "WML"]
                 [image (scale .5 (bitmap/file "WallML.png"))]
                 [passable false]
                 [portal empty]))
(define WMC (new tile%
                 [name "WMC"]
                 [image (scale .5 (bitmap/file "WallMC.png"))]
                 [passable false]
                 [portal empty]))
(define WMR (new tile%
                 [name "WMR"]
                 [image (scale .5 (bitmap/file "WallMR.png"))]
                 [passable false]
                 [portal empty]))
(define WBL (new tile%
                 [name "WBL"]
                 [image (scale .5 (bitmap/file "WallBL.png"))]
                 [passable false]
                 [portal empty]))
(define WBC (new tile%
                 [name "WBC"]
                 [image (scale .5 (bitmap/file "WallBC.png"))]
                 [passable false]
                 [portal empty]))
(define WBR (new tile%
                 [name "WBR"]
                 [image (scale .5 (bitmap/file "WallBR.png"))]
                 [passable false]
                 [portal empty]))
;; Street
(define STR (new tile%
                 [name "STR"]
                 [image (scale .5 (bitmap/file "Street.png"))]
                 [passable true]
                 [portal empty]))
;; Signs
(define HEL (new tile%
                 [name "HEL"]
                 [image (scale .5 (bitmap/file "healer.png"))]
                 [passable false]
                 [portal empty]))
(define WPN (new tile%
                 [name "WPN"]
                 [image (scale .5 (bitmap/file "wpnsmith.png"))]
                 [passable false]
                 [portal empty]))
(define ITM (new tile%
                 [name "ITM"]
                 [image (scale .5 (bitmap/file "itemshop.png"))]
                 [passable false]
                 [portal empty]))
(define MGU (new tile%
                 [name "MGU"]
                 [image (scale .5 (bitmap/file "mguild.png"))]
                 [passable false]
                 [portal empty]))
(define AGU (new tile%
                 [name "AGU"]
                 [image (scale .5 (bitmap/file "aguild.png"))]
                 [passable false]
                 [portal empty]))
(define TAV (new tile%
                 [name "TAV"]
                 [image (scale .5 (bitmap/file "tavern.png"))]
                 [passable false]
                 [portal empty]))
;; Door
(define DOO (new tile%
                 [name "DOO"]
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
               [name "W"]
               [image (bitmap/file "dirt.jpg")]
               [passable true]
               [portal empty]))

(define B (new tile%
               [name "B"]
               [image (bitmap/file "stone.jpg")]
               [passable false]
               [portal empty]))
(define X (new tile%
               [name "X"]
               [image (overlay (circle 30 'solid 'red)
                               (bitmap/file "stone.jpg"))]
               [passable true]
               [portal (make-portal "test_dungeon_1" "TestRoom2" (make-posn 20 20))]))
(define Y (new tile%
               [name "Y"]
               [image (overlay (circle 30 'solid 'blue)
                               (bitmap/file "stone.jpg"))]
               [passable true]
               [portal (make-portal "test_dungeon_1" "TestRoom1" (make-posn 3150 2250))]))
(define Z (new tile%
               [name "Z"]
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
                (list B B B B B B B B B B B B B B B B B B B B B B B B))) |#

;; TEST DUNGEONS
;; (define TESTDUNGEON1 (make-dungeon SPELLSWORD (list TESTROOM1 TESTROOM2) empty "test_dungeon_1" empty))
;; (define TESTDUNGEON2 (make-dungeon SPELLSWORD (list TESTROOM3) empty "test_dungeon_2" empty))

;; TESTROOMS
;; (define TESTROOM1 (make-room "TestRoom1" TILES1 5 (list NPC) (list NPC NPC2)))
;; (define TESTROOM2 (make-room "TestRoom2" TILES2 10 (list NPC2) (list NPC2)))
;; (define TESTROOM3 (make-room "TestRoom3" TILES3 10 (list NPC2) (list NPC NPC2)))