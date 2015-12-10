#lang racket
(require 2htdp/image)
(require "combat.rkt")
(require "items.rkt")
(require "spells.rkt")
(require "characters.rkt")
(provide tile% 
         (struct-out room)
         (struct-out portal)
         (struct-out dungeon)
         (all-defined-out))

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

(define TILE1 (new tile%
                   [image (overlay (square 50 'outline 'black)
                                   (square 50 'solid 'gray))]
                   [passable true]
                   [portal empty]))

(define TILE2 (new tile%
                   [image (square 50 'solid 'black)]
                   [passable false]
                   [portal empty]))

(define TILES1 (make-list 14 (make-list 18 TILE1)))

;; a room is a (make-room string list-of-tiles num list-of-npcs) where:
;; - the string is the name of the room
;; - the list-of-(list-of-tiles) are th
;; - the number is the proboblility you will encounter an enemy on a givin step
;; - the list-of-npcs is the list of all possible npcs you could face
(define-struct room (name tiles encounter-probability possible-encounters))

(define TESTROOM1 (make-room "test room 1" TILES1 0 empty))

;; a portal is a (make-portal string posn) where
;; the string is the name of the room to which the portal leads
;; the posn is the position in the room to which the portal leads
(define-struct portal (name position))

;; a dungen is a (make-dungeon player list-of-rooms)
(define-struct dungeon (player rooms))

(define TESTDUNGEON1 (make-dungeon SPELLSWORD (list TESTROOM1)))

;; RENDER -----------------------------------------------------------------------
(define (render-dungeon d)
  (render-room (send (dungeon-player d) get-position)
               (send (dungeon-player d) get-map-animation)
               (first (dungeon-rooms d))))

(define (render-room p a r)
  (overlay
   (map-animation-forward-stationary a)
   (place-image
    (tiles->image (room-tiles r))
    (+ 405 (- (/ (image-width (tiles->image (room-tiles r))) 2) (posn-x p)))
    (+ 315 (- (/ (image-height (tiles->image (room-tiles r))) 2) (posn-y p)))
    (overlay/align "left" "bottom" (text (room-name r) 15 'red) (rectangle 810 630 'solid 'black)))))

(define (tiles->image t)
  (cond
    [(empty? t) (square 0 'solid 'gold)]
    [(cons? t) (above (render-tile-row (first t))
                      (tiles->image (rest t)))]))

(define (render-tile-row r)
  (cond
    [(empty? r) (square 0 'solid 'red)]
    [(cons? r) (beside (send (first r) get-image)
                       (render-tile-row (rest r)))]))
