#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(require "combat.rkt")
(require "items.rkt")
(require "spells.rkt")
(require "characters.rkt")
(provide tile% 
         (struct-out room)
         (struct-out portal)
         (struct-out dungeon)
         (all-defined-out))

(define PLAYER-SPEED 15)
;; ----------------------------------------------------------------------------
(define base-tile<%>
  (interface ()
    get-image ;; gets tiles image
    passable? ;; true iff tile is passable
    portal? ;; true iff tile contains a portal
    ))

(define tile%
  (class* object% (base-tile<%>)
    (super-new)
    (init-field
     image ;; an image that is an image of the tile
     passable ;; true iff tile is passable
     portal ;; is one of: empty portal
     )
    (define/public (get-image) image)
    (define/public (passable?) passable)
    (define/public (portal?) (not (empty? portal)))))

(define W (new tile%
                   [image (bitmap/file "dirt.jpg")]
                   [passable true]
                   [portal empty]))

(define B (new tile%
                   [image (bitmap/file "stone.jpg")]
                   [passable false]
                   [portal empty]))

(define TILES1 (list
                (list B B B B B B B B B B B B B B B B B B B B B B B B)
                (list B W W B W W W W B W W W B W W W W B B B W W W B)
                (list B W B B W B B W W W B W B W B B W W W W W B W B)
                (list B W B B W W B B B B B W W W W W W B W B B B W B)
                (list B W B B B W B W W W W W B W B B B B W B W B W B)
                (list B W W W W W B W B B W B B W B W W W W W W W W B)
                (list B B B B B W W W B B W B B W B W B B B B W B B B)
                (list B W W W W W B W W W W W W W W W W W W W W W W B)
                (list B B B B B W B W B B W B B W B B W B B B W B W B)
                (list B W W W B W B W B B W B B W B B W B W W W B W B)
                (list B W B W B W B W B B W B B W B B W B W B B B W B)
                (list B W B W B W W W W W W W W W W W W B W B W W W B)
                (list B W B B B W B B B B W B B W B B W B B B W B B B)
                (list B W W W W W W W W W W B W W W B W W W W W B B B)
                (list B B B B B B B B B B B B B B B B B B B B B B B B)))

;; a room is a (make-room string list-of-tiles num list-of-npcs) where:
;; - the string is the name of the room
;; - the list-of-(list-of-tiles) are th
;; - the number is the proboblility you will encounter an enemy on a givin step
;; - the list-of-npcs is the list of all possible npcs you could face
(define-struct room (name tiles encounter-probability possible-encounters))

(define TESTROOM1 (make-room "test room 1" TILES1 5 (list NPC)))

;; a portal is a (make-portal string posn) where
;; the string is the name of the room to which the portal leads
;; the posn is the position in the room to which the portal leads
(define-struct portal (name position))

;; a dungen is a (make-dungeon player list-of-rooms loi menu)
(define-struct dungeon (player rooms images name))

(define TESTDUNGEON1 (make-dungeon SPELLSWORD (list TESTROOM1) empty "test_dungeon_1"))

;; DUNGEON-DIRECTORY (the list of all the dungeons)
(define DUNGEON-DIRECTORY (list TESTDUNGEON1))

(define (get-dungeon s) (first (filter (lambda (x) (string=? (dungeon-name x) s)) DUNGEON-DIRECTORY)))

(define (get-room d s) (first (filter (lambda (x) (string=? (room-name x) s)) (dungeon-rooms d))))